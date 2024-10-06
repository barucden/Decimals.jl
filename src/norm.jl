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

# Maximum exponent E such that 10^E is representable by Int and Culong
# (Culong is UInt32 on Windows)
const MAX_EXP = floor(Int, log(10, min(typemax(Culong), typemax(Int))))

function normalized(s, c::BigInt, q::Int)
    if iszero(c)
        return Decimal(s, c, 0)
    end

    # Remove all trailing zeros in c
    while mpz_isdivisible(c, 10)
        d = 10
        q = q + 1
        for e in 2:MAX_EXP
            mpz_isdivisible(c, 10 * d) || break
            d *= 10
            q += 1
        end
        c = mpz_divexact(c, d)
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
normalized(x::Decimal) = normalized(x.s, x.c, x.q)
