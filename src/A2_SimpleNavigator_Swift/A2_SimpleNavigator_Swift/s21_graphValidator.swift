//
//  s21_graphValidator
//  A2_SimpleNavigator_Swift
//
//  Created by Knapptan on 07.07.2024.
//

import Foundation

class GraphValidator {
    func validateGraph(_ graph: Graph) -> Bool {
        let adjacencyMatrix = graph.getAdjacencyMatrix()
        let verticesCount = graph.getVerticesCount()
//        let isDirected = graph.isGraphDirected()
        let isWeighted = graph.isGraphWeighted()
        
        // Проверка, что матрица смежности квадратная
        guard adjacencyMatrix.count == verticesCount else {
            print("Error: Adjacency matrix is not square.")
            return false
        }
        
        for row in adjacencyMatrix {
            guard row.count == verticesCount else {
                print("Error: Adjacency matrix is not square.")
                return false
            }
        }
        
        // Проверка, что все веса положительные и граф связан
        var isConnected = false
        for i in 0..<verticesCount {
            var rowConnected = false
            for j in 0..<verticesCount {
                if isWeighted && adjacencyMatrix[i][j] < 0 {
                    print("Error: Negative weight found at (\(i), \(j)).")
                    return false
                }
                if adjacencyMatrix[i][j] != 0 {
                    rowConnected = true
                }
            }
            if rowConnected {
                isConnected = true
            }
        }
        
        if !isConnected {
            print("Error: Graph is not connected.")
            return false
        }
        
        // Дополнительная проверка связности графа
        if !isGraphConnected(graph) {
            print("Error: Graph is not fully connected.")
            return false
        }
        
//        print("Graph is valid.")
        return true
    }
    
    private func isGraphConnected(_ graph: Graph) -> Bool {
        let verticesCount = graph.getVerticesCount()
        let adjacencyMatrix = graph.getAdjacencyMatrix()
        var visited = [Bool](repeating: false, count: verticesCount)
        
        func dfs(_ vertex: Int) {
            visited[vertex] = true
            for neighbor in 0..<verticesCount {
                if adjacencyMatrix[vertex][neighbor] != 0 && !visited[neighbor] {
                    dfs(neighbor)
                }
            }
        }
        
        // Начинаем обход с первой вершины
        dfs(0)
        
        // Если хотя бы одна вершина не была посещена, граф не связен
        for vertexVisited in visited where !vertexVisited {
            return false
        }
        
        return true
    }
}
