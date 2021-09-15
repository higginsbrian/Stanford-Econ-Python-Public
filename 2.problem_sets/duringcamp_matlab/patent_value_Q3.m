function [X, T, V, D] = patent_value_Q3(p,q,r,k,x,T,n)

N = T+1+n;
V = zeros(N,T+2);
D = zeros(N,T+1);
payoffs = x*(q.^(0:2:2*(N-1)))'*(q.^-(1:T+1));


for t = T+1:-1:1
    [v, d] = max([payoffs(1:end-1,t), payoffs(1:end-1,t) - ... 
        k + (1/(1+r))*[V(2:end,t+1) V(1:end-1,t+1)]*[p;1-p]]');
    V(1:end-1,t) = v;
    D(1:end-1,t) = d-1;
end

% The next line is to get rid of the last row, which is beyond the last
% date and is hepful for the mesh that we will graph
V(:,T+2) = [];
X = payoffs;
T = repmat(0:T,N,1);
