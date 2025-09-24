function carbon_casefile(file, fuel_dict)
    carbon_casefile(file, fuel_dict)
end

function carbon_casefile(file, fuel_dict)
    # Lookup tables for CO2 and CO2e emissions
    fuel_lookup = Dict( #CO2 GCI
        "ANT" => 0.9095, #Anthracite Coal
        "BIT" => 0.8204, #Bituminous Coal
        "Oil" => 0.7001, #Heavy Oil
        "GAS" => 0.5173,
        "CCGT" => 0.3621, #Gas Combined Cycle
        "ICE" => 0.6030, #Internal Combustion Engine
        "Thermal" => 0.6874, #Thermal Power (General)
        "NUC" => 0.0, #Nuclear Power
        "RE" => 0.0, #Renewable Energy
        "HYD" => 0.0, #Hydropower
        "N/A" => 0.0  # Ensure "N/A" exists
    )

    fuel_lookup_co2e = Dict( #CO2 GCI + (CH4 GCI * 21) + (N2O GCI * 310)
        "ANT" => 0.9143, #Anthracite Coal
        "BIT" => 0.8230, #Bituminous Coal
        "Oil" => 0.7018, #Heavy Oil
        "GAS" => 0.5177,
        "CCGT" => 0.3625, #Gas Combined Cycle
        "ICE" => 0.6049, #Internal Combustion Engine
        "Thermal" => 0.6894, #Thermal Power (General)
        "NUC" => 0.0, #Nuclear Power
        "RE" => 0.0, #Renewable Energy
        "HYD" => 0.0, #Hydropower
        "N/A" => 0.0  # Ensure "N/A" exists
    )

    for (bus_id, info) in fuel_dict
        # Check if both "type" and "emissions" exist before accessing them
        if haskey(info, "type") && haskey(info, "emissions")
            # Find generator IDs that match the given bus number
            matching_gen_ids = [string(gen_id) for (gen_id, gen_data) in file["gen"] if get(gen_data, "gen_bus", -1) == bus_id]

            # Determine the correct lookup table
            lookup_table = info["emissions"] == "CO2e" ? fuel_lookup_co2e : fuel_lookup

            # Assign GCI values to all matching generators
            for gen_id in matching_gen_ids
                file["gen"][gen_id]["GCI"] = get(lookup_table, info["type"], 0.0)  # Default to 0.0 if type not found
            end
        end
    end
end


function fuel_dict_generation(file)
    fuel_dict_generation(file)
end

function fuel_dict_generation(file)
    fuel_dict = Dict{Int, Dict{String, String}}()  # Initialize an empty dictionary

    for (_, gen_data) in file["gen"]  # Iterate over generator data
        gen_bus = get(gen_data, "gen_bus", nothing)  # Safely get "gen_bus"
        if gen_bus !== nothing && !haskey(fuel_dict, gen_bus)  # Ensure "gen_bus" exists and is not already added
            fuel_dict[gen_bus] = Dict("type" => "N/A", "emissions" => "CO2")  # Assign default values
        end
    end
    return fuel_dict
end
