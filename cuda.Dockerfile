FROM nvidia/cuda:12.5.1-cudnn-devel-ubuntu22.04

ENV LD_LIBRARY_PATH /usr/local/cuda/lib64/stubs/:/usr/lib/x86_64-linux-gnu:/usr/local/cuda-12.2/compat/:/usr/local/cuda-12.2/targets/x86_64-linux/lib/stubs:$LD_LIBRARY_PATH
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES video,compute,utility
RUN nvidia-smi  

WORKDIR /cake
COPY . .
RUN apt update && \
    apt install libssl-dev openssl curl pkg-config -y && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ENV PATH="/root/.cargo/bin:${PATH}"
RUN cargo build --release --features cuda

EXPOSE 8080
CMD ["cake-cli", "--topology","topology.yaml"]
