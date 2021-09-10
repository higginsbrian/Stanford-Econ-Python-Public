function fib_vec = fibo_loop_vec(n)

if n ==1
    fib_vec = 1;
elseif n==2
    fib_vec = [1;1];
else
    fib_vec = [1;1];
    fib = 1;
    fib_prev = 1;
    for i = 3:n
        temp = fib; % You save this because you want to generate the new fib_prev
        fib = fib + fib_prev;
        fib_vec(end+1) = fib;
        fib_prev = temp;
    end
end