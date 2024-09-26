# Snakemake workflow: Analysis of DMS data

[![Snakemake](https://img.shields.io/badge/snakemake-≥8.20.3-brightgreen.svg)](https://snakemake.github.io)
[![GitHub actions status](https://github.com/durr1602/DMS_analysis_snakemake/workflows/Tests/badge.svg?branch=main)](https://github.com/durr1602/DMS_analysis_snakemake/actions?query=branch%3Amain+workflow%3ATests)


A Snakemake workflow to analyze demultiplexed sequencing data of a DMS experiment, produce diagnostics plots and generate a dataframe of selection coefficients.

## Installation

1. Use `git clone` to clone this repository
2. a) If you are on a machine with `conda`, install snakemake in a virtual environment with the following lines (or equivalent):
```
mamba create -c conda-forge -c bioconda -n DMS-snake snakemake
mamba activate DMS-snake
```
2. b) If you are on a machine without `conda` (e.g. DRAC servers), create a virtual environment with `snakemake`, `pandas` and the plugin mentioned in step 3:

*work in progress*
```
module load python/3.12
module load scipy-stack
```
Once we make sure it works, we'll pip freeze the requirements and push it on this repo.

3. Intall plugin to run the workflow on HPC:
```
pip install snakemake-executor-plugin-cluster-generic
```
[Plugin documentation](https://github.com/jdblischak/smk-simple-slurm/tree/main)

4. Change file permissions to be able to run the plugin
```
chmod +x profile/status-sacct.sh
```
## Usage

### Prepare files and edit config
1. **IMPORTANT**: Read the [config documentation](config/README.md) and **edit the main config**.

### Check pipeline
2. (recommended) Perform a dry run using: `snakemake -n`

This step is strongly recommended. It will make sure the prepared workflow does not contain any error and will display the rules (steps) that need to be run in order to reach the specified target(s) (default value for the target is the dataframe of selection coefficients, which is produced during the very last step of the workflow). For the dry run or the actual run, you can decide to run the workflow only until a certain file is generated or rule is completed, using the `--until` flag in the snakemake command line, for example: `snakemake -n --until stats`

### Run pipeline
3. Running the workflow with `conda`

    a) Locally (on the server): `snakemake --cores 4 --use-conda` (recommended only for small steps, with the --cores flag indicating the max number of CPUs to use in parallel).
    
    b) **or** send to SLURM (1 job per rule per sample): `snakemake --profile profile --sdm conda` (all parameters are specified in the [config file](profile/config.v8+.yaml), jobs wait in the queue until the resources are allocated. For example, if you're allowed 40 CPUs, only 4 jobs at 10 CPUs each will be able to run at once. Once those jobs are completed, the next ones in the queue will automatically start.

4. Running the workflow inside a container (needs singularity/apptainer). In this case, the container will first be created, then conda envs will be created for each rule inside the container.

    a) Locally: does not work for now
    
    b) Send to SLURM (1 job per rule per sample): `snakemake --profile profile --sdm conda apptainer` (see comment about resource allocation above).

Fore more info on cluster execution: read the doc on [smk-cluster-generic plugin](https://github.com/jdblischak/smk-simple-slurm/tree/main)

**Important** If snakemake is launched directly from the command line, the process will be output to the terminal. Exiting with `<Ctrl+C>` is currently interpreted (as specified in the [config file](profile/config.v8+.yaml)) as cancelling all submitted jobs (`scancel`). To launch the pipeline and ensure that it continues to run in the background even when the terminal is closed, one should use [tmux](https://github.com/tmux/tmux/wiki/Getting-Started). This tool should be installed on servers. Follow the steps:
1. Type `tmux new -s snakes` to launch a new tmux session
2. Activate the conda env with `mamba activate DMS-snake` or `conda activate DMS-snake`
3. Navigate to the Snakefile directory and launch the pipeline with `snakemake --profile profile`
4. To close (detach) the session, type `<Ctrl+b>`, then `<d>`. You should see the message: `[detached (from session snakes)]`
5. To reconnect (attach) to the session, for example from a different machine: `tmux attach -t snakes`. You can also see existing sessions with `tmux ls`.
6. To close the session when everything is finished, type `<Ctrl+b>`, then `<:>`, then `kill-session` and finally `<Enter>`.

### Edit pipeline
One can manually edit the [Snakefile](workflow/Snakefile) and/or the rules (.smk files in rules folder) to edit the main steps of the pipeline. This should not be required to run the standard pipeline and should be done only when the workflow itself needs to be modified.
    
**Editing template jupyter notebooks** is tricky to do manually because the paths and kernel are not shared between platforms. Thankfully, there is a snakemake command that allows interactive editing of any template notebook, using any output file (from the notebook) as argument. The following example will generate URLs to open `jupyter`, in which we can edit the process_read_counts notebook that outputs the upset_plot.svg file, as specified in the Snakefile.

```
snakemake --use-conda --cores 1 --edit-notebook ../results/graphs/upset_plot.svg
```

**Careful**, to make sure you can open the generated URL, open a SSH tunnel between your local machine and the server by running the following command from a local terminal:
```  
ssh -L 8888:localhost:8888 <USER>@<ADRESS>
```
(adapt port if necessary, 8888 or 8889, should match what is featured in the URL generated by snakemake/jupyter)

The command simply opens a terminal on the server, but now you can copy-paste the URL in your local browser.
    
You can then open the notebook, run it (kernel and paths taken care of) and save it once the modifications have been done. Then click on "Close notebook" and finally "Shut down" on the main jupyter dashboard. The quitting and saving should be displayed on the initial server's terminal (the one from which the snakemake command was run). You'll also notice that the size of the template notebook file could be smaller, because outputs are automatically flushed out. To retrieve a notebook with outputs (for future HTML export for example), locate the notebook in the appropriate folder once the pipeline has run (path specified in the log directive of the Snakefile rule).

## Issues / work in progress

* Portability / installation on DRAC servers
* Local execution with apptainer integration does not currently work, potentially because of filesystem usage ("Assuming unrestricted shared filesystem usage", but it also states that when running it successfully with --use-conda...)