% From Exercise 10.5)
close  all;
epsilon = 0:0.01:0.5;

I = zeros(length(epsilon),1);


for i = 1:length(epsilon)
    info = 2 - 0.5*Entropy(epsilon(i)) - 0.5*Entropy(2*epsilon(i)) - epsilon(i);
    I(i) = info;
end


figure
plot(epsilon,I)
title('Information transmission per channel use','FontSize',18)
ylabel('I(X;Y)','Interpreter','latex', 'FontSize',18)
xlabel('Epsilon, $\epsilon$', 'Interpreter','latex','FontSize',18)
grid on