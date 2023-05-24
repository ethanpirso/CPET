% GaborTracking: initEyelink.m
% Author: Ethan Pirso
% Description: Initializes the Eyelink eye tracker and configures the calibration type.
% Dependencies: None
% Called by: run.m
%
% Input variables in the workspace:
% - trialName: Identifier for the current trial.
% - win: The window pointer for the PTB window.
% - windowRect: The window rectangle of the PTB window.
% - grey: The color used for the background of the window.
%
% Output variables in the workspace:
% - el: Eyelink defaults structure.
% - gazeData: Empty matrix to store gaze data.
% - trackedEye: Indicates the tracked eye (left or right).

% Constants and parameters definitions

% edfFile = input('\nenter tracker EDF file name (1 to 8 letters or numbers): ','s');
edfFile = trialName;

% Eyelink initialization and configuration
if Eyelink('initialize','PsychEyelinkDispatchCallback')
    fprintf('Eyelink failed init');
    Screen('CloseAll');
    return
end

HideCursor;
el = EyelinkInitDefaults(win);

% Send to Eyelink Host the display window coordinate space
if Eyelink('IsConnected') ~= el.notconnected
    Eyelink('Command', 'screen_pixel_coords = %d %d %d %d', 0, 0, windowRect(RectRight), windowRect(RectBottom));
end

% Define calibration type (13 calibration points)
Eyelink('Command','calibration_type = HV13');
% Sets which events will be written to the EDF file.
Eyelink('Command','file_event_filter = LEFT,RIGHT, FIXATION, BLINK, MESSAGE, BUTTON, SACCADE, INPUT');
% Sets which types of events will be sent through link
Eyelink('Command','link_event_filter = LEFT,RIGHT, FIXATION, BLINK, MESSAGE, BUTTON, SACCADE, INPUT');

if isempty(edfFile)
    edfFile = 'data';
end

Eyelink('openfile', edfFile);

% Check Eyelink status

el.backgroundcolour = 204;
el.foregroundcolour = 0;
el.window = win;
status = Eyelink('isconnected');
if status == 0 % if not connected, end script
    Eyelink('closefile');
    Eyelink('shutdown');
    Screen('CloseAll');
    ShowCursor;
    Screen('Preference', 'VisualDebugLevel', oldLevel);
    Screen('Preference', 'SuppressAllWarnings', oldEnableFlag);
    return;
end

% Do EyeLink calibration

el.callback = '';
error = EyelinkDoTrackerSetup(el, el.ENTER_KEY);

if error ~= 0
    fprintf('eye tracker setup error = %d\n',error);
end

% Reset background colour 
Screen('FillRect' ,win, grey, windowRect);
Screen('Flip', win);

% Start EyeLink data acquisition for experiment
Eyelink('StartRecording');
gazeData = []; % Initialize the gaze data matrix

trackedEye = Eyelink('EyeAvailable');

switch trackedEye % checks tracked eye recording status
    case el.BINOCULAR
        error('tracker indicates binocular');
    case el.LEFT_EYE
        disp('tracker indicates left eye');
    case el.RIGHT_EYE
        disp('tracker indicates right eye')
    case -1
        error('eyeavailable returned -1');
    otherwise
        error('unexpected result from eyeavailable');
end
