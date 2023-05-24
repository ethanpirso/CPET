% GaborTracking: plotData.m
% Author: Ethan Pirso
% Description: Generates plots of the target and subject gaze positions, normalized position error, and contrast.
% Dependencies: None
% Called by: run.m
%
% Input variables in the workspace:
% - gazeData: Matrix containing gaze position data.
% - gaborData: Matrix containing Gabor position and contrast data.
% - stimFreq: The frequency of Gabor stimulus position updates.
% - trialName: String containing the name of the current trial.
%
% Output variables in the workspace:
% - fig1: File name of the saved figure containing target and subject gaze positions.
% - fig2: File name of the saved figure containing normalized position error and contrast.

%% Preprocess Data

% Remove blinks
for i=1:length(gazeData)
    if gazeData(i,1) < 0 || gazeData(i,2) < 0
        gazeData(i,1) = gazeData(i-1,1);
        gazeData(i,2) = gazeData(i-1,2);
    end
end

% Fix any lag and truncate ends
[rx,xlags] = xcorr(stimData(:,1), gazeData(:,1));
[ry,ylags] = xcorr(stimData(:,2), gazeData(:,2));
lag = min(xlags(rx==max(rx)), ylags(ry==max(ry)));
gazeData = circshift(gazeData,lag,1);
gazeData = gazeData(1:end+lag,:);
stimData =stimData(1:end+lag,:);

% Extract the data
x_target = stimData(:,1);
y_target = stimData(:,2);
contrast = stimData(:,3);
x_subject = gazeData(:,1);
y_subject = gazeData(:,2);

X = 0:length(gazeData)-1;
X = X./stimFreq; % x-axis scaled to time (s)

%% Plot target, subject position, and contrast

subplot(2,1,1);
hold on
plot(X,x_target, 'black-')
plot(X,x_subject, 'red-')
hold off
ylabel('X Position')
legend('Target', 'Subject')
xlabel('Time (s)')

subplot(2,1,2);
hold on
plot(X,y_target, 'black-')
plot(X,y_subject, 'red-')
hold off
ylabel('Y Position')
legend('Target', 'Subject')
xlabel('Time (s)')

% Save figure
fig1 = append(trialName,'_response','.fig');
savefig(fig1);
movefile(fig1,'../DATA/FIG')
close

%% Plot normalized position error and contrast

% Calculate position error, moving med/avg, contrast threshold
err = normalize(sqrt((x_subject - x_target).^2 + (y_subject - y_target).^2) ...
    ,'zscore','robust');
M = movmedian(err,stimFreq*3); % 3 sec moving median
conThreshold = contrast(find(M>=3,1)); % MAD of pos err > 3

% 95% Confidence interval calculation
MstdErr = movstd(err,stimFreq*3)/sqrt(stimFreq*3);
CI_L = M - 1.96*MstdErr;
CI_U = M + 1.96*MstdErr;
conCI = [contrast(find(CI_L>=3,1)), contrast(find(CI_U>=3,1))];

figure;
yyaxis left
hold on
plot(X,err,'.','MarkerSize',0.8,'DisplayName','Error');
plot(X,M, '-','LineWidth',2,'DisplayName','Moving Error');
plot(X,CI_L,'LineStyle','--','LineWidth',1,'DisplayName','95% CI Error');
plot(X,CI_U,'LineStyle','--','LineWidth',1,'HandleVisibility','off');
ylim([min(err)-1, max(err)+3])
x1 = xline(X(find(M>=3,1)),'-',{string(conThreshold)},'DisplayName','Contrast Threshold');
x1.LabelVerticalAlignment = 'middle';
x1.LabelHorizontalAlignment = 'center';
% x1.LabelOrientation = 'horizontal';
% x1.Color = [0.8500 0.3250 0.0980];
% x1.LineWidth = 1.5;
xCI_L = xline(X(find(CI_L>=3,1)),'--',{string(conCI(2))},'DisplayName','95% CI Con. Threshold');
xCI_L.LabelVerticalAlignment = 'middle';
xCI_L.LabelHorizontalAlignment = 'center';
xCI_L.Color = [0.8500 0.3250 0.0980];
xCI_U = xline(X(find(CI_U>=3,1)),'--',{string(conCI(1))},'HandleVisibility','off');
xCI_U.LabelVerticalAlignment = 'middle';
xCI_U.LabelHorizontalAlignment = 'center';
xCI_U.Color = [0.8500 0.3250 0.0980];
hold off
ylabel('Normalized Pos Error (MAD)')
yyaxis right
plot(X,contrast,'DisplayName','Stimulus Contrast')
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

