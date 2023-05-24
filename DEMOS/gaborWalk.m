% GaborWalk: gaborWalk.m
% Author: Ethan Pirso
% Description: A demo script to display a Gabor patch following a random walk or curvilinear trajectory.
% Dependencies: Psychtoolbox
%
% Input variables in the workspace:
% - None
%
% Output variables in the workspace:
% - gaborData: Matrix containing x and y positions of the Gabor patch and the contrast value.

clear;

% Make sure Psychtoolbox is installed
AssertOpenGL;

% Default settings, and unit color range
PsychDefaultSetup(2);

% Disable synctests:
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
% color of 0.8 = gray with 80% max intensity
grey = [0.8 0.8 0.8];
win = PsychImaging('OpenWindow', screenid, grey, []);
fr = Screen('NominalFrameRate',win); % frame rate

% Initial stimulus params for the gabor patch
res = 1*[75 75];
phase = 0;
sc = 10;
freq = 0.15;
tilt = 0;
contrast = 20;
aspectratio = 1.0;
tw = res(1);
th = res(2);
x=tw/2;
y=th/2;

% Calculate the required value of 'freq' based on the desired frequency in cycles per degree
freq_cpd_desired = 4.5; % change this to your desired frequency in CPD
screen_width_cm = 41;
viewingDistanceCm = 60;
%freq = calc_freq_cpd(screen_width_cm, screenWidth, viewingDistanceCm, freq_cpd_desired);

% Build a procedural gabor texture for a gabor with a support of tw x th
% pixels, and a RGB color offset of 0.8 -- a 80% gray.
% gabortex = CreateProceduralGabor(win, tw, th, 0, [0.8 0.8 0.8 0.0]);
[gabortex, gaborRect] = CreateProceduralGabor(win, tw, th, 0, [grey 0]);

% Initialize the position of the Gabor
gaborX = screenWidth / 2 - x;
gaborY = screenHeight / 2 - y;

% Prompt the experimenter to select the desired movement type
fprintf('\nSelect the desired movement type:\n');
fprintf('1: Uniform step size\n');
fprintf('2: Normal step size\n');
fprintf('3: Curvilinear trajectory\n');
movementType = input('Enter the number corresponding to your selection: ');

switch movementType
    case 1 % Set initial prefs for uniform step size
        
        stepSize = 130;
        dwellTime = 120;
        conStep = 1;

    case 2 % Set initial prefs for normal step size
        
        stepSize = 130;
        dwellTime = 120;
        conStep = 1;
        mu = 0;
        sigma = 0.35;
        R = chol(sigma);

    case 3 % Set initial prefs for curvilinear trajectory
   
        conStep = 1;

        % Set stimulus display time
        stimulusDuration = 60; % seconds
        
        % Initialize random trajectory
        numPoints = 30; % controls speed
        % canvasSize = round(screenWidth/2);
        xPos = rand(1, numPoints-1) *  round(screenWidth/1.5) + screenWidth/6;
        yPos = rand(1, numPoints-1) *  round(screenHeight/1.5) + screenHeight/6;
        % xPos = rand(1, numPoints-1) * (screenWidth-tw);
        % yPos = rand(1, numPoints-1) * (screenHeight-th);
        xPos = [gaborX xPos];
        yPos = [gaborY yPos]; 
        
        % Get smooth curvilinear trajectory
        t = linspace(0, stimulusDuration, numPoints);
        ppx = spline(t, xPos);
        ppy = spline(t, yPos);
        
        % Calculate the number of frames based on stimulus duration and velocity
        numFrames = round(stimulusDuration * Screen('FrameRate', win));
        frameDuration = 1 / Screen('FrameRate', win);
        
        % Calculate new time values for the trajectory points based on the desired velocity
        tVals = linspace(0, stimulusDuration, numFrames);
        xPosSmooth = ppval(ppx, tVals);
        yPosSmooth = ppval(ppy, tVals);

    otherwise
        error('Invalid movement type selected. Please choose a valid option.');
end

gaborData = [];

for i=1:fr*3 % 3 second delay at beginning
    Screen('DrawText', win, 'Track the gabor. Press "esc" to escape.', ...
        320, 300)
    % Draw the Gabor
    Screen('DrawTexture', win, gabortex, [], [gaborX gaborY gaborX + tw gaborY + th], ...
        tilt, [], [], [], [], kPsychDontDoRotation, [phase, freq, sc, contrast, aspectratio, 0, 0, 0]);
    Screen('Flip', win);
end

% Loop to continuously display the Gabor
frame = 1;
while 1

    gaborData = [gaborData; gaborX gaborY contrast];

    switch movementType
        case 1 
            % Draw the Gabor
            Screen('DrawTexture', win, gabortex, [], [gaborX gaborY gaborX + tw gaborY + th], ...
                tilt, [], [], [], [], kPsychDontDoRotation, [phase, freq, sc, contrast, aspectratio, 0, 0, 0]);
            Screen('Flip', win);

            % Update the position of the Gabor
            gaborX = gaborX + (rand() * 2 - 1) * stepSize;
            gaborY = gaborY + (rand() * 2 - 1) * stepSize;

            % Lower contrast
            contrast = contrast * ((100-conStep) / 100);

            WaitSecs(dwellTime/1000);
   
        case 2
            % Draw the Gabor
            Screen('DrawTexture', win, gabortex, [], [gaborX gaborY gaborX + tw gaborY + th], ...
                tilt, [], [], [], [], kPsychDontDoRotation, [phase, freq, sc, contrast, aspectratio, 0, 0, 0]);
            Screen('Flip', win);

            % Update the position of the Gabor
            z1 = repmat(mu,1,1) + randn(1)*R;
            z2 = repmat(mu,1,1) + randn(1)*R;
            gaborX = gaborX + z1 * stepSize;
            gaborY = gaborY + z2 * stepSize;

            % Lower contrast
            contrast = contrast * ((100-conStep) / 100);

            WaitSecs(dwellTime/1000);

        case 3
            % Display Gabor stimulus along the trajectory
            if frame <= numel(xPosSmooth)
        
                Screen('DrawTexture', win, gabortex, [], [gaborX gaborY gaborX + tw gaborY + th], ...
                    tilt, [], [], [], [], kPsychDontDoRotation, [phase, freq, sc, contrast, aspectratio, 0, 0, 0]);
                Screen('Flip', win);
        
                gaborX = xPosSmooth(frame);
                gaborY = yPosSmooth(frame);

                if mod(frame, 14) == 0
                    % Lower contrast
                    contrast = contrast * ((100-conStep) / 100);
                end
        
                frame = frame + 1;
            end
    end
    
    % Make sure the Gabor stays within the screen boundaries
    gaborX = min(max(gaborX, 0), screenWidth - tw);
    gaborY = min(max(gaborY, 0), screenHeight - th);

    % Check for key presses and contrast > 0.2
    [~, ~, keyCode] = KbCheck();
    if keyCode(KbName('Escape')) || contrast <= 0.2
        break;
    end
    
end

% Close the window
Screen('Close', win);
