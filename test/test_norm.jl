using Decimals
using Test

@testset "Normalization" begin

@test Decimal(true, 151100, -4) == Decimal(true, 1511, -2)
@test Decimal(false, 100100, -5) == Decimal(false, 1001, -3)
@test normalize(Decimal(1, 151100, -4)) == Decimal(true, 1511, -2)
@test normalize(Decimal(0, 100100, -5)) == Decimal(false, 1001, -3)
@test parse(Decimal, "3.0") == Decimal(false, 3, 0)
@test parse(Decimal, "3.0") == Decimal(false, 30, -1)
@test parse(Decimal, "3.1400") == Decimal(false, 314, -2)
@test parse(Decimal, "1234") == Decimal(false, 1234, 0)

@testset "normalized" begin
    let vals = [(s=true, c=big"1", q=1, expected=Decimal(true, big"1", 1)),
                (s=true, c=big"10", q=1, expected=Decimal(true, big"1", 2)),
                (s=true, c=big"1_000_000_000_000_000_000_000", q=1, expected=Decimal(true, big"1", 22))]
        for (; s, c, q, expected) in vals
            @test Decimals.normalized(s, c, q) == expected
        end
    end
end

end
