// ============================================================================
// Inventory Check Agent - Email List Page
// ============================================================================
// This page displays all emails that have been received by the agent.
// Users can see which emails have been processed and their sender details.
// ============================================================================

namespace Demo.Agent.InventoryCheckAgent;

page 50100 "ICA Email List"
{
    Caption = 'Inventory Check Agent Emails';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ICA Email";
    Editable = false;
    CardPageId = "ICA Email Card";

    layout
    {
        area(Content)
        {
            repeater(Emails)
            {
                // Show sender information
                field("Sender Name"; Rec."Sender Name")
                {
                    ToolTip = 'The name of the person who sent the email.';
                }
                field("Sender Address"; Rec."Sender Address")
                {
                    ToolTip = 'The email address of the sender.';
                }

                // Show timestamps
                field("Received DateTime"; Rec."Received DateTime")
                {
                    ToolTip = 'When the email was received.';
                }

                // Show processing status
                field(Processed; Rec.Processed)
                {
                    ToolTip = 'Indicates if this email has been processed by the agent.';
                }

                // Show task link
                field("Task ID"; Rec."Task ID")
                {
                    ToolTip = 'The Agent Task ID created for this email.';
                }
            }
        }
    }
}
