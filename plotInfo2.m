%%%%%%%%%%%%%%%%%%%%%%% %% Plot I(X;Y) %%%%%%%%%%%%%%%%%%%%%%%
% From Problem 6, 2019 exam
clear all;

%% Init
EsN0 = -10:1:30; % Es/N0 in dB
X0 = 0;
X1 = 1;
eps = 1e-10; % Close to zero

%% Derive I(X;Y) for each EsN0 value
for t = 1:length(EsN0)
    % Fix X and derive N0 for X=0 and X=1
    N01 = X1/10^(EsN0(t)/10);
    N00 = N01/3;
    % H(Z|X) expression
    HZcX(t) = (1/4)*log2(pi*exp(1)*N00) + (1/4)*log2(pi*exp(1)*N01);

    %% Integrate from X0−5*stdev to X1+5*stdev with numerical steps of 0.005
    Y = X0-sqrt(N01)*5:0.005:X1+sqrt(N01)*5;
    %% Find f(y)
    fYcX0 = 1/sqrt(pi*N00)*exp(-(Y-X0).^2./(N00));
    fYcX0(fYcX0 < eps) = eps;% Avoid 0log0
    fYcX1 = 1/sqrt(pi*N01)*exp(-(Y-X1).^2./(N01));
    fYcX1(fYcX1 < eps) = eps;% Avoid 0log0
    fY = 1/2*(fYcX0+fYcX1);
    HY(t) = -trapz(Y,fY.*log2(fY));
    IXY(t) = HY(t)-HZcX(t);
end
plot(EsN0,IXY)

ylabel('Mutual Information $I(X;Y)$','Interpreter','latex','FontSize',22)
xlabel('SNR $E_s/N_0$ [dB]','Interpreter','latex','FontSize',22)
title('Mutual Information plot over varying SNR','FontSize',22)