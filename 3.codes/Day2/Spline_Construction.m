%% Construction of Splines

% Function to be splined
% f = @(x)(x.^2);
% f = @(x)(sin(x))
f = @(x)(min(x,5));

x = linspace(0,10,10);
y = f(x);

f_spline = spline(x,y);
x_spline = linspace(0,10,1000);
y_spline = fnval(f_spline,x_spline);

figure;
plot(x_spline,f(x_spline),'Linewidth',1.5)
hold on
plot(x_spline,y_spline,'Linewidth',1.5)
legend('Exact','Spline')
