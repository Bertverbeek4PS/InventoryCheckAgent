# Inventory Check Agent - Prompting Instructions

This document contains all the prompting instructions for the Inventory Check Agent. These prompts guide the AI model's behavior when processing inventory requests and creating purchase orders.

> **Note for Presentation:** The main prompt is stored in `Resources/InventoryCheckAgentPrompt.txt`

---

## Agent Responsibilities

The Inventory Check Agent handles the following tasks:

1. **Receive Email Requests** - Process emails asking about item inventory
2. **Check Inventory** - Look up item quantities in Business Central
3. **Create Purchase Orders** - When inventory is insufficient
4. **Send Email Replies** - Respond to users with results

---

## Main Agent Prompt

The main prompt is located in: `Resources/InventoryCheckAgentPrompt.txt`

This prompt instructs the agent to:
- Extract item information from emails
- Check inventory levels using the Item List
- Evaluate if inventory is sufficient for the request
- Create Purchase Orders when inventory is low
- Send formatted HTML email replies

---

## Email Processing Flow

```
┌──────────────────────────────────────────────────────────────┐
│                    AGENT WORKFLOW                            │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  1. RECEIVE EMAIL                                            │
│     └── Extract: Item, Quantity, Sender                      │
│                                                              │
│  2. CHECK INVENTORY                                          │
│     └── Open Item List → Search → Get Qty on Hand            │
│                                                              │
│  3. EVALUATE                                                 │
│     ├── Sufficient: Report availability                      │
│     └── Insufficient: Create Purchase Order                  │
│                                                              │
│  4. SEND REPLY                                               │
│     └── HTML formatted email with results                    │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

---

## Sample Email Conversations

### Example 1: Sufficient Inventory

**Incoming Email:**
```
Subject: Check stock for ITEM-1000
Hi, can you check if we have 50 units of ITEM-1000 in stock?
Thanks, John
```

**Agent Response:**
```html
<p>Dear John,</p>

<p>I have checked the inventory for your requested item:</p>

<table border="1" style="border-collapse: collapse;">
  <tr>
    <th style="text-align: left; padding: 5px;">Item</th>
    <th style="text-align: left; padding: 5px;">Current Stock</th>
    <th style="text-align: left; padding: 5px;">Requested</th>
    <th style="text-align: left; padding: 5px;">Status</th>
  </tr>
  <tr>
    <td style="padding: 5px;">ITEM-1000 - Widget Standard</td>
    <td style="padding: 5px;">150</td>
    <td style="padding: 5px;">50</td>
    <td style="padding: 5px;">Available</td>
  </tr>
</table>

<p>The requested quantity is available in stock.</p>

<p>Best regards,<br/>
CRONUS Inventory Team</p>

<p><em>Powered by Business Central AI Agent</em></p>
```

---

### Example 2: Insufficient Inventory (Purchase Order Created)

**Incoming Email:**
```
Subject: Need 200 units of ITEM-2000
We need 200 units of ITEM-2000 for an upcoming project.
Can you check availability?
- Sarah
```

**Agent Response:**
```html
<p>Dear Sarah,</p>

<p>I have checked the inventory for your requested item:</p>

<table border="1" style="border-collapse: collapse;">
  <tr>
    <th style="text-align: left; padding: 5px;">Item</th>
    <th style="text-align: left; padding: 5px;">Current Stock</th>
    <th style="text-align: left; padding: 5px;">Requested</th>
    <th style="text-align: left; padding: 5px;">Shortage</th>
  </tr>
  <tr>
    <td style="padding: 5px;">ITEM-2000 - Premium Widget</td>
    <td style="padding: 5px;">75</td>
    <td style="padding: 5px;">200</td>
    <td style="padding: 5px;">125</td>
  </tr>
</table>

<p>I have created Purchase Order <strong>PO-001234</strong> to replenish the stock.</p>
<p>Please review and approve the purchase order when convenient.</p>

<p>Best regards,<br/>
CRONUS Inventory Team</p>

<p><em>Powered by Business Central AI Agent</em></p>
```

---

## Guidelines for Email Signature

All responses should include this signature:

```
Best regards,
CRONUS Inventory Team

<em>Powered by Business Central AI Agent</em>
```

---

## Error Handling

The agent handles these scenarios:

| Scenario | Response |
|----------|----------|
| Item not found | Ask for clarification, suggest similar items |
| No vendor for item | Note in reply, request guidance |
| Cannot create PO | Explain issue, suggest manual action |
| Multiple items match | List all matches, ask which one |

---

## Customization Tips

1. **Company Branding** - Update signature in the prompt file
2. **Inventory Thresholds** - Adjust reorder point logic
3. **Email Format** - Modify HTML templates in prompt
4. **Vendor Selection** - Add vendor lookup logic
5. **Location Handling** - Add multi-location support

---

## For Presentation

### Key Points to Highlight

1. **Email Integration** - Agent reads from standard BC email inbox
2. **AI Processing** - Uses BC Agent framework for AI tasks
3. **Business Logic** - Can create Purchase Orders automatically
4. **Response Quality** - Formatted HTML emails with tables

### Demo Scenario

1. Send email: "Check stock for bicycle tires, need 100 units"
2. Agent processes the request
3. Agent checks Item List for "bicycle tires"
4. If insufficient, creates a Purchase Order
5. Sends formatted reply with results
