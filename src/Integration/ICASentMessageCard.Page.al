// ============================================================================
// Inventory Check Agent - Sent Message Card Page
// ============================================================================
// This page shows the details of a single sent message.
// ============================================================================

namespace Demo.Agent.InventoryCheckAgent;

page 50103 "ICA Sent Message Card"
{
    Caption = 'Inventory Check Agent Sent Message';
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "ICA Sent Message";
    Editable = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'The unique entry number.';
                }
                field("Sent At"; Rec."Sent At")
                {
                    ToolTip = 'When the message was sent.';
                }
            }

            group(TaskInfo)
            {
                Caption = 'Agent Task Information';

                field("Task ID"; Rec."Task ID")
                {
                    ToolTip = 'The Agent Task ID.';
                }
                field("Message ID"; Rec."Message ID")
                {
                    ToolTip = 'The Message ID within the task.';
                }
                field("External ID"; Rec."External ID")
                {
                    ToolTip = 'The external message identifier.';
                }
            }

            group(EmailInfo)
            {
                Caption = 'Email Information';

                field("Sent From"; Rec."Sent From")
                {
                    ToolTip = 'The sender email address.';
                }
                field("Sent To"; Rec."Sent To")
                {
                    ToolTip = 'The recipient email address.';
                }
            }
        }
    }
}
