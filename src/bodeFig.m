function [] = bodeFig(systems, freqs, opts_param)

%% Default values for opts
opts = struct('phase', false);

%% Check if the frequency is specified
ni = nargin;

if ni == 2
    if isstruct(freqs)
        opts_param = freqs;
        clear freqs;
    else
        opts_param = struct();
    end
end

%% Populate opts with input parameters
if exist('opts_param','var')
    for opt = fieldnames(opts_param)'
        opts.(opt{1}) = opts_param.(opt{1});
    end
end

%% Number of subplots
n_subplots = 1;
if opts.phase
    n_subplots = 2;
end

%% Cell of transfer function to array of tf
systems_arr = tf(0)*zeros(length(systems), 1);
for i = 1:length(systems)
    systems{i}.InputName = {};
    systems{i}.OutputName = {};
    systems_arr(i) = systems{i};
end

%% Compute the frequency response
bode_opts = bodeoptions;
bode_opts.FreqUnits       = 'Hz';
bode_opts.PhaseWrapping   = 'on';

if ~exist('freqs', 'var')
    [resp_mag,resp_phase,freqs] = bode(systems_arr, bode_opts);
else
    [resp_mag,resp_phase,freqs] = bode(systems_arr, freqs, bode_opts);
end

%% Plot
figure;

%% Phase
if opts.phase
    ax2 = subplot(n_subplots,1,2);
    hold on;
    for i = 1:length(systems)
        plot(freqs, mod(180+resp_phase(i, :), 360)-180);
    end
    set(gca,'xscale','log');
    ylim([-180, 180]);
    yticks([-180, -90, 0, 90, 180]);
    xlabel('Frequency ($Hz$)'); ylabel('Phase (deg)');
    hold off;
end

%% Amplitude
ax1 = subplot(n_subplots,1,1);
hold on;
for i = 1:length(systems)
    plot(freqs, resp_mag(i, :));
end
set(gca,'xscale','log'); set(gca,'yscale','log');
ylabel('Amplitude');

xlabel('Frequency ($Hz$)');
hold off;

%% Link X-axis
if opts.phase
	linkaxes([ax1, ax2], 'x');  
end

end

