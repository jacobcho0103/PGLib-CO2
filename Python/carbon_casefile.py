def carbon_casefile(net, fuel_dict):
    """
    Assigns GCI values to generators in the pandapower network based on fuel type and emission type.
    """
    # Lookup tables for CO2 and CO2e emissions
    fuel_lookup = {  # CO2 GCI
        "ANT": 0.9095,  # Anthracite Coal
        "BIT": 0.8204,  # Bituminous Coal
        "Oil": 0.7001,  # Heavy Oil
        "GAS": 0.5173,
        "CCGT": 0.3621,  # Gas Combined Cycle
        "ICE": 0.6030,  # Internal Combustion Engine
        "Thermal": 0.6874,  # Thermal Power (General)
        "NUC": 0.0,  # Nuclear Power
        "RE": 0.0,  # Renewable Energy
        "HYD": 0.0,  # Hydropower
        "N/A": 0.0  # Default case
    }

    fuel_lookup_co2e = {  # CO2 GCI + (CH4 GCI * 21) + (N2O GCI * 310)
        "ANT": 0.9143,  # Anthracite Coal
        "BIT": 0.8230,  # Bituminous Coal
        "Oil": 0.7018,  # Heavy Oil
        "GAS": 0.5177,
        "CCGT": 0.3625,  # Gas Combined Cycle
        "ICE": 0.6049,  # Internal Combustion Engine
        "Thermal": 0.6894,  # Thermal Power (General)
        "NUC": 0.0,  # Nuclear Power
        "RE": 0.0,  # Renewable Energy
        "HYD": 0.0,  # Hydropower
        "N/A": 0.0  # Default case
    }

    # Iterate over fuel_dict, assigning GCI values to the corresponding generators in pandapower
    for bus_id, info in fuel_dict.items():
        if "type" in info and "emissions" in info:
            lookup_table = fuel_lookup_co2e if info["emissions"] == "CO2e" else fuel_lookup
            
            # Find matching generators based on `bus` column in `net.gen`
            gen_mask = net.gen["bus"] == bus_id
            net.gen.loc[gen_mask, "GCI"] = lookup_table.get(info["type"], 0.0)  # Assign GCI value safely

def fuel_dict_generation(net):
    """
    Initializes a fuel dictionary from the pandapower network, setting default fuel type and emissions for each generator bus.
    """
    fuel_dict = {}

    for bus_id in net.gen["bus"].unique():  # Extract unique generator bus IDs
        fuel_dict[bus_id] = {"type": "N/A", "emissions": "CO2"}  # Default values

    return fuel_dict
