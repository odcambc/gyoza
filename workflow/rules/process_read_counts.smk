rule process_read_counts:
    input:
        rules.parse_fasta.output.read_counts
    params:
        sample_attributes = config['samples']['attributes'],
        exp_rc_per_var = config['rc_aims']['exp_rc_per_var'],
        rc_threshold = config['filter']['rc_threshold'],
        nb_gen = config['samples']['generations']
    output:
        selcoeffs = 'results/df/selcoeffs.csv',
        hist_plot = 'results/graphs/hist_plot.svg',
        upset_plot = 'results/graphs/upset_plot.svg',
        rc_var_plot = 'results/graphs/rc_var_plot.svg',
        timepoints_plot = 'results/graphs/timepoints_plot.svg',
        replicates_plot = 'results/graphs/replicates_plot.svg',
        scoeff_violin_plot = 'results/graphs/scoeff_violin_plot.svg'
    resources:
        mem_gb = 2, # > default to read csv.gz
        threads = 1,
        time = "00:02:00"
    log:
        notebook="logs/notebooks/process_read_counts.ipynb"
    conda:
        '../envs/jupyter_plotting.yaml'
    notebook:
        'notebooks/process_read_counts.py.ipynb'