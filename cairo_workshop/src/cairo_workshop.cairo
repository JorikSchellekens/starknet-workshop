use debug::PrintTrait;


fn fib(a: felt252, b: felt252, n: felt252) -> felt252 {
    if n == 0 {
        a
    } else {
        fib(b, a+b, n-1)
    }
}

fn main() {
    let x = fib(1,1,3);
    x.print();
}
