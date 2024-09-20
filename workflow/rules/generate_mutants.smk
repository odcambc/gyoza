rule generate_mutants:
    params:
        layout = config["samples"],
        seqs = 'config/project_files/wt_seq.tsv', # Projet-specific file containing the wild-type sequences
        codon_table = f'config/project_files/{config["codon_table"]}' # Projet-specific file containing the genetic code
    output:
        'results/df/master_layout.csv.gz'
    resources:
        threads = 1,
        time = "00:01:00"
    log:
        notebook="logs/notebooks/generate_mutants.ipynb"
    conda:
        '../envs/jupyter_basic.yaml'
    notebook:
        'notebooks/generate_mutants.py.ipynb'