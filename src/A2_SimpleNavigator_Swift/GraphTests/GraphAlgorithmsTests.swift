//
//  GraphTests.swift
//  GraphTests
//
//  Created by Knapptan on 17.06.2024.
//

import XCTest

@testable import A2_SimpleNavigator_Swift

final class GraphTests: XCTestCase {
    
    var graphAlgorithms: GraphAlgorithms!
    var graph: Graph!
    
    override func setUpWithError() throws {
        // Инициализация перед каждым тестом
        graphAlgorithms = GraphAlgorithms()
        
        // Пример графа
        // 0 - 1 - 2
        // |   |   |
        // 3 - 4 - 5
        let adjacencyMatrix = [
            [0, 1, 0, 1, 0, 0],
            [1, 0, 1, 0, 1, 0],
            [0, 1, 0, 0, 0, 1],
            [1, 0, 0, 0, 1, 0],
            [0, 1, 0, 1, 0, 1],
            [0, 0, 1, 0, 1, 0]
        ]
        
        graph = Graph(adjacencyMatrix: adjacencyMatrix)
    }
    
    override func tearDownWithError() throws {
        // Освобождение ресурсов после каждого теста
        graphAlgorithms = nil
        graph = nil
    }
    
    func testDepthFirstSearch() throws {
        let result = graphAlgorithms.depthFirstSearch(graph: graph, startVertex: 0)
        let expected = [0, 1, 2, 5, 4, 3]
        XCTAssertEqual(result, expected, "Depth First Search result is incorrect")
    }
    
    func testBreadthFirstSearch() throws {
        let result = graphAlgorithms.breadthFirstSearch(graph: graph, startVertex: 0)
        let expected = [0, 1, 3, 2, 4, 5]
        XCTAssertEqual(result, expected, "Breadth First Search result is incorrect")
    }
    
    func testGetShortestPathBetweenVertices() throws {
        let result = graphAlgorithms.getShortestPathBetweenVertices(graph: graph, vertex1: 0, vertex2: 5)
        let expected = 3
        XCTAssertEqual(result, expected, "Shortest path between vertices is incorrect")
    }
    
    func testGetShortestPathsBetweenAllVertices() throws {
        let result = graphAlgorithms.getShortestPathsBetweenAllVertices(graph: graph)
        let expected = [
            [0, 1, 2, 1, 2, 3],
            [1, 0, 1, 2, 1, 2],
            [2, 1, 0, 3, 2, 1],
            [1, 2, 3, 0, 1, 2],
            [2, 1, 2, 1, 0, 1],
            [3, 2, 1, 2, 1, 0]
        ]
        XCTAssertEqual(result, expected, "Shortest paths between all vertices is incorrect")
    }
    
    func testGetLeastSpanningTree() throws {
        let result = graphAlgorithms.getLeastSpanningTree(graph: graph)
        let expected = [
            [0, 1, 0, 1, 0, 0],
            [1, 0, 1, 0, 0, 0],
            [0, 1, 0, 0, 0, 1],
            [1, 0, 0, 0, 1, 0],
            [0, 0, 0, 1, 0, 0],
            [0, 0, 1, 0, 0, 0]
        ]
        XCTAssertEqual(result, expected, "Least spanning tree is incorrect")
    }
    
    func testSolveTravelingSalesmanProblem() throws {
        if let result = graphAlgorithms.solveTravelingSalesmanProblem(graph: graph) {
            let expectedPath = [0, 1, 2, 5, 4, 3, 0] // Пример ожидаемого пути (может варьироваться)
            let expectedDistance = 6.0 // Пример ожидаемого расстояния
//            XCTAssertEqual(result.distance, expectedDistance, accuracy: 0.1, "TSP distance is incorrect")
//            XCTAssertEqual(result.vertices, expectedPath, "TSP path is incorrect")
        } else {
            XCTFail("TSP result is nil")
        }
    }
    
    func testPerformanceExample() throws {
        measure {
            // Измерение производительности
            _ = graphAlgorithms.solveTravelingSalesmanProblem(graph: graph)
        }
    }
}
