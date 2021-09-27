function Start_deepMReye_calib(subjID, run)
% ------ Calibration script to acquire training data for DeepMReye ------ %

% This script requires Psychtoolbox: http://psychtoolbox.org
% To run it, paste "Start_deepMReye_calib('test', 1)" into the command 
% window and click enter. Screen and task settings can be changed below. 
% Last update: MN, September 2021

% ------------------------- This is a template -------------------------- %

% The type of training data you need depends on your study objectives. 
% Please adjust this script accordingly. See the user documentation for 
% details: https://deepmreye.slite.com/p/channel/MUgmvViEbaATSrqt3susLZ

% ---------------------------- 3 conditions ----------------------------- %

% By default, the script loops through following conditions
% 1) Fixations: The fixation cross will jump to various screen locations.
% 2) Smooth pursuit: The fixation cross will move smoothly at various speeds 
% on a random-walk trajectory with defined directional sampling.
% 3) Free viewing of images (only if camera-based eye tracking is available).

% ----------------------------- References ------------------------------ %

% If you use parts of this script please cite the following articles.

% 1) Frey* M., Nau* M., Doeller C.F. (2021). Magnetic resonance-based eye 
% tracking using deep neural networks. Nature Neuroscience.
% 2) Kleiner M., Brainard D., Pelli D. (2007). What's new in Psychtoolbox-3. 
% Perception, 36, 1.
% ----------------------------------------------------------------------- %

% clean up
close all; clearvars -except subjID run; clc
Screen('Preference', 'SkipSyncTests', 1); % for debugging only

% set state of random number generator
rng('shuffle');

% participant info for logging
settings.subjID                 =   subjID;
settings.run                    =   run;
settings.root                   =   '/Users/naum2/Desktop/Scripts/deepMReye_calibration'; % path to this folder

% screen settings
settings.scr.scrID              =    max(Screen('Screens')); % select screen
settings.scr.width              =    1280;  % screen width in pixel
settings.scr.width_cm           =    88;    % screen width in cm 36.9; % cm
settings.scr.height             =    1024;  % screen height in pixel
settings.scr.height_cm          =    40;    % screen height in cm
settings.scr.hz                 =    60;    % screen refresh rate in hertz
settings.scr.eye2scr            =    65.5;  % eye to screen distance in cm
settings.scr.txtsz              =    44;    % font size for task instructions (whatever looks good on your setup)

% compute units (e.g. degree visual angle)
settings.units                  =    getUnits(settings);

% eye tracking (Eyelink)
settings.eyeTracking            =    0; % Eyelink running? yes = 1, no = 0

% fixation cross settings
settings.crossSz                =    ceil(settings.scr.width/80); % size of the fixation cross in pixel
settings.crossVert              =    [0 0 0 settings.crossSz]; % vertical line
settings.crossHorz              =    [0 0 settings.crossSz 0]; % horizontal line

% condition 1: fixation task
settings.fixtask.win_sz         =    [settings.scr.height, settings.scr.height]./1.25; % sample fixations within this window
settings.fixtask.n_locs         =    [10,10]; % n fixation locations [horizontal, vertical]
settings.fixtask.dur            =    1.5; % fixation duration in s
settings                        =    getFixLocations(settings);

% condition 2: smooth pursuit task (pseudo-random walk)
settings.pursuit.win_sz         =    settings.fixtask.win_sz;
settings.pursuit.angles         =    deg2rad(0:15:359); % tested directions
settings.pursuit.mov_amp        =    [4 6 8]; % movement amplitudes in visual angle
settings.pursuit.mov_dur        =    1.5; % movement duration before changing direction
valid = 0; while ~valid
    [settings, valid]           =    getFixLocations_pursuit(settings, valid); end % smooth pursuit task

% condition 3: free picture viewing task (requires camera eye tracker)
settings.picTask.path2pics      =   fullfile(settings.root, 'images'); % path to your own images
settings.picTask.n_pics         =   6; % how many of the pictures in the folder should be shown (random selection)?
settings.picTask.dur            =   3; % duration of each image in seconds

% other settings
settings.colors                 =    getColors; % define colors
settings.waitSecsAfterRun       =    5; % wait a few seconds before closing (>15s in case HRF should be captured)

% start stimulus
[logs, settings]                =   deepMReye_calib(settings);

% save logs
logs{1}.settings                =   settings;
logs{1}.run                     =   run;
logs{1}.subjID                  =   subjID;
saveLogs(logs)

% stop key press monitoring
KbQueueFlush; KbQueueStop;
end