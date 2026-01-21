// ============================================================================
// Inventory Check Agent - Email Card Page
// ============================================================================
// This page shows the details of a single email record.
// ============================================================================

namespace Demo.Agent.InventoryCheckAgent;

page 50101 "ICA Email Card"
{
    Caption = 'Inventory Check Agent Email';
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "ICA Email";
    Editable = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Email Inbox ID"; Rec."Email Inbox ID")
                {
                    ToolTip = 'The unique identifier of the email in the inbox.';
                }
                field(Processed; Rec.Processed)
                {
                    ToolTip = 'Indicates if this email has been processed.';
                }
            }

            group(Sender)
            {
                Caption = 'Sender Information';

                field("Sender Name"; Rec."Sender Name")
                {
                    ToolTip = 'The name of the person who sent the email.';
                }
                field("Sender Address"; Rec."Sender Address")
                {
                    ToolTip = 'The email address of the sender.';
                }
            }

            group(Timing)
            {
                Caption = 'Timing';

                field("Received DateTime"; Rec."Received DateTime")
                {
                    ToolTip = 'When the email was received.';
                }
                field("Sent DateTime"; Rec."Sent DateTime")
                {
                    ToolTip = 'When the email was originally sent.';
                }
            }

            group(AgentTask)
            {
                Caption = 'Agent Task';

                field("Task ID"; Rec."Task ID")
                {
                    ToolTip = 'The Agent Task ID created for this email.';
                }
                field("Task Message ID"; Rec."Task Message ID")
                {
                    ToolTip = 'The message ID within the agent task.';
                }
            }
        }
    }
}
