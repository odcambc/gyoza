rule stats:
    input:
        cutadapt_logs = expand(rules.cutadapt.log, sample=samples),
        pandaseq_logs = expand(rules.pandaseq.log, sample=samples),
        vsearch_logs = expand(rules.vsearch.log, sample=samples)
    output:
        'results/read_stats.csv'
    resources:
        threads = 1,
        time = "00:01:00"
    conda:
        'envs/jupyter_basic.yaml'
    script:
        'scripts/get_read_stats.py'