function I=MutualInformation(P)
% The mutual information I(X;Y)
%
% P=P(X,Y) is the joint probability of X and Y.
%P = P';
[Px,Py] = calcProbDistrVector(P);
Px
Py

% H(X), H(Y)
Hx = Entropy(Px)
Hy = Entropy(Py)
% H(X,Y)
Hxy = sum(Entropy(P))

% I(X;Y)
I = Hx + Hy - Hxy

% Conditional entropies
Hx_given_y = Hx - I
Hy_given_x = Hy - I


    function [Px,Py] = calcProbDistrVector(P)
        sz = size(P);
        rows = sz(1);
        cols = sz(2);
        
        % Empty probability distribution (column) vectors
        Px = zeros(cols,1);
        Py = zeros(cols,1);

        % calculate prob distr. vector for X
        for i = 1:rows
            Px(i) = sum(P(i,:));
        end

        % calculate prob distr. vector for Y
        for i = 1:cols
            Py(i) = sum(P(:,i));
        end
    end

end
