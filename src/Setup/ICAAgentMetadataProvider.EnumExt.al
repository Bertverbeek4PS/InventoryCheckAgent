enumextension 50100 "ICA Agent Metadata Provider" extends "Agent Metadata Provider"
{
    value(50100; "ICA Inventory Check Agent")
    {
        Caption = 'ICA Inventory Check Agent';
        Implementation = IAgentMetadata = "ICA Agent Metadata", IAgentFactory = "ICA Agent Factory";
    }
}
