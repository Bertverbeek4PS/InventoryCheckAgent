// ============================================================================
// Inventory Check Agent - Send Replies Codeunit
// ============================================================================
// This codeunit handles sending email replies back to users.
// It processes reviewed agent output messages and sends them as email replies.
//
// WORKFLOW:
// 1. Find all reviewed output messages from the agent
// 2. For each message, find the original input message
// 3. Send an email reply using the original message's external ID
// 4. Record the sent message to prevent duplicates
// ============================================================================

namespace Demo.Agent.InventoryCheckAgent;

using System.Agents;
using System.Email;

codeunit 50101 "ICA Send Replies"
{
    Access = Internal;
    TableNo = "ICA Setup";
    Permissions = tabledata "Agent Task Message" = RMID,
                  tabledata "ICA Sent Message" = RIMD;
    InherentEntitlements = X;
    InherentPermissions = X;

    var
        // Subject line for reply emails
        EmailSubjectLbl: Label 'Inventory Check Agent - Reply to Task %1', Comment = '%1 = Task ID';

    trigger OnRun()
    begin
        // Get setup and send pending replies
        if Rec.FindFirst() then;
        SendPendingReplies(Rec);

        // Update sync timestamp
        Rec."Last Sync At" := CurrentDateTime();
        Rec.Modify();
    end;

    /// <summary>
    /// Main procedure to send all pending reply messages
    /// </summary>
    local procedure SendPendingReplies(var ICASetup: Record "ICA Setup")
    var
        OutputMessage: Record "Agent Task Message";
        InputMessage: Record "Agent Task Message";
        ICASentMessage: Record "ICA Sent Message";
    begin
        // ====================================================================
        // Step 1: Find all reviewed output messages for this agent
        // ====================================================================
        OutputMessage.ReadIsolation(IsolationLevel::ReadCommitted);
        OutputMessage.SetRange(Status, OutputMessage.Status::Reviewed);
        OutputMessage.SetRange(Type, OutputMessage.Type::Output);
        OutputMessage.SetRange("Agent User Security ID", ICASetup."User Security ID");

        if not OutputMessage.FindSet() then
            exit;

        // ====================================================================
        // Step 2: Process each output message
        // ====================================================================
        repeat
            // Skip if already sent
            if not ICASentMessage.IsMessageAlreadySent(OutputMessage."Task ID", OutputMessage.ID) then begin
                // Get the input message to reply to
                if InputMessage.Get(OutputMessage."Task ID", OutputMessage."Input Message ID") then begin
                    // Only send if we have the original external ID
                    if InputMessage."External ID" <> '' then
                        SendEmailReply(ICASetup, InputMessage, OutputMessage);
                end;
            end;
        until OutputMessage.Next() = 0;
    end;

    /// <summary>
    /// Sends an email reply for a specific output message
    /// </summary>
    local procedure SendEmailReply(
        var ICASetup: Record "ICA Setup";
        var InputMessage: Record "Agent Task Message";
        var OutputMessage: Record "Agent Task Message")
    var
        ICASentMessage: Record "ICA Sent Message";
        AgentMessage: Codeunit "Agent Message";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        Subject: Text;
        Body: Text;
    begin
        // ====================================================================
        // Step 3a: Build the reply email
        // ====================================================================
        Subject := StrSubstNo(EmailSubjectLbl, InputMessage."Task ID");
        Body := AgentMessage.GetText(OutputMessage);

        // Create a reply to the original email
        EmailMessage.CreateReplyAll(
            Subject,
            Body,
            true,  // HTML format
            InputMessage."External ID"
        );

        // ====================================================================
        // Step 3b: Send the email
        // ====================================================================
        if Email.ReplyAll(EmailMessage, ICASetup."Email Account ID", ICASetup."Email Connector") then begin
            // ================================================================
            // Step 3c: Record the sent message
            // ================================================================
            ICASentMessage.RecordSentMessage(
                OutputMessage,
                InputMessage."External ID",
                ICASetup."Email Address",
                CopyStr(InputMessage."Created By Full Name", 1, 250)
            );
        end;
    end;
}
