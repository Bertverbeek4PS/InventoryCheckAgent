// ============================================================================
// Inventory Check Agent - Purchase Order Page Customization
// ============================================================================
// Simplifies the Purchase Order page for the agent by showing only
// the most important fields needed for creating purchase orders.
// ============================================================================

namespace Demo.Agent.InventoryCheckAgent;

using Microsoft.Purchases.Document;

pagecustomization "ICA Purchase Order" customizes "Purchase Order"
{
    layout
    {
        // ====================================================================
        // GENERAL GROUP - Keep essential fields, hide the rest
        // ====================================================================

        // Keep visible: No., Vendor No., Vendor Name, Order Date
        // Hide less important fields

        modify("Buy-from Vendor No.")
        {
            Visible = true;  // Essential: Who we buy from
        }
        modify("Buy-from Vendor Name")
        {
            Visible = true;  // Essential: Vendor name for clarity
        }
        modify("No.")
        {
            Visible = true;  // Essential: Document number
        }
        modify("Document Date")
        {
            Visible = false; // Hide: Not critical for demo
        }
        modify("Due Date")
        {
            Visible = false; // Hide: Not critical for demo
        }
        modify("Posting Date")
        {
            Visible = false; // Hide: Not critical for demo
        }
        modify("Order Date")
        {
            Visible = true;  // Keep: When order was placed
        }
        modify("Quote No.")
        {
            Visible = false; // Hide: Not used in this flow
        }
        modify("Vendor Order No.")
        {
            Visible = false; // Hide: External reference
        }
        modify("Vendor Shipment No.")
        {
            Visible = false; // Hide: Not needed for creation
        }
        modify("Vendor Invoice No.")
        {
            Visible = false; // Hide: Not needed for creation
        }
        modify("Order Address Code")
        {
            Visible = false; // Hide: Advanced feature
        }
        modify("Purchaser Code")
        {
            Visible = false; // Hide: Not critical for demo
        }
        modify("Responsibility Center")
        {
            Visible = false; // Hide: Advanced feature
        }
        modify(Status)
        {
            Visible = true;  // Keep: Important to see status
        }

        // ====================================================================
        // Hide entire groups that are not needed for the demo
        // ====================================================================
        modify("Buy-from")
        {
            Visible = false; // Hide: Detailed address info
        }
        modify("Foreign Trade")
        {
            Visible = false; // Hide: Advanced feature
        }
    }
}
