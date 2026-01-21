// ============================================================================
// Inventory Check Agent - Email Table
// ============================================================================
// This table stores incoming emails that need to be processed by the agent.
// Each record links to an Email Inbox entry and tracks the processing status.
// ============================================================================

namespace Demo.Agent.InventoryCheckAgent;

using System.Email;
using System.Agents;

table 50100 "ICA Email"
{
    Caption = 'Inventory Check Agent Email';
    DataClassification = SystemMetadata;
    Access = Internal;
    InherentEntitlements = RIMDX;
    InherentPermissions = RIMDX;
    ReplicateData = false;

    fields
    {
        // Primary key - links to the Email Inbox
        field(1; "Email Inbox ID"; BigInteger)
        {
            Caption = 'Email Inbox ID';
            TableRelation = "Email Inbox".Id;
        }

        // Indicates if this email has been processed
        field(2; Processed; Boolean)
        {
            Caption = 'Processed';
        }

        // Sender information for display purposes
        field(10; "Sender Name"; Text[250])
        {
            Caption = 'Sender Name';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(11; "Sender Address"; Text[250])
        {
            Caption = 'Sender Address';
            DataClassification = EndUserIdentifiableInformation;
        }

        // Timestamps for tracking
        field(20; "Received DateTime"; DateTime)
        {
            Caption = 'Received DateTime';
            DataClassification = CustomerContent;
        }
        field(21; "Sent DateTime"; DateTime)
        {
            Caption = 'Sent DateTime';
            DataClassification = CustomerContent;
        }

        // Link to the Agent Task that was created for this email
        field(100; "Task ID"; BigInteger)
        {
            Caption = 'Task ID';
            TableRelation = "Agent Task".ID;
        }
        field(101; "Task Message ID"; Guid)
        {
            Caption = 'Task Message ID';
        }

        // FlowField to check if the agent task message exists
        field(102; "Agent Task Message Exist"; Boolean)
        {
            Caption = 'Agent Task Message Exists';
            FieldClass = FlowField;
            CalcFormula = exist("Agent Task Message" where(ID = field("Task Message ID"), "Task ID" = field("Task ID")));
        }
    }

    keys
    {
        key(PK; "Email Inbox ID")
        {
            Clustered = true;
        }
    }

    /// <summary>
    /// Sets the agent task message fields after creating a task
    /// </summary>
    internal procedure SetAgentMessageFields(var AgentTaskMessage: Record "Agent Task Message")
    begin
        Rec."Task ID" := AgentTaskMessage."Task ID";
        Rec."Task Message ID" := AgentTaskMessage.ID;
    end;
}
