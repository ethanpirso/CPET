% Continuous Psychophysics with Eye Tracking (CPET): initWin.m
% Author: Ethan Pirso
% Description: Sets up the Psychtoolbox (PTB) window and defines screen parameters.
% Dependencies: None
% Called by: run.m
%
% Input variables in the workspace:
% - fr: The desired frame rate of the Psychtoolbox window in Hz.
%
% Output variables in the workspace:
% - win: The window pointer for the PTB window.
% - windowRect: The window rectangle of the PTB window.
% - screenWidth: The screen width in pixels.
% - screenHeight: The screen height in pixels.

% Make sure Psychtoolbox is installed
AssertOpenGL;

% Default settings, and unit color range
PsychDefaultSetup(2);

% Disable synctests
% oldSyncLevel = Screen('Preference', 'SkipSyncTests', 2);
oldLevel = Screen('Preference', 'VisualDebugLevel', 1); 
oldEnableFlag = Screen('Preference', 'SuppressAllWarnings', 1);
Screen('Preference', 'SkipSyncTests', 1);

% Define the screen parameters
% Choose screen with maximum id - the secondary display
screenid = max(Screen('Screens'));
screenResolution = Screen('Resolution', screenid);
screenWidth = screenResolution.width;
screenHeight = screenResolution.height;

PsychImaging('PrepareConfiguration');

% Open a fullscreen onscreen window on that display, choose a background
% color of 0.8 = grey with 80% max intensity
[win, windowRect] = PsychImaging('OpenWindow', screenid, grey, []);

% Set parameters for on screen text
% Screen('TextFont', win, 'Helvetica Black');
Screen('TextSize', win, 26);
Screen('TextStyle', win, 1);

% Verify frame rate is 120Hz
if fr ~= Screen('NominalFrameRate',win)
    error('PTB window frame rate not 120Hz')
end

HideCursor;
