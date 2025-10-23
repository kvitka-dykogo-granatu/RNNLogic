#!/bin/bash

echo "=== COMPILING RNNLOGIC MINER ==="

# Change to miner directory
cd miner

# Compile the miner
echo "Compiling with g++..."
g++ -std=c++11 -O3 -o rnnlogic main.cpp rnnlogic.cpp -lpthread

if [ $? -eq 0 ]; then
    echo "Compilation successful!"
    echo ""
    echo "=== RUNNING MINER ON KINSHIP DATASET ==="
    echo "This will trace the concrete example: (person15, term7, person55)"
    echo ""
    
    # Run the miner with detailed output
    ./rnnlogic -data-path ../data/kinship -output-file ../data/kinship/mined_rules_detailed.txt -max-length 2 -threads 1 -iterations 1 -lr 0.01 -temp 100.0 -top-k 10 -top-n 100 -top-n-out 50
    
    echo ""
    echo "=== MINING COMPLETE ==="
    echo "Check the output file: ../data/kinship/mined_rules_detailed.txt"
    echo "The detailed trace shows how the miner processes the concrete example."
else
    echo "Compilation failed!"
    exit 1
fi
