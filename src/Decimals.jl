# Pure Julia decimal arithmetic
# @license MIT
# @author jack@tinybike.net (Jack Peterson), 7/3/2014

module Decimals

export Decimal,
       decimal,
       number,
       normalize

const DIGITS = 20

const PRECISION = Ref(20)
function Base.setprecision(Decimal, precision::Int)
    if precision < 1
        throw(ArgumentError("precision must be at least 1"))
    end
    PRECISION[] = precision
end


# Numerical value: (-1)^s * c * 10^q
struct Decimal <: AbstractFloat
    s::Bool  # sign can be 0 (+) or 1 (-)
    c::BigInt   # coefficient (significand), must be non-negative
    q::Int  # exponent

    function Decimal(s::Integer, c::Integer, e::Integer)
        new(Bool(s), c, e)
    end
end

include("mpz.jl")

# Convert between Decimal objects, numbers, and strings
include("decimal.jl")

# Decimal normalization
include("norm.jl")

# Addition, subtraction, negation, multiplication
include("arithmetic.jl")

# Equality
include("equals.jl")

# Rounding
include("round.jl")

end
