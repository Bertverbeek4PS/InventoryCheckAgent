// ============================================================================
// Inventory Check Agent - Sent Message Table
// ============================================================================
// This table tracks all messages that have been sent by the agent.
// It prevents duplicate sends and provides an audit trail.
// ============================================================================

namespace Demo.Agent.InventoryCheckAgent;

using System.Agents;

table 50101 "ICA Sent Message"
{
    Caption = 'Inventory Check Agent Sent Message';
    DataClassification = SystemMetadata;
    Access = Internal;
    InherentEntitlements = RIMDX;
    InherentPermissions = RIMDX;
    ReplicateData = false;

    fields
    {
        // Auto-increment primary key
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }

        // Link to the agent task
        field(10; "Task ID"; BigInteger)
        {
            Caption = 'Task ID';
            TableRelation = "Agent Task".ID;
        }
        field(11; "Message ID"; Guid)
        {
            Caption = 'Message ID';
        }

        // Email details
        field(20; "External ID"; Text[250])
        {
            Caption = 'External ID';
        }
        field(21; "Sent From"; Text[250])
        {
            Caption = 'Sent From';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(22; "Sent To"; Text[250])
        {
            Caption = 'Sent To';
            DataClassification = EndUserIdentifiableInformation;
        }

        // Timestamp
        field(30; "Sent At"; DateTime)
        {
            Caption = 'Sent At';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(TaskMessage; "Task ID", "Message ID")
        {
        }
    }

    /// <summary>
    /// Checks if a message was already sent to prevent duplicates
    /// </summary>
    internal procedure IsMessageAlreadySent(TaskID: BigInteger; MessageID: Guid): Boolean
    begin
        Rec.SetRange("Task ID", TaskID);
        Rec.SetRange("Message ID", MessageID);
        exit(not Rec.IsEmpty());
    end;

    /// <summary>
    /// Records that a message was sent
    /// </summary>
    internal procedure RecordSentMessage(
        OutputAgentTaskMessage: Record "Agent Task Message";
        ExternalID: Text[250];
        SentFrom: Text[250];
        SentTo: Text[250])
    begin
        Rec.Init();
        Rec."Task ID" := OutputAgentTaskMessage."Task ID";
        Rec."Message ID" := OutputAgentTaskMessage.ID;
        Rec."External ID" := ExternalID;
        Rec."Sent From" := SentFrom;
        Rec."Sent To" := SentTo;
        Rec."Sent At" := CurrentDateTime();
        Rec.Insert(true);
    end;
}
