function [settings, valid] = getFixLocations_pursuit(settings, valid)
    % Pseudorandom walk for smooth pusuit task balancing eye-movement directions
    % and speeds. MN, September 2021

    % get movement angles and amplitudes (in pixel coordinates)
    mov_angles = repmat(settings.pursuit.angles, 1, numel(settings.pursuit.mov_amp));
    mov_amp = settings.pursuit.mov_amp * settings.units.pxPdeg;
    mov_amp = ones(numel(settings.pursuit.angles), numel(settings.pursuit.mov_amp)) .* mov_amp;
    mov_amp = mov_amp(:)';

    % window for pursuit trajectory (fixation cross will not leave this window)
    calib_win = [-settings.pursuit.win_sz / 2; settings.pursuit.win_sz / 2]';

    % create pursuit trajectory with defined movement angles & amplitudes within predefined window
    settings.pursuit.xy = [0, 0]; % start at screen center
    cTrial = 2;
    stuck = 0;
    while cTrial <= (numel(settings.pursuit.mov_amp) * numel(settings.pursuit.angles) + 1)

        % if no solution can be found, step out and try again
        if stuck > 50
            return
        end

        % select random angle x amplitude combo
        trial_id    = randi(numel(mov_angles));
        trial_angle = mov_angles(trial_id);
        trial_amp   = mov_amp(trial_id);

        settings.pursuit.xy(cTrial, 1) = (settings.pursuit.xy(cTrial - 1, 1)) + round(trial_amp * cos(trial_angle));
        settings.pursuit.xy(cTrial, 2) = (settings.pursuit.xy(cTrial - 1, 2)) + round(trial_amp * sin(trial_angle));

        % if fixation cross leaves calibration window, try selecting another angle & amplitude
        if settings.pursuit.xy(cTrial, 1) < calib_win(1, 1) || settings.pursuit.xy(cTrial, 1) > calib_win(1, 2) || ...
                settings.pursuit.xy(cTrial, 2) < calib_win(2, 1) || settings.pursuit.xy(cTrial, 2) > calib_win(2, 2)
            stuck = stuck + 1;
            continue
        else
            % if fixation cross is within calibration window, remove chosen angle from list
            mov_angles(trial_id) = [];
            mov_amp(trial_id)  = [];
            cTrial = cTrial + 1;
        end
    end

    % interpolate position inbetween screen locations
    if isempty(mov_angles) && isempty(mov_amp)
        valid = 1;
        for cTrial = 2:size(settings.pursuit.xy, 1)
            settings.pursuit.xy_trials_pursuit{cTrial - 1}(1, :) = linspace(settings.pursuit.xy(cTrial - 1, 1), settings.pursuit.xy(cTrial, 1), settings.pursuit.dur * settings.scr.hz + 1);
            settings.pursuit.xy_trials_pursuit{cTrial - 1}(2, :) = linspace(settings.pursuit.xy(cTrial - 1, 2), settings.pursuit.xy(cTrial, 2), settings.pursuit.dur * settings.scr.hz + 1);
        end
    end

    % add starting position (0,0) as first trial
    settings.pursuit.xy_trials_pursuit = arrayfun(@(x) settings.pursuit.xy_trials_pursuit{x}(:, 2:end)', 1:numel(settings.pursuit.xy_trials_pursuit), 'UniformOutput', false);
    settings.pursuit.xy_trials_pursuit = [{zeros(settings.pursuit.dur * settings.scr.hz, 2)}, settings.pursuit.xy_trials_pursuit];
    settings.pursuit.xy_trials_pursuit = cellfun(@round, settings.pursuit.xy_trials_pursuit, 'uni', 0);
    % ----------------------------------------------------------------------- %
end
