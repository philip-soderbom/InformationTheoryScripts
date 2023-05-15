function [linvector] = toLinear(dBvector)
% Convert from dB (dBm) scale to linear (mW) scale
linvector = zeros(numel(dBvector),1);

for i = 1:numel(dBvector)
    dB_val = dBvector(i);
    lin_val = 10^(dB_val/10);
    linvector(i) = lin_val;
end

end

