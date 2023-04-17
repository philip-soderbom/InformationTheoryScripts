% Joint distribution of X and Y given by p(x,y)
% Aim is to calculate probability P(X<xlim,Y<ylim)

xlim = 4;
ylim = 4;

P = 0;
for x = 0:xlim-1
    for y = 0:ylim-1
        %fprintf('p(%d,%d) = %f\n', x,y,p(x,y))
        P = P + p(x,y);
    end    
end

fprintf('P(X < %d, Y < %d) = %f\n', xlim,ylim,P)

%% Specify the joint distr. function of X and Y here:
function z = p(x,y)
    z = (1/4)*2^-(x+y);
end