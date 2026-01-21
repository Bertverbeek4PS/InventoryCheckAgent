// ============================================================================
// Inventory Check Agent - Setup Table
// ============================================================================
// This table stores the configuration for the Inventory Check Agent.
// It contains the email account settings, agent user, and sync settings.
// ============================================================================

namespace Demo.Agent.InventoryCheckAgent;

using System.Email;

table 50102 "ICA Setup"
{
    Caption = 'Inventory Check Agent Setup';
    DataClassification = CustomerContent;
    Access = Internal;
    InherentEntitlements = RIMDX;
    InherentPermissions = RIMDX;
    ReplicateData = false;

    fields
    {
        // Primary Key (single record table)
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }

        // ====================================================================
        // Agent User Settings
        // ====================================================================
        field(10; "Agent User Security ID"; Guid)
        {
            Caption = 'Agent User Security ID';
            DataClassification = SystemMetadata;
        }

        // ====================================================================
        // Email Account Settings
        // ====================================================================
        field(20; "Email Account ID"; Guid)
        {
            Caption = 'Email Account ID';
            DataClassification = SystemMetadata;
        }
        field(21; "Email Connector"; Enum "Email Connector")
        {
            Caption = 'Email Connector';
            DataClassification = SystemMetadata;
        }
        field(22; "Email Address"; Text[250])
        {
            Caption = 'Email Address';
            ToolTip = 'The email address used by the agent.';
        }
        field(23; "Email Folder"; Text[250])
        {
            Caption = 'Email Folder';
            ToolTip = 'The folder to monitor for incoming emails.';
        }
        field(24; "Email Folder ID"; Text[2048])
        {
            Caption = 'Email Folder ID';
        }

        // ====================================================================
        // Processing Settings
        // ====================================================================
        field(30; "Email Monitoring Enabled"; Boolean)
        {
            Caption = 'Email Monitoring Enabled';
            ToolTip = 'Enable or disable automatic email monitoring.';
        }
        field(31; "Message Limit"; Integer)
        {
            Caption = 'Message Limit';
            ToolTip = 'Maximum number of emails to process per run.';
            InitValue = 100;
        }

        // ====================================================================
        // Sync Timestamps
        // ====================================================================
        field(40; "Last Sync At"; DateTime)
        {
            Caption = 'Last Sync At';
            ToolTip = 'When the agent last processed emails.';
        }
        field(41; "Earliest Sync At"; DateTime)
        {
            Caption = 'Earliest Sync At';
            ToolTip = 'Only process emails received after this time.';
        }

        // ====================================================================
        // Job Queue Settings
        // ====================================================================
        field(50; "Scheduled Task ID"; Guid)
        {
            Caption = 'Scheduled Task ID';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    /// <summary>
    /// Gets or creates the setup record
    /// </summary>
    internal procedure GetOrCreate()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec."Primary Key" := '';
            Rec."Message Limit" := 100;
            Rec."Earliest Sync At" := CurrentDateTime();
            Rec.Insert(true);
        end;
    end;
}
