# SolitonDistribution.jl

The [Robust Soliton
Distribution](https://en.wikipedia.org/wiki/Soliton_distribution) in
Julia.

``` julia
] # enter package management mode
add Distributions # pdf, cdf
add SolitonDistribution
# backspace to exit package management

using SolitonDistribution
D = Soliton(600, 40, 1e-6)
rand(D, 100) # draw 100 samples from D

using Distributions
pdf(D, 40) # evaluate the pdf at 40
cdf(D, 40 # evaluate the cdf at 40

using Statistics
mean(D) # distribution mean
var(D) # distribution variance
```
