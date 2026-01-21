// ============================================================================
// Inventory Check Agent - Sent Messages List Page
// ============================================================================
// This page displays all messages that have been sent by the agent.
// ============================================================================

namespace Demo.Agent.InventoryCheckAgent;

page 50102 "ICA Sent Messages"
{
    Caption = 'Inventory Check Agent Sent Messages';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ICA Sent Message";
    Editable = false;
    CardPageId = "ICA Sent Message Card";

    layout
    {
        area(Content)
        {
            repeater(Messages)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'The unique entry number of this sent message.';
                }
                field("Task ID"; Rec."Task ID")
                {
                    ToolTip = 'The Agent Task ID this message belongs to.';
                }
                field("Sent From"; Rec."Sent From")
                {
                    ToolTip = 'The email address the message was sent from.';
                }
                field("Sent To"; Rec."Sent To")
                {
                    ToolTip = 'The email address the message was sent to.';
                }
                field("Sent At"; Rec."Sent At")
                {
                    ToolTip = 'When the message was sent.';
                }
            }
        }
    }
}
