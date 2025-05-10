# llama.cpp Binaries for NVIDIA Jetson Orin

This repository contains pre-built llama.cpp binaries optimized for the NVIDIA Jetson Orin platform.

## Build Information
- Build date: May 10, 2025
- Target platform: NVIDIA Jetson Orin
- CUDA version: 12.x
- llama.cpp version: Latest from main branch

## Binary Components

### Core Applications
- `bin/llama-cli` - Main command-line interface for text generation
- `bin/llama-server` - HTTP/WebSocket server for inference
- `bin/llama-quantize` - Tool for quantizing models to smaller sizes
- `bin/llama-perplexity` - Measure perplexity of a model on text
- `bin/llama-tokenize` - Convert text to and from token IDs

### Specialized Applications
- `bin/llama-bench` - Benchmarking tool for performance testing
- `bin/llama-gguf` - Utility for inspecting and modifying GGUF files
- `bin/llama-simple` - Minimal implementation for basic text generation
- `bin/llama-batched` - Implementation supporting batched processing
- `bin/llama-speculative` - Speculative decoding implementation

### Multimodal Tools
- `bin/llama-llava-cli` - CLI for vision-language models (LLAVA)
- `bin/llama-mtmd-cli` - Multimodal model interface
- `bin/llama-gemma3-cli` - Interface for Gemma 3 models
- `bin/llama-qwen2vl-cli` - Interface for Qwen2-VL models

### Utility Tools
- `bin/llama-gguf-split` - Tool for splitting large GGUF files
- `bin/llama-gguf-hash` - Tool for hashing GGUF files
- `bin/llama-embedding` - Generate embeddings from text

### Libraries
- `lib/libllama.so` - Core llama.cpp shared library
- `lib/libggml.so` - GGML tensor library
- `lib/libggml-base.so` - GGML base components
- `lib/libggml-cpu.so` - CPU-specific implementations
- `lib/libllava_shared.so` - LLAVA shared components
- `lib/libmtmd_shared.so` - Multimodal shared components

## Usage Examples

### Basic Text Generation
```bash
./bin/llama-cli -m /path/to/model.gguf -p "Write a short poem about AI:" -n 200
