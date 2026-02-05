codeunit 50102 "ICA Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        CopilotCapability: Codeunit "Copilot Capability";
        EnvironmentInformation: Codeunit "Environment Information";
        LearnMoreUrlTxt: Label 'https://go.microsoft.com/fwlink/?linkid=2281481', Locked = true;
    begin
        if not EnvironmentInformation.IsSaaSInfrastructure() then
            exit;

        if CopilotCapability.IsCapabilityRegistered(Enum::"Copilot Capability"::"Inventory Check Agent") then
            CopilotCapability.ModifyCapability(Enum::"Copilot Capability"::"Inventory Check Agent", Enum::"Copilot Availability"::"Early Preview", Enum::"Copilot Billing Type"::"Microsoft Billed", LearnMoreUrlTxt)
        else
            CopilotCapability.RegisterCapability(Enum::"Copilot Capability"::"Inventory Check Agent", Enum::"Copilot Availability"::"Early Preview", Enum::"Copilot Billing Type"::"Microsoft Billed", LearnMoreUrlTxt);
        //CreateInventoryCheckAgent();
    end;

    procedure CreateInventoryCheckAgent()
    var
        Agent: Codeunit Agent;
        ICASetup: Record "ICA Setup";
        TempAgentAccessControl: Record "Agent Access Control" temporary;
        AgentUserSecurityID: Guid;
        AgentPrompt: Text;
        UserName: Code[50];
    begin
        // Load the agent prompt from the resource file
        AgentPrompt := LoadAgentPrompt();

        // Agent username
        UserName := 'INVENTORY_AGENT';

        // Check if agent already exists per our setup
        //ICASetup.GetOrCreate();
        if ICASetup.FindFirst() then;
        if not IsNullGuid(ICASetup."User Security ID") then begin
            // Agent already exists, just update instructions
            Agent.SetInstructions(ICASetup."User Security ID", AgentPrompt);
            exit;
        end;

        // Build default access controls - add current user as administrator
        TempAgentAccessControl.Init();
        TempAgentAccessControl."User Security ID" := UserSecurityId();
        TempAgentAccessControl."Can Configure Agent" := true;
        TempAgentAccessControl."Company Name" := CompanyName();
        TempAgentAccessControl.Insert();

        // Create the agent using the Agent Metadata Provider interface implementations
        AgentUserSecurityID := Agent.Create(
            Enum::"Agent Metadata Provider"::"ICA Inventory Check Agent",
            UserName,
            'Inventory Check Agent',
            TempAgentAccessControl);

        // Set agent instructions from prompt file
        Agent.SetInstructions(AgentUserSecurityID, AgentPrompt);

        // Assign profile to the agent
        AssignAgentProfile(AgentUserSecurityID);

        // Activate the agent
        //Agent.Activate(AgentUserSecurityID);

        // Update the ICA Setup table with the agent's GUID
        ICASetup.DeleteAll();
        ICASetup.Init();
        ICASetup."User Security ID" := AgentUserSecurityID;
        ICASetup.Insert(true);
    end;

    local procedure LoadAgentPrompt(): Text
    var
        PromptText: Text;
    begin
        // Load the agent prompt from the resource file
        // The resource name is relative to the resourceFolders specified in app.json
        PromptText := NavApp.GetResourceAsText('InventoryCheckAgentPrompt.txt', TextEncoding::UTF8);

        if PromptText = '' then
            Error('Failed to load the agent prompt resource file or the file is empty.');

        exit(PromptText);
    end;

    local procedure AssignAgentProfile(AgentUserSecurityID: Guid)
    var
        Agent: Codeunit Agent;
        AllProfile: Record "All Profile";
    begin
        // Find the ICA Inventory Check Agent profile
        AllProfile.SetRange("Profile ID", 'ICA Inventory Check Agent');
        if not AllProfile.FindFirst() then
            exit;

        // Assign the profile to the agent using the Agent codeunit
        Agent.SetProfile(AgentUserSecurityID, AllProfile."Profile ID", AllProfile."App ID");
    end;
}
