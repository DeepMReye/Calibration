function [logs, cFrame] = playGuidedViewing(logs, settings, currTrial, frames, flag)
% play smooth pursuit task
% MN, September 2021

% select fixation/pursuit trajectory
if strcmp(flag, 'fixation'); xy = settings.fixtask.xy_trials; 
elseif strcmp(flag, 'pursuit'); xy = settings.pursuit.xy_trials_pursuit; end

% play all frames
for cFrame = frames
    
    % quit if user aborted experiment
    [~, firstPress] = KbQueueCheck();
    if firstPress(logs{1}.keys.escapeKey) || logs{1}.userQuit == 1
        logs{1}.userQuit = 1; return; end
    
    % draw fix cross
    total_n_Trial =  currTrial+logs{1}.passedTrials;
    logs{total_n_Trial}.crossVert   = CenterRect(settings.crossVert, logs{1}.winRect);
    logs{total_n_Trial}.crossHorz   = CenterRect(settings.crossHorz, logs{1}.winRect);
    logs{total_n_Trial}.xy(cFrame, :) = [xy{currTrial}(cFrame,1), xy{currTrial}(cFrame,2)];
    logs{total_n_Trial}.crossVert  = OffsetRect(logs{total_n_Trial}.crossVert, xy{currTrial}(cFrame,1), xy{currTrial}(cFrame,2));
    logs{total_n_Trial}.crossHorz  = OffsetRect(logs{total_n_Trial}.crossHorz, xy{currTrial}(cFrame,1), xy{currTrial}(cFrame,2));
    Screen('DrawLines', logs{1}.w, [logs{total_n_Trial}.crossVert(1:2)', logs{total_n_Trial}.crossVert(3:4)', ...
        logs{total_n_Trial}.crossHorz(1:2)', logs{total_n_Trial}.crossHorz(3:4)'], 3, settings.colors.black, [], []);
    
    % finish drawing and flip to screen
    Screen('DrawingFinished', logs{1}.w);
    logs{total_n_Trial}.flips(cFrame,1)    = Screen('Flip', logs{1}.w);
    
    % log scanner trigger
    if firstPress(logs{1}.keys.scannerTriggerKey)
        logs{1}.tTriggers = [logs{1}.tTriggers, logs{total_n_Trial}.flips(cFrame,1)];
    end
end

% add trial info to log file
logs{total_n_Trial}.trialType = flag;
end
