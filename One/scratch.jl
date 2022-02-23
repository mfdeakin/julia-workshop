
struct Squares
    max :: Int
end

import Base.iterate

iterate(::Squares) = (1, 2)
function iterate(s :: Squares, i :: Int)
    if i > s.max
        nothing
    else
        (i^2, i + 1)
    end
end

struct NewtonIter
    f :: Function
    fprime :: Function
    initial :: Float64
    threshold :: Float64
    maxIters :: Int
end
Base.IteratorSize(NewtonIter) = Base.SizeUnknown()

struct NewtonIterState
    i :: Int64
    guess :: Float64
end

iterate(n :: NewtonIter) = ((1, n.initial, n.f(n.initial), n.fprime(n.initial)), NewtonIterState(1, n.initial * (1.0 + (rand() - 0.5) * 2.0e-6)))

function iterate(n :: NewtonIter, i :: NewtonIterState)
    if n.maxIters > 0 && i.i > n.maxIters
        nothing
    else
        perturbed_guess = i.guess
        e = n.f(perturbed_guess)
        if abs(e) < n.threshold
            nothing
        else
            d = n.fprime(perturbed_guess)
            nextGuess = perturbed_guess - e / d
            ((i.i, nextGuess, n.f(nextGuess), n.fprime(n.f(nextGuess))), NewtonIterState(i.i + 1, nextGuess))
        end
    end
end

xsq(x) = x * x - 2
xsqprime(x) = 2 * x

for ni in NewtonIter(xsq, xsqprime, 0.5, 1e-12, 100)
    println(ni)
end

nitr = NewtonIter(xsq, xsqprime, 0.5, 1e-12, 100)
steps = Iterators.take(nitr, 100)
collect(steps)

prod(1/i[3] for i in nitr) + 1
