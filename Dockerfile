FROM condaforge/mambaforge:latest
LABEL io.github.snakemake.containerized="true"
LABEL io.github.snakemake.conda_env_hash="2737dcf7d097fd8ed829a895ea4dc5b84c074e2177697ac4f4aeb3c39c477f92"

# Step 1: Retrieve conda environments

# Conda environment:
#   source: workflow/envs/cutadapt.yaml
#   prefix: /conda-envs/6e268855926f4445847951449a6b4113
#   channels:
#     - conda-forge
#     - bioconda
#     - defaults
#   dependencies:
#   - cutadapt=4.9
RUN mkdir -p /conda-envs/6e268855926f4445847951449a6b4113
COPY workflow/envs/cutadapt.yaml /conda-envs/6e268855926f4445847951449a6b4113/environment.yaml

# Conda environment:
#   source: workflow/envs/jupyter_basic.yaml
#   prefix: /conda-envs/938dd0caefd852e9346bb6f2985e58ad
#   channels:
#     - conda-forge
#     - defaults
#   dependencies:
#     - python=3.11
#     - jupyter=1.0
#     - jupyterlab_code_formatter=3.0.2
#     - ipykernel
#     - pandas>=2.2.2
#     - openpyxl>=3.1.5
#     - numpy>=2.1.0
RUN mkdir -p /conda-envs/938dd0caefd852e9346bb6f2985e58ad
COPY workflow/envs/jupyter_basic.yaml /conda-envs/938dd0caefd852e9346bb6f2985e58ad/environment.yaml

# Conda environment:
#   source: workflow/envs/jupyter_plotting.yaml
#   prefix: /conda-envs/ab5d48da9204bc83c873f29527aff7fa
#   channels:
#     - conda-forge
#     - defaults
#   dependencies:
#     - python=3.11
#     - jupyter=1.0
#     - jupyterlab_code_formatter=3.0.2
#     - ipykernel
#     - pandas>=2.2.2
#     - openpyxl>=3.1.5
#     - numpy>=2.1.0
#     - seaborn>=0.13.2
#     - upsetplot>=0.9
RUN mkdir -p /conda-envs/ab5d48da9204bc83c873f29527aff7fa
COPY workflow/envs/jupyter_plotting.yaml /conda-envs/ab5d48da9204bc83c873f29527aff7fa/environment.yaml

# Conda environment:
#   source: workflow/envs/pandaseq.yaml
#   prefix: /conda-envs/abc683d4960f0f28d14b5ccce74168b4
#   channels:
#     - conda-forge
#     - bioconda
#     - defaults
#   dependencies:
#   - pandaseq=2.11
RUN mkdir -p /conda-envs/abc683d4960f0f28d14b5ccce74168b4
COPY workflow/envs/pandaseq.yaml /conda-envs/abc683d4960f0f28d14b5ccce74168b4/environment.yaml

# Conda environment:
#   source: workflow/envs/vsearch.yaml
#   prefix: /conda-envs/45a148e3bf655109d36efa47ffc7a9f8
#   channels:
#     - conda-forge
#     - bioconda
#     - defaults
#   dependencies:
#   - vsearch=2.28.1
RUN mkdir -p /conda-envs/45a148e3bf655109d36efa47ffc7a9f8
COPY workflow/envs/vsearch.yaml /conda-envs/45a148e3bf655109d36efa47ffc7a9f8/environment.yaml

# Step 2: Generate conda environments

RUN mamba env create --prefix /conda-envs/6e268855926f4445847951449a6b4113 --file /conda-envs/6e268855926f4445847951449a6b4113/environment.yaml && \
    mamba env create --prefix /conda-envs/938dd0caefd852e9346bb6f2985e58ad --file /conda-envs/938dd0caefd852e9346bb6f2985e58ad/environment.yaml && \
    mamba env create --prefix /conda-envs/ab5d48da9204bc83c873f29527aff7fa --file /conda-envs/ab5d48da9204bc83c873f29527aff7fa/environment.yaml && \
    mamba env create --prefix /conda-envs/abc683d4960f0f28d14b5ccce74168b4 --file /conda-envs/abc683d4960f0f28d14b5ccce74168b4/environment.yaml && \
    mamba env create --prefix /conda-envs/45a148e3bf655109d36efa47ffc7a9f8 --file /conda-envs/45a148e3bf655109d36efa47ffc7a9f8/environment.yaml && \
    mamba clean --all -y
