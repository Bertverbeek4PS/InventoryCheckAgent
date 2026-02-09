// ============================================================================
// Inventory Check Agent - Retrieve Emails Codeunit
// ============================================================================
// This codeunit handles the retrieval of emails from the configured mailbox
// and creates Agent Tasks for processing by the AI agent.
//
// WORKFLOW:
// 1. Read unread emails from the configured email account
// 2. Store email references in the ICA Email table
// 3. Create Agent Tasks for each new email conversation
// 4. Link emails to existing tasks if they're part of a conversation
// ============================================================================

namespace Demo.Agent.InventoryCheckAgent;

using System.Email;
using System.Agents;

codeunit 50100 "ICA Retrieve Emails"
{
    Access = Internal;
    TableNo = "ICA Setup";
    Permissions = tabledata "Email Inbox" = rd;
    InherentEntitlements = X;
    InherentPermissions = X;

    var
        // Label for the agent task title
        AgentTaskTitleLbl: Label 'Inventory Check Request from %1', Comment = '%1 = Sender Name';
        // Template for formatting the message content
        MessageTemplateLbl: Label '<b>Subject:</b> %1<br/><b>Body:</b> %2', Comment = '%1 = Subject, %2 = Body';

    trigger OnRun()
    begin
        // Get the setup record and process emails
        if Rec.FindFirst() then;
        RetrieveAndProcessEmails(Rec);

        // Update the last sync timestamp
        Rec."Last Sync At" := CurrentDateTime();
        Rec.Modify();
    end;

    /// <summary>
    /// Main procedure to retrieve and process emails
    /// </summary>
    local procedure RetrieveAndProcessEmails(var ICASetup: Record "ICA Setup")
    var
        EmailInbox: Record "Email Inbox";
        TempFilters: Record "Email Retrieval Filters" temporary;
        Email: Codeunit Email;
    begin
        // ====================================================================
        // Step 1: Configure email retrieval filters
        // ====================================================================
        TempFilters."Unread Emails" := true;
        TempFilters."Max No. of Emails" := ICASetup."Message Limit";
        TempFilters."Load Attachments" := false; // Keep it simple for demo
        TempFilters."Last Message Only" := false;
        TempFilters."Folder Id" := ICASetup."Email Folder ID";
        TempFilters."Earliest Email" := ICASetup."Earliest Sync At";
        TempFilters.Insert();

        // ====================================================================
        // Step 2: Retrieve emails from the mailbox
        // ====================================================================
        Email.RetrieveEmails(
            ICASetup."Email Account ID",
            ICASetup."Email Connector",
            EmailInbox,
            TempFilters
        );

        // Exit if no emails found
        if not EmailInbox.FindSet() then
            exit;

        // ====================================================================
        // Step 3: Process each email
        // ====================================================================
        ProcessEmailsToAgentTasks(ICASetup, EmailInbox);
    end;

    /// <summary>
    /// Process emails and create agent tasks
    /// </summary>
    local procedure ProcessEmailsToAgentTasks(
        var ICASetup: Record "ICA Setup";
        var EmailInbox: Record "Email Inbox")
    var
        ICAEmail: Record "ICA Email";
        AgentTaskBuilder: Codeunit "Agent Task Builder";
        Email: Codeunit Email;
    begin
        repeat
            // Skip already read emails
            if not EmailInbox."Is Read" then begin
                // ============================================================
                // Step 3a: Store email reference in our table
                // ============================================================
                ICAEmail.Init();
                ICAEmail."Email Inbox ID" := EmailInbox.Id;
                ICAEmail."Sender Name" := EmailInbox."Sender Name";
                ICAEmail."Sender Address" := EmailInbox."Sender Address";
                ICAEmail."Sent DateTime" := EmailInbox."Sent DateTime";
                ICAEmail."Received DateTime" := EmailInbox."Received DateTime";

                if ICAEmail.Insert() then begin
                    // Mark email as read in the mailbox
                    Email.MarkAsRead(
                        ICASetup."Email Account ID",
                        ICASetup."Email Connector",
                        EmailInbox."External Message Id"
                    );

                    // ========================================================
                    // Step 3b: Create or add to agent task
                    // ========================================================
                    if AgentTaskBuilder.TaskExists(
                        ICASetup."User Security ID",
                        EmailInbox."Conversation Id")
                    then
                        AddEmailToExistingTask(ICASetup, EmailInbox, ICAEmail)
                    else
                        CreateNewAgentTask(ICASetup, EmailInbox, ICAEmail);

                    // Mark as processed
                    ICAEmail.Processed := true;
                    ICAEmail.Modify();
                end;
            end;
        until EmailInbox.Next() = 0;

        Commit();
    end;

    /// <summary>
    /// Creates a new agent task for an email
    /// </summary>
    local procedure CreateNewAgentTask(
        var ICASetup: Record "ICA Setup";
        var EmailInbox: Record "Email Inbox";
        var ICAEmail: Record "ICA Email")
    var
        AgentTaskRecord: Record "Agent Task";
        AgentTaskMessage: Record "Agent Task Message";
        AgentTaskBuilder: Codeunit "Agent Task Builder";
        AgentMessageBuilder: Codeunit "Agent Task Message Builder";
        EmailMessage: Codeunit "Email Message";
        MessageText: Text;
        TaskTitle: Text[150];
    begin
        // Get the email message content
        EmailMessage.Get(EmailInbox."Message Id");
        MessageText := StrSubstNo(
            MessageTemplateLbl,
            EmailMessage.GetSubject(),
            EmailMessage.GetBody()
        );

        // Create a friendly task title
        TaskTitle := CopyStr(
            StrSubstNo(AgentTaskTitleLbl, EmailInbox."Sender Name"),
            1,
            MaxStrLen(AgentTaskRecord.Title)
        );

        // ====================================================================
        // Build the agent message
        // ====================================================================
        AgentMessageBuilder.Initialize(EmailInbox."Sender Address", MessageText)
            .SetMessageExternalID(EmailInbox."External Message Id");

        // ====================================================================
        // Build and create the agent task
        // ====================================================================
        AgentTaskBuilder.Initialize(ICASetup."User Security ID", TaskTitle)
            .SetExternalId(EmailInbox."Conversation Id")
            .AddTaskMessage(AgentMessageBuilder);

        AgentTaskBuilder.Create();

        // Link the email to the created task
        AgentTaskMessage := AgentTaskBuilder.GetAgentTaskMessageCreated();
        ICAEmail.SetAgentMessageFields(AgentTaskMessage);
    end;

    /// <summary>
    /// Adds an email to an existing agent task (for conversation threads)
    /// </summary>
    local procedure AddEmailToExistingTask(
        var ICASetup: Record "ICA Setup";
        var EmailInbox: Record "Email Inbox";
        var ICAEmail: Record "ICA Email")
    var
        AgentTaskRecord: Record "Agent Task";
        AgentTaskMessage: Record "Agent Task Message";
        AgentMessageBuilder: Codeunit "Agent Task Message Builder";
        EmailMessage: Codeunit "Email Message";
        MessageText: Text;
    begin
        // Find the existing task by conversation ID
        AgentTaskRecord.ReadIsolation(IsolationLevel::ReadCommitted);
        AgentTaskRecord.SetRange("External ID", EmailInbox."Conversation Id");
        if not AgentTaskRecord.FindFirst() then
            exit;

        // Check if this message already exists
        AgentTaskMessage.ReadIsolation(IsolationLevel::ReadCommitted);
        AgentTaskMessage.SetRange("Task ID", AgentTaskRecord.ID);
        AgentTaskMessage.SetRange("External ID", EmailInbox."External Message Id");
        if AgentTaskMessage.Count() >= 1 then
            exit;

        // Get the email content
        EmailMessage.Get(EmailInbox."Message Id");
        MessageText := StrSubstNo(
            MessageTemplateLbl,
            EmailMessage.GetSubject(),
            EmailMessage.GetBody()
        );

        // ====================================================================
        // Build and add the message to existing task
        // ====================================================================
        AgentMessageBuilder.Initialize(EmailInbox."Sender Address", MessageText)
            .SetMessageExternalID(EmailInbox."External Message Id")
            .SetAgentTask(AgentTaskRecord);

        AgentTaskMessage := AgentMessageBuilder.Create();

        // Link the email to the task message
        ICAEmail.SetAgentMessageFields(AgentTaskMessage);
    end;
}
