function [G_string] = zpk2latex(G)
    [z, p, k] = zpkdata(G);

    C_gain = sprintf('%.1e ', k);

    C_num = '';
    for i = 1:length(z{1})
        C_num = horzcat(C_num, '(s');
        if imag(z{1}(i)) == 0
            C_num = horzcat(C_num, sprintf('%+.1e', -z{1}(i)));
        else
            C_num = horzcat(C_num, sprintf('-(%.1e%+.1e i)', real(z{1}(i)), imag(z{1}(i))));
        end
        C_num = horzcat(C_num, ')');
    end

    C_den = '';
    for i = 1:length(p{1})
        C_den = horzcat(C_den, '(s');
        if imag(p{1}(i)) == 0
            C_den = horzcat(C_den, sprintf('%+.1e', -p{1}(i)));
        else
            C_den = horzcat(C_den, sprintf('-(%.1e%+.1e i)', real(p{1}(i)), imag(p{1}(i))));
        end
        C_den = horzcat(C_den, ')');
    end

    C_size = max(length(C_num), length(C_den));

    G_string = [C_gain, '\frac{', C_num, '}{', C_den, '}'];
end
