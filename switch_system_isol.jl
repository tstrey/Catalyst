using ModelingToolkit
using Catalyst
using DifferentialEquations
using Plots

@variables t 
@parameters k_on switch_time k_off
@species A(t) B(t)

rxs = [(@reaction k_on, A --> B), (@reaction k_off, B --> A)]
discrete_events = (t == switch_time) => [k_on ~ 0.0]

u0 = [:A => 10.0, :B => 0.0]
tspan = (0.0, 4.0)
p = [k_on => 100.0, switch_time => 2.0, k_off => 10.0]
@named osys = ReactionSystem(rxs, t, [A, B], [k_on, k_off, switch_time]; discrete_events)

oprob = ODEProblem(osys, u0, tspan, p)
sol = solve(oprob, Tsit5(); tstops = 2.0)

plot(sol)
