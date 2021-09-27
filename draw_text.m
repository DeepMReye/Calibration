function [logs, settings, total_n_Trial] = draw_text(settings, logs, currTrial, howlong, theStr)
% draw text on gray background onto the screen
% MN, September 2021

% Need to add comments here still
if ~logs{1}.userQuit % user quit?
    total_n_Trial =  currTrial+logs{1}.passedTrials; frCtr = 0;
    for cFrame = 1:(howlong.*settings.scr.hz)
        frCtr = frCtr + 1;
        Screen('FillRect', logs{1}.w, settings.colors.gray);
        if iscell(theStr)
            text_spacing = settings.scr.width.*0.0275;
            text_positions = (0:text_spacing:text_spacing.*numel(theStr)) - text_spacing.*numel(theStr)/2;
            for cStr = 1:numel(theStr)
                DrawFormattedText(logs{1}.w,  theStr{cStr}, 'center', settings.scr.height/2 + text_positions(cStr), settings.colors.black);
            end
        else
            DrawFormattedText(logs{1}.w,  theStr, 'center', 'center', settings.colors.black);
        end
        
        % log stuff
        logs{total_n_Trial}.xy(frCtr, :) = [nan, nan];
        logs{total_n_Trial}.trialType = 'blank_text';
        logs{total_n_Trial}.flips(frCtr,1) = Screen('Flip', logs{1}.w);
        
        % check keyboard / triggers
        [~, firstPress] = KbQueueCheck();
        if firstPress(logs{1}.keys.scannerTriggerKey)
            logs{1}.tTriggers = [logs{1}.tTriggers, logs{total_n_Trial}.flips(frCtr,1)];
        elseif firstPress(logs{1}.keys.escapeKey)
            logs{1}.userQuit    = 1; sca
            return;
        elseif firstPress(logs{1}.keys.response_right)
            logs{total_n_Trial}.tkeyPress = logs{total_n_Trial}.flips(frCtr,1);
            total_n_Trial =  total_n_Trial + 1;
            currTrial = currTrial+1; frCtr = 0;
        elseif firstPress(logs{1}.keys.response_left)
            logs{total_n_Trial}.tkeyPress = logs{total_n_Trial}.flips(frCtr,1);
            total_n_Trial =  total_n_Trial + 1;
            currTrial = currTrial+1; frCtr = 0;
        end
    end
end
end