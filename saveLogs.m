function saveLogs(logs)
% log and save everything
% MN, September 2021

% output path
outPath = which('Start_deepMReye_calib.m'); % where are the stimulus script?
outPath = fullfile(fileparts(outPath), 'logs'); %

% create output directory if it does not exist
if exist(outPath, 'dir') ~= 7; mkdir(outPath); end

% set file name
if ~logs{1}.userQuit % if experiment ended normally
    file2save  = sprintf('%d_%s_logfile_%s.mat', logs{1}.run, logs{1}.subjID, datestr(now, 'dd.mm.yy_HH-MM'));
else % if user quit experiment manually
    file2save  = sprintf('quit_%d_%s_logfile_%s.mat', logs{1}.run, logs{1}.subjID, datestr(now, 'dd.mm.yy_HH-MM'));
end

% save
save(fullfile(outPath, file2save), 'logs');

end