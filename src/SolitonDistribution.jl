module SolitonDistribution
export Soliton

using StatsBase, Statistics, Distributions

"""

Soliton(K::Integer, M::Integer, δ::Real, atol::Real=0) <: Distribution{Univariate, Discrete}

The Robust Soliton distribution of length K, with mode M (i.e., the
location of the robust component spike), and peeling process failure
probability δ. Degrees for which the PDF would be less than atol are
discarded.

Soliton distribution on Wikipedia:
https://en.wikipedia.org/wiki/Soliton_distribution

"""
struct Soliton <: DiscreteUnivariateDistribution
    K::Int64 # Number of input symbols
    M::Int64 # Location of the robust component spike
    δ::Float64 # Peeling process failure probability
    degrees::Vector{Int} # Degrees with non-zero probability
    CDF::Vector{Float64} # CDF evaluated at each element in degrees
    function Soliton(K::Integer, M::Integer, δ::Real, atol::Real=0)
        0 < K || throw(ArgumentError("Expected 0 < K, but got $K."))
        0 < δ < 1 || throw(ArgumentError("Expected 0 < δ < 1, but got $δ."))
        0 < M <= K || throw(ArgumentError("Expected 0 < M <= K, but got $M."))
        0 <= atol < 1 || throw(ArgumentError("Expected 0 <= atol < 1, but got $atol."))
        PDF = [τ(K, M, δ, i)+ρ(K, i) for i in 1:K]
        PDF ./= sum(PDF)
        degrees = [i for i in 1:K if PDF[i] > atol]
        CDF = cumsum([PDF[i] for i in degrees])
        CDF ./= CDF[end]
        new(K, M, δ, degrees, CDF)
    end
end

Base.show(io::IO, D::Soliton) = print(io, "Soliton(K=$(D.K), M=$(D.M), δ=$(D.δ))")

"""Robust component of the Soliton distribution."""
function τ(K::Integer, M::Integer, δ::Real, i::Integer)::Float64
    i <= K || throw(ArgumentError("Expected i <=K, but got $i."))
    R = K / M
    if i < M
        return 1 / (i * M)
    elseif i == M
        return log(R / δ) / M
    else # i <= K
        return 0.0
    end
end

"""Ideal component of the Soliton distribution."""
function ρ(K::Integer, i::Integer)::Float64
    i <= K || throw(ArgumentError("Expected i <=K, but got $i."))
    if i == 1
        return 1 / K
    else # i <= K
        return 1 / (i * (i - 1))
    end
end

StatsBase.params(Ω::Soliton) = (Ω.K, Ω.M, Ω.δ)

function Distributions.pdf(Ω::Soliton, i::Integer)::Float64
    j = searchsortedfirst(Ω.degrees, i)
    if j > length(Ω.degrees) || Ω.degrees[j] != i return 0.0 end
    rv = Ω.CDF[j]
    if j > 1 rv -= Ω.CDF[j-1] end
    return rv
end

function Distributions.cdf(Ω::Soliton, i::Integer)
    if i < Ω.degrees[1] return 0.0 end
    if i > Ω.degrees[end] return 1.0 end
    j = searchsortedfirst(Ω.degrees, i)
    if Ω.degrees[j] == i return Ω.CDF[j] end
    return Ω.CDF[j-1]
end

Statistics.mean(Ω::Soliton) = sum(i*pdf(Ω, i) for i in Ω.degrees)

function Statistics.quantile(Ω::Soliton, v::Real)::Int
    0 <= v <= 1 || throw(ArgumentError("Expected 0 <= v <= 1, but got $v."))
    j = searchsortedfirst(Ω.CDF, v)
    j = min(length(Ω.degrees), j)
    return Ω.degrees[j]
end

Base.minimum(Ω::Soliton) = 1
Base.maximum(Ω::Soliton) = Ω.K

end
