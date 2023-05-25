% Continuous Psychophysics with Eye Tracking (CPET): collectData.m
% Author: Ethan Pirso
% Description: Collects eye gaze data from the EyeLink and updates stimulus position data.
% Dependencies: None
% Called by: run.m
%
% Input variables in the workspace:
% - trackedEye: The eye that is being tracked (el.LEFT_EYE or el.RIGHT_EYE).
% - el: Eyelink configuration structure.
% - X: X coordinate of the stimulus center on the screen.
% - Y: Y coordinate of the stimulus center on the screen.
% - contrast: Contrast of the stimulus.
%
% Output variables in the workspace:
% - gazeData: Updated matrix containing gaze positions for each frame.
% - stimData: Updated matrix containing stimulus positions and contrast for each frame.

if exist('demo','var') && ~demo
    % Collect all data from eyelink
    [samples, events, drained] = Eyelink('GetQueuedData'); 
    
    switch trackedEye % checks tracked eye recording status
        case el.BINOCULAR
            error('tracker indicates binocular');
        case el.LEFT_EYE
            leftGazePos = [(samples(14,end)) (samples(16,end))]; % xy-pos of left gaze 
            gazeData = [gazeData; leftGazePos];
        case el.RIGHT_EYE
            rightGazePos = [(samples(15,end)) (samples(17,end))]; % xy-pos of right gaze
            gazeData = [gazeData; rightGazePos];
        case -1
            error('eyeavailable returned -1');
        otherwise
            error('unexpected result from eyeavailable');
    end
end

% Append the stimulus position & contrast to the stim data matrix
stimData = [stimData; X Y contrast];
