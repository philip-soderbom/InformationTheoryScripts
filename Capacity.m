function [C] = Capacity(power,noise)
    C = 0;
    for i = 1:numel(power)
        if (power(i) > 0 && noise(i) > 0)
            C = C + 0.5*log2(1+power(i)/noise(i));
        end
    end
end

