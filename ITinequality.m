close all;

x = linspace(0,5,100);
y1 = x-1;
y2 = log(x);

plot(x,y1, '-', 'LineWidth',2);
hold on;
grid on;
plot(x,y2, '--', 'LineWidth',2);

xlabel('x','FontSize', 28)
ylabel('y','FontSize', 28)
title('IT inequality', 'FontSize', 28)

yline(0)

legend('$y=x-1$', '$y=\ln(x)$', 'Interpreter', 'latex', 'location', 'northwest', 'FontSize', 20)