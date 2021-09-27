function logs = wait4Trigger(logs, settings, theStr)
% Wait for scanner trigger.
% MN, September 2021

logs{1}.userQuit    = 0;
waiting4Trigger  	= 1;
fprintf('\n Waiting for trigger...')
while waiting4Trigger
    gotTrigger = 0;
    
    % draw waiting screen
    Screen('FillRect', logs{1}.w, settings.colors.gray);
    DrawFormattedText(logs{1}.w, cell2mat(theStr(1:numel(theStr))), 'center','center', settings.colors.black);
    Screen('Flip', logs{1}.w);
    
    % Check if trigger arrived
    [~, firstPress]         = KbQueueCheck();
    if firstPress(logs{1}.keys.scannerTriggerKey) % trigger arrived
        gotTrigger          = 1;
        triggertstamp       = firstPress(logs{1}.keys.scannerTriggerKey);
    elseif firstPress(logs{1}.keys.escapeKey) % user quit
        logs{1}.userQuit    = 1; sca
        return;
    end
    
    % if trigger arrived, break while loop and start stimulus
    if gotTrigger
        % print to user
        fprintf(' Got it!');
        fprintf('\nStarting stimulus ...');
        
        % log everything
        waiting4Trigger = 0;
        scannerTrCtr = 1;
        logs{1}.FirstVolOfExp = triggertstamp;
        logs{1}.tTriggers(scannerTrCtr) = triggertstamp;
    end
end
end