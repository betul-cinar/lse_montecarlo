function y = photodiode_model_inverse(x, coeff_inv)
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

    y =  x.^10 .* coeff_inv.p_inv(1) + x.^9 .* coeff_inv.p_inv(2)+ x.^8 .* coeff_inv.p_inv(3)+ x.^7 .* coeff_inv.p_inv(4)+...
         x.^6 .* coeff_inv.p_inv(5)+ x.^5 .* coeff_inv.p_inv(6)+ x.^4 .* coeff_inv.p_inv(7)+ x.^3 .* coeff_inv.p_inv(8)+...
         x.^2 .* coeff_inv.p_inv(9) + x .* coeff_inv.p_inv(10) + coeff_inv.p_inv(11);

end