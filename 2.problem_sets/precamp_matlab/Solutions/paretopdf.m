function f = paretopdf(x,x_m,alpha)
f = zeros(size(x));
f(x>x_m) = (alpha*x_m^alpha)*x(x>x_m).^(-alpha-1);
