// ============================================================================
// Inventory Check Agent - Setup Page
// ============================================================================
// This page allows users to configure the Inventory Check Agent.
// Users can set up the email account, enable monitoring, and run manual syncs.
// ============================================================================

namespace Demo.Agent.InventoryCheckAgent;

using System.Email;

page 50104 "ICA Setup"
{
    Caption = 'Inventory Check Agent Setup';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ICA Setup";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            // ================================================================
            // Agent Configuration
            // ================================================================
            group(AgentConfig)
            {
                Caption = 'Agent Configuration';

                field("User Security ID"; Rec."User Security ID")
                {
                    ToolTip = 'The security ID of the agent user.';
                }
            }

            // ================================================================
            // Email Settings
            // ================================================================
            group(EmailSettings)
            {
                Caption = 'Email Settings';

                field("Email Address"; Rec."Email Address")
                {
                    ToolTip = 'The email address used by the agent.';
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        SelectEmailAccount();
                    end;
                }
                field("Email Folder"; Rec."Email Folder")
                {
                    ToolTip = 'The folder to monitor for incoming emails.';
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        SelectEmailFolder();
                    end;
                }
            }

            // ================================================================
            // Processing Settings
            // ================================================================
            group(Processing)
            {
                Caption = 'Processing Settings';

                field("Email Monitoring Enabled"; Rec."Email Monitoring Enabled")
                {
                    ToolTip = 'Enable automatic email monitoring.';
                }
                field("Message Limit"; Rec."Message Limit")
                {
                    ToolTip = 'Maximum emails to process per run.';
                }
            }

            // ================================================================
            // Sync Status
            // ================================================================
            group(SyncStatus)
            {
                Caption = 'Synchronization Status';

                field("Last Sync At"; Rec."Last Sync At")
                {
                    ToolTip = 'When emails were last processed.';
                    Editable = false;
                }
                field("Earliest Sync At"; Rec."Earliest Sync At")
                {
                    ToolTip = 'Only process emails after this time.';
                }
            }
        }
    }

    actions
    {
        // ====================================================================
        // Navigation Actions
        // ====================================================================
        area(Navigation)
        {
            action(ViewEmails)
            {
                Caption = 'View Emails';
                Image = Email;
                ToolTip = 'View emails processed by the agent.';
                RunObject = page "ICA Email List";
            }
            action(ViewSentMessages)
            {
                Caption = 'Sent Messages';
                Image = SendMail;
                ToolTip = 'View messages sent by the agent.';
                RunObject = page "ICA Sent Messages";
            }
        }

        // ====================================================================
        // Processing Actions
        // ====================================================================
        area(Processing)
        {
            action(CreateAgent)
            {
                Caption = 'Create Agent';
                Image = User;
                ToolTip = 'Create the Inventory Check Agent user.';

                trigger OnAction()
                var
                    ICAInstall: Codeunit "ICA Install";
                begin
                    ICAInstall.CreateInventoryCheckAgent();
                    Message('Inventory Check Agent created successfully.');
                end;
            }
            action(RetrieveEmails)
            {
                Caption = 'Retrieve Emails';
                Image = Email;
                ToolTip = 'Manually retrieve and process new emails.';

                trigger OnAction()
                var
                    ICARetrieveEmails: Codeunit "ICA Retrieve Emails";
                begin
                    ICARetrieveEmails.Run(Rec);
                    Message('Email retrieval completed.');
                end;
            }
            action(SendReplies)
            {
                Caption = 'Send Replies';
                Image = SendMail;
                ToolTip = 'Send pending reply messages.';

                trigger OnAction()
                var
                    ICASendReplies: Codeunit "ICA Send Replies";
                begin
                    ICASendReplies.Run(Rec);
                    Message('Reply sending completed.');
                end;
            }
        }

        // ====================================================================
        // Promoted Actions
        // ====================================================================
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(RetrieveEmails_Promoted; RetrieveEmails) { }
                actionref(SendReplies_Promoted; SendReplies) { }
            }
            group(Category_Navigate)
            {
                Caption = 'Navigate';

                actionref(ViewEmails_Promoted; ViewEmails) { }
                actionref(ViewSentMessages_Promoted; ViewSentMessages) { }
            }
        }
    }

    trigger OnOpenPage()
    begin
        // Ensure a setup record exists
        if Rec.FindFirst() then;
    end;

    /// <summary>
    /// Opens the email account selection page
    /// </summary>
    local procedure SelectEmailAccount()
    var
        TempEmailAccount: Record "Email Account" temporary;
        EmailAccounts: Page "Email Accounts";
    begin
        EmailAccounts.EnableLookupMode();
        if EmailAccounts.RunModal() = Action::LookupOK then begin
            EmailAccounts.GetAccount(TempEmailAccount);
            Rec."Email Account ID" := TempEmailAccount."Account Id";
            Rec."Email Connector" := TempEmailAccount.Connector;
            Rec."Email Address" := TempEmailAccount."Email Address";
        end;
    end;

    /// <summary>
    /// Opens the email folder selection page
    /// </summary>
    local procedure SelectEmailFolder()
    var
        TempEmailFolder: Record "Email Folders" temporary;
        EmailFolders: Page "Email Account Folders";
    begin
        if IsNullGuid(Rec."Email Account ID") then begin
            Message('Please select an email account first.');
            exit;
        end;

        EmailFolders.LookupMode(true);
        EmailFolders.SetEmailAccount(Rec."Email Account ID", Rec."Email Connector");
        if EmailFolders.RunModal() = Action::LookupOK then begin
            EmailFolders.GetRecord(TempEmailFolder);
            Rec."Email Folder" := TempEmailFolder."Folder Name";
            Rec."Email Folder ID" := TempEmailFolder.Id;
        end;
    end;
}
