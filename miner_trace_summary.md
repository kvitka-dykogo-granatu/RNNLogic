# RNNLogic Miner Detailed Trace Summary

## Overview
This document summarizes the detailed trace of the RNNLogic miner processing the concrete example `(person15, term7, person55)` from the kinship dataset.

## Key Findings from the Trace

### 1. Data Loading Phase
```
=== KNOWLEDGE GRAPH DATA LOADING ===
  Entity: person15 -> ID: 0
  Entity: person55 -> ID: 54
  Relation: term7 -> ID: 0
  Loaded 104 entities
  Loaded 26 relations
  *** TARGET TRIPLET FOUND ***
  Triplet: person15 term7 person55 -> (0, 0, 54)
  This will be our concrete example for mining!
```

### 2. Adjacency List Construction
The miner builds adjacency lists showing all connections from each entity:
```
  Adjacency: person15 --term7--> person55
  Adjacency: person15 --term16--> person103
  Adjacency: person15 --term0--> person23
  ... (and more connections)
```

### 3. Rule Discovery Process
The trace shows the detailed path search algorithm:

#### Initial Search
```
=== PROCESSING TARGET TRIPLET ===
Thread 0: Processing triplet (person15, term7, person55) -> (0, 0, 54)
Searching for paths from person15 to person55 with max_length=2
```

#### Path Exploration
The algorithm explores all possible paths from person15 to person55:

```
[RULE_SEARCH] depth=0, from=person15, goal=person55, path=[]
[RULE_SEARCH] Exploring relation term7 from person15 (1 connections)
[RULE_SEARCH] Skipping removed triplet: person15 --term7--> person55
[RULE_SEARCH] Exploring relation term16 from person15 (5 connections)
[RULE_SEARCH] Following: person15 --term16--> person103
[RULE_SEARCH] depth=1, from=person103, goal=person55, path=[term16]
[RULE_SEARCH] Exploring relation term0 from person103 (2 connections)
[RULE_SEARCH] Following: person103 --term0--> person23
[RULE_SEARCH] depth=2, from=person23, goal=person55, path=[term16,term0]
[RULE_SEARCH] Max depth reached at person23
```

#### Rule Discovery
The algorithm finds several rules, including:
```
*** RULE FOUND *** depth=2, head=term7, body=[term16,term16]
```

This means: `term16(x,y) ∧ term16(y,z) → term7(x,z)`

### 4. Rule Quality Assessment
The miner evaluates each discovered rule using H-scores:

```
Found 2 rules for target triplet:
  Rule 1: term7 -> [term16,term16] (length=2)
  Rule 2: term7 -> [term0,term16] (length=2)
```

### 5. Weight Learning Process
The trace shows the learning process:
```
Learning Rule Weights | Progress: 0.312% | Loss: 0.058188
Learning Rule Weights | Progress: 0.624% | Loss: 0.058119
...
Learning Rule Weights | DONE! | Loss: 0.057762
```

### 6. Final Rule Output
The miner outputs the top rules with their H-scores:
```
0 6 16 0.0030879600748596    # term7 -> [term6,term16]
0 0 9 0.0020274485339988      # term7 -> [term0,term9]
0 7 9 0.0017779164067374     # term7 -> [term7,term9]
```

## Algorithm Insights

### Path Search Strategy
1. **Depth-First Search**: The algorithm uses recursive depth-first search
2. **Path Tracking**: Each path is stored as a sequence of relation IDs
3. **Goal Checking**: When the target entity is reached, a rule is created
4. **Depth Limiting**: Maximum depth prevents infinite loops

### Rule Quality Metrics
1. **H-Score**: Measures how well a rule predicts the target relation
2. **Weight Learning**: Rules get learnable weights through gradient descent
3. **Rule Ranking**: Rules are ranked by their H-scores

### Performance Optimizations
1. **Multi-threading**: Parallel processing of different triplets
2. **Adjacency Lists**: Fast graph traversal using pre-computed connections
3. **Rule Deduplication**: Automatic removal of duplicate rules

## Concrete Example Analysis

For the triplet `(person15, term7, person55)`:

1. **Input**: person15 --term7--> person55
2. **Goal**: Find paths from person15 to person55 using other relations
3. **Discovered Rules**:
   - `term16(x,y) ∧ term16(y,z) → term7(x,z)`
   - `term0(x,y) ∧ term16(y,z) → term7(x,z)`
4. **Quality**: Each rule gets an H-score based on how often it correctly predicts term7

## Key Code Functions Traced

1. **`KnowledgeGraph::read_data()`**: Loads entities, relations, and triplets
2. **`KnowledgeGraph::rule_search()`**: Recursive path finding algorithm
3. **`RuleMiner::search_thread()`**: Multi-threaded rule discovery
4. **`ReasoningPredictor::learn_thread()`**: Weight learning process
5. **`RuleGenerator::out_rules()`**: Final rule output

## Conclusion

The detailed trace shows exactly how the RNNLogic miner:
1. Loads and processes the knowledge graph
2. Discovers logical rules through path-based search
3. Evaluates rule quality using H-scores
4. Learns rule weights through gradient descent
5. Outputs the most promising rules

This demonstrates the sophisticated graph traversal and machine learning techniques used in automated rule discovery from knowledge graphs.
