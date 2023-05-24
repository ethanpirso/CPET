switch stim
    case 1
        % Draw Gabor
        Screen('DrawTexture', win, gabortex, [], [X Y X + tw Y + th], ...
            tilt, [], [], [], [], kPsychDontDoRotation, [phase, freq, sc, contrast, aspectratio, 0, 0, 0]);
        Screen('Flip', win);
    case 2
        % Draw letter
        Screen('TextColor', win, textColor);
        DrawFormattedText(win, letter, X, Y);
        Screen('Flip', win);
        textColor = grey - grey(1) * contrast / 100;
    case 3
        % Draw optotype
        Screen('DrawTexture', win, optotex, [], [X Y X + stimSize Y + stimSize]);
        Screen('Flip', win);
        imgColor = grey(1) - grey(1) * contrast / 100;
        optotype(optotype<grey(1)) = imgColor;
        optotex = Screen('MakeTexture', win, optotype);
    case 4
        % Draw marmoset face
        Screen('DrawTexture', win, marmosettex, [], [X Y X + stimSize Y + stimSize]);
        Screen('Flip', win);
%         marmoset = marmoset * (grey(1) + (1 - contrast / 100));
        marmosettex = Screen('MakeTexture', win, marmoset);
end