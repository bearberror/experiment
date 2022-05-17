using CSV
using DataFrames
using Gadfly
using MLJ
using StatsPlots
using StatsBase
using Query
using Chain

##
data = CSV.read("./kaggle-dataset/diabetes.csv", DataFrame)
coerce!(data, :Outcome => OrderedFactor)

## EDA
Gadfly.plot(data, x="Pregnancies", color="Outcome", Geom.histogram)
Gadfly.plot(data, x=:BMI, Geom.histogram)
Gadfly.plot(data, x=:Insulin, Geom.histogram)
Gadfly.plot(data, x=:SkinThickness, Geom.histogram)
Gadfly.plot(data, x=:BMI, y=:Glucose, color=:Outcome, Geom.point)
@df data corrplot([:Glucose :BloodPressure :Insulin :BMI :SkinThickness :Age])

## data cleaning
@chain data begin
  subset!(:Glucose => x -> x .> 0)
  subset!(:BMI => x -> x .> 0)
  subset!(:BloodPressure => x -> x .> 0)
end

replace!(data.SkinThickness, 0 => floor(mean(data.SkinThickness)))
replace!(data.Insulin, 0 => floor(mean(data.Insulin)))
##

