import Foundation

public class Graph {
    private var adjacencyMatrix: [[Int]]
    private var verticesCount: Int
    private var isDirected: Bool
    private var isWeighted: Bool
    
    public init() {
        self.adjacencyMatrix = []
        self.verticesCount = 0
        self.isDirected = false
        self.isWeighted = false
    }
    
    public init(verticesCount: Int) {
        self.verticesCount = verticesCount
        self.adjacencyMatrix = Array(repeating: Array(repeating: 0, count: verticesCount), count: verticesCount)
        self.isDirected = false
        self.isWeighted = false
    }
    // для тестов
    public init(adjacencyMatrix: [[Int]]) {
        self.verticesCount = adjacencyMatrix.count
        self.adjacencyMatrix = adjacencyMatrix
        self.isDirected = false
        self.isWeighted = false
    }
    
    public func loadGraphFromFile(_ filename: String) {
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
    
    
    public func getAdjacencyMatrix() -> [[Int]] {
        return adjacencyMatrix
    }
    
    public func getVerticesCount() -> Int {
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
    public func exportGraphToDot(_ filename: String) {
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


public class GraphValidator {
    public init() {
        
    }
    
    public func validateGraph(_ graph: Graph) -> Bool {
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
