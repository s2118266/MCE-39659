using Pkg
Pkg.add(["Plots", "StatsPlots", "LaTeXStrings"])
using Plots, StatsPlots, LaTeXStrings
gr()   # clean, fast backend
x = range(-4, 4, length=500)
y = exp.(-0.5 .* x.^2) ./ sqrt(2π)

plot(
    x, y,
    linewidth=3,
    color=:navy,
    xlabel=L"x",
    ylabel=L"f(x)",
    title="Standard Normal Distribution",
    legend=false,
    grid=true
)
x = 1:100
μ = log.(x)
σ = 0.15

upper = μ .+ 2σ
lower = μ .- 2σ

plot(
    x, μ,
    linewidth=3,
    label="Mean",
    color=:black
)

plot!(
    x, upper,
    fillrange=lower,
    fillalpha=0.25,
    color=:blue,
    label="95% band"
)
x = range(0, 10, length=100)
y = range(0, 5, length=100)
z = [log(1 + xi + yi) for xi in x, yi in y]

heatmap(
    x, y, z,
    xlabel="Capital",
    ylabel="Shock",
    title="Value Function",
    color=:viridis
)
