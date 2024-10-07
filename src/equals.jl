# Equality

_sign(x::Decimal) = x.s ? -1 : 1

function Base.cmp(x::Decimal, y::Decimal)
    if iszero(x) && iszero(y)
        return 0
    elseif iszero(x) # && !iszero(y)
        return -_sign(y)
    elseif iszero(y) # && !iszero(x)
        return _sign(x)
    end

    # Neither x nor y is zero here

    if x.s != y.s
        # x and y have different signs:
        #  if x < 0, then return -1 (because y is positive)
        #  if x > 0, then return +1 (because y is negative)
        return _sign(x)
    end

    x = normalized(x)
    y = normalized(y)

    cmp_c = cmp(x.c, y.c)
    cmp_q = cmp(x.q, y.q)

    # If both x.c and x.q is greater (or equal, or less) than y.c and y.q,
    # then x is greater (or equal, or less) than y.
    if cmp_c == cmp_q
        return cmp_c
    else
        d = x - y
        return _sign(d)
    end
end

Base.:(==)(x::Decimal, y::Decimal) = iszero(cmp(x, y))
Base.:(<)(x::Decimal, y::Decimal) = cmp(x, y) < 0
Base.:(<=)(x::Decimal, y::Decimal) = cmp(x, y) ≤ 0

Base.min(x::Decimal, y::Decimal) = x ≤ y ? x : y
Base.max(x::Decimal, y::Decimal) = x ≤ y ? y : x

# Special case equality with AbstractFloat to allow comparison against Inf/Nan
# which are not representable in Decimal

Base.:(==)(a::AbstractFloat, b::Decimal) = b == a
function Base.:(==)(a::Decimal, b::AbstractFloat)
    # Decimal does not represent NaN/Inf
    (isinf(b) || isnan(b)) && return false
    ==(promote(a, b)...)
end

function Base.min(a::AbstractFloat, b::Decimal)
    !signbit(a) && isinf(a) && return convert(promote_type(typeof(a), typeof(b)), b)
    min(promote(a, b)...)
end
function Base.min(a::Decimal, b::AbstractFloat)
    !signbit(b) && isinf(b) && return convert(promote_type(typeof(a), typeof(b)), a)
    min(promote(a, b)...)
end

function Base.max(a::AbstractFloat, b::Decimal)
    signbit(a) && isinf(a) && return convert(promote_type(typeof(a), typeof(b)), b)
    max(promote(a, b)...)
end
function Base.max(a::Decimal, b::AbstractFloat)
    signbit(b) && isinf(b) && return convert(promote_type(typeof(a), typeof(b)), a)
    max(promote(a, b)...)
end
