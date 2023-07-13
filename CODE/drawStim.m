% Continuous Psychophysics with Eye Tracking (CPET): drawStim.m
% Author: Ethan Pirso
% Description: This script draws the chosen stimulus (Gabor patch, Letter, Aukland Optotype, or Marmoset stimuli) 
%              on the screen based on the parameters initialized in params.m. The script also modifies the 
%              color of the stimuli based on the current contrast settings and then flips the window to 
%              display the updated stimulus. Each type of stimulus has its own specific parameters and 
%              processing, as detailed within the case structure of the script.
%
% Dependencies: params.m.
%
% Input variables in the workspace:
% - stim: Stimulus type.
% - win: PTB window where the stimulus is displayed.
% - X, Y: Coordinates for drawing the stimulus.
% - For Gabor: gabortex, tw, th, tilt, phase, freq, sc, contrast, aspectratio.
% - For Letter: textColor, letter.
% - For Optotype: optotex, stimSize, optotype.
% - For Marmoset: marmosettex, stimSize, marmoset.
%
% Output variables in the workspace:
% - None

switch stim
    case 1
        % Draw Gabor
        Screen('DrawTexture', win, gabortex, [], [X Y X + stimSize Y + stimSize], ...
            tilt, [], [], [], [], kPsychDontDoRotation, [phase, freq, sc, contrast, aspectratio, 0, 0, 0]);
        Screen('Flip', win);
    case 2
        % Draw Letter
        Screen('TextColor', win, textColor);
        DrawFormattedText(win, letter, X, Y);
        Screen('Flip', win);
        textColor = grey - grey(1) * contrast / 100;
    case 3
        % Draw Optotype
        Screen('DrawTexture', win, optotex, [], [X Y X + stimSize Y + stimSize]);
        Screen('Flip', win);
        if mod(frame,dwellFrames) == 0
            optotype = optotype * (1 - conStep/100) + grey(1) * (conStep/100);
        end
        optotex = Screen('MakeTexture', win, optotype);
    case 4
        % Draw Marmoset
        Screen('DrawTexture', win, marmosettex, [], [X Y X + stimSize Y + stimSize]);
        Screen('Flip', win);
        if mod(frame,dwellFrames) == 0
            marmoset = marmoset * (1 - conStep/100) + grey(1) * (conStep/100);
        end
        marmosettex = Screen('MakeTexture', win, marmoset);
end
