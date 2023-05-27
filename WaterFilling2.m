close all;
%% Gaussian channel is split into 4 sub-channels
% From Exercise 9.8)

% Each sub-channel has the bandwidth W_delta [Hz]
%W_delta = 10000;
W_delta = 10000;

% Attenuation for each sub-channel [dBm/Hz]
%H = [-40 -44 -49 -53 -58 -62 -67 -71 -76 -80];
%H = [-36 -30 -16 -21];
%H = [0 -5 -10 -15 -20];
H = [-40 -44 -49 -53 -58 -62 -67 -71 -76 -80];
H_lin = toLinear(H)

% Noise levels for each sub-channel [dB]
%N = [-133 -129 -115 -138 -139 -135 -125 -118 -121 -126];
%N = [-108 -129 -96 -124];
%N = [-120 -110 -90 -110 -120];
N = [-133 -129 -115 -138 -139 -135 -125 -118 -121 -126];
% After conversion to linear scale, we have [mW/Hz]
N_lin = toLinear(N)
sub_channels = numel(N);



% Total allowed power usage in transmitted signal
P = -20; % [dBm]
P_lin = toLinear(P); % [mW]


%% Calc sum with several components
sum = 0;
for i = 1:numel(N_lin)
    value = (N_lin(i)*W_delta)/H_lin(i);
    sum = sum + value;
end
sum


%% Find P_i for each sub-channel with Water-Filling algorithm
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
        newBW = calcBW(N_lin,P_lin,W_delta,H_lin)
        P_i = waterFilling(newBW,N_lin,W_delta,H_lin)
    end
end

% Calculate capacity after water-filling algorithm
capacity = Capacity2(P_i,N_lin,H_lin,W_delta)

%% SNR plots
SNR = calcSNR(P_i,H_lin,N_lin,W_delta)
% Covert SNR linear value to dB
SNR_dB = 10*log10(SNR)

% Plot SNR
figure
subplot(121)
bar(SNR_dB)
ylabel('SNR [dB]', 'FontSize',18)
xlabel('Sub-channel', 'FontSize',18)

% Plot Capacity
subplot(122)
capacitites = zeros(sub_channels,1);
for i = 1:sub_channels
    capacitites(i) = W_delta*log2(1+SNR(i));
end
bar(capacitites/1000,'g')
ylabel('Capacity [kbps]', 'FontSize',18)
xlabel('Sub-channel', 'FontSize',18)



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

function [c] = Capacity2(power,noise,attenuation,bandwidth)
    c = 0;
    for i = 1:numel(power)
        if (power(i) > 0 && noise(i) > 0)
            num = power(i)*attenuation(i);
            den = noise(i)*bandwidth;
            snr = num/den;
            c = c + bandwidth*log2(1+snr);
        end
    end
end

function [SNR] = calcSNR(P,H,N,W)
    % All parameters in linear scale
    if (numel(P) > 1)
        SNR = zeros(numel(N),1);
        for i = 1:numel(N)
            SNR(i) = (P(i)*H(i))/(N(i)*W);
        end
    else
        SNR = zeros(numel(N),1);
        for i = 1:numel(N)
            SNR(i) = (P*H(i))/(N(i)*W);
        end
    end
end