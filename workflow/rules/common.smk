##### Import libraries #####

import pandas as pd
import warnings

##### Import sample layout #####

sample_layout = pd.read_csv(config["samples"]["path"], dtype={"Sample_name": str}).set_index("Sample_name")

##### Select samples to process #####

samples = sample_layout.sort_index().index

if config["samples"]["selection"] != "all":
    selection = [x for x in config["samples"]["selection"]]
    if len(selection) == 0:
        raise Exception("Error with the selection of samples to process in the config file")
    elif len(selection) != len(config["samples"]["selection"]):
        warnings.warn("Warning... at least one sample was misspelled when selecting samples to process in the config file"+
        "\n...Will continue with only the correctly spelled samples"
        )
    else:
        samples = selection

##### Specify final target #####

def get_target():
    return 'results/df/selcoeffs.csv'