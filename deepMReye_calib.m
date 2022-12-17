function [logs, settings] = deepMReye_calib(settings)
    % ======================================================================= %
    %                          Main stimulus script                           %
    % ======================================================================= %
    % Presents following tasks: fixation, smooth pursuit, picture viewing
    % MN, September 2021

    % ------------------ Open ptb-window and initiate task ------------------ %
    % PsychDebugWindowConfiguration % make ptb screen transparent for debugging
    [logs, oldRes] = openPTBwindow(settings);

    % Initialize eye tracker
    if settings.eyeTracking == 1
        [logs, settings] = initEyeLink(logs, settings);
    end

    % Load images for picture viewing
    settings = importPics(settings, logs);

    % Wait for trigger & show instructions
    theStr{1} = 'DeepMReye exemplary calibration script \n\n';
    theStr{2} = 'Waiting for triggers... (Dummy run: click "s" to start.)';
    logs = wait4Trigger(logs, settings, theStr);

    % ----------------------------------------------------------------------- %

    % ============================  Start tasks ============================= %

    % -------------  Condition 1: Fixation (pseudorandom walk)  ------------- %

    % draw task instructions
    theStr  = 'Fixation task - always fixate at the black cross';
    logs{1}.passedTrials = 1;
    [logs, settings] = draw_text(settings, logs, 1, 4, theStr);

    % go!
    logs{1}.passedTrials = logs{1}.passedTrials + 1;
    currTrial = 0;
    while currTrial <= numel(settings.fixtask.xy_trials) - 1 && logs{1}.userQuit == 0
        currTrial = currTrial + 1;
        cFrame = 0;

        % send trial info to eye tracker
        if settings.eyeTracking == 1
            Eyelink('Message', sprintf('Trial%d', currTrial));
        end

        % show fixation sequence
        frames = cFrame + 1:cFrame + settings.fixtask.dur * settings.scr.hz;
        [logs, cFrame] = playGuidedViewing(logs, settings, currTrial, frames, 'fixation');
    end
    logs{1}.passedTrials = logs{1}.passedTrials + currTrial;

    % -----------  Condition 2: Smooth Pursuit (pseudorandom walk) ---------- %

    % draw task instructions
    theStr  = 'Smooth-pursuit task - always fixate at the moving black cross';
    [logs, settings] = draw_text(settings, logs, 1, 4, theStr);

    % go!
    logs{1}.passedTrials = logs{1}.passedTrials + 1;
    currTrial = 0;
    while currTrial <= numel(settings.pursuit.xy_trials_pursuit) - 1 && logs{1}.userQuit == 0
        currTrial = currTrial + 1;
        cFrame = 0;

        % send trial info to eye tracker
        if settings.eyeTracking == 1
            Eyelink('Message', sprintf('Tr%d', currTrial));
        end

        % show pursuit sequence
        frames = cFrame + 1:cFrame + settings.pursuit.dur * settings.scr.hz;
        [logs, cFrame] = playGuidedViewing(logs, settings, currTrial, frames, 'pursuit');
    end
    logs{1}.passedTrials = logs{1}.passedTrials + currTrial;

    % -----------------  Condition 3: Free image viewing  ------------------- %

    % draw task instructions
    theStr  = 'Free viewing task - explore the following images however you like';
    [logs, settings] = draw_text(settings, logs, 1, 4, theStr); % draw task instructions

    % go!
    logs{1}.passedTrials = logs{1}.passedTrials + 1;
    currTrial = 0;
    while currTrial < numel(settings.pics.id) && logs{1}.userQuit == 0
        currTrial = currTrial + 1;
        cFrame = 0;

        % send trial info to eye tracker
        if settings.eyeTracking == 1
            Eyelink('Message', sprintf('Tr%d', currTrial));
        end

        % draw image
        frames = cFrame + 1:cFrame + settings.picTask.dur * settings.scr.hz;
        [settings, logs] = playPictureViewing(settings, logs, currTrial, frames);
    end
    logs{1}.passedTrials = logs{1}.passedTrials + currTrial;

    % =============================  End tasks ============================== %

    % finish and shut down
    if logs{1}.userQuit == 0
        for cFrame = 1:settings.waitSecsAfterRun * settings.scr.hz

            % Show final text/feedback
            theStr = sprintf('Well done! We are finishing in %d seconds. \n\n', settings.waitSecsAfterRun);
            DrawFormattedText(logs{1}.w,  theStr, 'center', settings.scr.height / 2 + 40, settings.colors.black);
            logs{1}.feedback(cFrame) = Screen('Flip', logs{1}.w);

            % log scanner trigger
            [~, firstPress] = KbQueueCheck();
            if firstPress(logs{1}.keys.scannerTriggerKey)
                logs{1}.tTriggers = [logs{1}.tTriggers, logs{1}.feedback(cFrame)];
            end
        end
    end
    Screen('CloseAll');
    % ----------------------------------------------------------------------- %

    % log all XYs for all frames
    tmp = arrayfun(@(x) logs{x}.flips', 2:numel(logs) - 1, 'UniformOutput', false);
    logs{1}.allFlips = horzcat(tmp{:})';
    tmp = arrayfun(@(x) logs{x}.xy', 2:numel(logs) - 1, 'UniformOutput', false);
    logs{1}.allXYs = cell2mat(tmp)';

    % stop eye tracker and close file
    if settings.eyeTracking == 1
        Eyelink('StopRecording');
        Eyelink('CloseFile');
        Eyelink('Shutdown');
    end

    % plot fixation-target trajectory & triggers for fun
    if ~logs{1}.userQuit % if experiment ended normally
        figure;
        hold all;
        plot(logs{1}.allFlips, logs{1}.allXYs(:, 1)); % X coordinates over time
        plot(logs{1}.allFlips, logs{1}.allXYs(:, 2)); % Y coordinates over time
        xlabel('frames');
        ylabel('position (X & Y)');
        title('target position over time');
        legend({'X', 'Y'});
        arrayfun(@(x) vline(logs{1}.tTriggers(x)), 1:numel(logs{1}.tTriggers), 'uni', 0);
        hold off;
    end

    % set back resolution
    if ~isempty(oldRes)
        Screen('Resolution', settings.scr.scrID, oldRes.width, ...
               oldRes.height, oldRes.hz, oldRes.pixelSize, []);
    end
end
