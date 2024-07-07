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
    private var isDirected: Bool
    private var isWeighted: Bool
    
    init() {
        self.adjacencyMatrix = []
        self.verticesCount = 0
        self.isDirected = false
        self.isWeighted = false
    }
    
    init(verticesCount: Int) {
        self.verticesCount = verticesCount
        self.adjacencyMatrix = Array(repeating: Array(repeating: 0, count: verticesCount), count: verticesCount)
        self.isDirected = false
        self.isWeighted = false
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
      
      func getVerticesCount() -> Int {
          return verticesCount
      }
      
      func setDirected(_ directed: Bool) {
          self.isDirected = directed
      }
      
      func setWeighted(_ weighted: Bool) {
          self.isWeighted = weighted
      }
      
      func isGraphDirected() -> Bool {
          return isDirected
      }
      
      func isGraphWeighted() -> Bool {
          return isWeighted
      }
    
    // определение является ли граф взвешенным направленным
    private func determineGraphProperties() {
        isDirected = false
        isWeighted = false
        
        for i in 0..<verticesCount {
            for j in 0..<verticesCount {
                if adjacencyMatrix[i][j] != adjacencyMatrix[j][i] {
                    isDirected = true
                }
                if adjacencyMatrix[i][j] > 1 {
                    isWeighted = true
                }
            }
        }
    }
    
    // переваод в дот формат
    func exportGraphToDot(_ filename: String) {
        var dotString: String
        
        // если направленный то заголовок с приставкой ди
        if isDirected {
            dotString = "digraph \(filename){\n"
        } else {
            dotString = "graph \(filename){\n"
        }
        // указатель связи зависит от типа
        let connection = isDirected ? "->" : "--"
        
        for i in 0..<verticesCount {
            for j in 0..<verticesCount {
                if adjacencyMatrix[i][j] != 0 {
                    // условие для проверки если граф неориентированный i < j обеспечит добавление только одной из двух симметричных версий ребра
                    if isDirected || i < j {
                        let weightString = isWeighted ? " [weight=\(adjacencyMatrix[i][j])]" : ""
                        dotString += "    \(i) \(connection) \(j)\(weightString);\n"
                    }
                }
            }
        }
        dotString += "}\n"
        
        do {
            try dotString.write(toFile: filename, atomically: true, encoding: .utf8)
        } catch {
            print("Error writing file: \(error)")
        }
    }
    
}
