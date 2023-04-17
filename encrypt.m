function E = encrypt(T, D)
% Encrypts the given text T according to the given dictionary D
%
% Input:
%   T: text to be encrypted.
%   D: dictionary to encrypt by.

E = [];
% loop through the text file
for i=1:length(T)
    character = T(i);
    codeword = D(character); % map character to codeword (bit sequence)
    E=[E codeword];
end
