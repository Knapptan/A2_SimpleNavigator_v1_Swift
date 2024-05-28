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
        var stack = Stack<Int>()
        return []
    }
    
    // Поиск в ширину
    func breadthFirstSearch(graph: Graph, startVertex: Int) -> [Int] {
        // только задал начало для алгоритма
        var queue = Queue<Int>()
        var visitetNodes = Set<Int>()
        var distances = [Int]()
        var parents = [Int]()
        
        queue.push(startVertex)

        return []
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
