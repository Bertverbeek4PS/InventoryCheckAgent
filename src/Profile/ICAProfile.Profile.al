// ============================================================================
// Inventory Check Agent - Profile
// ============================================================================
// This profile defines the role center and page customizations for the agent.
// Page customizations simplify the UI so the agent sees only essential fields.
// ============================================================================

namespace Demo.Agent.InventoryCheckAgent;

profile "ICA Inventory Check Agent"
{
    Caption = 'Inventory Check Agent (Copilot)';
    Description = 'Agent that checks item inventory and creates purchase orders based on email requests.';
    RoleCenter = "ICA Role Center";

    // Apply page customizations to simplify the Purchase Order pages
    Customizations = "ICA Purchase Order", "ICA Purchase Order Subform", "ICA Purchase Order List";
}
