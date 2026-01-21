// ============================================================================
// Inventory Check Agent - Cues Page
// ============================================================================
// This page displays activity cues for the Role Center.
// ============================================================================

namespace Demo.Agent.InventoryCheckAgent;

using Microsoft.Purchases.Document;

page 50106 "ICA Cues"
{
    Caption = 'Inventory Check Agent Activities';
    PageType = CardPart;
    SourceTable = "ICA Cue";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            cuegroup(PurchaseOrders)
            {
                Caption = 'Purchase Orders';

                field("Open Purchase Orders"; Rec."Open Purchase Orders")
                {
                    ApplicationArea = All;
                    Caption = 'Open';
                    ToolTip = 'Shows the number of open purchase orders.';
                    DrillDownPageId = "Purchase Order List";
                }
                field("Released Purchase Orders"; Rec."Released Purchase Orders")
                {
                    ApplicationArea = All;
                    Caption = 'Released';
                    ToolTip = 'Shows the number of released purchase orders.';
                    DrillDownPageId = "Purchase Order List";
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
