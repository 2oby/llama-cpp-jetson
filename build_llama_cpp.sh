#!/bin/bash
set -e

echo "🔧 [1/7] Checking for 32GB swap file at /swapfile..."

if ! swapon --show | grep -q "/swapfile"; then
    echo "⚠️  No swapfile active — creating 32GB swap at /swapfile..."
    sudo swapoff -a || true
    sudo fallocate -l 32G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    grep -q "/swapfile" /etc/fstab || echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
    sudo sysctl vm.swappiness=60
else
    echo "✅ Swapfile already exists and is active."
fi

echo "📊 Current swap status:"
swapon --show

echo "📦 [2/7] Installing minimal build dependencies..."
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    build-essential cmake git curl ca-certificates

echo "🔌 [3/7] Stopping graphical desktop to free memory..."
sudo systemctl stop gdm3 || sudo systemctl stop lightdm || sudo systemctl stop graphical.target
sudo systemctl start multi-user.target

echo "🧠 [4/7] Exporting memory-safe build flags..."
export MAKEFLAGS="-j1"
export GOMAXPROCS=1
export LDFLAGS="-Wl,--no-keep-memory -Wl,--reduce-memory-overheads"

echo "📥 [5/7] Cloning llama.cpp..."
rm -rf llama.cpp
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
git checkout master  # Latest development version with all recent fixes

echo "🛠️ [6/7] Configuring CMake for CUDA compute capability 8.7..."
mkdir -p build && cd build
cmake .. \
  -DCMAKE_CUDA_ARCHITECTURES=87 \
  -DCMAKE_BUILD_TYPE=Release \
  -DGGML_CUDA=ON \
  -DLLAMA_CURL=OFF  # Disable CURL to bypass missing libcurl4-openssl-dev

echo "⚙️ [7/7] Building all targets with CUDA (GGML_CUDA) and silencing array bounds warnings..."
make all GGML_CUDA=1 -j1 CFLAGS="-Wno-array-bounds"

echo "📂 Copying binaries to output folder..."
cd ../..
mkdir -p bin models
rm -rf bin/*  # Clear old binaries to avoid confusion
cp -v llama.cpp/build/bin/* bin/ 2>/dev/null || echo "Warning: No binaries found in llama.cpp/build/bin/"

echo "📋 Listing copied binaries..."
ls -l bin/

echo "✅ Build complete!"
echo "📍 Binaries are now in: ./bin/"
echo "📥 Place your GGUF model in ./models or use a Dockerfile to download it."
