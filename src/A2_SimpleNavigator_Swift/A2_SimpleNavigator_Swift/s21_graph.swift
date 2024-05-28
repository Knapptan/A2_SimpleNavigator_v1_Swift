//
//  s21_graph.swift
//  A2_SimpleNavigator_Swift
//
//  Created by Anton Krivonozhenkov on 26.05.2024.
//

import Foundation

class Graph {
    private var adjacencyMatrix: [[Int]]
    private var verticesCount: Int
    
    init() {
        self.adjacencyMatrix = []
        self.verticesCount = 0
    }
    
    func loadGraphFromFile(_ filename: String) {
        do {
            let fileContents = try String(contentsOfFile: filename)
            let lines = fileContents.split(separator: "\n")
            
            guard let verticesCount = Int(lines[0]) else {
                print("Invalid file format: the first line must be the number of vertices.")
                return
            }
            
            self.verticesCount = verticesCount
            self.adjacencyMatrix = Array(repeating: Array(repeating: 0, count: verticesCount), count: verticesCount)
            
            for (i, line) in lines[1...].enumerated() {
                let weights = line.split(separator: " ").compactMap { Int($0) }
                if weights.count != verticesCount {
                    print("Invalid file format: the adjacency matrix must be square.")
                    return
                }
                for (j, weight) in weights.enumerated() {
                    adjacencyMatrix[i][j] = weight
                }
            }
        } catch {
            print("Error reading file: \(error)")
        }
    }
    
    func getAdjacencyMatrix() -> [[Int]] {
        return adjacencyMatrix
    }
    
    func exportGraphToDot(_ filename: String) {
        // сейчас простой перевод в направленные с весом, нужно переделать
        // как различать типы матриц смежности?
        var dotString = "digraph G {\n"
        
        for i in 0..<verticesCount{
            for j in 0..<verticesCount{
                if adjacencyMatrix[i][j] != 0 {
                    dotString += "    \(i) -> \(j) [label=\(adjacencyMatrix[i][j])];\n"
                }
            }
        }
        dotString += "}\n"
        print(dotString)
        do {
            try dotString.write(toFile: filename, atomically: true, encoding: .utf8)
        } catch {
            print("Error writing file: \(error)")
        }
    }
}
