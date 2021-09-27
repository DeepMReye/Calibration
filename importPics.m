function settings = importPics(settings, logs)
% import random images from specified folder.
% MN, September 2021

% select random images
path2pics = dir(settings.picTask.path2pics); path2pics = path2pics(3:end);
path2pics = fullfile(path2pics(1).folder, {path2pics(:).name}');
tmp  = unique(randi(numel(path2pics), 1, 100)); tmp = tmp(randperm(numel(tmp))); 
path2pics = path2pics(tmp(1:settings.picTask.n_pics));
settings.pics.paths = path2pics;

% import images
settings.pics.id = cell2mat(arrayfun(@(x) Screen('MakeTexture', logs{1}.w, imread(path2pics{x})), 1:settings.picTask.n_pics, 'uni', 0));
end
