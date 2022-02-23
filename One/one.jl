

function main()
    function foo(x)
        if x > 5
            2 * x
        else
            3 * x
        end
    end

    quadruple(x) = 4 * x

    range(n) = 1 : n
    println(range(4))

    # A = [2 1 3; 1 4 0; 3 0 -1]
    # println(ℯ ^ A)

    println(rand(2 : 5))

    s = "453"
    println(parse(Int, s))

    function guessingGame(range)
        ans = rand(range)
        guess = 0
        count = 0
        while ans != guess
            print("Enter your guess: ")
            guess = parse(Int, readline())
            if guess > 100 || guess < 1
                count -= 1
                println("$guess is out of the range 1 - 100")
            elseif guess < ans
                println("$guess is too low")
            elseif guess > ans
                println("$guess is too high")
            end
            count += 1
        end
        count
    end
    # count = guessingGame(1 : 2)
    # println("Success in $count guesses")

    println(Real <: Int)
    println(Real <: Real)
    println(Int <: Real)
    println(10 isa Any)
    println(5 isa Integer)

    b = [1, 2.0, 4 + 5im]
    println(typeof(b))
    push!(b, 4)

    c = Float64[]
    d = Real[]

    # @which +(1, 4)

    bar(x) = x
    bar(x::Integer) = 2 * x
    bar(x::Int8) = 3 * x

    n::Int8 = 122
    bar(n)

    ab = IntModN(3, 9)
    println(ab)
end

using Revise

includet("int_ring.jl")
main()
