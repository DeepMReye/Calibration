function [units] = getUnits(settings)
% Compute a few useful units based on your screen settings 
% MN, September 2021

units.ScrDiag_px   =   sqrt(settings.scr.width^2 + settings.scr.height^2); % screen diagonal in pixel
units.ScrDiag_cm   =   sqrt(settings.scr.width_cm^2 + settings.scr.height_cm^2); % screen diagonal in cm
units.pxPcm        =   units.ScrDiag_px/units.ScrDiag_cm; % pixel per cm
units.pxPdeg       =   (settings.scr.eye2scr*tand(1))*units.pxPcm; % pixel per degree

% add your favorite units here
end