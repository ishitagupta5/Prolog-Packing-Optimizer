# Prolog-Packing-Optimizer
A Prolog program that solves a subset of the knapsack problem by computing all optimal subsets of items that fit within a given capacity using backtracking and recursion.

- The total weight does not exceed the bag's capacity.
- No additional item could be added without exceeding the capacity.
- Duplicates are handled using multiset semantics.

---

## Files

- `project3.pl` – Main Prolog script
- `input.txt` – Input file with packing scenarios (you create this)
- `output.txt` – Output file with selected optimal packings

---

## How to Run

Make sure SWI-Prolog is installed. Then run:

```bash
swipl project3.pl input.txt output.txt
```

## Input Format
Each non-empty line in the input file should be of the format:

```bash
<Capacity> [Item1, Weight1], [Item2, Weight2], ...
```
Example:
```bash
10 [apple,3], [book,4], [camera,6], [laptop,5]
7 [pen,1], [notebook,2], [bottle,4]
```

## Output Example
```bash
Capacity: 10 Items to pack: [[apple,3],[book,4],[camera,6],[laptop,5]] Pack this: [[[book,4],[laptop,5]]]
Capacity: 7 Items to pack: [[pen,1],[notebook,2],[bottle,4]] Pack this: [[[bottle,4],[notebook,2],[pen,1]]]
```
- Each input line gets its own output result.
- The packings are sorted and output in a uniform format.
- If no items fit, output is: Pack this: [[]]

## Logic Overview
- packing_list/3 finds all maximal subsets that fit within capacity.
- optimal_packing/3 ensures no better solution exists with leftover space.
- Multisets are supported using multiset_subtract/3.
- Pure backtracking and recursion — no loops or mutable state.

## Requirements
SWI-Prolog
