function [v, d] = patent_recursion(p,r,realized,k,K,t,T)

if t>T
    v = 0;
    d = 0;
elseif realized == 1
    v = patent_recursion(p,r,1,k,K,t+1,T);
    [v, d] = max([K,K - k + v/(1+r)]);
    d = d-1;
else
    v_r = patent_recursion(p,r,1,k,K,t+1,T);
    v_nr = patent_recursion(p,r,0,k,K,t+1,T);
    [v, d] = max([0,- k + (1/(1+r))*(p*v_r + (1-p)*v_nr)]);
    d = d-1;
end
