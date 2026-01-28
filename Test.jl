############################################################
# Test.jl — Simulation + DP + Fancy Plots (FIXED)
############################################################

########################
# 0. PACKAGES
########################

using Random
using Statistics
using LinearAlgebra
using Plots
using LaTeXStrings
using Distributions

gr()
default(fontfamily="Computer Modern", linewidth=2, framestyle=:box)

########################
# 1. SET SEED
########################

Random.seed!(1234)

########################
# 2. SIMULATE AR(1)
########################

function simulate_ar1(T, ρ, σ; x0 = 0.0)
    x = zeros(T)
    x[1] = x0
    for t in 2:T
        x[t] = ρ * x[t-1] + σ * randn()
    end
    return x
end

T  = 300
ρ  = 0.95
σ  = 0.1

y = simulate_ar1(T, ρ, σ)

println("AR(1) moments:")
println("Mean = ", mean(y))
println("Std  = ", std(y))

########################
# 3. TIME SERIES PLOT
########################

p_ts = plot(
    y,
    xlabel="Time",
    ylabel=L"y_t",
    title="Simulated AR(1) Process",
    color=:darkblue,
    legend=false
)

########################
# 4. HISTOGRAM + NORMAL
########################

xgrid = range(minimum(y), maximum(y), length=400)
normal_pdf = pdf.(Normal(mean(y), std(y)), xgrid)

p_dist = histogram(
    y,
    bins=30,
    normalize=true,
    alpha=0.5,
    label="Simulation",
    title="Distribution of y"
)

plot!(
    p_dist,
    xgrid,
    normal_pdf,
    linewidth=3,
    label="Normal approximation",
    color=:red
)

########################
# 5. VALUE FUNCTION ITERATION (FIXED)
########################

function value_function_iteration(β, grid)
    V  = zeros(length(grid))
    Vn = similar(V)

    tol  = 1e-6
    diff = Inf

    while diff > tol
        for (i, k) in enumerate(grid)
            c = max.(k .- grid, eps())   # ← FIX
            Vn[i] = maximum(log.(c) .+ β .* V)
        end
        diff = maximum(abs.(Vn .- V))
        V .= Vn
    end

    return V
end

grid = range(0.1, 10.0, length=200)
β    = 0.95

V = value_function_iteration(β, grid)

########################
# 6. VALUE FUNCTION PLOT
########################

p_v = plot(
    grid,
    V,
    xlabel=L"k",
    ylabel=L"V(k)",
    title="Value Function",
    linewidth=3,
    color=:black,
    legend=false
)

########################
# 7. COMBINE PLOTS
########################

plot(
    p_ts,
    p_dist,
    p_v,
    layout=(3,1),
    size=(800, 900)
)

############################################################
# END
############################################################

