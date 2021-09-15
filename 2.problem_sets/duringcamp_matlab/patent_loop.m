function [V, D] = patent_loop(p,r,k,K,T) % No longer any "t" or "realized"

V = zeros(2,T+2);
D = zeros(2,T+1);
p_vec = [1 p]; % This is the difference in probability of renewal across two states
K_vec = [K 0]; % This is the payment conditional on state
for t = T+1:-1:1
    for j = 1:2
        % For me at least, it was crucial to have brackets around second
        % element in order for it to work
        [v, d] = max([K_vec(j);( K_vec(j) - k +...
            (1/(1+r))*[p_vec(j) 1-p_vec(j)]*V(:,t+1))]); 
        V(j,t) = v;
        D(j,t) = d-1;
    end
end

