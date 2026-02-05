// ============================================================================
// Inventory Check Agent - Setup Dialog Page
// ============================================================================
// This ConfigurationDialog page allows users to configure the Inventory Check Agent.
// It integrates with the Agent Setup Part for standard agent configuration.
// ============================================================================

namespace Demo.Agent.InventoryCheckAgent;

using System.Agents;
using System.AI;
using System.Email;

#pragma warning disable AS0007
#pragma warning disable AS0032
page 50110 "ICA Setup Dialog"
{
    PageType = ConfigurationDialog;
    Extensible = false;
    ApplicationArea = All;
    Caption = 'Configure Inventory Check Agent';
    InstructionalText = 'Choose how the agent monitors emails and checks inventory.';
    AdditionalSearchTerms = 'Inventory Check Agent, Copilot agent, Agent, ICA';
    SourceTable = "ICA Setup";
    SourceTableTemporary = true;
    RefreshOnActivate = true;
    InherentEntitlements = X;
    InherentPermissions = X;

    layout
    {
        area(Content)
        {
            part(AgentSetupPart; "Agent Setup Part")
            {
                ApplicationArea = All;
                UpdatePropagation = Both;
            }

            group(EmailMonitoringCard)
            {
                Caption = 'Email Monitoring';
                InstructionalText = 'Configure how the agent monitors incoming emails.';

                field("Email Monitoring Enabled"; Rec."Email Monitoring Enabled")
                {
                    Caption = 'Enable Email Monitoring';
                    ToolTip = 'Specifies if the agent should monitor incoming emails.';

                    trigger OnValidate()
                    begin
                        ConfigUpdated();
                    end;
                }

                group(MailboxGroup)
                {
                    Caption = 'Mailbox Settings';

                    field(Mailbox; MailboxName)
                    {
                        Caption = 'Email Account';
                        ToolTip = 'Specifies the email account that the agent monitors.';
                        Editable = false;
                        ShowMandatory = true;

                        trigger OnAssistEdit()
                        begin
                            OnAssistEditMailbox();
                        end;
                    }

                    field(MailboxFolder; MailboxFolderName)
                    {
                        Caption = 'Folder';
                        ToolTip = 'Specifies the email folder that the agent monitors.';
                        Editable = false;

                        trigger OnAssistEdit()
                        begin
                            OnAssistEditFolder();
                        end;
                    }

                    field(LastSync; LastSyncText)
                    {
                        Caption = 'Last Sync';
                        ToolTip = 'Specifies the date and time of the last sync with the mailbox.';
                        Editable = false;
                        Visible = ShowLastSync;
                    }
                }
            }

            group(ProcessingSettingsCard)
            {
                Caption = 'Processing Settings';
                InstructionalText = 'Configure how many emails the agent processes.';

                field(DailyEmailLimit; DailyEmailLimit)
                {
                    Caption = 'Message Limit';
                    ToolTip = 'Specifies the maximum number of emails to process per run.';
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        Rec."Message Limit" := DailyEmailLimit;
                        ConfigUpdated();
                    end;
                }
            }

            group(BillingInformationGroup)
            {
                Visible = FirstConfig;
                InstructionalText = 'By enabling the Inventory Check Agent, you understand your organization may be billed for its use.';
                Caption = 'Important';

                field(LearnMoreBilling; LearnMoreTxt)
                {
                    ShowCaption = false;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        Hyperlink(LearnMoreBillingLinkTxt);
                    end;
                }
            }
        }
    }

    actions
    {
        area(SystemActions)
        {
            systemaction(OK)
            {
                Caption = 'Update';
                Enabled = IsConfigUpdated;
                ToolTip = 'Apply the changes to the agent setup.';
            }
            systemaction(Cancel)
            {
                Caption = 'Cancel';
                ToolTip = 'Discards the changes and closes the setup page.';
            }
        }
    }

    trigger OnOpenPage()
    var
        AzureOpenAI: Codeunit "Azure OpenAI";
        UserSecurityIDFilter: Text;
        UserSecurityID: Guid;
    begin
        if not AzureOpenAI.IsEnabled(Enum::"Copilot Capability"::"Inventory Check Agent") then
            Error('The Inventory Check Agent capability is not enabled.');

        IsConfigUpdated := false;
        FirstConfig := IsFirstConfig();
        UserSecurityIDFilter := Rec.GetFilter("User Security ID");
        if not Evaluate(UserSecurityID, UserSecurityIDFilter) then
            Clear(UserSecurityID);

        CurrPage.AgentSetupPart.Page.Initialize(
            UserSecurityID,
            Enum::"Agent Metadata Provider"::"ICA Inventory Check Agent",
            GetICAUsername(),
            GetICAUserDisplayName(),
            GetAgentSummary());

        UpdateAgentSetupBuffer();
        InitialState := AgentSetupBuffer.State;
        UpdateControls();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateAgentSetupBuffer();
        IsConfigUpdated := IsConfigUpdated or AgentSetup.GetChangesMade(AgentSetupBuffer);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        ReadyToActivateLbl: Label 'Ready to activate the Inventory Check Agent?\\The agent will run now and until you deactivate it.';
        ActivateWithoutMailboxLbl: Label 'There is no mailbox selected for the agent to monitor. Are you sure you want to continue?';
        MessageLimitErr: Label 'The message limit must be greater than zero.';
    begin
        if CloseAction = CloseAction::Cancel then
            exit(true);

        if EnabledAgentFirstConfig() then
            if Confirm(ReadyToActivateLbl) then
                Rec.State := Rec.State::Enabled;

        UpdateAgentSetupBuffer();

        if (AgentSetupBuffer.State = AgentSetupBuffer.State::Enabled) and StateChanged() then begin
            if Rec."Email Monitoring Enabled" and (MailboxName = '') then
                if not Confirm(ActivateWithoutMailboxLbl) then
                    exit(false);
        end;

        if Rec."Message Limit" <= 0 then
            Error(MessageLimitErr);

        UpdateAgent();
        exit(true);
    end;

    local procedure UpdateAgentSetupBuffer()
    begin
        CurrPage.AgentSetupPart.Page.GetAgentSetupBuffer(AgentSetupBuffer);
    end;

    local procedure StateChanged(): Boolean
    begin
        exit((AgentSetupBuffer.State <> InitialState) or IsFirstConfig());
    end;

    local procedure UpdateControls()
    var
        ICASetup: Record "ICA Setup";
    begin
        if Rec.IsEmpty() or (Rec."User Security ID" <> AgentSetupBuffer."User Security ID") then begin
            GetICASetup(ICASetup, AgentSetupBuffer."User Security ID");
            Rec.TransferFields(ICASetup);
            if Rec.IsEmpty() then
                Rec.Insert()
            else
                Rec.Modify();
            MailboxName := Rec."Email Address";
            MailboxFolderName := Rec."Email Folder";
            if MailboxFolderName = '' then
                MailboxFolderName := OptionalFolderLbl;
            ShowLastSync := (Rec."Last Sync At" <> 0DT);
            LastSyncText := Format(Rec."Last Sync At");
        end;

        DailyEmailLimit := Rec."Message Limit";
        if DailyEmailLimit = 0 then
            DailyEmailLimit := 100;
    end;

    local procedure ConfigUpdated()
    begin
        IsConfigUpdated := true;

        if EnabledAgentFirstConfig() then
            AgentSetupBuffer.State := AgentSetupBuffer.State::Enabled;
    end;

    local procedure EnabledAgentFirstConfig(): Boolean
    begin
        exit((AgentSetupBuffer.State = AgentSetupBuffer.State::Disabled) and IsFirstConfig() and CheckIsValidConfig());
    end;

    local procedure CheckIsValidConfig(): Boolean
    begin
        exit(Rec."Email Monitoring Enabled" and (MailboxName <> ''));
    end;

    local procedure IsFirstConfig(): Boolean
    begin
        exit(IsNullGuid(Rec."User Security ID"));
    end;

    local procedure OnAssistEditMailbox()
    var
        EmailAccounts: Page "Email Accounts";
    begin
        EmailAccounts.EnableLookupMode();
        if EmailAccounts.RunModal() = Action::LookupOK then begin
            EmailAccounts.GetAccount(TempEmailAccount);
            Rec."Email Account ID" := TempEmailAccount."Account Id";
            Rec."Email Connector" := TempEmailAccount.Connector;
            Rec."Email Address" := TempEmailAccount."Email Address";
            Rec.Modify();
            MailboxName := Rec."Email Address";
            ConfigUpdated();
        end;
    end;

    local procedure OnAssistEditFolder()
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
            Rec."Email Folder ID" := TempEmailFolder."Id";
            Rec.Modify();
            MailboxFolderName := TempEmailFolder."Folder Name";
            ConfigUpdated();
        end;
    end;

    local procedure GetICASetup(var ICASetup: Record "ICA Setup"; UserSecurityID: Guid)
    begin
        ICASetup.GetOrCreate(UserSecurityID);
    end;

    local procedure GetICAUsername(): Code[50]
    begin
        exit('INVENTORY_AGENT');
    end;

    local procedure GetICAUserDisplayName(): Text[80]
    begin
        exit('Inventory Check Agent');
    end;

    local procedure GetAgentSummary(): Text
    begin
        exit('The Inventory Check Agent monitors incoming emails for inventory inquiries, checks item availability in Business Central, and creates purchase orders when needed.');
    end;

    local procedure UpdateAgent()
    var
        ICASetup: Record "ICA Setup";
        Agent: Codeunit Agent;
        NewUserSecurityID: Guid;
        IsNew: Boolean;
    begin
        // Save agent setup via the Agent Setup codeunit first (may create new agent)
        NewUserSecurityID := AgentSetup.SaveChanges(AgentSetupBuffer);

        // Get or create the ICA Setup record for this agent
        IsNew := not ICASetup.Get(NewUserSecurityID);
        if IsNew then begin
            ICASetup.Init();
            ICASetup."User Security ID" := NewUserSecurityID;
        end;

        // Update all fields
        ICASetup."Email Account ID" := Rec."Email Account ID";
        ICASetup."Email Connector" := Rec."Email Connector";
        ICASetup."Email Address" := Rec."Email Address";
        ICASetup."Email Folder" := Rec."Email Folder";
        ICASetup."Email Folder ID" := Rec."Email Folder ID";
        ICASetup."Email Monitoring Enabled" := Rec."Email Monitoring Enabled";
        ICASetup."Message Limit" := Rec."Message Limit";
        ICASetup."Configured By" := UserSecurityId();

        // Update state
        if AgentSetupBuffer.State = AgentSetupBuffer.State::Enabled then begin
            ICASetup.State := ICASetup.State::Enabled;
            Agent.Activate(ICASetup."User Security ID");
        end else begin
            ICASetup.State := ICASetup.State::Disabled;
            Agent.Deactivate(ICASetup."User Security ID");
        end;

        // Insert or Modify
        if IsNew then
            ICASetup.Insert(true)
        else
            ICASetup.Modify(true);
    end;

    var
        AgentSetupBuffer: Record "Agent Setup Buffer";
        TempEmailAccount: Record "Email Account" temporary;
        AgentSetup: Codeunit "Agent Setup";
        MailboxName: Text;
        MailboxFolderName: Text;
        LastSyncText: Text;
        InitialState: Option;
        DailyEmailLimit: Integer;
        ShowLastSync: Boolean;
        FirstConfig: Boolean;
        IsConfigUpdated: Boolean;
        LearnMoreTxt: Label 'Learn more';
        LearnMoreBillingLinkTxt: Label 'https://go.microsoft.com/fwlink/?linkid=2333517', Locked = true;
        OptionalFolderLbl: Label '(optional)';
}
