% Continuous Psychophysics with Eye Tracking (CPET): closeEyelink.m
% Author: Ethan Pirso
% Description: Stops EyeLink data acquisition, closes the EDF file, downloads the output file, and shuts down the EyeLink system.
% Dependencies: None
% Called by: run.m
%
% Input variables in the workspace:
% - edfFile: Name of the EyeLink EDF file.
%
% Output variables in the workspace:
% - None

% Stop eyelink data acquisition
Eyelink('StopRecording');
Eyelink('command', 'set_idle_mode');
WaitSecs(0.5);
Eyelink('CloseFile');

% Download eyelink output file
path = fullfile(pwd,'../DATA/EDF');
try
    fprintf('Receiving data file ''%s''\n', edfFile);
    status=Eyelink('ReceiveFile', edfFile, path, 1);
    if status > 0
        fprintf('ReceiveFile status %d\n', status);
    end
    if 2==exist(edfFile, 'file')
        fprintf('Data file ''%s'' can be found in ''%s''\n', edfFile, pwd );
    end
catch %#ok<*CTCH>
    fprintf('Problem receiving data file ''%s''\n', edfFile );
end

Eyelink('ShutDown');
