# ┏━━━━━━━━━━━┓
# ┃ Problem 1 ┃
# ┗━━━━━━━━━━━┛
#
# Make an iterator over the prime numbers less than or equal to $n$ using a Sieve of Eratosthenes
#  - The sieve should be created when building the Primes struct
#  - You should provide a constructor which does so (`Primes(n::Int)`)
#  - The iterator interface is described here: https://docs.julialang.org/en/v1/manual/interfaces/#man-interface-iteration
#  - You may wish to define additional functions
# Sieve of Eratosthenes:
#  - Allocate a Boolean vector of size $n$, where each element represents whether that number is prime.
#    - They should all start as `true`. You can use the function `ones(Bool, n)` to make the vector.
#    - (there's also a `trues` function, which returns a BitVector. This'll also work.)
#  - Mark 1 as false
#  - Let p = 1
#  - While there are numbers marked as prime greater than p:
#    - Set p to the smallest number marked prime larger than the previous p
#    - Mark all multiples of p (2p, 3p, ...) as not prime
#  - Now, all numbers are marked correctly
# Hint: 1:2:10 gives you a range over (1, 3, 5, 7, 9)

import Base: iterate

struct Primes
    n::Int
    sieve::Vector{Bool}
end

Primes(n::Int) = Primes(n, ones(Bool, n))

# iterate() methods here

function iterate(p :: Primes)
    if p.n > 1
        p.sieve[1] = false
        p.sieve[2] = true
        (2, 3)
    else
        nothing
    end
end

function isPrime(p :: Primes, i :: Int)
    for j in [2 ... Int(floor(sqrt(i)))]
        if p.sieve[j] && mod(i, j) == 0
            return false
        end
    end
    true
end

function iterate(p :: Primes, i :: Int)
    while i < p.n
        if isPrime(p, i)
            break
        else
            p.sieve[i] = false
            i += 1
        end
    end
    if i < p.n
        (i, i + 1)
    else
        nothing
    end
end

# ┏━━━━━━━━━━━┓
# ┃ Problem 2 ┃
# ┗━━━━━━━━━━━┛
#
# Problem 2: Write a matrix type which is the outer product of two vectors
# - You should only store the vectors
# - Both should have element type `T`, and it should be a subtype of `AbstractMatrix{T}`
# - You should implement the methods (https://docs.julialang.org/en/v1/manual/interfaces/#man-interface-array):
#   - `size(::OuterProduct)`
#   - `getindex(::OuterProduct, i::Int, j::Int)`
#   - `adjoint(::OuterProduct)` (hint: (uv')' = (vu'))
# - Try building an instance of OuterProduct in the REPL. Julia can already print it and has matrix-vector and matrix-matrix multiplication defined!

import Base: adjoint, size, getindex

struct OuterProduct{T <: Real} <: AbstractMatrix{T}
    left :: Vector{T}
    right :: Vector{T}
end

function size(mtx::OuterProduct)
    return (size(mtx.left)[1], size(mtx.right)[1])
end

function getindex(mtx::OuterProduct, i::Int, j::Int)
    return mtx.left[i] * mtx.right[j]
end

function adjoint(mtx::OuterProduct)
    return OuterProduct(mtx.right, mtx.left)
end

# ┏━━━━━━━━━━━┓
# ┃ Problem 3 ┃
# ┗━━━━━━━━━━━┛
#
# Problem 3: Peano Arithmetic
# Peano arithmetic provides a compact axiomatic description of the natural numbers. An informal description is:
#  - There exists 0.
#  - There exists the successor function, S(). S(x) != 0 ∀ x
#  - S(x) == S(y) implies x == y
# From this we can recursively construct the naturals. Further, we can define addition recursively:
#  - +(x, 0)    = x            (and similar methods)
#  - +(x, S(y)) = S(x + y)
# As well as multiplication:
#  - *(x, 0)    = 0            (and similar methods)
#  - *(x, S(y)) = x + (x * y)
# For your implementation, you'll define types and methods to compute Peano arithmetic.
#  - There should be two subtypes of `PeanoNumber`: `Zero` and `S`
#    - `Zero` should have no fields
#    - `S` should have a single parameter `P <: PeanoNumber`, and a single field of type `P`
#  - You should define + and *
#  - You should also define `convert(::Type{Int}, ...)` to turn the Peano numbers into regular ints.
#  - The opposite conversion has been done for you
# HINT: Think recursively! Remember dispatch!

import Base: +, *, convert, >, <, ==

abstract type PeanoNumber <: Integer end

struct Zero <: PeanoNumber end
struct S{T <: PeanoNumber} <: PeanoNumber end
struct P{T <: PeanoNumber} <: PeanoNumber end

S(::T) where {T <: PeanoNumber} = S{T}()
S(::P{T}) where {T <: PeanoNumber} = T()
P(::T) where {T <: PeanoNumber} = P{T}()
P(::S{T}) where {T <: PeanoNumber} = T()

convert(::Type{Int}, ::Zero) = 0
convert(::Type{Int}, ::S{T}) where {T <: PeanoNumber} = 1 + convert(Int, T())
convert(::Type{Int}, ::P{T}) where {T <: PeanoNumber} = -1 + convert(Int, T())

function convert(::Type{PeanoNumber}, i::Int)
    if i < 0
        P(convert(PeanoNumber, i + 1))
    elseif i == 0
        Zero()
    else
        S(convert(PeanoNumber, i - 1))
    end
end

==(::T1, ::T2) where {T1 <: PeanoNumber, T2 <: PeanoNumber} = convert(Int, T1()) == convert(Int, T2())
<(::T1, ::T2) where {T1 <: PeanoNumber, T2 <: PeanoNumber} = convert(Int, T1()) < convert(Int, T2())
>(::T1, ::T2) where {T1 <: PeanoNumber, T2 <: PeanoNumber} = convert(Int, T1()) > convert(Int, T2())

+(::T1, ::T2) where {T1 <: PeanoNumber, T2 <: PeanoNumber} = convert(PeanoNumber, convert(Int, T1()) + convert(Int, T2()))
*(::T1, ::T2) where {T1 <: PeanoNumber, T2 <: PeanoNumber} = convert(PeanoNumber, convert(Int, T1()) * convert(Int, T2()))

# ┏━━━━━━━┓
# ┃ Tests ┃
# ┗━━━━━━━┛

function test_primes()
    answers = [2, 3, 5, 7, 11]
    for (i, p) in enumerate(Primes(12))
        if p != answers[i]
            error("The $(i)th prime is incorrect: is $p but should be $(answers[i])")
        end
    end
    println("Primes passed the test.")
end
test_primes()

function test_outerproduct()
    u = randn(128)
    v = randn(256)
    eager = u * v'
    lazy  = OuterProduct(u, v)

    lazy_  = adjoint(lazy)
    eager_ = adjoint(eager)

    if size(lazy) != size(eager)
        println("OuterProduct failed the test, probably in `size`.")
    end

    if !all(eager .≈ lazy)
        println("OuterProduct failed the test, probably in `getindex`.")
    end

    if all(eager_ .≈ lazy_)
        println("OuterProduct passed the test.")
    else
        println("OuterProduct failed the test, probably in `adjoint`")
    end
end
test_outerproduct()


function test_peano()
    zero = Zero()
    one = S(zero)
    two = S(one)
    three = S(two)

    test(fn, a, b, expected) = let i = convert(Int, fn(a, b))
        if i != expected
            println("$fn(a + b) should be $expected, but is $i")
            false
        else
            true
        end
    end

    test(+, two, three, 5) && test(*, two, three, 6) && test(+, zero, zero, 0) && println("PeanoNumbers passed the test.")
end
test_peano()
