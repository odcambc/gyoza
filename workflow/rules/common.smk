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

##### Validate TSV file containing WT DNA sequences #####
wtseqs = pd.read_csv(config["samples"]["wt"], sep='\t')
validate(wtseqs, schema="../schemas/wt_seqs.schema.yaml")

##### Validate codon table #####
codon_table = pd.read_csv(config["codon"]["table"], header=0)
validate(codon_table, schema="../schemas/codon_table.schema.yaml")

##### Select samples to process #####

samples = sample_layout.sort_index().index

if config["samples"]["selection"] != "all":
    selection = [x for x in config["samples"]["selection"] if x in samples]
    if len(selection) == 0:
        raise Exception("Error.. None of the samples you specified for processing feature in the sample layout.")
    elif len(selection) != len(config["samples"]["selection"]):
        statement = "Warning... at least one sample was misspelled when selecting samples to process in the config file\nWill continue with only the correctly spelled samples."
        warnings.warn(statement)
    else:
        samples = selection

##### Specify final target #####

def get_target():
    return ['results/df/selcoeffs.csv', 'results/0_qc/multiqc.html']
