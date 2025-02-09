FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

# Set up environment variables
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /workspace

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-venv git \
    libgl1 libglib2.0-0 && \
    rm -rf /var/lib/apt/lists/*

# Clone the user's forked repository
RUN git clone https://github.com/DoubtfulTurnip/SUPIR.git /workspace/SUPIR
WORKDIR /workspace/SUPIR

# Ensure requirements.txt is available before installing dependencies
RUN if [ ! -f requirements.txt ]; then echo "requirements.txt not found!"; exit 1; fi

# Set up a virtual environment and install dependencies
RUN python3 -m venv venv && \
    . venv/bin/activate && \
    pip install --upgrade pip && \
    pip install --no-cache-dir -r /workspace/SUPIR/requirements.txt

# Create models directory
RUN mkdir -p /workspace/SUPIR/models

# Copy script to download models
COPY download_models.sh /workspace/SUPIR/download_models.sh
RUN chmod +x /workspace/SUPIR/download_models.sh

# Download models
RUN /workspace/SUPIR/download_models.sh

# Expose the port for the web UI
EXPOSE 6688

# Set up entrypoint for running the Web UI
CMD ["/bin/bash", "-c", ". venv/bin/activate && python gradio_demo.py --ip 0.0.0.0 --port 6688 --use_image_slider --loading_half_params --load_8bit_llava --use_tile_vae --log_history"]
