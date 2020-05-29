# SolitonDistribution

A package implementing the [Robust Soliton
Distribution](https://en.wikipedia.org/wiki/Soliton_distribution) in
Julia.

``` julia
using Pkg
Pkg.add("StatsBase") # params
Pkg.add("Statistics") # quantile
Pkg.add("Distributions") # pdf, cdf
Pkg.add("https://github.com/severinson/SolitonDistribution")
using SolitonDistribution
D = Soliton(600, 40, 1e-6)
pdf(D, 40) # evaluate the pdf at 40
cdf(D, 40 # evaluate the cdf at 40
rand(D, 100) # draw 100 samples from D
```
