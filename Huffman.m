function [C,binaryTreeString,mapping] = Huffman(D)
% Generates Huffman codes for the given distribution D
%   Input:
%       D: A two dimensional cell array containing the letters in the first
%       column and their probabilities in the second column.

%% Uses Huffman algorithm to generate a binary tree string to represent the code.
% I could not use (, ) or , to build the binary tree string 
% as those characters are included in the text
while size(D) > 1
    % Sort on probability, least probable are placed first (at the head of the list)
    D = sortrows(D, 2);
    
    % Get 2 least probable from D and make them a new node with added prob
    leaf1 = cell2mat(D(1,1));
    leaf1prob = cell2mat(D(1,2));
    leaf2 = cell2mat(D(2,1));
    leaf2prob = cell2mat(D(2,2));
    node = [{['{' leaf1 '+' leaf2 '}']} {leaf1prob + leaf2prob}];
    %new = [{['(' cell2mat(D(1, 1)) ',' cell2mat(D(2, 1)) ')']} {cell2mat(D(1, 2)) + cell2mat(D(2, 2))}];
    
    % Remove them (first row of D) and add as one element
    D(1,:) = [];
    D(1,:) = node;
end

binaryTreeString = D(1);

%% Parses the tree-string to get the codes.
% Branch up: '0'
% Branch down: '1'

% Get binary tree string (bts) from cell format to matrix
bts = cell2mat(D(1));
% Current codeword
code = '';
keys = [];
vals = [];

% loop through binary tree string
for i = (length(bts)):-1:1
    if bts(i) == '}'
        % append 1 as last bit (branching down)
        code = [code '1'];
    elseif bts(i) == '{' && ~isempty(code)
        % remove last bit
        code(end) = [];
    elseif bts(i) == '+' && ~isempty(code)
        % replace last bit with 0 (branching up)
        code(end) = '0';
    elseif bts(i) == '+'
        code = '0';
    else
        keys = [keys; {bts(i)}];
        vals = [vals; {code}];
    end
end

mapping = [keys, vals];
C=containers.Map(keys, vals);
end