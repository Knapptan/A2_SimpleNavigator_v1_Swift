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
    func getShortestPathBetweenVertices(graph: Graph, vertex1: Int, vertex2: Int) -> Int? {
        let verticesCount = graph.getVerticesCount()
        
        // проверка что вершины в пределах графа
        guard vertex1 >= 0, vertex1 < verticesCount, vertex2 >= 0,vertex2 < verticesCount else {
            print("Error: One or both vertices are out of bounds.")
            return nil
        }
        
        // Создаем массив расстояний до вершин и заполняем услоной бесконечностью - инт макс
        var distances = [Int](repeating: Int.max, count: verticesCount)
        // Обновляем расстояние до начальной вершины оно равно 0
        distances[vertex1] = 0
        
        // Создаем массив родителей и заполняем нилл (не обязательная часть алгоритма)
        var parents = [Int?](repeating: nil, count: verticesCount)
        
        // Создаем очередь приоритетов которая сотрирует вершины по дистанции до вершины
        var priorityQueue = PriorityQueue<VertexDistance>()
        // Добавляем первую вершину с 0 дистаницей
        priorityQueue.enqueue(VertexDistance(vertex: vertex1, distance: 0), priority: 0)
        
        // Цикл пока приоритетная очередь не опустеет
        while !priorityQueue.isEmpty() {
            // Извлекаем элемент из очереди приоритетов это кортеж с вершиной ирасстоянием до нее
            guard let currentVertexDistance = priorityQueue.dequeue() else { break }
            // Извлекакем вершину
            let currentVertex = currentVertexDistance.vertex
            // Извлекаем расстояние
            let currentDistance = currentVertexDistance.distance
            
            // Если извлеченное расстояние больше уже известного минимального расстояния до текущей вершины, то текущий путь не оптимален
            if currentDistance > distances[currentVertex] {
                continue
            }
            
            // перебор соседей вершины
            for neighbor in 0..<verticesCount {
                //  проходимся по массиву соседей и получаем вес ребра между текущей вершиной и её соседом
                let weight = graph.getAdjacencyMatrix()[currentVertex][neighbor]
                if weight != 0 {
                    let newDistance = currentDistance + weight
                    // Если новое рассчитанное расстояние меньше текущего известного минимального расстояния до соседа, то обновляем минимальное расстояние до соседа.
                    if newDistance < distances[neighbor] {
                        distances[neighbor] = newDistance
                        //Обновляем родительскую вершину для соседа, чтобы позже можно было восстановить кратчайший путь.
                        parents[neighbor] = currentVertex
                        //Добавляем соседа в очередь приоритетов с обновленным расстоянием. Это гарантирует, что сосед будет обработан позже с учетом нового минимального расстояния.
                        priorityQueue.enqueue(VertexDistance(vertex: neighbor, distance: newDistance), priority: newDistance)
                    }
                }
            }
        }
        return distances[vertex2]
    }
    
    func getShortestPathsBetweenAllVertices(graph: Graph) -> [[Int]] {
        let verticesCount = graph.getVerticesCount()
        let adjacencyMatrix = graph.getAdjacencyMatrix()
        let inf = Int.max
        
        // Инициализация мтарицы расстояний
        var dist = Array(repeating: Array(repeating: inf, count: verticesCount), count: verticesCount)
        
        // Заполняем главную диагональ нулями и переносим имеющиеся значения из матрицы смежности
        for i in 0..<verticesCount {
            for j in 0..<verticesCount {
                if i == j {
                    dist[i][j] = 0
                } else if adjacencyMatrix[i][j] != 0 {
                    dist[i][j] = adjacencyMatrix[i][j]
                }
            }
        }
        
        // Алгоритм Флойда-Уоршелла
        // Если путь через вершину k короче текущего известного пути от i до j, обновляем dist
        for k in 0..<verticesCount {
            for i in 0..<verticesCount {
                for j in 0..<verticesCount {
                    if dist[i][k] != inf && dist[k][j] != inf && dist[i][k] + dist[k][j] < dist[i][j] {
                        dist[i][j] = dist[i][k] + dist[k][j]
                    }
                }
            }
        }
        
        return dist
    }
    // MARK: - PART 3
    
    func getLeastSpanningTree(graph: Graph, startVertex: Int = 3) -> [[Int]] {
        let adjacencyMatrix = graph.getAdjacencyMatrix()
        let verticesCount = graph.getVerticesCount()
        
        guard startVertex >= 0 && startVertex < verticesCount else {
            print("Error: Starting vertex out of range.")
            return []
        }
        
        var key = Array(repeating: Int.max, count: verticesCount)
        var parent = Array(repeating: -1, count: verticesCount)
        var SpanningTreeArray = Array(repeating: false, count: verticesCount)
        
        key[startVertex] = 0
        parent[startVertex] = -1
        
        for _ in 0..<verticesCount-1 {
            let j = minKey(keys: key, mstSet: SpanningTreeArray)
            SpanningTreeArray[j] = true
            
            for i in 0..<verticesCount {
                if adjacencyMatrix[j][i] != 0 && !SpanningTreeArray[i] && adjacencyMatrix[j][i] < key[i] {
                    parent[i] = j
                    key[i] = adjacencyMatrix[j][i]
                }
            }
        }
        
        var LeastSpanningTreeAdjacencyMatrix = Array(repeating: Array(repeating: 0, count: verticesCount), count: verticesCount)
        
        for i in 0..<verticesCount {
            if parent[i] != -1 {
                LeastSpanningTreeAdjacencyMatrix[parent[i]][i] = adjacencyMatrix[parent[i]][i]
                LeastSpanningTreeAdjacencyMatrix[i][parent[i]] = adjacencyMatrix[i][parent[i]]
            }
        }
        
        return LeastSpanningTreeAdjacencyMatrix
    }
    
    private func minKey(keys: [Int], mstSet: [Bool]) -> Int {
        var min = Int.max
        var minIndex = -1
        
        for i in 0..<keys.count {
            if mstSet[i] == false && keys[i] < min {
                min = keys[i]
                minIndex = i
            }
        }
        return minIndex
    }
    
    // MARK: - PART 4
    
    func solveTravelingSalesmanProblem(graph: Graph) -> TsmResult {
        let verticesCount = graph.getVerticesCount()
        let alpha = 1.0 // Влияние феромона
        let beta = 5.0 // Влияние эвристической функции (обратное расстояние)
        let evaporationRate = 0.5 // Коэффициент испарения феромона
        let initialPheromone = 1.0 // Начальное значение ферамонов
        let numAnts = verticesCount // Количество муравьев в каждой итерации
        let maxIterations = verticesCount * 100 // Максимальное количество итераций
        
        // Инициализация матрицы феромонов
        var pheromones = Array(repeating: Array(repeating: initialPheromone, count: verticesCount), count: verticesCount)
        
        var bestPath: [Int] = [] // Переменная для хранения лучшего пути
        var bestDistance = Double.infinity // Переменная для хранения длины лучшего пути
        
        // В каждой итерации создается множество муравьев, каждый из которых строит свой путь, посещая все вершины
        for _ in 0..<maxIterations {
        
            var allPaths: [[Int]] = [] // Массив для хранения всех путей, найденных муравьями
            var allDistances: [Double] = [] // Массив для хранения расстояний для всех путей
            
            // Цикл для создания и движения каждого муравья
            for _ in 0..<numAnts {
                var visited = Set<Int>() // Множество для хранения посещенных вершин
                var path: [Int] = [] // Массив для хранения пути муравья
                var currentVertex = Int.random(in: 0..<verticesCount) // Случайный выбор начальной вершины
                path.append(currentVertex) // Добавление начальной вершины в путь
                visited.insert(currentVertex) // Отправление начальной вершины в посещенные
                
                // Цикл, пока все вершины не будут посещены
                while visited.count < verticesCount {
                    // Выбор следующей вершины на основе вероятностей
                    let nextVertex = selectNextVertex(from: currentVertex, graph: graph, pheromones: pheromones, visited: visited, alpha: alpha, beta: beta)
                    // Записть каждой посещенной вернины
                    path.append(nextVertex)
                    visited.insert(nextVertex)
                    currentVertex = nextVertex // Рассмотрение следующей вершины
                }
                
                path.append((path[0])) // / Возвращение к начальной вершине
                let distance = calculatePathDistance(path: path, graph: graph) // Вычисление длины пути
                 allPaths.append(path) // Сохранение пути
                 allDistances.append(distance) // Сохранение длины пути
                
                // Обновление лучшего пути и его длины
                if distance < bestDistance {
                    bestPath = path
                    bestDistance = distance
                }
            }
            
            // Испарение феромонов
            for i in 0..<verticesCount {
                for j in 0..<verticesCount{
                    pheromones[i][j] *= (1.0 - evaporationRate)
                }
            }
            
            // Обновление феромонов на основе пройденных путей
            for (path, distance) in zip(allPaths, allDistances) {
                for i in 0..<(path.count - 1) {
                    let from = path[i]
                    let to = path[i + 1]
                    pheromones[from][to] = 1.0 / distance
                    pheromones[to][from] = 1.0 / distance
                }
            }
        }
        // Возвращение результата - лучший найденный путь и его длина
        return TsmResult(vertices: bestPath, distance: bestDistance)
    }
    
    //  Для каждой вершины вычисляется вероятность на основе феромонов и эвристической функции
    private func selectNextVertex(from currentVertex: Int, graph: Graph , pheromones: [[Double]], visited: Set<Int>, alpha: Double, beta: Double) -> Int {
        let verticesCount = graph.getVerticesCount()
        let adjacencyMatrix = graph.getAdjacencyMatrix()
        
        var probabilities: [Double] = [] // Массив для хранения вероятностей выбора вершин
        var totalProbability = 0.0 // Общая сумма вероятностей
        
        // Вычисление вероятностей выбора каждой вершины
        for vertex in 0..<verticesCount {
            // Вычисляем если не посещали вершину
            if !visited.contains(vertex) {
                let pheromone = pheromones[currentVertex][vertex] // Извлечение значения феромона
                let distance = Double(adjacencyMatrix[currentVertex][vertex]) // Извлечение расстояния
                let probability = pow(pheromone, alpha) * pow(1.0 / distance, beta) // Вычисление вероятности выбора вершины
                probabilities.append(probability) // Добавление вероятности в массив
                totalProbability += probability // Обновление общей суммы вероятностей
            } else {
                probabilities.append(0.0) // Обработка уже посещенных вершин - не будем посещать
            }
        }
        
        // Случайный выбор вершины на основе вероятностей
        let randomValue = Double.random(in: 0..<totalProbability)
        var cumulativeProbability = 0.0
        
        for (vertex, probability) in probabilities.enumerated() {
            cumulativeProbability += probability
            if randomValue <= cumulativeProbability {
                return vertex
            }
        }
        return currentVertex
    }
    
    // Метод для вычисления длины пути - просто складываем расстояния между точками в пути
    private func calculatePathDistance(path: [Int], graph: Graph) -> Double {
        let adjacencyMatrix = graph.getAdjacencyMatrix()
        var distance = 0.0
        
        for i in 0..<(path.count - 1) {
            distance += Double(adjacencyMatrix[path[i]][path[i + 1]])
        }
        
        return distance
    }

}
