codeunit 50104 "ICA Agent Factory" implements IAgentFactory
{
    Access = Internal;

    procedure GetDefaultProfile(var TempAllProfile: Record "All Profile" temporary)
    var
        Agent: Codeunit Agent;
        ModuleInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(ModuleInfo);
        Agent.PopulateDefaultProfile('ICA Inventory Check Agent', ModuleInfo.Id, TempAllProfile);
    end;

    procedure GetDefaultInitials(): Text[4]
    begin
        exit('ICA');
    end;

    procedure GetFirstTimeSetupPageId(): Integer
    begin
        exit(Page::"ICA Setup Dialog");
    end;

    procedure ShowCanCreateAgent(): Boolean
    begin
        exit(true);
    end;

    procedure GetCopilotCapability(): Enum "Copilot Capability"
    begin
        exit(Enum::"Copilot Capability"::"Inventory Check Agent");
    end;

    procedure GetDefaultAccessControls(var TempAccessControlBuffer: Record "Access Control Buffer" temporary);
    var
        ModuleInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(ModuleInfo);
        TempAccessControlBuffer.Init();
        TempAccessControlBuffer."Company Name" := CopyStr(CompanyName(), 1, MaxStrLen(TempAccessControlBuffer."Company Name"));
        TempAccessControlBuffer.Scope := TempAccessControlBuffer.Scope::System;
        TempAccessControlBuffer."App ID" := ModuleInfo.Id;
        TempAccessControlBuffer."Role ID" := 'SUPER (DATA)';
        TempAccessControlBuffer.Insert();
    end;
}
