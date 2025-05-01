function y = photodiode_model(x, coeff)
% PHOTODIODE_MODEL Computes the output y of a photodiode model
%   y = x.^2 * coeff(1) + x * coeff(2) + coeff(3)
%
%   Inputs:
%       x     - Input value(s), can be scalar or vector
%       coeff - 1x3 matrix (or vector) of coefficients [a b c]
%               such that y = a*x^2 + b*x + c
%
%   Output:
%       y     - Output value(s) of the same size as x

    y =  x.^10 .* coeff(1) + x.^9 .* coeff(2)+ x.^8 .* coeff(3)+ x.^7 .* coeff(4)+...
         x.^6 .* coeff(5)+ x.^5 .* coeff(6)+ x.^4 .* coeff(7)+ x.^3 .* coeff(8)+...
         x.^2 .* coeff(9) + x .* coeff(10) + coeff(11);

end