clear;
file = fopen('Alice29.txt');
txt = fscanf(file,'%c');
fclose(file);

% cast text to uint8 data class, all letters are casted to an integer
% value, stored in the order of their occurance in the text
% NOTE: case-sensitive
letters = cast(txt, 'uint8');

% num_letters is the maximum value of the casted integers,
% which corresponds to the number of letters, this is equal to 122
num_letters = max(letters); % = 122

% To count all occurrences of each uint8-casted letter,
% The k:th element corresponds to how many occurances there are
% for the casted value k
count = zeros(1, num_letters);

% Loop through all letters and count their occurances
for letter = letters
    count(letter) = count(letter) + 1;
end

% Turn the count array into probabilities
probs = count/sum(count);

%% Find letter(symbol) distribution
% Remove all zeros and change to a better format.
dist = [];
for i = 1:num_letters
    if probs(i) ~= 0
        % update dist, cast integers to characters together
        % with each char's probability
        dist = [dist; {cast(i, 'char')} {probs(i)}];
    end
end

%% Calculate the codewords using Huffman algorithm
[C,tree,map] = Huffman(dist);
% Construct N-by-3 cell array to store: symbol, codeword, probability
totalCell = TotalCell(map,dist);

% calculate average codeword length (bits/symbol)
L = avgCodewordLength(totalCell(:,3),totalCell(:,2));

% The average codeword length per symbol: L = (1/N)*L
% N is the length of the longest symbol?
% number of symbols = x = 2^(N) => N = log2(x)
x = size(map,1);
N = log2(x);
Ls = L/N; % bits/symbol

% Calculate entropy
H = Entropy(probs');

% Encrypt the text
E = encrypt(txt, C);

% Compare the length of encoded text with original text
% to find compression ratio
compRatio = (length(txt)*8)/length(E)
cf = length(E)/(length(txt)*8)

% Calculate percentage for number of zeros
ratioZeros = length(strfind(E, '0'))/length(E)





%% Test examples
%alphabet = {'A', 0.073; 'B', 0.009; 'C', 0.030; 'D', 0.044; 'E', 0.130; 'F', 0.028; 'G', 0.016; 'H', 0.035; 'I', 0.074; 'J', 0.002; 'K', 0.003; 'L', 0.035; 'M', 0.025; 'N', 0.078; 'O', 0.074; 'P', 0.027; 'Q', 0.003; 'R', 0.077; 'S', 0.063; 'T', 0.093; 'U', 0.027; 'V', 0.013; 'W', 0.016; 'X', 0.005; 'Y', 0.019; 'Z', 0.001};
values = [73,9,30,44,130,28,16,35,74,2,3,35,25,78,74,27,3,77,63,93,27,13,16,5,19,1]/1000;
letters = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
alphabet = [letters', num2cell(values)'];



[code1,tree1,map1] = Huffman(alphabet);
total1 = TotalCell(map1,alphabet);
% Get probabilities and codeword lengths, lx
p = cell2mat(alphabet(:,2));
cellCodes = map1(:,2);
% average codeword length - not working entirely correctly
L1 = avgCodewordLength(total1(:,3), total1(:,2)); 
H1 = Entropy(cell2mat(alphabet(:,2)));

%% another test, see 4.3d)
t = [{'4'} {0.25}; {'3'} {0.2}; {'6'} {0.18}; {'2'} {0.15}; {'5'} {0.12}; {'1'} {0.1}];
[code2,tree2,map2] = Huffman(t);
total2 = TotalCell(map2, t);
L2 = avgCodewordLength(total2(:,3), total2(:,2));

%% another test, Lecture4 example
distribution = [{'1'} {0.45}; {'2'} {0.25}; {'3'} {0.2}; {'4'} {0.1}];
[code3,tree3,map3] = Huffman(distribution);
total3 = TotalCell(map3, distribution);
L3 = avgCodewordLength(total3(:,3),total3(:,2));