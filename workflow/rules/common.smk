##### Import libraries #####

import pandas as pd
from snakemake.utils import validate
import warnings

##### Import main config ####

configfile: "config/config_file.yaml"

## Validate config
validate(config, schema="../schemas/config.schema.yaml")

##### Import and validate sample layout #####

layout_csv = pd.read_csv(config["samples"]["path"])
validate(layout_csv, schema="../schemas/sample_layout.schema.yaml")
sample_layout = layout_csv.set_index("Sample_name")

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
    return ['results/df/selcoeffs.csv', 'results/0_qc/multiqc.html']
