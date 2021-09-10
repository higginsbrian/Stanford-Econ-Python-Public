function [x, u] = demand(y, p, util)
 
f = @(z)(-util(z)); 
A = [p;-eye(2)]; % Budget Constraint and non-negativity constraint
b = [p*y';0 ;0];
[x, u] = fmincon(f,y,A,b);
u = -u; % Because we are trying to minimize negative utility
