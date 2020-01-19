package found.tool;

//Kha
import kha.Color;

//Zui
import found.zui.Id;
import found.zui.Zui;
import found.zui.Nodes;

//Editor
import found.data.SceneFormat.LogicNodeData;
import found.node.data.StdNode;
import found.node.data.MathNode;
import found.node.data.LogicNode;
import found.node.data.NodeCreator;
import found.node.data.VariableNode;

@:access(zui.Zui)
class NodeEditor {
    var ui: Zui;

	public static var nodesArray: Array<LogicNodeData> = [];
	public static var selectedNode:LogicNodeData = null;

	public static var nodeHandle = Id.handle();
	public static var nodeTabHandle = Id.handle();
    
    public static function renderNodes(ui:Zui) {
		if(selectedNode != null) selectedNode.nodes.nodeCanvas(ui, selectedNode.nodeCanvas);
    }

	public static function renderNodesMenu(ui:Zui) {
		if(selectedNode == null) return;

		if(ui.window(nodeHandle, 200, 60, 150, 540, true)){

            if(ui.tab(nodeTabHandle, "Std")){
				if(ui.panel(Id.handle(), "Logic")){
					if(ui.button("Gate")) pushNodeToSelectedGroup(LogicNode.gate);
					if(ui.button("Branch")) pushNodeToSelectedGroup(LogicNode.branch);
					if(ui.button("Is False")) pushNodeToSelectedGroup(LogicNode.isFalse);
					if(ui.button("Is True")) pushNodeToSelectedGroup(LogicNode.isTrue);
					if(ui.button("While")) pushNodeToSelectedGroup(LogicNode.whileN);
				}
				if(ui.panel(Id.handle(), "Variable")){
					if(ui.button("String")) pushNodeToSelectedGroup(VariableNode.string);
					if(ui.button("Float")) pushNodeToSelectedGroup(VariableNode.float);
					if(ui.button("Int")) pushNodeToSelectedGroup(VariableNode.int);
					// ui.button("Array");
					if(ui.button("Boolean")) pushNodeToSelectedGroup(VariableNode.boolean);
				}
				if(ui.panel(Id.handle(), "Std")){
					if(ui.button("Print")) pushNodeToSelectedGroup(StdNode.print);
					if(ui.button("Parse Int")) pushNodeToSelectedGroup(StdNode.parseInt);
					if(ui.button("Parse Float")) pushNodeToSelectedGroup(StdNode.parseFloat);
					if(ui.button("Float To Int")) pushNodeToSelectedGroup(StdNode.floatToInt);
				}
				if(ui.panel(Id.handle(), "Math")){
					if(ui.button("Maths")) pushNodeToSelectedGroup(MathNode.maths);
					if(ui.button("Rad to Deg")) pushNodeToSelectedGroup(MathNode.radtodeg);
					if(ui.button("Deg to Rad")) pushNodeToSelectedGroup(MathNode.degtorad);
					if(ui.button("Random (Int)")) pushNodeToSelectedGroup(MathNode.randi);
					if(ui.button("Random (Float)")) pushNodeToSelectedGroup(MathNode.randf);
				}
            }
            if(ui.tab(nodeTabHandle, "Foundry2d")){
                if (ui.panel(eventNodeHandle, "Event")) {
                    if (ui.button("On Init")) pushNodeToSelectedGroup(FoundryNode.onInitNode);
                    if (ui.button("On Update"))pushNodeToSelectedGroup(FoundryNode.onUpdateNode);
                }
                if (ui.panel(inputNodeHandle, "Input")) {
                    if (ui.button("On Mouse")) pushNodeToSelectedGroup(FoundryNode.onMouseNode);
                    if (ui.button("Mouse Coord"))pushNodeToSelectedGroup(FoundryNode.mouseCoordNode);
                    if (ui.button("On Keyboard")) pushNodeToSelectedGroup(FoundryNode.onKeyboardNode);
                }
                if (ui.panel(mathNodeHandle, "Math")) {
                    if (ui.button("Split Vec2")) pushNodeToSelectedGroup(FoundryNode.splitVec2Node);
                    if (ui.button("Join Vec2")) pushNodeToSelectedGroup(FoundryNode.joinVec2Node);
                }
                if (ui.panel(transformNodeHandle, "Transform")) {
                    if (ui.button("Set Object Loc")) pushNodeToSelectedGroup(FoundryNode.setObjectLocNode);
                    if (ui.button("Translate Object")) pushNodeToSelectedGroup(FoundryNode.translateObjectNode);
                }
            }

		}
	}

	public static function getNodesArrayNames() {
		var names = [];
		for (nodes in nodesArray) names.push(nodes.name);
		return names;
	}

	public static function pushNodeToSelectedGroup(tnode:TNode) {
		selectedNode.nodeCanvas.nodes.push(NodeCreator.createNode(tnode, selectedNode.nodes, selectedNode.nodeCanvas));
	}

}
// Colours
// Bool -> Green -> -10822566
// Float/Int -> Blue -> -10183681
// String -> Grey -> -4934476
// Action type node -> Red -> -4962746
// Variable type node -> Cyan -> -16067936