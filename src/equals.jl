# Equality

function Base.cmp(x::Decimal, y::Decimal)
    if iszero(x)
        if iszero(y)
            return 0
        else
            return y.s ? 1 : -1
        end
    else # x != 0
        if iszero(y)
            return x.s ? -1 : 1
        end
    end

    if x.s != y.s
        return x.s ? -1 : 1
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
        return d.s ? -1 : 1
    end
end

Base.:(==)(x::Decimal, y::Decimal) = iszero(cmp(x, y))
Base.:(<)(x::Decimal, y::Decimal) = cmp(x, y) < 0
Base.:(<=)(x::Decimal, y::Decimal) = cmp(x, y) ≤ 0

Base.min(x::Decimal, y::Decimal) = x ≤ y ? x : y
Base.max(x::Decimal, y::Decimal) = x ≤ y ? y : x

Base.iszero(x::Decimal) = iszero(x.c)
# TODO: Implement isone

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
