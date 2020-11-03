function [] = endOfCode()
    load('gong', 'Fs', 'y');
    sound(0.5*y, Fs);
end
