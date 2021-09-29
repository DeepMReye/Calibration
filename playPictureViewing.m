function [settings, logs] = playPictureViewing(settings, logs, currTrial, frames)
% play picture-viewing task
% MN, September 2021

total_n_Trial =  currTrial+logs{1}.passedTrials;
logs{total_n_Trial}.pic = settings.pics.paths{currTrial};
for cFrame = frames
    
    % quit if user aborted experiment
    [~, firstPress] = KbQueueCheck();
    if firstPress(logs{1}.keys.escapeKey) || logs{1}.userQuit == 1
        logs{1}.userQuit = 1;
        return;
    end
    
    % draw image
    total_n_Trial          =  currTrial+logs{1}.passedTrials;
    picSz                  = round(settings.scr.height/3);
    [center(1), center(2)] = RectCenter(logs{1}.winRect);
    picCoords              = [center(1)-picSz center(2)-picSz, center(1)+picSz center(2)+picSz];
    Screen('DrawTexture', logs{1}.w, settings.pics.id(currTrial), [],picCoords);
    
    % finish drawing and flip to screen
    Screen('DrawingFinished', logs{1}.w);
    logs{total_n_Trial}.flips(cFrame,1)    = Screen('Flip', logs{1}.w);
    
    % log scanner trigger
    if firstPress(logs{1}.keys.scannerTriggerKey)
        logs{1}.tTriggers = [logs{1}.tTriggers, logs{total_n_Trial}.flips(cFrame,1)];
    end
    
    % log NaN's for xy's
    logs{total_n_Trial}.xy(cFrame, :) = [nan, nan];
end

% add trial info to log file
logs{total_n_Trial}.trialType = 'free_viewing';
end

