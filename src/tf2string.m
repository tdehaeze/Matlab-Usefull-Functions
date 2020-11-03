function [G_string] = tf2string(G)
    G = tf(G);
    syms s;
    sym_num=poly2sym(G.num{:},s);
    sym_num=vpa(sym_num, 4);
    char_num=char(sym_num);

    sym_den=poly2sym(G.den{:},s);
    sym_den=vpa(sym_den, 4);
    char_den=char(sym_den);

    G_string = ['(', char_num, ')/(', char_den, ')'];
end
