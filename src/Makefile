CXX = swiftc
APPNAME = A2SimpleNavigatorSwift
BUILD = buildA2
DOCS = docsA2

all: install

ins:
	xcodebuild -project A2_SimpleNavigator_Swift/A2_SimpleNavigator_Swift.xcodeproj -scheme A2_SimpleNavigator_Swift -configuration Release -sdk macosx build SYMROOT=$(BUILD)


install: s21_graph s21_graph_algorithms ins
	cd A2_SimpleNavigator_Swift/$(BUILD)/Release/; mv A2_SimpleNavigator_Swift A2_SimpleNavigator_Swiftconsole; cp A2_SimpleNavigator_Swiftconsole ../..
	chmod +x A2_SimpleNavigator_Swift/A2_SimpleNavigator_Swiftconsole; ./A2_SimpleNavigator_Swift/A2_SimpleNavigator_Swiftconsole

clean:
	rm -rf A2_SimpleNavigator_Swift.swiftmodule
	rm -rf A2_SimpleNavigator_Swift/buildA2
	rm -rf A2_SimpleNavigator_Swift/s21_graph_algorithms.swiftmodule
	rm -rf A2_SimpleNavigator_Swift/s21_graph.swiftmodule
	rm A2_SimpleNavigator_Swift/libs21_graph_algorithms.a
	rm A2_SimpleNavigator_Swift/libs21_graph.a
	rm -rf A2_SimpleNavigator_Swift/s21_graph_algorithms/s21_graph.swiftmodule
	rm A2_SimpleNavigator_Swift/s21_graph_algorithms/libs21_graph.a	
	rm A2_SimpleNavigator_Swift/A2_SimpleNavigator_Swiftconsole

tests:
	

s21_graph:
	xcodebuild -project A2_SimpleNavigator_Swift/s21_graph/s21_graph.xcodeproj -scheme s21_graph -configuration Release -sdk macosx build CONFIGURATION_BUILD_DIR='../s21_graph_algorithms/'
	cd A2_SimpleNavigator_Swift/s21_graph_algorithms; cp libs21_graph.a ..
	cd A2_SimpleNavigator_Swift/s21_graph_algorithms; cp -r s21_graph.swiftmodule ..
	

s21_graph_algorithms:
	xcodebuild -project A2_SimpleNavigator_Swift/s21_graph_algorithms/s21_graph_algorithms.xcodeproj -scheme s21_graph_algorithms -configuration Release -sdk macosx clean build CONFIGURATION_BUILD_DIR='../'
	
