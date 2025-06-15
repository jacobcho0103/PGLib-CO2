# Power Grid Lib - CO2

This repository provides a carbon utilization framework for the [Benchmarks for Validation of Emerging Power System Algorithms](https://power-grid-lib.github.io/) from the IEEE PES Task Force. It implements carbon-aware power system modeling using **pandapower** in Python and **PowerModels.jl** in Julia. The objective is to integrate carbon constraints into power system case files by assigning specific fuel types and their associated emissions to generator buses. This approach enables the evaluation of power system operations with respect to environmental impact considerations.

## Repository Structure

This repository includes implementations in both **Python (using pandapower)** and **Julia (using PowerModels.jl)**. Each section below explains the respective implementations in detail.

## Carbon Emission Types

This implementation allows us to deal with two types of carbon emissions:
- **CO2 (Carbon Dioxide):** A primary greenhouse gas emitted through fossil fuel combustion.
- **CO2e (Carbon Dioxide Equivalent):** A metric that includes CO2 along with other greenhouse gases such as **CH4 (Methane)** and **N2O (Nitrous Oxide)**, providing a comprehensive measure of total emissions impact.

## Python Implementation (Pandapower)

### What is Pandapower?
[Pandapower](https://github.com/e2nIEE/pandapower) is an open-source Python library for power system modeling, analysis, and optimization. It is built on **pandas** and **NumPy**, providing a user-friendly interface for working with electrical networks.

### Implementation Details

#### Import Required Libraries
```python
# Import required libraries
import pandapower as pp
import pandapower.networks as pn
import pandas as pd
```

#### Load the Pandapower Network
We use the IEEE 30-bus test system as an example. The network is loaded using the built-in function `case30()`.
```python
# Load the pandapower network (assumed to be in MATPOWER format)
net = pn.case30() 
```

#### Generate the Fuel Dictionary
A fuel dictionary is created to map generator buses to their respective fuel types and emissions.
```python
# Generate the fuel dictionary
fuel_dict = fuel_dict_generation(net)

# Assign fuel types and emissions to specific generator buses
fuel_dict[1] = {"type": "GAS", "emissions": "CO2e"}
fuel_dict[12] = {"type": "ANT", "emissions": "CO2"}
fuel_dict[22] = {"type": "BIT", "emissions": "CO2"}
```

#### Apply Carbon Constraints
The function `carbon_casefile()` is used to integrate carbon constraints into the power system model.
```python
# Apply carbon constraints to the pandapower network
carbon_casefile(net, fuel_dict)
```

---

## Julia Implementation (PowerModels.jl)

### What is PowerModels.jl?
[PowerModels.jl](https://github.com/lanl-ansi/PowerModels.jl) is an optimization-based power system analysis package written in **Julia**. It enables the solution of optimal power flow (OPF), unit commitment (UC), and other power system optimization problems, leveraging mathematical programming techniques.

### Implementation Details

#### Import Required Libraries
```julia
# Import required libraries
using PowerModels
```

#### Load the PowerModels Network
We use the **IEEE 118-bus** test system as an example. The case file is assumed to be in **MATPOWER format**.
```julia
# Load the Powermodels.jl network (assumed to be in MATPOWER format)
net = PowerModels.parse_file("case118.m")
```

#### Generate the Fuel Dictionary
A fuel dictionary is created to map generator buses to their respective fuel types and emissions.
```julia
# Generate the fuel dictionary
fuel_dict = fuel_dict_generation(net)

# Assign fuel types and emissions to specific generator buses
fuel_dict[6] = Dict("type" => "GAS", "emissions" => "CO2e")
fuel_dict[55] = Dict("type" => "ANT", "emissions" => "CO2")
fuel_dict[110] = Dict("type" => "BIT", "emissions" => "CO2")
```

#### Apply Carbon Constraints
The function `carbon_casefile()` is used to integrate carbon constraints into the power system model.
```julia
# Apply carbon constraints to the PowerModels network
carbon_casefile(net, fuel_dict)
```

## Summary
This repository demonstrates how to incorporate carbon-aware constraints into power system networks using two popular frameworks:
- **Python (Pandapower):** Best suited for power flow analysis and network modeling with an intuitive API.
- **Julia (PowerModels.jl):** Designed for power system optimization, capable of solving complex optimization problems efficiently.

By utilizing **fuel type assignments and carbon constraints**, this implementation enables more environmentally conscious power system planning and operations.
