rule parse_fasta:
    input:
        fasta_files = expand(rules.vsearch.output, sample=samples),
        read_stats = rules.stats.output[0],
        expected_mutants = rules.generate_mutants.output[0]
    params:
        exp_rc_per_sample = config['rc_aims']['exp_rc_per_sample']
    output:
        read_counts = 'results/df/readcounts.csv.gz',
        unexp_rc_plot = 'results/graphs/unexp_rc_plot.svg',
        rc_filter_plot = 'results/graphs/rc_filter_plot.svg'
    resources:
        mem_gb = 2, # > default to read csv.gz
        threads = 1,
        time = "00:01:00"
    log:
        notebook="logs/notebooks/parse_fasta.ipynb"
    conda:
        '../envs/jupyter_plotting.yaml'
    notebook:
        'notebooks/parse_fasta.py.ipynb'