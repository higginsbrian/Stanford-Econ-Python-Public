function fib = fibo_loop(n)

if n <=2
    fib = 1;
else
    fib = 1;
    fib_prev = 1;
    
    for i = 3:n
        temp = fib; % You save this because you want to generate the new fib_prev
        fib = fib + fib_prev;
        fib_prev = temp;
    end
end