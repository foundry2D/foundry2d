package found.tool;

// Kha
import kha.Color;
// Zui
import zui.Id;
import zui.Zui;
import zui.Nodes;
// Editor
import found.data.SceneFormat.LogicTreeData;
import found.node.data.StdNode;
import found.node.data.MathNode;
import found.node.data.LogicNode;
import found.node.data.NodeCreator;
import found.node.data.VariableNode;
import found.node.data.FoundryNode;
import found.State;

@:access(zui.Zui)
class NodeEditor {
	var ui:Zui;

	public var visible:Bool;

	public static var width:Int;
	public static var height:Int;
	public static var x:Int;
	public static var y:Int;

	public function new(px:Int, py:Int, w:Int, h:Int) {
		this.visible = false;
		ui = new Zui({font: kha.Assets.fonts.font_default});
		setAll(px, py, w, h);
	}

	public function setAll(px:Int, py:Int, w:Int, h:Int) {
		x = px;
		y = py;
		width = w;
		height = h;
	}

	public static var nodesArray:Array<LogicTreeData> = [];
	public static var selectedNode:LogicTreeData = null;

	public static var nodeHandle = Id.handle();
	public static var nodeTabHandle = Id.handle();

	public function render(g:kha.graphics2.Graphics) {
		if (!visible)
			return;

		if (grid == null) {
			g.end();
			drawGrid();
			g.begin();
		}

		var nodePanX:Float = 0.0;
		var nodePanY:Float = 0.0;
		if (NodeEditor.selectedNode != null) {
			nodePanX += NodeEditor.selectedNode.nodes.panX * NodeEditor.selectedNode.nodes.SCALE() % 40 - 40;
			nodePanY += NodeEditor.selectedNode.nodes.panY * NodeEditor.selectedNode.nodes.SCALE() % 40 - 40;
			if (nodePanX > 0.0)
				nodePanX = 0;
			else if (Math.abs(nodePanX) > kha.System.windowWidth() - NodeEditor.width)
				nodePanX = -(kha.System.windowWidth() - NodeEditor.width);
			if (nodePanY > 0.0)
				nodePanY = 0;
			else if (Math.abs(nodePanY) > kha.System.windowHeight() - NodeEditor.height)
				nodePanY = -(kha.System.windowHeight() - NodeEditor.height);

			var updatedObjectList = State.active.getObjectNames();
			for (node in NodeEditor.selectedNode.nodes.nodesSelected) {
				if (node.type == "GetObjectNode") {
					node.buttons[0].data = updatedObjectList;
				}
			}
		}
		g.end();
		ui.begin(g);
		if (ui.window(Id.handle(), NodeEditor.x, NodeEditor.y, NodeEditor.width, NodeEditor.height)) {
			ui.g.color = kha.Color.White;
			ui.g.drawImage(grid, nodePanX, nodePanY);
			renderNodes(ui);
		}
		renderNodesMenu(ui);
		ui.end();
		g.begin(false);
	}

	public static function renderNodes(ui:Zui) {
		if (selectedNode != null)
			selectedNode.nodes.nodeCanvas(ui, selectedNode.nodeCanvas);
	}

	public static function renderNodesMenu(ui:Zui) {
		if (selectedNode == null)
			return;

		if (ui.window(nodeHandle, NodeEditor.x, NodeEditor.y, 150, Std.int(NodeEditor.height * 0.75), true)) {
			if (ui.tab(nodeTabHandle, "Std")) {
				if (ui.panel(Id.handle(), "Logic")) {
					if (ui.button("Gate"))
						pushNodeToSelectedGroup(LogicNode.gate);
					if (ui.button("Branch"))
						pushNodeToSelectedGroup(LogicNode.branch);
					if (ui.button("Is False"))
						pushNodeToSelectedGroup(LogicNode.isFalse);
					if (ui.button("Is True"))
						pushNodeToSelectedGroup(LogicNode.isTrue);
					if (ui.button("While"))
						pushNodeToSelectedGroup(LogicNode.whileN);
				}
				if (ui.panel(Id.handle(), "Variable")) {
					if (ui.button("String"))
						pushNodeToSelectedGroup(VariableNode.string);
					if (ui.button("Float"))
						pushNodeToSelectedGroup(VariableNode.float);
					if (ui.button("Int"))
						pushNodeToSelectedGroup(VariableNode.int);
					// ui.button("Array");
					if (ui.button("Boolean"))
						pushNodeToSelectedGroup(VariableNode.boolean);
					if (ui.button("Vector2"))
						pushNodeToSelectedGroup(VariableNode.vector2);
				}
				if (ui.panel(Id.handle(), "Std")) {
					if (ui.button("Print"))
						pushNodeToSelectedGroup(StdNode.print);
					if (ui.button("Parse Int"))
						pushNodeToSelectedGroup(StdNode.parseInt);
					if (ui.button("Parse Float"))
						pushNodeToSelectedGroup(StdNode.parseFloat);
					if (ui.button("Float To Int"))
						pushNodeToSelectedGroup(StdNode.floatToInt);
				}
				if (ui.panel(Id.handle(), "Math")) {
					if (ui.button("Maths"))
						pushNodeToSelectedGroup(MathNode.maths);
					if (ui.button("Rad to Deg"))
						pushNodeToSelectedGroup(MathNode.radtodeg);
					if (ui.button("Deg to Rad"))
						pushNodeToSelectedGroup(MathNode.degtorad);
					if (ui.button("Random (Int)"))
						pushNodeToSelectedGroup(MathNode.randi);
					if (ui.button("Random (Float)"))
						pushNodeToSelectedGroup(MathNode.randf);
				}
			}
			if (ui.tab(nodeTabHandle, "Foundry2d")) {
				if (ui.panel(Id.handle(), "Event")) {
					if (ui.button("On Init"))
						pushNodeToSelectedGroup(FoundryNode.onInitNode);
					if (ui.button("On Update"))
						pushNodeToSelectedGroup(FoundryNode.onUpdateNode);
				}
				if (ui.panel(Id.handle(), "Input")) {
					if (ui.button("On Mouse"))
						pushNodeToSelectedGroup(FoundryNode.onMouseNode);
					if (ui.button("Mouse Coord"))
						pushNodeToSelectedGroup(FoundryNode.mouseCoordNode);
					if (ui.button("On Keyboard"))
						pushNodeToSelectedGroup(FoundryNode.onKeyboardNode);
					if (ui.button("On Gamepad Axis"))
						pushNodeToSelectedGroup(FoundryNode.gamepadAxisInputNode);
					if (ui.button("On Gamepad Button"))
						pushNodeToSelectedGroup(FoundryNode.gamepadButtonInputNode);
				}
				if (ui.panel(Id.handle(), "Math")) {
					if (ui.button("Split Vec2"))
						pushNodeToSelectedGroup(FoundryNode.splitVec2Node);
					if (ui.button("Join Vec2"))
						pushNodeToSelectedGroup(FoundryNode.joinVec2Node);
				}
				if (ui.panel(Id.handle(), "Transform")) {
					if (ui.button("Set Object Loc"))
						pushNodeToSelectedGroup(FoundryNode.setObjectLocNode);
					if (ui.button("Translate Object"))
						pushNodeToSelectedGroup(FoundryNode.translateObjectNode);
				}
				if (ui.panel(Id.handle(), "Object")) {
					if (ui.button("Get Object"))
						pushNodeToSelectedGroup(FoundryNode.getObjectNode);
				}
				if (ui.panel(Id.handle(), "Physics")) {
					if (ui.button("Apply Force To Rigidbody"))
						pushNodeToSelectedGroup(FoundryNode.applyForceToRigidbodyNode);
					if (ui.button("Apply Impulse To Rigidbody"))
						pushNodeToSelectedGroup(FoundryNode.applyImpulseToRigidbodyNode);
				}
			}
		}
	}

	public static function getNodesArrayNames() {
		var names = [];
		for (nodes in nodesArray)
			names.push(nodes.name);
		return names;
	}

	public static function pushNodeToSelectedGroup(tnode:TNode) {
		selectedNode.nodeCanvas.nodes.push(NodeCreator.createNode(tnode, selectedNode.nodes, selectedNode.nodeCanvas));
	}

	public static var grid:kha.Image = null;
	public static var gridSize:Int = 20;

	function drawGrid() {
		var doubleGridSize = gridSize * 2;
		var ww = kha.System.windowWidth();
		var wh = kha.System.windowHeight();
		var w = ww + doubleGridSize * 2;
		var h = wh + doubleGridSize * 2;
		grid = kha.Image.createRenderTarget(w, h);
		grid.g2.begin(true, 0xff242424);
		grid.g2.color = 0xff202020;
		grid.g2.fillRect(0, 0, w, h);
		for (i in 0...Std.int(h / doubleGridSize) + 1) {
			grid.g2.color = 0xff282828;
			grid.g2.drawLine(0, i * doubleGridSize, w, i * doubleGridSize, 2);
			grid.g2.color = 0xff323232;
			grid.g2.drawLine(0, i * doubleGridSize + gridSize, w, i * doubleGridSize + gridSize);
		}
		for (i in 0...Std.int(w / doubleGridSize) + 1) {
			grid.g2.color = 0xff282828;
			grid.g2.drawLine(i * doubleGridSize, 0, i * doubleGridSize, h, 2);
			grid.g2.color = 0xff323232;
			grid.g2.drawLine(i * doubleGridSize + gridSize, 0, i * doubleGridSize + gridSize, h);
		}

		grid.g2.end();
	}
}
// Colours
// Bool -> Green -> -10822566
// Float/Int -> Blue -> -10183681
// String -> Grey -> -4934476
// Action type node -> Red -> -4962746
// Variable type node -> Cyan -> -16067936
