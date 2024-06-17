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
                    }
                }
            }
        }
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
                    }
                }
            }
        }
        return orderOfVisit
    }
    
    // MARK: - PART 2
    // почему-то не отрабатывает как надо, нужно переделать под сет каскадов
    func getShortestPathBetweenVertices(graph: Graph, vertex1: Int, vertex2: Int) -> Int{
        let verticesCount = graph.getVerticesCount()
        guard vertex1 >= 0 && vertex1 < verticesCount && vertex2 >= 0 && vertex2 < verticesCount else {
            print("Error: One or both vertices are out of bounds.")
            return Int.max
        }
        
        var distances = [Int](repeating: Int.max, count: verticesCount)
        distances[vertex1] = 0
        
        var parents = [Int?](repeating: nil, count: verticesCount)
        
        var priorityQueue = PriorityQueue<(vertex: Int, distance: Int)> { $0.distance < $1.distance}
        priorityQueue.enqueue((vertex: vertex1, distance: 0))
        
        while !priorityQueue.isEmpty() {
            guard let (currentVertex, currentDistance) = priorityQueue.dequeue() else {continue}
            
            if currentVertex == vertex1 {
                return currentDistance
            }
            
            for neighbor in 0..<verticesCount {
                let weight = graph.getAdjacencyMatrix()[currentVertex][neighbor]
                
                if weight > 0 {
                    let newDistance = currentDistance + weight
                    if newDistance < distances[neighbor] {
                        distances[neighbor] = newDistance
                        parents[neighbor] = currentVertex
                        priorityQueue.enqueue((vertex: neighbor, distance: newDistance))
                    }
                }
            }
        }
        
        return distances[vertex2]
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
