// ============================================================================
// Inventory Check Agent - Purchase Order List Page Customization
// ============================================================================
// Simplifies the Purchase Order List for the agent by showing only
// essential columns and the New action to create purchase orders.
// ============================================================================

namespace Demo.Agent.InventoryCheckAgent;

using Microsoft.Purchases.Document;

pagecustomization "ICA Purchase Order List" customizes "Purchase Order List"
{
    layout
    {
        // ====================================================================
        // ESSENTIAL COLUMNS - Keep these visible
        // ====================================================================

        modify("No.")
        {
            Visible = true;  // Essential: Document number
        }
        modify("Buy-from Vendor No.")
        {
            Visible = true;  // Essential: Vendor
        }
        modify("Buy-from Vendor Name")
        {
            Visible = true;  // Essential: Vendor name
        }
        modify(Status)
        {
            Visible = true;  // Essential: Document status
        }

        // ====================================================================
        // HIDE NON-ESSENTIAL COLUMNS - Keep the list clean
        // ====================================================================

        modify("Vendor Authorization No.")
        {
            Visible = false;
        }
        modify("Buy-from Post Code")
        {
            Visible = false;
        }
        modify("Buy-from Country/Region Code")
        {
            Visible = false;
        }
        modify("Buy-from Contact")
        {
            Visible = false;
        }
        modify("Pay-to Vendor No.")
        {
            Visible = false;
        }
        modify("Pay-to Name")
        {
            Visible = false;
        }
        modify("Pay-to Post Code")
        {
            Visible = false;
        }
        modify("Pay-to Country/Region Code")
        {
            Visible = false;
        }
        modify("Pay-to Contact")
        {
            Visible = false;
        }
        modify("Ship-to Code")
        {
            Visible = false;
        }
        modify("Ship-to Name")
        {
            Visible = false;
        }
        modify("Ship-to Post Code")
        {
            Visible = false;
        }
        modify("Ship-to Country/Region Code")
        {
            Visible = false;
        }
        modify("Ship-to Contact")
        {
            Visible = false;
        }
        modify("Posting Date")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = false;
        }
        modify("Location Code")
        {
            Visible = false;
        }
        modify("Purchaser Code")
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Currency Code")
        {
            Visible = false;
        }
        modify("Document Date")
        {
            Visible = false;
        }
        modify("Requested Receipt Date")
        {
            Visible = false;
        }
        modify("Job Queue Status")
        {
            Visible = false;
        }
        modify(Amount)
        {
            Visible = false;
        }
        modify("Amount Including VAT")
        {
            Visible = false;
        }
    }

    actions
    {
        // ====================================================================
        // KEEP ONLY THE NEW ACTION - Hide everything else
        // ====================================================================

        // Hide process actions
        modify(Release)
        {
            Visible = false;
        }
        modify(Reopen)
        {
            Visible = false;
        }
        modify(Print)
        {
            Visible = false;
        }
        modify(AttachAsPDF)
        {
            Visible = false;
        }

        // Hide posting actions
        modify(Post)
        {
            Visible = false;
        }
        modify(Preview)
        {
            Visible = false;
        }
        modify(PostAndPrint)
        {
            Visible = false;
        }
        modify(PostBatch)
        {
            Visible = false;
        }

        // Hide request approval actions
        modify(SendApprovalRequest)
        {
            Visible = false;
        }
        modify(CancelApprovalRequest)
        {
            Visible = false;
        }
    }
}
