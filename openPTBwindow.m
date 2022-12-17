function [logs, oldRes] = openPTBwindow(settings)
    % Initialize psychtoolbox and open window
    % MN, September 2021

    % HideCursor;
    dbstop if error;
    Screen('Preference', 'ConserveVRAM', 4096);

    % set up keyboard and start queue for monitoring button presses
    logs = getKeyboard;

    % adjust screen resolution
    try
        oldRes    =   Screen('Resolution', settings.scr.scrID, settings.scr.width, ...
                             settings.scr.height, settings.scr.hz, [], []);
    catch
        warning('Your screen resolution was not changed - do it manually!');
        oldRes = [];
    end

    % open window
    [logs{1}.w, logs{1}.winRect]    =   Screen('OpenWindow', settings.scr.scrID);
    Screen('TextFont', logs{1}.w, 'Arial');
    Screen('TextSize', logs{1}.w, settings.scr.txtsz);
    % Priority(MaxPriority(logs{1}.w));

    % initial flip to sync us to VBL, get start timestamp and get rid of some bugs
    logs{1}.vbl = Screen('Flip', logs{1}.w);
end
