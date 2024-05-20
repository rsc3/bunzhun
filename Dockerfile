FROM nvidia/cuda:12.1.0-devel-ubuntu22.04
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
ENV DEBIAN_FRONTEND="noninteractive"
RUN apt-get update

RUN apt-get install -y wget zlib1g && rm -rf /var/lib/apt/lists/*

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 

RUN ["/bin/bash", "-c", "source /root/miniconda3/etc/profile.d/conda.sh && \
conda activate && \
conda update -n base conda -y && \
conda update --all -y && \
conda create -n torchgpu jupyter matplotlib pandas scikit-learn -y && \
conda activate torchgpu && \
conda install jupyterlab pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia -y"]

RUN ["/bin/bash", "-c", "cat <(echo 'source /root/miniconda3/etc/profile.d/conda.sh') /root/.bashrc > /root/.newrc"]

RUN mv /root/.newrc /root/.bashrc && chmod 0644 /root/.bashrc
