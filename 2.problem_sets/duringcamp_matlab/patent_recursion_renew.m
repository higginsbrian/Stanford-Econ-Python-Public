function [v, d] = patent_recursion_renew(p,r,realized,k,K,t,T)

if t>T
    v = 0;
    d = 0;
elseif realized == 1
    v = patent_recursion_renew(p,r,1,k,K,t+1,T);
    v = (t==T)*K + (t<T)*(- k + K + v/(1+r)); % No need to renew in period T
    d = 1;
else
    v_r = patent_recursion_renew(p,r,1,k,K,t+1,T);
    v_nr = patent_recursion_renew(p,r,0,k,K,t+1,T);
    v = (t<T)*(- k + (1/(1+r))*(p*v_r + (1-p)*v_nr)); % No need to renew in period T
    d = 1;
end
