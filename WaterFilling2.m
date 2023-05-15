%% Gaussian channel is split into 4 sub-channels
% From Exercise 9.8)

% Each sub-channel has the bandwidth W_delta [Hz]
W_delta = 1000;

% Attenuation for each sub-channel [dBm/Hz]
H = [-36 -30 -16 -21];
H_lin = toLinear(H)

% Noise levels for each sub-channel [dB]
N = [-108 -129 -96 -124];
% After conversion to linear scale, we have [mW/Hz]
N_lin = toLinear(N)
sub_channels = numel(N);


% Capacity for equally distributed power over all n sub-channels
%capacity_eq = Capacity(P/sub_channels*ones(sub_channels,1),N)

% Total allowed power usage in transmitted signal
P = -50; % [dBm]
P_lin = toLinear(P); % [mW]

% Calculate B*W_delta
BW = calcBW(N_lin,P_lin,W_delta,H_lin)

P_i = waterFilling(BW,N_lin,W_delta,H_lin)

for i = 1:numel(N)-1
    fprintf('Iteration: %d\n', i+1);
    % Find any zeros in P_i, delete that sub-channel
    %prevIdx = zeroIndices;
    zeroIndices = find(P_i == 0)
       
    % Set the noise level for the removed sub-channel to 0
    if ~isempty(zeroIndices)
        % Delete sub-channels for the found indices
        for i = 1:numel(zeroIndices)
            zeroIndex = zeroIndices(i);
            N_lin(zeroIndex) = 0;
        end
        N_lin
        newBW = calcBW(N_lin,P_lin,W_delta,H_lin);
        P_i = waterFilling(newBW,N_lin,W_delta,H_lin)
    end
end

% Calculate capacity after water-filling algorithm
capacity = Capacity2(P_i,N_lin,H_lin,W_delta)




function [BW] = calcBW(N, P, W, H)
    % BW = 1/4 (P + sum(SNR))
    snr = sum(N.*W./H);
    BW = (P + snr)./nnz(N);
end


function [P_i] = waterFilling(BW, N, W, H)
    P_i = zeros(numel(N),1);
    for i = 1:numel(N)
        p = BW - (N(i)*W/H(i));
        if p < 0 || N(i) == 0
            p = 0;
        end
        P_i(i) = p;
    end
end

function [C] = Capacity2(power,noise,attenuation,bandwidth)
    C = 0;
    for i = 1:numel(power)
        if (power(i) > 0 && noise(i) > 0)
            num = power(i)*attenuation(i);
            den = noise(i)*bandwidth;
            snr = num/den;
            C = C + bandwidth*log2(1+snr);
        end
    end
end