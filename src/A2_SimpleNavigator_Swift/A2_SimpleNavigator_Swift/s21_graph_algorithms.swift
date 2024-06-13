//
//  s21_graph_algorithms.swift
//  A2_SimpleNavigator_Swift
//
//  Created by Anton Krivonozhenkov on 26.05.2024.
//

import Foundation

class GraphAlgorithms {
    
    // MARK: - PART 1
    
    // Поиск в глубину
    func depthFirstSearch(graph: Graph, startVertex: Int) -> [Int] {
        guard startVertex >= 0 && startVertex < graph.getVerticesCount() else {
            print("Error: Start vertex \(startVertex) is out of bounds.")
            return []
        }
        // Стек обработки
        var stack = Stack<Int>()
        // Посещенные вершины
        var visitedNodes = Set<Int>()
        // Последовательность посещения
        var orderOfVisit = [Int]()
        
        // Начальная инициализация DFS
        stack.push(startVertex)
        
        while !stack.isEmpty() {
            if let currentVertex = stack.pop() {
                if !visitedNodes.contains(currentVertex){
                    visitedNodes.insert(currentVertex)
                    orderOfVisit.append(currentVertex)
                    
                    for neighbor in (0..<graph.getVerticesCount()).reversed() {
                        if graph.getAdjacencyMatrix()[currentVertex][neighbor] != 0 && !visitedNodes.contains(neighbor){
                            stack.push(neighbor)
                        }
//                        print("Visiting node \(neighbor) from node \(currentVertex)")
                    }
                }
            }
        }
        //        print(visitedNodes)
        //        print(distances)
        return orderOfVisit
    }
    
    // Поиск в ширину
    func breadthFirstSearch(graph: Graph, startVertex: Int) -> [Int] {
        guard startVertex >= 0 && startVertex < graph.getVerticesCount() else {
            print("Error: Start vertex \(startVertex) is out of bounds.")
            return []
        }
        
        // Очередь обработки
        var queue = Queue<Int>()
        // Посещенные вершины
        var visitedNodes = Set<Int>()
        // Последовательность посещения
        var orderOfVisit = [Int]()
        // Количество вершин
        let verticesCount = graph.getVerticesCount()
        // расстояния от начальной вершины
        // длиной в колличество вершин, -1 - вершина на посещалась
        var distances = [Int](repeating: -1, count: verticesCount)
        // массив опциональных родительских вершин
        var parents = [Int?](repeating: nil, count: verticesCount)
        
    //    Начальная инициализация BFS
        queue.push(startVertex)
        visitedNodes.insert(startVertex)
        distances[startVertex] = 0

        while !queue.isEmpty(){
            if let currentVertex = queue.pop(){
                orderOfVisit.append(currentVertex)
                for neighbor in 0..<verticesCount {
                    if graph.getAdjacencyMatrix()[currentVertex][neighbor] != 0 && !visitedNodes.contains(neighbor) {
                        queue.push(neighbor)
                        visitedNodes .insert(neighbor)
                        distances[neighbor] = distances[currentVertex] + 1
                        parents[neighbor] = currentVertex
//                        print("Visiting node \(neighbor) from node \(currentVertex), setting distance: \(distances[neighbor]), parent: \(currentVertex)")
                    }
                }
            }
        }
//        print(visitedNodes)
//        print(distances)
        return orderOfVisit
    }
    
    // MARK: - PART 2
    
    func getShortestPathBetweenVertices(graph: Graph, vertex1: Int, vertex2: Int) {
        
    }

    func getShortestPathsBetweenAllVertices(graph: Graph) {
        
    }
    
    // MARK: - PART 3
    
    func getLeastSpanningTree(graph: Graph) {
        
    }
    
    // MARK: - PART 4
    
    func solveTravelingSalesmanProblem(graph: Graph) {
        
    }
}
