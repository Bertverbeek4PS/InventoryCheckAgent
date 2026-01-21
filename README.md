# Inventory Check Agent - Playground

A Business Central playground agent for checking item inventory via email and creating purchase orders when needed.

> **Demo/Presentation App** - Designed for demonstrations and learning purposes.

## Overview

This agent receives email requests from users to check item inventory. When inventory is insufficient, it automatically creates purchase orders. All responses are sent back via email.

## Features

- Receives email inquiries about item availability
- Checks inventory levels in Business Central
- Creates Purchase Orders for items with low/insufficient inventory
- Sends formatted HTML email replies with results
- Tracks processed emails and sent messages

## Project Structure

```
InventoryCheckAgent/
├── app.json                                    # Extension manifest
├── README.md                                   # This file
├── Resources/
│   └── InventoryCheckAgentPrompt.txt          # AI Agent instructions
└── src/
    ├── Integration/
    │   ├── ICAEmail.Table.al                  # Email tracking table
    │   ├── ICAEmailList.Page.al               # Email list view
    │   ├── ICAEmailCard.Page.al               # Email detail view
    │   ├── ICASentMessage.Table.al            # Sent message tracking
    │   ├── ICASentMessages.Page.al            # Sent messages list
    │   ├── ICASentMessageCard.Page.al         # Sent message detail
    │   ├── ICARetrieveEmails.Codeunit.al      # Email retrieval logic
    │   └── ICASendReplies.Codeunit.al         # Email reply logic
    ├── Setup/
    │   ├── ICASetup.Table.al                  # Configuration table
    │   └── ICASetup.Page.al                   # Configuration page
    ├── RoleCenter/
    │   └── ICARoleCenter.Page.al              # Agent role center
    ├── Profile/
    │   └── ICAProfile.Profile.al              # Agent profile
    └── Permissions/
        └── ICAFullAccess.PermissionSet.al     # Permission set
```

## Key Components

| Component | Purpose |
|-----------|---------|
| `ICA Setup` | Configure email account and agent settings |
| `ICA Retrieve Emails` | Fetches emails and creates Agent Tasks |
| `ICA Send Replies` | Sends agent responses back via email |
| `ICA Email` | Tracks processed emails |
| `ICA Sent Message` | Tracks sent replies (prevents duplicates) |

## Object Ranges

| Type | Range | Used |
|------|-------|------|
| Tables | 50100-50199 | 50100-50102 |
| Pages | 50100-50199 | 50100-50105 |
| Codeunits | 50100-50199 | 50100-50101 |
| Permission Sets | 50100-50199 | 50100 |

## Installation

1. Open the project in VS Code with AL Language extension
2. Download symbols: `Ctrl+Shift+P` -> `AL: Download Symbols`
3. Publish to your BC environment: `Ctrl+F5`

## Configuration

1. Search for **"ICA Setup"** in Business Central
2. Select an email account (click assist-edit on Email Address)
3. Optionally select a specific email folder to monitor
4. Set the Agent User Security ID (from the Agent setup)
5. Enable email monitoring

## How It Works

```
┌─────────────────────────────────────────────────────────────────┐
│                         EMAIL WORKFLOW                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  [User Email] ──► [Retrieve Emails] ──► [Create Agent Task]    │
│                                              │                  │
│                                              ▼                  │
│                                     [AI Agent Processes]        │
│                                              │                  │
│                                              ▼                  │
│  [User Gets Reply] ◄── [Send Replies] ◄── [Reviewed Output]    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Agent Workflow

1. **Email Arrives** - User sends email asking about inventory
2. **Retrieve Emails** - Codeunit fetches unread emails
3. **Create Task** - Agent Task created for AI processing
4. **AI Processing** - Agent checks items, creates POs if needed
5. **Send Reply** - Response sent back to user via email

## For Presentation

### Code Highlights
- All files have detailed comments explaining the logic
- Code is structured for easy walkthrough
- Uses standard BC patterns and best practices

### Key Files to Show
1. `ICARetrieveEmails.Codeunit.al` - How emails become Agent Tasks
2. `ICASendReplies.Codeunit.al` - How agent responses become emails
3. `InventoryCheckAgentPrompt.txt` - The AI agent instructions

### Demo Flow
1. Show the Setup page and email configuration
2. Send a test email asking about an item
3. Run "Retrieve Emails" action
4. Show the Agent Task created
5. Let the agent process (or manually review)
6. Run "Send Replies" action
7. Show the reply email received

## Testing

Use the actions on the Setup page:
- **Retrieve Emails** - Manually fetch new emails
- **Send Replies** - Manually send pending replies
- **View Emails** - See processed emails
- **Sent Messages** - See sent replies
