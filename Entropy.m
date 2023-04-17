function H=Entropy(P)
close all;
% The Entropy function H(X)
%
% P column vector: the vector is the probability distribution.
% P matrix: Each column vector is a probability distribution
% P scalar: The binary entropy function of [P; 1-P]
% P row vector: Each position gives binary entropy function

s = size(P);
sum = 0;

function px = calcProb(p)
    px = p*log2(p);
end

function h = binaryEntropy(p)
    if (p == 0 || p == 1)
        h = 0;
    else
        h = -p*log2(p) - (1-p)*log2(1-p);
    end
end

%% P scalar, binary entropy function h(p)
if (s(1) == 1 && s(2) == 1)
    H = binaryEntropy(P);
end



%% P column vector
if (s(2) == 1 && s(1) > 1)
    for i = 1:length(P)
        if (P(i) == 0)
            sum = sum + 0;
        else
            sum = sum + calcProb(P(i));
        end
    end
    sum = -sum;
    H = sum;
end

%% P matrix
if (s(1) > 1 && s(2) > 1)
    rows = s(1);
    cols = s(2);
    sum = zeros(1, cols);
    
    for col = 1:cols
        for i = 1:rows
            p = P(i,col);
            if (p == 0 || p == 1)
                sum(col) = sum(col) + 0;
            else
                sum(col) = sum(col) + calcProb(p);
            end
        end
        sum(col) = -sum(col);
    end
    H = sum;
end


%% P row vector, plot binary entropy function

if (s(1) == 1 && s(2) > 1)
    close all;
    L = length(P);
    figure(1)
    hold on
    grid on
    xlabel("$p$ $\cdot$ (1/" + L + ")", 'Interpreter','latex', 'FontSize', 22)
    ylabel('$h(p)$', 'Interpreter','latex', 'FontSize', 22)
    H = zeros(1,L);
    for i = 1:length(P)
        H(i) = binaryEntropy(P(i));
    end
    H
end



end
