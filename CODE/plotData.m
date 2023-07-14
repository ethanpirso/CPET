% Continuous Psychophysics with Eye Tracking (CPET): plotData.m
% Author: Ethan Pirso
% Description: Produces plots visualizing target and subject gaze positions, normalized position error, and contrast. Two figure files are saved to the workspace: one displaying target and subject positions, and the other showing normalized position error and contrast.
% Dependencies: None
% Called by: runCPET.m
%
% Input variables in the workspace:
% - gazeData: Matrix with gaze positions for each frame.
% - stimData: Matrix with stimulus positions and contrast for each frame.
% - stimFreq: Frequency of stimulus position updates.
% - trialName: String identifying the current trial.
%
% Output variables in the workspace:
% - fig1: File name of the saved figure presenting target and subject gaze positions.
% - fig2: File name of the saved figure presenting normalized position error and contrast.
%
% This script performs the following tasks:
% 1. Preprocesses gaze and stimulus data to remove blinks, correct for possible lag, and ensure data array synchronization.
% 2. Extracts and prepares relevant variables for plotting.
% 3. Generates and saves a figure (fig1) displaying X and Y positions for both the target stimulus and the subject's gaze over time.
% 4. Computes the normalized positional error and a moving median error over a 3-second window.
% 5. Determines a contrast threshold based on the moving median error.
% 6. Calculates a 95% confidence interval for the error.
% 7. Generates and saves a second figure (fig2) presenting the normalized positional error, moving median error, and stimulus contrast over time, with annotations for the contrast threshold and its confidence interval.

%% Preprocess Data

% Extract the data
x_target = stimData(:,1);
y_target = stimData(:,2);
contrast = stimData(:,3);
x_subject = gazeData(:,1);
y_subject = gazeData(:,2);

% Remove blinks
for i=1:length(gazeData)
    if gazeData(i,1) < 0 || gazeData(i,2) < 0
        x_subject(i) = gazeData(i-1,1);
        y_subject(i) = gazeData(i-1,2);
    end
end

% Median filter
x_subject(:) = movmedian(gazeData(:,1),5);
y_subject(:) = movmedian(gazeData(:,2),5);

% Fix lag and truncate ends
[rx,xlags] = xcorr(x_target, x_subject);
[ry,ylags] = xcorr(y_target, y_subject);
lag = min(xlags(rx==max(rx)), ylags(ry==max(ry)));
% stem(xlags, rx);
if lag <= 0 % assume that gaze lags target position always
    x_subject = circshift(x_subject,lag);
    y_subject = circshift(y_subject,lag);
    x_target = x_target(1:end+lag,:);
    y_target = y_target(1:end+lag,:);
    x_subject = x_subject(1:end+lag,:); 
    y_subject = y_subject(1:end+lag,:);
end

xaxis = 0:length(gazeData)-1;
xaxis = xaxis./stimFreq; % x-axis scaled to time (s)

% Throw out first 5 seconds of data (removing initial saccade and instructions)
xaxis = xaxis(xaxis>=5);
x_target = x_target(xaxis>=5);
y_target = y_target(xaxis>=5);
contrast = contrast(xaxis>=5);
x_subject = x_subject(xaxis>=5);
y_subject = y_subject(xaxis>=5);

%% Plot target, subject position, and contrast

subplot(2,1,1);
hold on
plot(xaxis,x_target, 'black-')
plot(xaxis,x_subject, 'red-')
hold off
ylabel('X Position')
legend('Target', 'Subject')
xlabel('Time (s)')

subplot(2,1,2);
hold on
plot(xaxis,y_target, 'black-')
plot(xaxis,y_subject, 'red-')
hold off
ylabel('Y Position')
% legend('Target', 'Subject')
xlabel('Time (s)')

% Save figure
fig1 = append(trialName,'_response','.fig');
savefig(fig1);
movefile(fig1,'../DATA/FIG')
% close

%% Plot normalized position error and contrast

% Calculate position error, moving med/avg, contrast threshold
err = normalize(sqrt((x_subject - x_target).^2 + (y_subject - y_target).^2) ...
    ,'zscore','robust');
M = movmedian(err,stimFreq*3); % 3 sec moving median
conThreshold = round(contrast(find(M>=3,1)),2); % MAD of pos err > 3

% 95% Confidence interval calculation
MstdErr = movstd(err,stimFreq*3)/sqrt(stimFreq*3); % moving std. err. over 3 second sliding window
CI_L = M - 1.96*MstdErr;
CI_U = M + 1.96*MstdErr;
conCI = [round(contrast(find(CI_L>=3,1)),2), round(contrast(find(CI_U>=3,1)),2)];

figure;
yyaxis left
hold on
plot(xaxis,err,'.','MarkerSize',0.8,'DisplayName','Error');
plot(xaxis,M, '-','LineWidth',2,'DisplayName','Moving Error');
plot(xaxis,CI_L,'LineStyle','--','LineWidth',1,'DisplayName','95% CI Error');
plot(xaxis,CI_U,'LineStyle','--','LineWidth',1,'HandleVisibility','off');
ylim([min(err)-1, max(err)+1])
x1 = xline(xaxis(find(M>=3,1)),'-',{string(conThreshold)},'FontSize',11,'DisplayName','Contrast Threshold');
x1.LabelVerticalAlignment = 'middle';
x1.LabelHorizontalAlignment = 'center';
% x1.LabelOrientation = 'horizontal';
% x1.Color = [0.8500 0.3250 0.0980];
% x1.LineWidth = 1.5;
xCI_L = xline(xaxis(find(CI_L>=3,1)),'--',{string(conCI(1))},'FontSize',11,'DisplayName','95% CI Con. Threshold');
xCI_L.LabelVerticalAlignment = 'middle';
xCI_L.LabelHorizontalAlignment = 'right';
xCI_L.Color = [0.8500 0.3250 0.0980];
xCI_U = xline(xaxis(find(CI_U>=3,1)),'--',{string(conCI(2))},'FontSize',11,'HandleVisibility','off');
xCI_U.LabelVerticalAlignment = 'middle';
xCI_U.LabelHorizontalAlignment = 'left';
xCI_U.Color = [0.8500 0.3250 0.0980];
hold off
ylabel('Normalized Pos Error (MAD)')
yyaxis right
% plot(X,contrast,'DisplayName','Stimulus Contrast');
semilogy(xaxis,contrast,'Color',[0.8500 0.3250 0.0980],'DisplayName','Stimulus Contrast');
xlim([0,max(xaxis)+3])
ylim([min(err)-1,20]);
ylabel('Contrast (%)')
xlabel('Time (s)')
lgd = legend;
lgd.NumColumns = 2;
lgd.Location = 'north';

% Save figure
fig2 = append(trialName,'_pos_err','.fig');
savefig(fig2);
movefile(fig2,'../DATA/FIG')

