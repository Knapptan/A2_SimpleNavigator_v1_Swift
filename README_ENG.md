
# Simple Navigator

## Project Description
Simple Navigator is an application for working with graphs that allows you to implement basic graph algorithms, including graph traversal, shortest path search, minimum spanning tree construction, and solving the traveling salesman problem.

## Table of Contents
1. Introduction
2. Historical Background
3. Graph Description
4. Project Functionality
5. Launch Instructions
6. Algorithms
   6.1. Depth-First and Breadth-First Graph Traversal
   6.2. Shortest Path Search
   6.3. Minimum Spanning Tree
   6.4. Traveling Salesman Problem
7. Console Interface

## Introduction
Graphs are one of the fundamental data structures in programming. They are used in various fields such as road modeling, social network connections, electrical circuits, and more.

In this project, you will implement a library for working with graphs, including algorithms for pathfinding, minimum spanning trees, and solving the traveling salesman problem.

## Historical Background
The first step in creating graph theory was solving the problem of the Seven Bridges of Königsberg, proposed by Leonhard Euler in 1736. This laid the foundation for the development of graph theory, which is widely used today.

## Graph Description
A graph is a set of vertices and edges connecting these vertices. The project includes the following types of graphs:
- **Undirected Graph** — edges have no direction.
- **Directed Graph** — edges have a direction (arcs).
- **Weighted Graph** — edges have a numerical weight.

## Project Functionality
The project includes the implementation of the following features:
- Loading a graph from a file in adjacency matrix format.
- Exporting the graph to Graphviz (DOT) format.
- Depth-First Search (DFS) and Breadth-First Search (BFS).
- Shortest path search.
- Minimum spanning tree construction.
- Solving the traveling salesman problem.

## Launch Instructions
### Clone the repository:
```sh
git clone https://github.com/username/simple-navigator.git
cd simple-navigator
```

### Build the project:
Use the Makefile to build the project:
```sh
make all
```

### Run the tests:
```sh
make test
```

## Algorithms
### Depth-First and Breadth-First Graph Traversal
Methods for performing graph traversal:
- **DFS (Depth-First Search)** — depth-first traversal.
- **BFS (Breadth-First Search)** — breadth-first traversal.

### Shortest Path Search
Algorithms for finding the shortest path between graph vertices:
- **Dijkstra’s Algorithm**
- **Floyd-Warshall Algorithm**

### Minimum Spanning Tree
Methods for constructing a minimum spanning tree:
- **Kruskal’s Algorithm**
- **Prim’s Algorithm**

### Traveling Salesman Problem
Implementation of the traveling salesman problem using the following methods:
- **Greedy Algorithm**
- **Brute Force Method**

## Console Interface
The application provides a console interface for user interaction. Key commands include:
- `load [filename]` — load a graph from a file.
- `export [filename]` — export the graph to DOT format.
- `dfs [start_node]` — depth-first traversal.
- `bfs [start_node]` — breadth-first traversal.
- `shortest_path [start] [end]` — find the shortest path.
