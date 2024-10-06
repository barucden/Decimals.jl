@static if VERSION < v"1.10-"
    const libgmp = :libgmp
else
    const libgmp = Base.GMP.libgmp
end

function mpz_isdivisible(x::BigInt, y::Int)
    r = ccall((:__gmpz_divisible_ui_p, libgmp), Cint,
              (Base.GMP.MPZ.mpz_t, Culong), x, y)
    return r != 0
end

function mpz_divexact(x::BigInt, d::Int)
    y = BigInt()
    ccall((:__gmpz_divexact_ui, libgmp), Cvoid,
          (Base.GMP.MPZ.mpz_t, Base.GMP.MPZ.mpz_t, Culong), y, x, d)
    return y
end


