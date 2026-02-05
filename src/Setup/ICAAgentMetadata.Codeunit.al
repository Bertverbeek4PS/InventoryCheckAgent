codeunit 50103 "ICA Agent Metadata" implements IAgentMetadata
{
    Access = Internal;

    procedure GetDisplayName(): Text[80]
    begin
        exit('Inventory Check Agent');
    end;

    procedure GetInitials(AgentUserId: Guid): Text[4];
    begin
        exit('ICA');
    end;

    procedure GetSetupPageId(AgentUserId: Guid): Integer;
    begin
        exit(Page::"ICA Setup Dialog");
    end;

    procedure GetSummaryPageId(AgentUserId: Guid): Integer
    begin
        exit(Page::"ICA KPI");
    end;

    procedure GetAgentTaskMessagePageId(AgentUserId: Guid): Integer
    begin
        exit(Page::"Agent Task Message Card"); // Use default
    end;

    procedure GetAgentAnnotations(AgentUserId: Guid; var Annotations: Record "Agent Annotation");
    begin
        // No custom annotations for this agent
    end;

    procedure GetAgentTaskMessagePageId(AgentUserId: Guid; MessageId: Guid): Integer;
    begin
        exit(Page::"Agent Task Message Card"); // Use default
    end;
}
