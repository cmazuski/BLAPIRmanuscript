
% Figure 1C- 1I


thisDir = pwd;

lcCSV  = fullfile(thisDir,'learning_curve.csv');
duCSV  = fullfile(thisDir,'days_until_criterion.csv');
flCSV  = fullfile(thisDir,'first_last_rates.csv');
pdCSV  = fullfile(thisDir,'plot_data.csv');
olfCSV = fullfile(thisDir,'olfactory_block.csv');
visCSV = fullfile(thisDir,'visual_block.csv');

LC = readtable(lcCSV, 'TextType','string');
DU = readtable(duCSV, 'TextType','string');
FL = readtable(flCSV, 'TextType','string');
OLF = readtable(olfCSV, 'TextType','string'); 
VIS = readtable(visCSV, 'TextType','string');

T = readtable(pdCSV, 'TextType','string');


%% Figure 1C — Learning curve

figure('Name','Figure 1C'); 
hold on;
grey = [0.8 0.8 0.8]; 
black = [0 0 0];

% highlight one animal 
chosenAnimal = "BLA04";

if ~iscategorical(LC.AnimalID)
    LC.AnimalID = categorical(LC.AnimalID);
end
animals = unique(LC.AnimalID, 'stable');

for i = 1:numel(animals)
    aID = animals(i);
    rows = (LC.AnimalID == aID);
    x = LC.SessionIndex(rows);
    y = LC.Accuracy(rows);
    if strlength(chosenAnimal)>0 && aID==chosenAnimal
        plot(x, y, 'Color', black, 'LineWidth', 2);
    else
        plot(x, y, 'Color', grey,  'LineWidth', 1);
    end
end

yline(50,'--','HandleVisibility','off');
axis square
xlabel('Session number');
ylabel('Accuracy (%)');
xlim([0, max(LC.SessionIndex)+1]);
ylim([0, 100]);
title(sprintf('n=%d', numel(animals)));
hold off;


%% Figure 1D — Days until criterion


figure('Name','Figure 1D');
hold on;
d  = DU.DaysUntilCriterion;
% jitter around x=1
x0 = 1 + 0.05*(rand(size(d)) - 0.5); 
scatter(x0, d, 'filled');

m  = mean(d);
se = std(d) / sqrt(numel(d));
errorbar(1, m, se, 'k', 'LineWidth', 1, 'CapSize', 0);
bar(1, m, 0.2, 'FaceColor','none', 'EdgeColor','k');

xlim([0.8, 1.2]); 
set(gca,'XTick',[]);
ylim([0, max(d)+1]);
ylabel('Days until criterion');
axis square
title(sprintf('n=%d', numel(d)));
hold off;


%% Figure 1E — Hit rate 


[~, p_hit] = ttest(FL.HitRateFirst, FL.HitRateLast);

figure('Name','Figure 1E'); 
hold on;
x1=1;
x2=2; 
grey=[0.6 0.6 0.6];
for i = 1:height(FL)
    plot([x1 x2], [FL.HitRateFirst(i), FL.HitRateLast(i)], '-', 'Color', grey);
end
eh1 = errorbar(x1-0.05, mean(FL.HitRateFirst), std(FL.HitRateFirst)/sqrt(height(FL)), 'k', 'LineWidth',1); 
eh1.Marker='_';
eh2 = errorbar(x2+0.05, mean(FL.HitRateLast),  std(FL.HitRateLast )/sqrt(height(FL)), 'k', 'LineWidth',1);
eh2.Marker='_';

xlim([0.5, 2.5]); 
ylim([0, 1]);
set(gca,'XTick',[1 2],'XTickLabel',{'First','Last'});
ylabel('Hit rate');
axis square
title(sprintf('Paired t-test: p = %.3f', p_hit));
hold off;


%% Figure 1F — False alarm rate


[~, p_fa] = ttest(FL.FARFirst, FL.FARLast);

figure('Name','Figure 1F'); 
hold on;
x1=1;
x2=2;
grey=[0.6 0.6 0.6];
for i = 1:height(FL)
    plot([x1 x2], [FL.FARFirst(i), FL.FARLast(i)], '-', 'Color', grey);
end
ef1 = errorbar(x1-0.05, mean(FL.FARFirst), std(FL.FARFirst)/sqrt(height(FL)), 'k', 'LineWidth',1); 
ef1.Marker='_';
ef2 = errorbar(x2+0.05, mean(FL.FARLast),  std(FL.FARLast )/sqrt(height(FL)), 'k', 'LineWidth',1); 
ef2.Marker='_';

xlim([0.5, 2.5]); 
ylim([0, 1]);
set(gca,'XTick',[1 2],'XTickLabel',{'First','Last'});
ylabel('False alarm rate');
axis square
title(sprintf('Paired t-test: p = %.3f', p_fa));
hold off;


%% Figure 1G — Sensory block: Olfactory


% Paired t-test and mean ± SEM
[~, pOlfactory] = ttest(OLF.PreMean, OLF.BlockMean);
mPreO = mean(OLF.PreMean);  
sePreO = std(OLF.PreMean)/sqrt(height(OLF));
mBlkO = mean(OLF.BlockMean);
seBlkO = std(OLF.BlockMean)/sqrt(height(OLF));

figure('Name','Figure 1G');
hold on;
x1=1;
x2=2; 
grey=[0.6 0.6 0.6];
for i=1:height(OLF)
    plot([x1 x2], [OLF.PreMean(i), OLF.BlockMean(i)], '-', 'Color', grey);
end
errorbar(x1, mPreO, sePreO, 'k','LineWidth',1);
errorbar(x2, mBlkO, seBlkO, 'k','LineWidth',1);
bar(x1, mPreO, 0.2, 'FaceColor','none','EdgeColor','k');
bar(x2, mBlkO, 0.2, 'FaceColor','none','EdgeColor','k');

xticks([x1 x2]); 
xticklabels({'Pre','Olfactory blocked'});
ylabel('Accuracy (%)');
yline(50,'--','HandleVisibility','off');
xlim([0 3]);
ylim([0 100]);
axis square;
title(sprintf('Olfactory (n=%d)  p=%.3f', height(OLF), pOlfactory));
hold off;


%% Figure 1H — Sensory block: Visual


% Paired t-test and mean ± SEM
[~, pVisual] = ttest(VIS.PreMean, VIS.BlockMean);
mPreV = mean(VIS.PreMean); 
sePreV = std(VIS.PreMean)/sqrt(height(VIS));
mBlkV = mean(VIS.BlockMean);
seBlkV = std(VIS.BlockMean)/sqrt(height(VIS));

figure('Name','Figure 1H'); 
hold on;
x1=1; 
x2=2; 
grey=[0.6 0.6 0.6];
for i=1:height(VIS)
    plot([x1 x2], [VIS.PreMean(i), VIS.BlockMean(i)], '-', 'Color', grey);
end
errorbar(x1, mPreV, sePreV, 'k','LineWidth',1);
errorbar(x2, mBlkV, seBlkV, 'k','LineWidth',1);
bar(x1, mPreV, 0.2, 'FaceColor','none','EdgeColor','k');
bar(x2, mBlkV, 0.2, 'FaceColor','none','EdgeColor','k');

xticks([x1 x2]); 
xticklabels({'Pre','Visual blocked'});
ylabel('Accuracy (%)');
yline(50,'--','HandleVisibility','off');
xlim([0 3]); 
ylim([0 100]); 
axis square;
title(sprintf('Visual (n=%d)  p=%.3f', height(VIS), pVisual));
hold off;


%% Figure 1I — Per-animal session plot

  
sessionGapTrials  = 10;   % gap between sessions (in trials)

animalIDs = unique(T.animalID, 'stable');

for i = 1:numel(animalIDs)
    TA = T(T.animalID == animalIDs(i), :);
    stimPairs = unique(TA.stimPairNum, 'stable');

    figure('Name', sprintf('%s', animalIDs(i)));
    hold on;
    colors = lines(numel(stimPairs));
    h = gobjects(1, numel(stimPairs));
    legendLabels = strings(1, numel(stimPairs));

    xTicks = [];
    xTickLabels = strings(0);

    pairOffset = 0;  % cumulative extra shift due to session gaps in previous pairs

    for j = 1:numel(stimPairs)
        TP = TA(TA.stimPairNum == stimPairs(j), :);
        TP = sortrows(TP, {'sessionOrder','blockIndex'});

        % legend text
        stimPairName = TP.stimPairName(1);
        experiment   = TP.experiment(1);
        legendLabels(j) = sprintf('%s (%s)', stimPairName, experiment);

        sessOrders = unique(TP.sessionOrder, 'stable');
        firstHandleSet = false;

        for k = 1:numel(sessOrders)
            S = TP(TP.sessionOrder == sessOrders(k), :);
            if isempty(S)
                continue;
            end
            S = sortrows(S, 'blockIndex');

            % total shift = pairOffset + per-session shift
            sessShift = pairOffset + (k-1)*sessionGapTrials;

            % shifted x for this session only (breaks lines between sessions)
            xVals = double(S.xValue) + sessShift;
            yVals = double(S.meanAccuracy);

            ph = plot(xVals, yVals, 'o-', 'Color', colors(j,:));
            if ~firstHandleSet
                h(j) = ph;
                firstHandleSet = true;
            end

            % tick at middle of shifted session
            xStart  = min(xVals);
            nTrials = double(S.nTrials(1));
            middleX = xStart + floor(nTrials/2);
            xTicks = [xTicks, middleX];
            xTickLabels = [xTickLabels; string(S.sessionOrder(1))];
        end

        % increase pairOffset
        nSessInPair = numel(sessOrders);
        if nSessInPair > 0
            pairOffset = pairOffset + (nSessInPair - 1)*sessionGapTrials;
        end
    end

    legend(h, cellstr(legendLabels), 'Location','best', 'Interpreter','none');
    xlabel('Session / Day');
    ylabel('Accuracy (%)');
    title(sprintf('%s', animalIDs(i)));
    ylim([0, 100]);
    set(gca, 'XTick', xTicks, 'XTickLabel', xTickLabels);

    yline(50,'--','HandleVisibility','off');
  
    hold off;
end

