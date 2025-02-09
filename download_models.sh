#!/bin/bash

MODEL_DIR="/workspace/SUPIR/models"

# Function to check if a model directory contains files
check_and_download() {
    local model_name=$1
    local target_dir="$MODEL_DIR/$2"
    local hf_model_path=$3

    if [ -d "$target_dir" ] && [ "$(ls -A "$target_dir")" ]; then
        echo "Model '$model_name' already exists in '$target_dir'. Skipping download."
    else
        echo "Downloading '$model_name' to '$target_dir'..."
        mkdir -p "$target_dir"
        huggingface-cli download "$hf_model_path" --local-dir "$target_dir"
    fi
}

# Function to check and download files from Hugging Face
check_and_download_file() {
    local file_name=$1
    local target_file="$MODEL_DIR/$2/$file_name"
    local hf_file_url=$3

    if [ -f "$target_file" ]; then
        echo "File '$file_name' already exists in '$MODEL_DIR/$2'. Skipping download."
    else
        echo "Downloading '$file_name' to '$MODEL_DIR/$2'..."
        mkdir -p "$MODEL_DIR/$2"
        wget -O "$target_file" "$hf_file_url"
    fi
}

# Check and download models
check_and_download "LLaVA CLIP" "LLaVA CLIP" "openai/clip-vit-large-patch14-336"
check_and_download "LLaVA v1.5 13B" "LLaVA v1.5 13B" "liuhaotian/llava-v1.5-13b"
check_and_download "LLAVA v1.5 7B" "LLAVA v1.5 7B" "liuhaotian/llava-v1.5-7b"
check_and_download "Juggernaut-X-v10" "Optional" "RunDiffusion/Juggernaut-X-v10"
check_and_download "SDXL base 1.0" "SDXL base 1.0_0.9vae" "stabilityai/stable-diffusion-xl-base-1.0"
check_and_download "SDXL CLIP Encoder-1" "SDXL CLIP Encoder-1" "openai/clip-vit-large-patch14"
check_and_download "SDXL CLIP Encoder-2" "SDXL CLIP Encoder-2" "laion/CLIP-ViT-bigG-14-laion2B-39B-b160k"

# Check and download Supir models
check_and_download_file "SUPIR-v0F.ckpt" "Supir-Models/SUPIR-v0F" "https://huggingface.co/ashleykleynhans/SUPIR/resolve/main/SUPIR-v0F.ckpt"
check_and_download_file "SUPIR-v0Q.ckpt" "Supir-Models/SUPIR-v0Q" "https://huggingface.co/ashleykleynhans/SUPIR/resolve/main/SUPIR-v0Q.ckpt"

echo "All models checked and downloaded if necessary!"
