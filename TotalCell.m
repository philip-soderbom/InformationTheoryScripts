function [total] = TotalCell(mapping,distribution)
% Create N-by-3 cell array with symbol, codeword, probability
%   Input:
%       mapping: The ampping between symbol and codeword (N-by-2 cell array) 
%       distribution: The distribution of probabilites of different symbols
%                     (N-by-2 cell array)

codewords = mapping(:,2);
symbols = mapping(:,1); % char array

total = cell(size(codewords,1),3);

total(:,1) = symbols;
total(:,2) = codewords;

px = cell(length(codewords),1);

% match symbol from mapping with correct probability
for i = 1:length(codewords)
    sym = cell2mat(distribution(i,1));
    p = cell2mat(distribution(i,2));

    for j = 1:length(codewords)
        if (sym == cell2mat(mapping(j,1)))
            px(j) = {p};
        end    
    end
end    

total(:,3) = px;
end

