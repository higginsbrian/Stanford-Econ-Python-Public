function x = totaldemand(y,p,util)

x = [0 0];

for i = 1:length(x)
    x = x + demand(y(i,:),[1 p],util);
end

x = x(2);    