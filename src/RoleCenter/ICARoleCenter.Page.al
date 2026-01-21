// ============================================================================
// Inventory Check Agent - Role Center Page
// ============================================================================
// This is the main page for the Inventory Check Agent.
// It provides quick access to all agent-related functionality.
// ============================================================================

namespace Demo.Agent.InventoryCheckAgent;

using Microsoft.Inventory.Item;
using Microsoft.Purchases.Document;

page 50105 "ICA Role Center"
{
    Caption = 'Inventory Check Agent';
    PageType = RoleCenter;
    ApplicationArea = All;

    layout
    {
        area(RoleCenter)
        {
            part(AgentCues; "ICA Cues")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // ====================================================================
        // Main Navigation Actions
        // ====================================================================
        area(Embedding)
        {
            ToolTip = 'Check inventory and create purchase orders based on email requests.';

            // Quick access to items
            action(Items)
            {
                Caption = 'Items';
                ApplicationArea = All;
                Image = Item;
                RunObject = page "Item List";
                ToolTip = 'View and manage items and their inventory levels.';
            }

            // Quick access to purchase orders
            action(PurchaseOrders)
            {
                Caption = 'Purchase Orders';
                ApplicationArea = All;
                Image = Document;
                RunObject = page "Purchase Order List";
                ToolTip = 'View and create purchase orders.';
            }
        }
    }
}
