// ============================================================================
// Inventory Check Agent - Permission Set
// ============================================================================
// This permission set grants access to all agent-related objects.
// Assign this to users who need to configure or use the agent.
// ============================================================================

namespace Demo.Agent.InventoryCheckAgent;

permissionset 50100 "ICA Full Access"
{
    Caption = 'Inventory Check Agent - Full Access';
    Assignable = true;

    Permissions =
        // Tables
        tabledata "ICA Email" = RIMD,
        tabledata "ICA Sent Message" = RIMD,
        tabledata "ICA Setup" = RIMD,

        // Codeunits
        codeunit "ICA Retrieve Emails" = X,
        codeunit "ICA Send Replies" = X,

        // Pages
        page "ICA Email List" = X,
        page "ICA Email Card" = X,
        page "ICA Sent Messages" = X,
        page "ICA Sent Message Card" = X,
        page "ICA Setup" = X,
        page "ICA Role Center" = X;
}
