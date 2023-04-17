function [L] = avgCodewordLength(cellpx,cellCodes)
% Calculate average codeword length E[L]
%   Input:
%       px: probabilities given in a cell array
%       cellCodes: codewords given as cell array

lx = zeros(1,length(cellCodes));
px = zeros(1,length(cellCodes));

% take out elements from cellCodes and put their length in normal vector
% take out elements from cellpx and put into normal vector

for i = 1:length(cellCodes)
    cellCode = cellCodes(i);
    code = cell2mat(cellCode);
    lx(i) = length(code);

    pxz = cellpx(i);
    px(i) = cell2mat(pxz);
end   


L = 0;
for i = 1:length(px)
    L = L + lx(i) * px(i);
    %fprintf("%d * %d = %d\n",lx(i),px(i), lx(i)*px(i))
end    

end

