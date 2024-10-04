using Decimals
using Test
using Supposition

@testset "Arithmetic" begin

DecimalGen = @composed function generate_decimal(
        s = Data.Integers(0, 1),
        c = Data.Integers(0, 2^8),
        q = Data.Integers(-4, 4))
    Decimal(s, c, q)
end

@testset "Addition" begin
    @test Decimal(0.1) + 0.2 == 0.1 + Decimal(0.2) == Decimal(0.1) + Decimal(0.2) == Decimal(0.3)
    @test Decimal.([0.1 0.2]) .+ [0.3 0.1] == Decimal.([0.4 0.3])
    @test Decimal(2147483646) + Decimal(1) == Decimal(2147483647)
    @test Decimal(1,3,-2) + parse(Decimal, "0.2523410412138103") == Decimal(0,2223410412138103,-16)

    @test Decimal(0, 10000000000000000001, -19) + Decimal(0, 1, 0) == Decimal(0, 20000000000000000001, -19)

    @testset "Properties" begin
        @check function add_comutative(x = DecimalGen, y = DecimalGen)
            return x + y == y + x
        end

        @check function add_neutral_element(x = DecimalGen)
            return x + zero(x) == x
        end

        @check function add_successor(x = DecimalGen)
            return x + oneunit(x) > x
        end
    end
end

@testset "Subtraction" begin
    @test Decimal(0.3) - 0.1 == 0.3 - Decimal(0.1)
    @test 0.3 - Decimal(0.1) == Decimal(0.3) - Decimal(0.1)
    @test Decimal(0.3) - Decimal(0.1) == Decimal(0.2)
    @test Decimal.([0.3 0.1]) .- [0.1 0.5] == Decimal.([0.2 -0.4])

    @testset "Properties" begin
        @check function sub_anticomutative(x = DecimalGen, y = DecimalGen)
            return x - y == -(y - x)
        end

        @check function sub_predecessor(x = DecimalGen)
            return x - oneunit(x) < x
        end
    end
end

@testset "Negation" begin
    @test -Decimal.([0.3 0.2]) == [-Decimal(0.3) -Decimal(0.2)]
    @test -Decimal(0.3) == zero(Decimal) - Decimal(0.3)
    @test iszero(decimal(12.1) - decimal(12.1))

    @testset "Properties" begin
        @check function neg_identity(x = DecimalGen)
            return x == -(-x)
        end
    end
end

@testset "Multiplication" begin
    @test Decimal(12.21) * Decimal(2.12) == Decimal(0,258852,-4)
    @test Decimal(12.2112543) * Decimal(2.121352) == Decimal(0,259043687318136,-13)
    @test Decimal(0.2) * 0.1 == 0.2 * Decimal(0.1)
    @test 0.2 * Decimal(0.1) == Decimal(0.02)
    @test Decimal(12.34) * 0.1234 == 12.34 * Decimal(0.1234)
    @test 12.34 * Decimal(0.1234) == Decimal(1.522756)
    @test Decimal(0.21084210) * -2 == -2 * Decimal(0.21084210)
    @test -2 * Decimal(0.21084210) == Decimal(-0.4216842)
    @test Decimal(0, 2, -1) * 0.0 == zero(Decimal)
    @test Decimal.([0.3, 0.6]) .* 5 == [Decimal(0.3)*5, Decimal(0.6)*5]
    @test one(Decimal) * 1 == Decimal(0, 1, 0)

    @testset "Properties" begin
        @check function mul_comutative(x = DecimalGen, y = DecimalGen)
            return x * y == y * x
        end

        @check function mul_neutral_element(x = DecimalGen)
            return x * one(x) == x
        end

        @check function zero_element(x = DecimalGen)
            return x * zero(x) == zero(x)
        end

        @check function mul_negation(x = DecimalGen)
            return -1 * x == -x
        end
    end
end

@testset "Inversion" begin
    @test inv(Decimal(false, 1, -1)) == Decimal(false, 1, 1)
    @test inv(Decimal(false, 1, 1)) == Decimal(false, 1, -1)
    @test inv(Decimal(true, 2, -1)) == Decimal(true, 5, 0)
    @test inv(Decimal(true, 5, 0)) == Decimal(true, 2, -1)
    @test inv(Decimal(false, 2, -2)) == Decimal(false, 5, 1)
    @test inv(Decimal(false, 5, 1)) == Decimal(false, 2, -2)
    @test inv(Decimal(true, 4, -1)) == Decimal(true, 25, -1)
    @test inv(Decimal(true, 25, -1)) == Decimal(true, 4, -1)
    @test inv(Decimal(false, 123, -1)) == Decimal(false, 813008130081300813, -19) # 1/12.3 ≈ 0.08
end

@testset "Division" begin
    @test Decimal(0.2) / Decimal(0.1) == Decimal(2)
    @test Decimal(0.3) / Decimal(0.1) == Decimal(0,3,0)
    @test [Decimal(0.3) / Decimal(0.1), Decimal(0.6) / Decimal(0.1)] == [Decimal(0.3), Decimal(0.6)] ./ Decimal(0.1)
    @test [Decimal(0.3) / 0.1, Decimal(0.6) / 0.1] == [Decimal(0.3), Decimal(0.6)] ./ 0.1
end

end
