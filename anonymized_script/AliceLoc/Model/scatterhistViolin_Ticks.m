function ax = scatterhistViolin_Ticks(x, y, varargin)
% SCATTERHISTVIOLIN  Scatter plot with violin-shaped marginal distributions.
%
%   ax = scatterhistViolin(x, y, 'Name', Value, ...)
%
% Draws a main scatter (+ optional linear fit) axis, with a mirrored
% kernel-density ("violin") strip along the top for the x-distribution
% and along the right for the y-distribution.
%
% Name-Value pairs:
%   'Position'   [left bottom width height] in the parent figure's
%                normalized units. Default [0.1 0.1 0.6 0.6].
%   'Parent'     figure handle. Default gcf.
%   'Color'      RGB triplet for scatter/violin fill. Default [0.2 0.4 0.8].
%   'FitColor'   RGB triplet for the fit line/CI. Default [0.8 0.2 0.2].
%   'MarkerSize' scatter marker size. Default 18.
%   'FitLine'    true/false, show linear fit + CI + stats in title. Default true.
%   'XLabel'     x-axis label string.
%   'YLabel'     y-axis label string.
%   'XTick'      vector of tick locations for the x-axis. Default [] (auto).
%   'YTick'      vector of tick locations for the y-axis. Default [] (auto).
%   'Grid'       true/false, show grid on the main axis. Default false.
%


p = inputParser;
addParameter(p,'Position',[0.1 0.1 0.6 0.6]);
addParameter(p,'Parent',gcf);
addParameter(p,'Color',[0.2 0.4 0.8]);
addParameter(p,'FitColor',[0.8 0.2 0.2]);
addParameter(p,'MarkerSize',18);
addParameter(p,'FitLine',true);
addParameter(p,'XLabel','X');
addParameter(p,'YLabel','Y');
addParameter(p,'XTick',[]);
addParameter(p,'YTick',[]);
addParameter(p,'XLim',[]);
addParameter(p,'YLim',[]);
addParameter(p,'Grid',false);
parse(p,varargin{:});
opt = p.Results;

fig = opt.Parent;
pos = opt.Position;

% --- layout: main axis gets ~78% of width/height, margins get the rest
mainFrac  = 0.78;
gapFrac   = 0.02;
sideFrac  = 1 - mainFrac - gapFrac;

posMain  = [pos(1), ...
            pos(2), ...
            pos(3)*mainFrac, ...
            pos(4)*mainFrac];

posTop   = [pos(1), ...
            pos(2) + pos(4)*(mainFrac+gapFrac), ...
            pos(3)*mainFrac, ...
            pos(4)*sideFrac];

posRight = [pos(1) + pos(3)*(mainFrac+gapFrac), ...
            pos(2), ...
            pos(3)*sideFrac, ...
            pos(4)*mainFrac];

% --- clean data
valid = ~isnan(x) & ~isnan(y);
x = x(valid); y = y(valid);

% --- main scatter (+ fit)
axMain = axes('Parent',fig,'Position',posMain);
scatter(axMain, x, y, opt.MarkerSize, 'filled', ...
    'MarkerFaceColor', opt.Color, 'MarkerEdgeColor', 'none'); hold(axMain,'on');

if opt.FitLine
    mdl = fitlm(x,y);
    [xs, sidx] = sort(x); %#ok<ASGLU>
    xs = sort(x);
    [pred, ci] = predict(mdl, xs);
    patch(axMain, [xs;flipud(xs)], [ci(:,1);flipud(ci(:,2))], opt.FitColor, ...
        'FaceAlpha',0.15,'EdgeColor','none');
    plot(axMain, xs, pred, 'Color', opt.FitColor, 'LineWidth', 2);
    [r,pval] = corr(x, y, 'Rows','complete'); %#ok<ASGLU>
 %   title(axMain, sprintf('p = %.3f, r = %.2f', mdl.Coefficients.pValue(2), r), ...
   %     'FontWeight','normal','FontSize',9);
end
xlabel(axMain, opt.XLabel); ylabel(axMain, opt.YLabel);
box(axMain,'on');
if opt.Grid, grid(axMain,'on'); else, grid(axMain,'off'); end
if ~isempty(opt.XLim), xlim(axMain, opt.XLim); end
if ~isempty(opt.YLim), ylim(axMain, opt.YLim); end
if ~isempty(opt.XTick), xticks(axMain, opt.XTick); end
if ~isempty(opt.YTick), yticks(axMain, opt.YTick); end

xl = xlim(axMain); yl = ylim(axMain);

% --- top violin (distribution of x)
axTop = axes('Parent',fig,'Position',posTop);
[fX, xiX] = ksdensity(x, 'NumPoints', 200);
fX = fX / max(fX) * 0.42; % half-width of the violin, in normalized-ish units
fill(axTop, [xiX fliplr(xiX)], [fX -fliplr(fX)], opt.Color, ...
    'FaceAlpha',0.5, 'EdgeColor', opt.Color, 'LineWidth', 1);
xlim(axTop, xl); ylim(axTop, [-1 1]);
axis(axTop,'off'); linkaxes([axMain axTop], 'x');

% --- right violin (distribution of y)
axRight = axes('Parent',fig,'Position',posRight);
[fY, xiY] = ksdensity(y, 'NumPoints', 200);
fY = fY / max(fY) * 0.42;
fill(axRight, [fY -fliplr(fY)], [xiY fliplr(xiY)], opt.Color, ...
    'FaceAlpha',0.5, 'EdgeColor', opt.Color, 'LineWidth', 1);
ylim(axRight, yl); xlim(axRight, [-1 1]);
axis(axRight,'off'); linkaxes([axMain axRight], 'y');

ax.main = axMain; ax.top = axTop; ax.right = axRight;
end
