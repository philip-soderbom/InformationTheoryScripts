function [D_pq,D_qp] = RelativeEntropy(px,qx)
% RELATIVEENTROPY Calculates the Relative Entropy for two
% probability distribuitions, p(x) and q(x), for the same sample set X
% Inputs: probability distribuitions, p(x) and q(x)
% Outputs:
%   D_pq: The Relative Entropy D(p||q)
%   D_qp: The Relative Entropy D(q||p)

D_pq = 0;
D_qp = 0;
L = length(px);

for i = 1:L
    p = px(i);
    q = qx(i);
    D_pq = D_pq + p*log2(p/q);
    D_qp = D_qp + q*log2(q/p);
end    

D_pq
D_qp

end

