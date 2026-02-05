// ============================================================================
// Inventory Check Agent - Job Queue Handler
// ============================================================================
// This codeunit handles the scheduled execution of email retrieval and
// reply sending. It is called by the Job Queue Entry every minute when
// email monitoring is enabled.
// ============================================================================

namespace Demo.Agent.InventoryCheckAgent;

using System.Threading;

codeunit 50105 "ICA Job Queue Handler"
{
    Access = Internal;
    TableNo = "Job Queue Entry";

    var
        JobQueueCategoryCodeTok: Label 'ICA', Locked = true;
        JobQueueDescriptionLbl: Label 'Inventory Check Agent - Email Processing';

    trigger OnRun()
    var
        ICASetup: Record "ICA Setup";
        ICARetrieveEmails: Codeunit "ICA Retrieve Emails";
        ICASendReplies: Codeunit "ICA Send Replies";
    begin
        // Get setup record
        if not ICASetup.FindFirst() then
            exit;

        // Check if monitoring is enabled
        if not ICASetup."Email Monitoring Enabled" then
            exit;

        // Check if agent is enabled
        if ICASetup.State <> ICASetup.State::Enabled then
            exit;

        // Step 1: Retrieve new emails and create agent tasks
        ICARetrieveEmails.Run(ICASetup);

        // Step 2: Send replies for approved messages
        ICASendReplies.Run(ICASetup);
    end;

    /// <summary>
    /// Creates or enables the job queue entry for email processing
    /// </summary>
    procedure EnableJobQueue(var ICASetup: Record "ICA Setup")
    var
        JobQueueEntry: Record "Job Queue Entry";
        JobQueueCategory: Record "Job Queue Category";
    begin
        // Ensure job queue category exists
        if not JobQueueCategory.Get(JobQueueCategoryCodeTok) then begin
            JobQueueCategory.Init();
            JobQueueCategory.Code := JobQueueCategoryCodeTok;
            JobQueueCategory.Description := 'Inventory Check Agent';
            JobQueueCategory.Insert(true);
        end;

        // Check if we already have a job queue entry
        if not IsNullGuid(ICASetup."Scheduled Task ID") then begin
            if JobQueueEntry.Get(ICASetup."Scheduled Task ID") then begin
                // Re-enable existing job queue entry
                if JobQueueEntry.Status <> JobQueueEntry.Status::Ready then begin
                    JobQueueEntry.Status := JobQueueEntry.Status::Ready;
                    JobQueueEntry.Modify(true);
                    Codeunit.Run(Codeunit::"Job Queue - Enqueue", JobQueueEntry);
                end;
                exit;
            end;
        end;

        // Create new job queue entry
        JobQueueEntry.Init();
        JobQueueEntry.ID := CreateGuid();
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
        JobQueueEntry."Object ID to Run" := Codeunit::"ICA Job Queue Handler";
        JobQueueEntry.Description := JobQueueDescriptionLbl;
        JobQueueEntry."Job Queue Category Code" := JobQueueCategoryCodeTok;
        JobQueueEntry."Recurring Job" := true;
        JobQueueEntry."Run on Mondays" := true;
        JobQueueEntry."Run on Tuesdays" := true;
        JobQueueEntry."Run on Wednesdays" := true;
        JobQueueEntry."Run on Thursdays" := true;
        JobQueueEntry."Run on Fridays" := true;
        JobQueueEntry."Run on Saturdays" := true;
        JobQueueEntry."Run on Sundays" := true;
        JobQueueEntry."Starting Time" := 000000T;
        JobQueueEntry."Ending Time" := 235959T;
        JobQueueEntry."No. of Minutes between Runs" := 1;
        JobQueueEntry."Maximum No. of Attempts to Run" := 3;
        JobQueueEntry."Rerun Delay (sec.)" := 30;
        JobQueueEntry.Insert(true);

        // Store the job queue entry ID in setup
        ICASetup."Scheduled Task ID" := JobQueueEntry.ID;
        ICASetup.Modify(true);

        // Set to ready and enqueue
        Codeunit.Run(Codeunit::"Job Queue - Enqueue", JobQueueEntry);
    end;

    /// <summary>
    /// Disables the job queue entry for email processing
    /// </summary>
    procedure DisableJobQueue(var ICASetup: Record "ICA Setup")
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        if IsNullGuid(ICASetup."Scheduled Task ID") then
            exit;

        if not JobQueueEntry.Get(ICASetup."Scheduled Task ID") then
            exit;

        // Set to on hold to disable
        if JobQueueEntry.Status <> JobQueueEntry.Status::"On Hold" then begin
            JobQueueEntry.Status := JobQueueEntry.Status::"On Hold";
            JobQueueEntry.Modify(true);
        end;
    end;

    /// <summary>
    /// Deletes the job queue entry completely
    /// </summary>
    procedure DeleteJobQueue(var ICASetup: Record "ICA Setup")
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        if IsNullGuid(ICASetup."Scheduled Task ID") then
            exit;

        if JobQueueEntry.Get(ICASetup."Scheduled Task ID") then
            JobQueueEntry.Delete(true);

        Clear(ICASetup."Scheduled Task ID");
        ICASetup.Modify(true);
    end;

    /// <summary>
    /// Updates the job queue state based on current setup
    /// </summary>
    procedure UpdateJobQueueState(var ICASetup: Record "ICA Setup")
    begin
        if ICASetup."Email Monitoring Enabled" and (ICASetup.State = ICASetup.State::Enabled) then
            EnableJobQueue(ICASetup)
        else
            DisableJobQueue(ICASetup);
    end;
}
