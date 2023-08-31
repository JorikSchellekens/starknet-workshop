# Starknet

---

# STARK

Succinct Non-Interactive Argument of Knowledge

---

# STARK proofs in 1 minute

Proof of 'integrity'

They come from the research of zero knowledge proofs

Examples:

- Where's wally

- I know your password 

- I computed program P over input I which resulted in O


Main ingredients:
- Fiat Shamir
- FRI

---

# draw it out

Draw it out?

---

# SHARP prover

The Shared Prover


Creates joint proofs across many programs

This 'batching' is what makes Starknet's verification so cheap

Allows for recursive proofs (proof of a proof of a proof ....)

The proofs created by SHARP are uploaded to Ethereum and verified

---

# Structure of the network

```


                                             ┌───────────┐
                                  ┌─────────►│           │ Proof
                                  │          │   SHARP   ├────────┐
                              ┌───┴───┐      │           │        │
┌─────┐      ┌──────────┐     │ Block │      └───────────┘  ┌─────▼───────┐
│ tx1 │      │          │     │  ---  │                     │             │
│     ├─────►│ Starknet ├────►│  tx1  │                     │   Ethereum  │
│ tx2 │      │          │     │       │                     │             │
│     │      └──────────┘     │  tx2  │                     └─────────────┘
│ tx3 │                       │       │                           ▲
│     │                       │  tx3  ├───────────────────────────┘
│  .  │                       │       │
│  .  │                       │   .   │
│  .  │                       │   .   │
│     │                       │   .   │
└─────┘                       └───────┘

```
---

# Open voyager.online

---

# Cairo


Cairo is a provable language

I.e. execution of Cairo can be proven by SHARP.

---

This is a lie

`Cairo Assembly` (`CASM`) is a provable language

`Cairo` is a high level language 🦀🦀🦀
which compiles to `CASM`

---

This is also a lie

`Cairo` compiles to `Sierra`

The `S`afe `I`nt`e`rmediate `R`ep`r`esent`a`tion

`Sierra` compiles to `CASM`

---

# Why?

```
assert 1 = 0
```

---

```

     ┌─────────┐
     │         │
     │  Cairo  │
     │         │
     └────┬────┘                             ┌───────────────────────┐
          │                                  │                       │
          ▼                                  │                       │
   ┌────────────┐                            │                       │
   │            │                            │                       │
   │   Sierra   │     ──────────────────►    │   Starknet network    │
   │            │                            │                       │
   └──────┬─────┘                            │                       │
          │                                  │                       │
          ▼                                  └────────┬──────────────┘
 ┌─────────────────┐                                  │
 │                 │                                  │
 │      CASM       │                                  │
 │(Cairo Assembly) │                                  │
 │                 ├──────────────────────────────────┤
 └─────────────────┘                                  │
                                                      ▼
                                              ┌─┬─────┬───┬─┐
                                              │ ├─────────┤ │
                                              │ │         │ │
                                              │ │  SHARP  │ │
                                              │ │         │ │
                                              │ ├─────────┤ │
                                              └─┴────┼────┴─┘
```

---

Easy 😎

---

# Install scarb


```
curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh
```

I also recommend Starknet Foundry but won't be covering this here:

```
https://github.com/foundry-rs/starknet-foundry/tree/master
```

---

# Cairo book

A lot of what I'm covering can be found here:
https://book.cairo-lang.org/

---

# leggo

Start a new project

```
scarb new cairo_workshop
```

---
Edit `src/lib.cairo`


```rust
use debug::PrintTrait;

fn main() {
    let x = 'yo yo yo';
    x.print();
}
```
---

# Simple fib
```rust
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
```

# Error:
```
Expected variable data for statement not found. :(
```
```
scarb cairo-run --available-gas=20000000
```

---

# mutability

```rust
use debug::PrintTrait;
fn main() {
    let x = 5;
    x.print();
    x = 6;
    x.print();
}
```

---

# mutability

```rust
use debug::PrintTrait;
fn main() {
    let mut x = 5;
    x.print();
    x = 6;
    x.print();
}
```

---

# Types

Scalar types

- Felt type : `felt252`
- Integer type : `u8`, `u16`, `u32`, `u64`, `u128`, `u256`, `usize`
- Boolean : `bool`
- 'strings' : `felt252`
- unit: `()`
---

# Casting

```rust
use traits::TryInto;
use option::OptionTrait;
fn main() {
    let x: felt252 = 3;
    let y: u32 = x.try_into().unwrap();
}
```
---

# functions

```rust
use debug::PrintTrait;

fn another_function() {
    'Another function.'.print();
}

fn main() {
    'Hello, world!'.print();
    another_function();
}
```

---

# functions
## named parameters

```rust
fn foo(x: u8, y: u8) {}

fn main() {
    let first_arg = 3;
    let second_arg = 4;
    foo(x: first_arg, y: second_arg);
    let x = 1;
    let y = 2;
    foo(:x, :y)
}
```

---

# functions
## statements and expressions

```
let x = 5;
```

```
x + 1
```
---

# functions
## Return values

A function 'is an expression'

```rust
use debug::PrintTrait;

fn main() {
    let x = plus_one(5);

    x.print();
}

fn plus_one(x: u32) -> u32 {
    x + 1
}
```

---
# Control flow
## if else

```rust
use debug::PrintTrait;

fn main() {
    let number = 3;

    if number == 12 {
        'number is 12'.print();
    } else if number == 3 {
        'number is 3'.print();
    } else if number - 2 == 1 {
        'number minus 2 is 1'.print();
    } else {
        'number not found'.print();
    }
}
```


Note: 'if' is an expression!

```rust
if true { 42 } else { 0 } == 42
```

---
# Control flow
## loops

```rust
use debug::PrintTrait;
fn main() {
    let mut i: usize = 0;
    loop {
        if i > 10 {
            break;
        }
        if i == 5 {
            i += 1;
            continue;
        }
        i.print();
        i += 1;
    }
}
```

Need to specify a gas limit:

```
scarb cairo-run --available-gas=20000000
```

---

# challenges

1. Write fib from scratch
2. Write the ackerman function from scratch

---

# structs

```rust
struct User {
    active: bool,
    username: felt252,
    email: felt252,
    sign_in_count: u64,
}
```
---

# arrays

```rust
use array::ArrayTrait;

fn main() {
    let mut a = ArrayTrait::new();
    a.append(0);
    a.append(1);
    a.append(2);
}
```
Note the `mut`

```rust
let first_value = a.pop_front().unwrap();
```

---

# arrays

`arr.at(0)`

```rust
use array::ArrayTrait;
fn main() {
    let mut a = ArrayTrait::new();
    a.append(0);
    a.append(1);

    let first = *a.at(0);
    let second = *a.at(1);
}
```

---

# arrays

`arr.get(0)`

```rust
use array::ArrayTrait;
use box::BoxTrait;
fn main() -> u128 {
    let mut arr = ArrayTrait::<u128>::new();
    arr.append(100);
    let index_to_access =
        1; // Change this value to see different results, what would happen if the index doesn't exist?
    match arr.get(index_to_access) {
        Option::Some(x) => {
            *x.unbox()
        // Don't worry about * for now, if you are curious see Chapter 3.2 #desnap operator
        // It basically means "transform what get(idx) returned into a real value"
        },
        Option::None(_) => {
            let mut data = ArrayTrait::new();
            data.append('out of bounds');
            panic(data)
        }
    }
}
```
---

# dictionaries

```rust
use dict::Felt252DictTrait;

fn main() {
    let mut balances: Felt252Dict<u64> = Default::default();

    balances.insert('Alex', 100);

    let alex_balance = balances.get('Alex');
    assert(alex_balance == 100, 'Balance is not 100');
}
```

---

# Ownership

```
{
  let s = ...;
}
```

- s is always 'owned'
- When s comes into scope, it is valid.
- It remains valid until it goes out of scope.


If s is passed to a function it is moved.
However, if s implements Copy is is copied.

---

# Snapshot

A snap shot is an immutable instance of a variable.
```
let v = ...;
let snapshot_v = @v;

let modifiablevalue = *snapshot_v;
```

A function must explicitely specify the snapshot type to accept snapshots.

```
fn mod(arg: @ArgType) {
}
```

why?

---
# References

References are implicitly returned from function

```rust
fn main() {
    let mut rec = ...;
    modifyingFunction(ref rec);
    // rec has changed here
}

fn modifyingFunction(ref rec: Rectangle) {
  // modify rec here
  blah
}
```


---

# Lets get more blockchainy

go to https://remix.ethereum.org/#activate=Starknet-cairo1-compiler

or just install the `starknet` plugin on https://remix.ethereum.org

---

In two files I have examples you can play with.

in `voting.cairo` you'll find an example voting contract

upload it to remix.

---

# Constructor


External functions

```rust
#[external(v0)]
fn function() {
}

#[external(v0)]
impl ERC20 of IERC20 {
  // all functions external
}
```

# bad
# Get set up

Devnet requires Python versions >=3.9 and <3.10.

I usually set up a python env for this, you do you.

On Ubuntu/Debian, first run:

```bash
$ sudo apt install -y libgmp3-dev
```

On Mac, you can use brew:

```bash
$ brew install gmp
```

# Install a local testnet

```
pip install starknet-devnet
```

Note: Python devnet is being replaced by a rust version, you can also experiment with katana.

https://github.com/0xSpaceShard/starknet-devnet

https://github.com/0xSpaceShard/starknet-devnet-rs

https://github.com/dojoengine/dojo/tree/main/crates/katana

---

# macos :(

If you're running intel macos you may need toy

```
CFLAGS=-I`brew \
  --prefix gmp`/include LDFLAGS=-L`brew \
  --prefix gmp`/lib \
  pip install ecdsa fastecdsa sympy
pip install starknet-devnet
```

---

# Install Starkli

```
curl https://get.starkli.sh | sh
starkliup
```

---
more reasources

- https://starknet-by-example.voyager.online
- https://cairo-book.github.io/
---

Voyager

---

Basic syntax:
Statements
Functions
For loops
Dictionaries
Basic examples
Tooling (10 minutes):
Intros to:
Scarb
Remix
Starkli
Voyager
Devnet
Practical Cairo (10 minutes)
Contract syntax
Contract to contract calling
Storage
Walkthrough of a basic AMM



Basic cairo program


---

Language constructs
  - declarations
  - types
  - structs
  - dicts
  - functions
  - interfaces

---

More interesting cairo program

---

Remix

---

contract syntax

contract to contract calling

---

toy amm?

---

check on voyager

---

Advanced
  - borrow semantics
  - snapshots
  - traits
  - 

---


