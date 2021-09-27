function settings = getFixLocations(settings)
% condition 1: fixations at various locations on the screen
% MN, September 2021

% get coordinates
x = round(linspace(-settings.fixtask.win_sz(1)/2, settings.fixtask.win_sz(1)/2, settings.fixtask.n_locs(1)))';
y = round(linspace(-settings.fixtask.win_sz(2)/2, settings.fixtask.win_sz(2)/2, settings.fixtask.n_locs(2)))';
xy = [];
for i = 1:numel(x)
    xy  = [xy; repmat(x(i),numel(y),1),y];
end

% randomize presentation order
xy = xy(randperm(length(xy)), :);

% split into frames and trials
fix_dur = settings.fixtask.dur*settings.scr.hz;
settings.fixtask.xy_trials = arrayfun(@(i) repmat(xy(i,:), fix_dur, 1), 1:length(xy), 'uni', 0);
end