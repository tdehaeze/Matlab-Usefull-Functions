function [] = exportFig(file_name, fig_size, opts_param)

%% Default values for opts
opts = struct('path', 'pwd',...
              'folder', 'figures',...
              'tikz', false,...
              'pdf', true,...
              'png', true,...
              'size', 'full' ...
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
end

%% Populate opts with input parameters
if exist('opts_param','var')
    for opt = fieldnames(opts_param)'
        opts.(opt{1}) = opts_param.(opt{1});
    end
end

%%
change_size = true;
if strcmp(opts.size, 'full') % Full figure
    opts.pos = [20 60 500 400];
elseif strcmp(opts.size, 'half') % Used for sub figures
    opts.pos = [20 60 300 300];
elseif strcmp(opts.size, 'small') % Used for wrap figures
    opts.pos = [20 60 400 300];
elseif strcmp(opts.size, 'wide') % Used to display wide figures
    opts.pos = [20 60 600 400];
else
    change_size = false;
end

if strcmp(opts.path, 'pwd')
    opts.path = pwd;
end

%%
set(gcf,'color','w');
if change_size
    set(gcf,'pos',opts.pos);
end

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

