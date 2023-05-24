% TrackGaze: trackGaze.m
% Author: Ethan Pirso
% Description: A demo script for gaze tracking using the EyeLink eye tracker.
% Dependencies: Psychtoolbox, Eyelink library
%
% Input variables in the workspace:
% - None
%
% Output variables in the workspace:
% - gazeData: Matrix containing x and y positions of the gaze.

% Initialize the EyeLink library
el = EyelinkInit();

% Set the calibration type to 9-point calibration
Eyelink('Command', 'calibration_type = HV9');

% Perform the calibration
EyelinkDoTrackerSetup(el);

% Start recording data from the EyeLink tracker
Eyelink('StartRecording');

% Initialize the gaze data matrix
gazeData = [];

% Loop to get the gaze position data in real-time
while true
    % Get the gaze position data
    data = Eyelink('GetQueuedData');
    % Extract the gaze position
    gazeX = data.gx(1);
    gazeY = data.gy(1);
    % Append the gaze position to the gaze data matrix
    gazeData = [gazeData; gazeX gazeY];
    % Check if the escape key is pressed
    [~,~,keyCode] = KbCheck;
    if keyCode(KbName('ESCAPE'))
        break;
    end
    % Wait for a short period before getting the next data point
    WaitSecs(0.05);
end

% Stop recording data and close the connection to the EyeLink tracker
Eyelink('StopRecording');
Eyelink('CloseFile');
