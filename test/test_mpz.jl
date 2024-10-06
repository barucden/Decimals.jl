using Decimals
using Test

@testset "MPZ" begin
    @testset "isdivisible" begin
        @test Decimals.mpz_isdivisible(BigInt(10), 5)
        @test !Decimals.mpz_isdivisible(BigInt(10), 3)
    end

    @testset "divexact" begin
        @test Decimals.mpz_divexact(BigInt(10), 5) == BigInt(2)
    end
end
