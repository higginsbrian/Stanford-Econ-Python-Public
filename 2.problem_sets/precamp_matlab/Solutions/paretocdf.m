function f = paretocdf(x,x_m,alpha)
f = zeros(size(x));
f(x>x_m) = 1 - (x_m^alpha)*x.^(-alpha);