function [logs, settings] = initEyelink(logs, settings)
    % initialize EYELINK eye tracker
    % MN, September 2021

    % Provide Eyelink with details about the graphics environment &
    % initialize
    el = EyelinkInitDefaults(logs{1}.w);
    dummymode = 0;
    if ~EyelinkInit(dummymode, 1) % Check
        fprintf('Eyelink Init aborted.\n');
        cleanup;
        return
    end
    [~, vs] = Eyelink('GetTrackerVersion');
    fprintf('Running experiment on a ''%s'' tracker.\n', vs); % Check

    % configuration settings
    Eyelink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE');
    Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,AREA'); % Check
    % set link data (used for gaze cursor)
    Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT');
    Eyelink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,AREA');

    % make sure that we get gaze data from the Eyelink
    Eyelink('Command', 'link_sample_data = LEFT,RIGHT,GAZE,AREA');

    % open file to record data to
    thedatestr = datestr(now, 'yyyy-mm-dd_HH.MM');
    settings.eyelink.edfFile = [sprintf('%s_run%d', settings.subjID, settings.run)];
    status = Eyelink('Openfile', [settings.eyelink.edfFile '.edf']);
    if status ~= 0
        fprintf('Could not open Eyelink file');
    end

    % Calibrate the eye tracker
    EyelinkDoTrackerSetup(el);

    % check calibration and do drift correction if necessary
    % EyelinkDoDriftCorrection(el);

    % start recording
    Eyelink('StartRecording');

    % add go signal to log file
    Eyelink('Message', 'SYNCTIME');
end
