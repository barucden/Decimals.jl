# Normalization: remove trailing zeros in coefficient
function normalize(x::Decimal; rounded::Bool=false)
    p = 0
    if x.c != 0
        while x.c % BigTen^(p+1) == 0
            p += 1
        end
    end
    c = BigInt(x.c / BigTen^p)
    q = (c == 0 && x.s == 0) ? 0 : x.q + p
    if rounded
        Decimal(x.s, abs(c), q)
    else
        round(Decimal(x.s, abs(c), q), digits=DIGITS, normal=true)
    end
end


function mpz_exact_div(x::BigInt, n::Int)
    return BigInt(x / n)
end
function mpz_isdivisible(x::BigInt, n::Int)
    return (x % n) == 0
end


# Maximum exponent E such that 10^E is representable in T
_maxexp(::Type{Int64}) = 18
_maxexp(::Type{Int32}) = 9

function normalized(s, c::BigInt, q::Int)
    if iszero(c)
        return Decimal(s, c, 0)
    end

    # Remove all trailing zeros in c
    while mpz_isdivisible(c, 10)
        d = 10
        q = q + 1
        for e in 1:_maxexp(Int)
            mpz_isdivisible(c, 10 * d) || break
            d *= 10
            q += 1
        end
        c = mpz_exact_div(c, d)
    end

    # Make sure precision is respected
    precision = PRECISION[]
    n = ndigits(c, base=10)
    if n > precision
        # Number of digits to remove
        shift = n - precision

        c = div(c, BigTen^shift, RoundNearest)
        q = q + shift
    end

    return Decimal(s, c, q)
end

