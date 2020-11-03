function [Gp] = flipRphZeros(G)
% flipRphZeros -
%
% Syntax: [Gp] = flipRphZeros(G)
%
% Inputs:
%    - in_data -
%
% Outputs:
%    - in_data -

  [z, p, k] = zpkdata(G);
  z{1}(real(z{1}) > 0) = -real(z{1}(real(z{1}) > 0)) + imag(z{1}(real(z{1}) > 0));
  Gp = zpk(z, p, k);

end
