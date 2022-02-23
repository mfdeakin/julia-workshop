
struct ModN{T <: Integer} <: Integer
    value :: T
    modulus :: T
end

ModN(value::Integer, modulus::Integer) = ModN(promote(value, modulus)...)

IntModN = ModN{Int}

import Base.show
show(io::IO, x::ModN{Int}) = print(io, "ModN($(x.value) mod $(x.modulus))")

struct MismatchedModulusException{T, U} <: Exception
    first::ModN{T}
    second::ModN{U}
end
show(io::IO, x::MismatchedModulusException) = print(io, "Cannot perform a binary operation with modulus $(x.first.modulus) and $(x.second.modulus)")

import Base.+, Base.*

function +(x::ModN, y::ModN)
    if x.modulus != y.modulus
        throw(MismatchedModulusException(x, y))
    end
    IntModN((x.value + y.value) % x.modulus, x.modulus)
end

function *(x::ModN, y::ModN)
    if x.modulus != y.modulus
        throw(MismatchedModulusException(x, y))
    end
    IntModN((x.value * y.value) % x.modulus, x.modulus)
end

function congruent(x, y)
    (x - y).value == 0
end
