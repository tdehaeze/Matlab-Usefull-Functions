function [Gp] = flipRphPoles(G)
% flipRphPoles -
%
% Syntax: [Gp] = flipRphPoles(G)
%
% Inputs:
%    - in_data -
%
% Outputs:
%    - in_data -

  [z, p, k] = zpkdata(G);
  p{1}(real(p{1}) > 0) = -real(p{1}(real(p{1}) > 0)) + imag(p{1}(real(p{1}) > 0));
  Gp = zpk(z, p, k);

end
