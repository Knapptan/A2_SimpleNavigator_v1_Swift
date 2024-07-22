import Foundation
import s21_graph
import s21_graph_algorithms

enum MenuOption: Int, CaseIterable {
    case breadthFirstSearch = 1
    case depthFirstSearch = 2
    case shortestPathBetweenTwoVertices = 3
    case shortestPathsBetweenAllPairs = 4
    case minimumSpanningTree = 5
    case solveTSP = 6
    case exportToDot = 7
    case exit = 0
    
    var description: String {
        switch self {
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
            return "Export loaded graph to dot format"
        case .exit:
            return "Exit the program."
        }
    }
}

class ConsoleApp {
    private var graph = Graph()
    private var graph_algos = GraphAlgorithms()
    private var graph_validator = GraphValidator()
    
    private func printInitialMenu() {
        print("Please load the graph from a file:")
        print("1. Load the original graph from a file.")
        print("0. Exit the program.")
    }
    
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
    
    private func loadGraph() -> Bool {
        print("Enter the file path to load the graph or leave it empty for default graph:")
        
        var filePath: String = ""
        filePath = readLine() ?? ""
        
        if !filePath.isEmpty {
            graph.loadGraphFromFile(filePath)
            if graph_validator.validateGraph(graph) {
                print("Graph successfully loaded and validated.")
                graph.getAdjacencyMatrix().forEach{print($0)}
                return true
            } else {
                print("Invalid graph structure.")
            }
        } else {
            print("Invalid file path.")
        }
        return false
    }
    
    private func handleOption(_ option: MenuOption) {
        switch option {
        case .breadthFirstSearch:
            print(option.description)
            print("Enter vertex:")
            if let v1 = readUserInput() {
                let result = graph_algos.breadthFirstSearch(graph: graph, startVertex: v1)
                result.forEach{print($0)}
            }
            
        case .depthFirstSearch:
            print(option.description)
            print("Enter vertex:")
            if let v1 = readUserInput() {
                let result = graph_algos.depthFirstSearch(graph: graph, startVertex: v1)
                result.forEach{print($0)}
            }
            
        case .shortestPathBetweenTwoVertices:
            print(option.description)
            print("Enter two vertices:")
            if let v1 = readUserInput(), let v2 = readUserInput() {
                let shortestPath = graph_algos.getShortestPathBetweenVertices(graph: graph, vertex1: v1, vertex2: v2)
                print(shortestPath ?? -1)
            }
            
        case .shortestPathsBetweenAllPairs:
            print(option.description)
            let result = graph_algos.getShortestPathsBetweenAllVertices(graph: graph)
            result.forEach{print($0)}
            
        case .minimumSpanningTree:
            print(option.description)
            let result = graph_algos.getLeastSpanningTree(graph: graph)
            result.forEach{print($0)}
            
        case .solveTSP:
            print(option.description)
            if graph_validator.validateGraph(graph) {
                let solutionTSP = graph_algos.solveTravelingSalesmanProblem(graph: graph)
                print(solutionTSP ?? "Nil")
            } else {
                print("Failed to solve TSP due to graph validation error.")
            }
            
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
            printInitialMenu()
            if let choice = readUserInput(), choice == 1 {
                if loadGraph() {
                    var innerShouldExit = false
                    while !innerShouldExit {
                        printMenu()
                        if let innerChoice = readUserInput(), let option = MenuOption(rawValue: innerChoice) {
                            handleOption(option)
                            if option == .exit {
                                innerShouldExit = true
                                shouldExit = true
                            }
                        } else {
                            print("Invalid choice. Please enter a number between 0 and \(MenuOption.allCases.count - 1).")
                        }
//                        sleep(2)
                    }
                }
            } else if let choice = readUserInput(), choice == 0 {
                shouldExit = true
                print("Exiting the program.")
            } else {
                print("Invalid choice. Please enter 1 to load the graph or 0 to exit.")
            }
//            sleep(2)
        }
    }
}

let main = ConsoleApp()
main.run()
