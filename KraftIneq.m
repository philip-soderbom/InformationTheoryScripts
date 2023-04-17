function [res] = KraftIneq(codeword_lengths,D)
% KRAFTINEQ calculates the Kraft Inequality equation
% Input:
%   codeword_lengths: vector containing the codeword lengths
%   D: check for D-ary prefix code
% Output:
%   If res <= 1, then there exists a D-ary prefix code for the given set of
%   codeword lengths

k = length(codeword_lengths);
res = 0;

for i = 1:k
    res = res + D^(-codeword_lengths(i));
end


% generate possible code C if res <= 1
if (res <= 1)
    C = generatePrefixCode(codeword_lengths);
end

%C

end

