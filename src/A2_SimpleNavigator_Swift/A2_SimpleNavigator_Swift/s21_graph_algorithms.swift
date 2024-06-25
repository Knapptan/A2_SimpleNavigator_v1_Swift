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
    
    func getLeastSpanningTree(graph: Graph) {
        
    }
    
    // MARK: - PART 4
    
    func solveTravelingSalesmanProblem(graph: Graph) {
        
    }
}
