function [] = exportFig(file_name, fig_size, opts_param)

%% Default values for opts
opts = struct('path', 'pwd',...
              'folder', 'figures',...
              'tikz', false,...
              'pdf', true,...
              'png', true,...
              'size', 'normal-normal' ...
);

%% Check if the frequency is specified
ni = nargin;

if ni == 1 % No opts_param
    opts_param = struct();
elseif ni == 2
    if isstruct(fig_size) % If the second parameter is the opts_param
        opts_param = fig_size;
        clear fig_size;
    else % If second parameter is the fig_size
        opts_param = struct();
        opts_param.size = fig_size;
    end
else % 3 arguments
    opts_param.size = fig_size;
end

%% Populate opts with input parameters
if exist('opts_param','var')
    for opt = fieldnames(opts_param)'
        opts.(opt{1}) = opts_param.(opt{1});
    end
end

%% Change size of figure
% width-height
% first part (width): normal, full, half
% second part (height): normal, short, tall
size_strings = strsplit(opts.size, '-');
if length(size_strings) == 1 % Only specify the width
    width_string = opts.size{1};
    height_string = 'normal';
else
    width_string = size_strings{1};
    height_string = size_strings{2};
end
opts.pos = [20 60];

if strcmp(width_string, 'normal')
    opts.pos = [opts.pos, 450];
elseif strcmp(width_string, 'wide')
    opts.pos = [opts.pos, 600];
elseif strcmp(width_string, 'full')
    opts.pos = [opts.pos, 700];
elseif strcmp(width_string, 'half')
    opts.pos = [opts.pos, 300];
elseif strcmp(width_string, 'third')
    opts.pos = [opts.pos, 230];
else
    opts.pos = [opts.pos, 450];
end

if strcmp(height_string, 'normal')
    opts.pos = [opts.pos, 300];
elseif strcmp(height_string, 'tall')
    opts.pos = [opts.pos, 500];
elseif strcmp(height_string, 'short')
    opts.pos = [opts.pos, 250];
elseif strcmp(height_string, 'tiny')
    opts.pos = [opts.pos, 200];
else
    opts.pos = [opts.pos, 300];
end

if strcmp(opts.path, 'pwd')
    opts.path = pwd;
end

%%
set(gcf,'color','w');
set(gcf, 'pos', opts.pos);

tightfig;

%%
if opts.png
    export_fig(sprintf('%s/%s/%s.png', opts.path, opts.folder, file_name), '-png')
end

if opts.pdf
    export_fig(sprintf('%s/%s/%s.png', opts.path, opts.folder, file_name), '-pdf')
end

% TODO - change size depending of opts.size
if opts.tikz
    cleanfigure;
    matlab2tikz(sprintf('%s/%s/%s.tex', opts.path, opts.folder, file_name), ...
        'height', '\fheight', ...
        'width',  '\fwidth',  ...
        'showInfo', false);

    str_start = [...
        "\documentclass[12pt,tikz]{standalone}"; ...
        ""; ...
        "\ifstandalone%"; ...
        "\usepackage{import}"; ...
        "\import{../../configuration/}{comon_packages.tex}%"; ...
        "\import{../../configuration/}{variables.tex}%"; ...
        "\import{../../configuration/}{conftikz.tex}%"; ...
        "\import{../../configuration/}{custom_config.tex}%"; ...
        ""; ...
        "\setlength\fwidth{0.5\columnwidth}"; ...
        "\setlength\fheight{4cm}"; ...
        "\fi"; ...
        ""; ...
        "\begin{document}"; ...
    ];

    str_end = [...
        "\end{document}" ...
    ];

    str_middle = fileread(sprintf('%s/%s/%s.tex', opts.path, opts.folder, file_name));

    fid = fopen(sprintf('%s/%s/%s.tex', opts.path, opts.folder, file_name), 'wt');

    fprintf(fid, '%s\n', str_start);
    fprintf(fid, '%s\n', str_middle);
    fprintf(fid, '%s\n', str_end);

    fclose(fid);
end

end

