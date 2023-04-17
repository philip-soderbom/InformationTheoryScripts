function [H_inf,mu] = EntropyRate(P)
% Calculate stationary distribution and entropy rate
%   Input: P is the transition matrix

H = Entropy(P');

% Get mu values, steade state solution (stationary distribution)
% Solving mu*P=mu <=> mu(P-I)=0, solve for mu: A*mu = B = 0

% A = (P - I)
A = P - eye(size(P));

% Construct complete A matrix for solving equation
% sum of all mu_i values = 1 as last row
A = [A'; ones(1,size(P,1))];

% Right-hand side of equation
B = [zeros(size(P,1),1); 1];

% Get stationary distribution vector, mu
mu = linsolve(A,B); % mu = A\B

% Calculate entropy rate
H_inf = sum(mu'.*H);

% Entropy for the memory-less case,
% using stationary probability distribution mus
H = Entropy(mu);



end

