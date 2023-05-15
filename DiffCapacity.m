% Find optimal value A for maximizing the channel capacity
idx = 1;
range = 0:0.01:1;

capacities = size(range);

for a = range
    capacities(idx) = capacity(a);
    idx = idx + 1;
end

% find max capacity
[maxCapacity, i] = max(capacities);
maxCapacity
optimalA = range(i)


function C = capacity(A)
C = Entropy(A/2) - A;
end




