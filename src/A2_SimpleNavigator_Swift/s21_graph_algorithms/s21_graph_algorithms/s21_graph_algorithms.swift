import Foundation
import s21_graph

public class GraphAlgorithms {
    
    public init() {
        
    }
    
    // MARK: - PART 1
    
    // Поиск в глубину
    public func depthFirstSearch(graph: Graph, startVertex: Int) -> [Int] {
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
    public func breadthFirstSearch(graph: Graph, startVertex: Int) -> [Int] {
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
    public func getShortestPathBetweenVertices(graph: Graph, vertex1: Int, vertex2: Int) -> Int? {
        let verticesCount = graph.getVerticesCount()
        
        // проверка что вершины в пределах графа
        guard vertex1 >= 0, vertex1 < verticesCount, vertex2 >= 0, vertex2 < verticesCount else {
            print("Error: One or both vertices are out of bounds.")
            return nil
        }
        
        // Создаем массив расстояний до вершин и заполняем условной бесконечностью - Int.max
        var distances = [Int](repeating: Int.max, count: verticesCount)
        // Обновляем расстояние до начальной вершины, оно равно 0
        distances[vertex1] = 0
        
        // Создаем массив родителей и заполняем nil (не обязательная часть алгоритма)
        var parents = [Int?](repeating: nil, count: verticesCount)
        
        // Создаем очередь приоритетов, которая сортирует вершины по дистанции до вершины
        var priorityQueue = PriorityQueue<VertexDistance>()
        // Добавляем первую вершину с 0 дистанцией
        priorityQueue.enqueue(VertexDistance(vertex: vertex1, distance: 0), priority: 0)
        
        // Цикл пока приоритетная очередь не опустеет
        while !priorityQueue.isEmpty() {
            // Извлекаем элемент из очереди приоритетов, это кортеж с вершиной и расстоянием до неё
            guard let currentVertexDistance = priorityQueue.dequeue() else { break }
            // Извлекаем вершину
            let currentVertex = currentVertexDistance.vertex
            // Извлекаем расстояние
            let currentDistance = currentVertexDistance.distance
            
            // Если извлеченное расстояние больше уже известного минимального расстояния до текущей вершины, то текущий путь не оптимален
            if currentDistance > distances[currentVertex] {
                continue
            }
            
            // Перебор соседей вершины
            for neighbor in 0..<verticesCount {
                // Проходимся по массиву соседей и получаем вес ребра между текущей вершиной и её соседом
                let weight = graph.getAdjacencyMatrix()[currentVertex][neighbor]
                if weight != 0 {
                    let newDistance = currentDistance + weight
                    // Если новое рассчитанное расстояние меньше текущего известного минимального расстояния до соседа, то обновляем минимальное расстояние до соседа.
                    if newDistance < distances[neighbor] {
                        distances[neighbor] = newDistance
                        // Обновляем родительскую вершину для соседа, чтобы позже можно было восстановить кратчайший путь.
                        parents[neighbor] = currentVertex
                        // Добавляем соседа в очередь приоритетов с обновленным расстоянием. Это гарантирует, что сосед будет обработан позже с учетом нового минимального расстояния.
                        priorityQueue.enqueue(VertexDistance(vertex: neighbor, distance: newDistance), priority: newDistance)
                    }
                }
            }
        }
        
        // Если расстояние до целевой вершины все еще равно Int.max, значит путь не найден
        return distances[vertex2] == Int.max ? nil : distances[vertex2]
    }

    
    public func getShortestPathsBetweenAllVertices(graph: Graph) -> [[Int]] {
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
    
    public func getLeastSpanningTree(graph: Graph) -> [[Int]] {
        let adjacencyMatrix = graph.getAdjacencyMatrix()
        let verticesCount = graph.getVerticesCount()

        var key = Array(repeating: Int.max, count: verticesCount) // ключи, используемые для выбора минимального веса ребра
        var parent = Array(repeating: -1, count: verticesCount) // массив для хранения MST
        var SpanningTreeArray = Array(repeating: false, count: verticesCount) // чтобы отслеживать вершины включенные в MST
        
        key[0] = 0 // выбираем первую вершину в качестве стартовой
        parent[0] = -1 // первая вершина является корнем MST
        
        for _ in 0..<verticesCount-1 {
            // выбираем вершину u, не включенную в MST, с минимальным значением ключа
            let j = minKey(keys: key, mstSet: SpanningTreeArray)
            
            // Если minKey вернул -1, это означает, что нет доступных вершин для выбора
            if j == -1 {
                break
            }
            
            SpanningTreeArray[j] = true // добавляем вершину в MST
            
            for i in 0..<verticesCount {
                if adjacencyMatrix[j][i] != 0 && !SpanningTreeArray[i] && adjacencyMatrix[j][i] < key[i] {
                    parent[i] = j
                    key[i] = adjacencyMatrix[j][i]
                }
            }
        }
        
        // создаем матрицу смежности для MST
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
            if !mstSet[i] && keys[i] < min {
                min = keys[i]
                minIndex = i
            }
        }
        return minIndex
    }
    
    // MARK: - PART 4
    
    public func solveTravelingSalesmanProblem(graph: Graph) -> TsmResult? {
        let verticesCount = graph.getVerticesCount()
        let initialVertex = 0 // Начинаем с первой вершины
        var bestPath: [Int] = []
        var bestDistance: Double = Double.infinity
        
        // Инициализация феромонов
        var pheromones: [[Double]] = Array(repeating: Array(repeating: 1.0, count: verticesCount), count: verticesCount)
        let evaporationRate = 0.5 // Коэффициент испарения феромонов
        let alpha = 1.0 // Влияние феромонов
        let beta = 1.0 // Влияние эвристической информации
        
        // Проверка связности графа
        if !isGraphConnected(graph: graph) {
            return nil
        }
        
        // Количество итераций и муравьев
        let numberOfIterations = 100
        let numberOfAnts = verticesCount
        
        for _ in 0..<numberOfIterations {
            var allPaths: [[Int]] = []
            var allDistances: [Double] = []
            
            for _ in 0..<numberOfAnts {
                var currentVertex = initialVertex
                var visited: Set<Int> = [currentVertex]
                var path: [Int] = [currentVertex]
                
                // Построение пути муравьем
                while visited.count < verticesCount {
                    let nextVertex = selectNextVertex(from: currentVertex, graph: graph, pheromones: pheromones, visited: visited, alpha: alpha, beta: beta)
                    path.append(nextVertex)
                    visited.insert(nextVertex)
                    currentVertex = nextVertex
                }
                
                // Добавляем возврат к начальной вершине
                path.append(initialVertex)
                let pathDistance = calculatePathDistance(path: path, graph: graph)
                allPaths.append(path)
                allDistances.append(pathDistance)
                
                // Обновление лучшего пути
                if pathDistance < bestDistance {
                    bestDistance = pathDistance
                    bestPath = path
                }
            }
            
            // Испарение феромонов
            for i in 0..<verticesCount {
                for j in 0..<verticesCount {
                    pheromones[i][j] *= (1.0 - evaporationRate)
                }
            }
            
            // Обновление феромонов на основе пройденных путей
            for (path, distance) in zip(allPaths, allDistances) {
                let pheromoneDeposit = 1.0 / distance
                for i in 0..<(path.count - 1) {
                    let from = path[i]
                    let to = path[i + 1]
                    pheromones[from][to] += pheromoneDeposit
                    pheromones[to][from] += pheromoneDeposit
                }
            }
        }
        // Возвращение результата - лучший найденный путь и его длина
        return TsmResult(vertices: bestPath, distance: bestDistance)
    }
    
    // Проверка связности графа
    func isGraphConnected(graph: Graph) -> Bool {
        let verticesCount = graph.getVerticesCount()
        var visited = [Bool](repeating: false, count: verticesCount)
        
        // Запуск DFS с первой вершины
        func dfs(vertex: Int) {
            visited[vertex] = true
            for neighbor in 0..<verticesCount where graph.getAdjacencyMatrix()[vertex][neighbor] != 0 && !visited[neighbor] {
                dfs(vertex: neighbor)
            }
        }
        
        dfs(vertex: 0)
        
        // Если все вершины посещены, граф связный
        return visited.allSatisfy { $0 }
    }
    
    private func selectNextVertex(from currentVertex: Int, graph: Graph, pheromones: [[Double]], visited: Set<Int>, alpha: Double, beta: Double) -> Int {
        let verticesCount = graph.getVerticesCount()
        let adjacencyMatrix = graph.getAdjacencyMatrix()
        
        var probabilities: [Double] = [] // Массив для хранения вероятностей выбора вершин
        var totalProbability = 0.0 // Общая сумма вероятностей
        
        // Вычисление вероятностей выбора каждой вершины
        for vertex in 0..<verticesCount {
            // Вычисляем только для непосещенных вершин
            if !visited.contains(vertex) && adjacencyMatrix[currentVertex][vertex] > 0 {
                let pheromone = pheromones[currentVertex][vertex] // Извлечение значения феромона
                let distance = Double(adjacencyMatrix[currentVertex][vertex]) // Извлечение расстояния
                let probability = pow(pheromone, alpha) * pow(1.0 / distance, beta) // Вычисление вероятности выбора вершины
                probabilities.append(probability) // Добавление вероятности в массив
                totalProbability += probability // Обновление общей суммы вероятностей
            } else {
                probabilities.append(0.0) // Для уже посещенных вершин вероятность равна 0
            }
        }
        
        // Проверка, что totalProbability не равен нулю или бесконечности
        if totalProbability == 0.0 || probabilities.contains(Double.infinity) {
            // Если нет допустимых вероятностей, возвращаем случайную непосещенную вершину
            let unvisitedVertices = (0..<verticesCount).filter { !visited.contains($0) }
            if let randomUnvisited = unvisitedVertices.randomElement() {
                return randomUnvisited
            } else {
                // Если почему-то все вершины посещены, возвращаем текущую вершину
                return currentVertex
            }
        }
        
        // Случайный выбор вершины на основе вероятностей
        let randomValue = Double.random(in: 0.0..<totalProbability)
        var cumulativeProbability = 0.0
        
        for (vertex, probability) in probabilities.enumerated() {
            cumulativeProbability += probability
            if randomValue <= cumulativeProbability {
                return vertex
            }
        }
        
        // Если по какой-то причине не удалось выбрать вершину, возвращаем текущую
        return currentVertex
    }
    
    // Метод для вычисления длины пути - просто складываем расстояния между точками в пути
    private func calculatePathDistance(path: [Int], graph: Graph) -> Double {
        let adjacencyMatrix = graph.getAdjacencyMatrix()
        var distance = 0.0
        
        for i in 0..<(path.count - 1) {
            distance += Double(adjacencyMatrix[path[i]][path[i + 1]])
        }
        
        // Добавляем расстояние от последней вершины обратно к первой, чтобы сделать путь циклическим
        distance += Double(adjacencyMatrix[path.last!][path.first!])
        
        return distance
    }
}

struct Stack<Element> {
    private var elements: [Element] = []
    
    // Создание пустого стека
    init() {}
    
    // Проверка, пуст ли стек
    func isEmpty() -> Bool {
        return elements.isEmpty
    }
    
    // Добавление элемента на вершину стека
    mutating func push(_ value: Element){
        elements.append(value)
    }
    
    // Удаление элемента с вершины стека
    @discardableResult
    mutating func pop() -> Element? {
        return elements.popLast()
    }
    
    // Получение с вершины стека без его удаления
    func top() -> Element? {
        return elements.last
    }
    
    // Получение количества элементов в стеке
    func count() -> Int {
        return elements.count
    }
    
}


struct Queue<Element> {
    private var elements: [Element] = []
    
    // Создание пустой очереди
    init() {}
    
    // Проверка, пуста ли очередь
    func isEmpty() -> Bool {
        return elements.isEmpty
    }
    
    // Добавление элемента в конец очереди
    mutating func push(_ value: Element){
        elements.append(value)
    }
    
    // Удаление элемента из начала очереди
    @discardableResult
    mutating func pop() -> Element? {
        return elements.removeFirst()
    }
    
    // Получение первого элемента из очереди без его удаления из очереди
    func front() -> Element? {
        return elements.first
    }
    
    // Получение последнего элемента из очереди без его удаления из очереди
    func back() -> Element? {
        return elements.last
    }
    
    // Получение количества элементов в очереди
    func count() -> Int {
        return elements.count
    }
    
}

// Приоритетная очередь, сортируется по дистанции
struct PriorityQueue<Element: Equatable & Hashable> {
    private var elements: [(element: Element, priority: Int)] = []
    
    func isEmpty() -> Bool {
        return elements.isEmpty
    }
    
    mutating func enqueue(_ element: Element, priority: Int) {
        elements.append((element, priority))
        elements.sort { $0.priority < $1.priority }
    }
    
    mutating func dequeue() -> Element? {
        return isEmpty() ? nil : elements.removeFirst().element
    }
}

// Описание типа кортежа в массиве протоколы Equatable и Hashable
struct VertexDistance: Equatable, Hashable {
    let vertex: Int
    let distance: Int
}

func ==(lhs: VertexDistance, rhs: VertexDistance) -> Bool {
    return lhs.vertex == rhs.vertex && lhs.distance == rhs.distance
}

public struct TsmResult {
    var vertices: [Int] // массив с искомым маршрутом (с порядком обхода вершин).
    var distance: Double // длина этого маршрута
}
