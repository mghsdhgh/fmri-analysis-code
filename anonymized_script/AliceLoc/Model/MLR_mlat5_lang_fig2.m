clear all; clc; close all

subjectDir = '/path_to/nebula101/';
dirInfo = dir(fullfile(subjectDir, 'sub-pp*')); 
SubID = {dirInfo([dirInfo.isdir]).name}; 

%% read variables
[sex, age, hand,edu, lang, mlat] = read_behavData(SubID);
handedness = hand;
%%
lang = (lang - mean(lang)) / std(lang);
mlat = (mlat - mean(mlat)) / std(mlat);
age = (age - mean(age)) / std(age);
edu = (edu - mean(edu)) / std(edu);
handedness = (handedness - mean(handedness)) / std(handedness);
Y= lang; yl = 'multilingual speaking entropy (residuals)';
X = mlat ; TT = 'mlat5 score';  TTT='mlat5_score';xl = 'MLAT-V score (residuals)';
%%
covars_full = [age, sex, handedness, edu];
[r_partial2, p_partial2] = partialcorr(mlat, lang, covars_full, 'Rows','complete');
fprintf('Partial correlation MLAT-V vs %s, controlling age+sex+education+handedness: r = %.3f, p = %.4f\n', ...
    yl, r_partial2, p_partial2);
%% MOdel
handedness = hand;
data = table                                    (X,age,sex,handedness, edu,Y);
data.Properties.VariableNames{'X'} = TTT;
mdl_lh = fitlm(data, ['Y ~ ',TTT,'+age+sex+handedness+edu']);
%% plot
covars_full = [age, sex, handedness,edu];

mdl_x = fitlm(covars_full, mlat);     
X = mdl_x.Residuals.Raw;      

mdl_y = fitlm(covars_full, lang);     
Y = mdl_y.Residuals.Raw;     

C=7;
[cb] = cbrewer('qual','Set2',8); [cb2] = cbrewer('seq','Blues',8);
 
figSize = 700; % pixels, square
fh = figure('Position',[200 200 figSize figSize]);
set(fh,'Color',[1 1 1]);
L =[0,3]; L2=[0,4000];
T = [-5:1:5]; 
sp = subplot(1,1,1); pos = get(sp,'Position'); delete(sp);
ax = scatterhistViolin_Ticks(X, Y, 'Position', pos, 'Parent', fh, ...
    'Color', cb2(C,:), 'FitColor', cb(8,:), 'MarkerSize', 18);

xlabel(ax.main, xl, 'FontSize', 14, 'FontWeight', 'normal');
ylabel(ax.main, yl, 'FontSize', 14, 'FontWeight', 'normal');

legend(ax.main, 'off');

c = mdl_lh.Coefficients;
c.Properties.RowNames{2} = TT; 
disp(c)
c   = mdl_lh.Coefficients;
row = 2;                                   
b  = c.Estimate(row);
tv = c.tStat(row);
pv = c.pValue(row);

if pv < 0.001
    pstr = 'p < 0.001';
else
    pstr = sprintf('p = %.3f', pv);
end

txt = sprintf('\\beta = %.2f, t = %.2f, %s', b, tv, pstr);

text(ax.main, 0.04, 0.96, txt, ...
     'Units', 'normalized', ...
     'FontSize', 13, ...
     'HorizontalAlignment', 'left', ...
     'VerticalAlignment', 'top', ...
     'BackgroundColor', [1 1 1 0.7], ...
     'Margin', 3);