// ============================================================================
// Inventory Check Agent - Purchase Order Subform Page Customization
// ============================================================================
// Simplifies the Purchase Order Lines (subform) for the agent by showing
// only the essential columns needed for adding items to a purchase order.
// ============================================================================

namespace Demo.Agent.InventoryCheckAgent;

using Microsoft.Purchases.Document;

pagecustomization "ICA Purchase Order Subform" customizes "Purchase Order Subform"
{
    layout
    {
        // ====================================================================
        // ESSENTIAL COLUMNS - Keep these visible
        // ====================================================================

        modify(Type)
        {
            Visible = true;  // Essential: Item, G/L Account, etc.
        }
        modify("No.")
        {
            Visible = true;  // Essential: Item number
        }
        modify(Description)
        {
            Visible = true;  // Essential: What we're ordering
        }
        modify(Quantity)
        {
            Visible = true;  // Essential: How many
        }
        modify("Unit of Measure Code")
        {
            Visible = true;  // Essential: Unit of measure
        }
        modify("Direct Unit Cost")
        {
            Visible = true;  // Essential: Price per unit
        }
        modify("Line Amount")
        {
            Visible = true;  // Essential: Total line amount
        }

        // ====================================================================
        // HIDE NON-ESSENTIAL COLUMNS - Keep the view clean
        // ====================================================================

        modify("Location Code")
        {
            Visible = false; // Hide: Use default location
        }
        modify("Bin Code")
        {
            Visible = false; // Hide: Warehouse feature
        }
        modify("Variant Code")
        {
            Visible = false; // Hide: Item variants
        }
        modify("Item Reference No.")
        {
            Visible = false; // Hide: Cross-reference
        }
        modify("VAT Prod. Posting Group")
        {
            Visible = false; // Hide: Tax setup
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = false; // Hide: Posting setup
        }
        modify("Expected Receipt Date")
        {
            Visible = false; // Hide: Scheduling
        }
        modify("Promised Receipt Date")
        {
            Visible = false; // Hide: Scheduling
        }
        modify("Planned Receipt Date")
        {
            Visible = false; // Hide: Scheduling
        }
        modify("Requested Receipt Date")
        {
            Visible = false; // Hide: Scheduling
        }
        modify("Line Discount %")
        {
            Visible = false; // Hide: Pricing details
        }
        modify("Line Discount Amount")
        {
            Visible = false; // Hide: Pricing details
        }
        modify("Allow Invoice Disc.")
        {
            Visible = false; // Hide: Advanced pricing
        }
        modify("Inv. Discount Amount")
        {
            Visible = false; // Hide: Advanced pricing
        }
        modify("Qty. to Receive")
        {
            Visible = false; // Hide: Receiving process
        }
        modify("Quantity Received")
        {
            Visible = false; // Hide: Receiving process
        }
        modify("Qty. to Invoice")
        {
            Visible = false; // Hide: Invoicing process
        }
        modify("Quantity Invoiced")
        {
            Visible = false; // Hide: Invoicing process
        }
        modify("Job No.")
        {
            Visible = false; // Hide: Job costing
        }
        modify("Job Task No.")
        {
            Visible = false; // Hide: Job costing
        }
        modify("Job Line Type")
        {
            Visible = false; // Hide: Job costing
        }
        modify("Shortcut Dimension 1 Code")
        {
            Visible = false; // Hide: Dimensions
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = false; // Hide: Dimensions
        }
    }
}
