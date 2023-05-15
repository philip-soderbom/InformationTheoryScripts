%% Suppose we have a channel consisting of n parallel Gaussian sub-channels
% From Exercise 9.6)

% Noise levels for each sub-channel
N = [8 12 14 10 16 6];
sub_channels = numel(N);

% Capacity for equally distributed power over all n sub-channels
capacity_eq = Capacity(P/sub_channels*ones(sub_channels,1),N)

% Total allowed power usage in transmitted signal
P = 19;

% Calculate B
B = calcB(N,P)

P_i = waterFilling(B,N)

for i = 1:numel(N)-1
    fprintf('Iteration: %d\n', i+1);
    % Find any zeros in P_i, delete that sub-channel
    prevIdx = zeroIndices;
    zeroIndices = find(P_i == 0)
       
    % Set the noise level for the removed sub-channel to 0
    if ~isempty(zeroIndices)
        % Delete sub-channels for the found indices
        for i = 1:numel(zeroIndices)
            zeroIndex = zeroIndices(i);
            N(zeroIndex) = 0;
        end
        N
        newB = calcB(N,P)
        P_i = waterFilling(newB,N)
    end
end

% Calculate capacity after water-filling algorithm
capacity = Capacity(P_i,N)




function [B] = calcB(noise, power)
    B = (power + sum(noise))/nnz(noise);
end


function [P_i] = waterFilling(B, N)
    P_i = zeros(numel(N),1);
    for i = 1:numel(N)
        p = B - N(i);
        if p < 0 || N(i) == 0
            p = 0;
        end
        P_i(i) = p;
    end
end