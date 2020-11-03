function [filepath] = exportFig(filepath, args)
% exportFig - Function to save figure in many different formats
%
% Syntax: exportFig(filepath, args)
%
% Inputs:
%    - filepath - path to file to export exportation (with or without extension)
%    - args:
%       - fig    - Save fig file (default: false)
%       - pdf    - Save pdf file (default: true)
%       - eps    - Save eps file (default: false)
%       - png    - Save png file (default: true)
%       - svg    - Save svg file (default: false)
%       - width  -
%       - height -

arguments
    filepath
    args.fig (1,1) logical {mustBeNumericOrLogical}    = false
    args.pdf (1,1) logical {mustBeNumericOrLogical}    = true
    args.png (1,1) logical {mustBeNumericOrLogical}    = true
    args.eps (1,1) logical {mustBeNumericOrLogical}    = false
    args.svg (1,1) logical {mustBeNumericOrLogical}    = false
    args.width  = 'normal'
    args.height = 'normal'
end

filepath_split = strsplit(filepath, '.');

if length(filepath_split) > 1
    filepath = filepath_split{1};
end

pos = [-10 -10];

if strcmp(args.width, 'normal')
    pos = [pos, 800];
elseif strcmp(args.width, 'wide')
    pos = [pos, 900];
elseif strcmp(args.width, 'full')
    pos = [pos, 1200];
elseif strcmp(args.width, 'half')
    pos = [pos, 650];
elseif strcmp(args.width, 'third')
    pos = [pos, 400];
elseif isnumeric(args.width)
    pos = [pos, args.width];
else
    pos = [pos, 800];
end

if strcmp(args.height, 'normal')
    pos = [pos, 500];
elseif strcmp(args.height, 'tall')
    pos = [pos, 800];
elseif strcmp(args.height, 'full')
    pos = [pos, 1000];
elseif strcmp(args.height, 'short')
    pos = [pos, 400];
elseif strcmp(args.height, 'tiny')
    pos = [pos, 300];
elseif isnumeric(args.height)
    pos = [pos, args.height];
else
    pos = [pos, 500];
end

f = gcf;
set(f, 'visible', 'off');

set(f,'pos', pos);

if args.pdf || args.svg
    exportgraphics(f, sprintf('%s.pdf', filepath), 'BackgroundColor', 'none', 'ContentType', 'vector');
end

if args.png
    try
        system(sprintf('pdftocairo -png -transp -singlefile %s.pdf %s >/dev/null 2>&1', filepath, filepath));
    catch
        warning('pdftocario command has failed. Using exportgraphics instead.');
        exportgraphics(f, sprintf('%s.png', filepath));
    end
end

if args.eps
    exportgraphics(f, sprintf('%s.eps', filepath), 'BackgroundColor', 'none');
end

if args.svg
    system(sprintf('pdftocairo -svg %s.pdf %s.svg >/dev/null 2>&1', filepath, filepath));
    if ~args.pdf
        system(sprintf('rm %s.pdf', filepath));
    end
end

if args.fig
    saveas(f, filepath, 'fig');
end

set(f, 'visible', 'on');

filepath = [filepath, '.png'];
end

function mustBeWidth(arg)
    if any(mustBeMember(arg,{'normal', 'wide', 'full', 'half', 'third'}) || mustBePositive(str2num(arg)))
        error('Width is wrongly specify')
    end
end

function mustBeHeight(arg)
    if any(mustBeMember(arg,{'normal', 'tall', 'full', 'short', 'tiny'}) || mustBePositive(str2num(arg)))
        error('Height is wrongly specify')
    end
end
