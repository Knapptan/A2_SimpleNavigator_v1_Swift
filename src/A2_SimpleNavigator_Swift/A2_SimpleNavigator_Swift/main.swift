//
//  main.swift
//  A2_SimpleNavigator_Swift
//
//  Created by Anton Krivonozhenkov on 26.05.2024.
//

import Foundation

enum MenuOption: Int, CaseIterable {
    case loadGraph = 1
    case breadthFirstSearch = 2
    case depthFirstSearch = 3
    case shortestPathBetweenTwoVertices = 4
    case shortestPathsBetweenAllPairs = 5
    case minimumSpanningTree = 6
    case solveTSP = 7
    case exportToDot = 8
    case exit = 0
    
    var description: String {
        switch self {
        case .loadGraph:
            return "Load the original graph from a file."
        case .breadthFirstSearch:
            return "Traverse the graph in breadth and print the result."
        case .depthFirstSearch:
            return "Traverse the graph in depth and print the result."
        case .shortestPathBetweenTwoVertices:
            return "Find the shortest path between any two vertices and print the result."
        case .shortestPathsBetweenAllPairs:
            return "Find the shortest paths between all pairs of vertices and print the result matrix."
        case .minimumSpanningTree:
            return "Search for the minimum spanning tree in the graph and print the resulting adjacency matrix."
        case .solveTSP:
            return "Solve the Salesman problem and print the resulting route and its length."
        case .exportToDot:
            return "Export loeaded graph to dot format"
        case .exit:
            return "Exit the program."
        }
    }
}

class ConsoleApp {
    private var graph = Graph()
    private var graph_algos = GraphAlgorithms()
    
    private func printMenu() {
        print("Please choose an option:")
        MenuOption.allCases.forEach { print("\($0.rawValue). \($0.description)") }
    }
    
    private func readUserInput() -> Int? {
        if let input = readLine(), let choice = Int(input) {
            return choice
        }
        return nil
    }
    
    private func loadGraph() {
        print("Enter the file path to load the graph or leave it empty for default graph:")
        
        var filePath: String = ""
        filePath = readLine() ?? ""
        
        if filePath.isEmpty {
            filePath = "graph11.txt"
            graph.loadGraphFromFile(filePath)
            graph.getAdjacencyMatrix().forEach{print($0)}
        } else {
            print("Invalid file path.")
        }
    }
    
    private func handleOption(_ option: MenuOption) {
        switch option {
        case .loadGraph:
            print(option.description)
            loadGraph()
            
        case .breadthFirstSearch:
            print(option.description)
            print("Enter vertex:")
            if let v1 = readUserInput() {
                let tmparray1 = graph_algos.breadthFirstSearch(graph: graph, startVertex: v1)
                tmparray1.forEach{print($0)}
            }
            
        case .depthFirstSearch:
            print(option.description)
            print("Enter vertex:")
            if let v1 = readUserInput() {
                let tmparray2 = graph_algos.depthFirstSearch(graph: graph, startVertex: v1)
                tmparray2.forEach{print($0)}
            }
            
        case .shortestPathBetweenTwoVertices:
            print(option.description)
            print("Enter two vertexes:")
            if let v1 = readUserInput(), let v2 = readUserInput() {
                let shortestPath = graph_algos.getShortestPathBetweenVertices(graph: graph, vertex1: v1, vertex2: v2)
                print(shortestPath ?? -1)
            }
            
        case .shortestPathsBetweenAllPairs:
            print(option.description)
            let tmparray3 = graph_algos.getShortestPathsBetweenAllVertices(graph: graph)
            tmparray3.forEach{print($0)}
            
        case .minimumSpanningTree:
            print(option.description)
        case .solveTSP:
            print(option.description)
            
        case .exportToDot:
            print(option.description)
            graph.exportGraphToDot("graph_.dot")
            
        case .exit:
            print("Exiting the program.")
        }
    }
    
    func run() {
        var shouldExit = false
        while !shouldExit {
            printMenu()
            if let choice = readUserInput(), let option = MenuOption(rawValue: choice) {
                handleOption(option)
                if option == .exit {
                    shouldExit = true
                }
            } else {
                print("Invalid choice. Please enter a number between 1 and \(MenuOption.allCases.count).")
            }
        }
    }
}

let main = ConsoleApp()
main.run()

