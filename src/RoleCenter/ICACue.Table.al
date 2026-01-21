// ============================================================================
// Inventory Check Agent - Cue Table
// ============================================================================
// This table stores calculated cue values for the Role Center.
// ============================================================================

namespace Demo.Agent.InventoryCheckAgent;

using Microsoft.Purchases.Document;

table 50103 "ICA Cue"
{
    Caption = 'Inventory Check Agent Cue';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(10; "Processed Emails"; Integer)
        {
            Caption = 'Processed Emails';
            FieldClass = FlowField;
            CalcFormula = count("ICA Email");
        }
        field(20; "Sent Messages"; Integer)
        {
            Caption = 'Sent Messages';
            FieldClass = FlowField;
            CalcFormula = count("ICA Sent Message");
        }
        field(30; "Open Purchase Orders"; Integer)
        {
            Caption = 'Open Purchase Orders';
            FieldClass = FlowField;
            CalcFormula = count("Purchase Header" where("Document Type" = const(Order), Status = const(Open)));
        }
        field(40; "Released Purchase Orders"; Integer)
        {
            Caption = 'Released Purchase Orders';
            FieldClass = FlowField;
            CalcFormula = count("Purchase Header" where("Document Type" = const(Order), Status = const(Released)));
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
