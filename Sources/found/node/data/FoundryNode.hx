package found.node.data;

import zui.Nodes.TNode;
import kha.math.FastVector2;

class FoundryNode {
	public static var onInitNode:TNode = {
		id: 0,
		name: "On Init",
		type: "InitNode",
		x: 200,
		y: 200,
		inputs: [],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Out",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			}
		],
		buttons: [],
		color: -4962746
	};
	public static var onUpdateNode:TNode = {
		id: 0,
		name: "On Update",
		type: "UpdateNode",
		x: 200,
		y: 200,
		inputs: [],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Out",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			}
		],
		buttons: [],
		color: -4962746
	};
	public static var onMouseNode:TNode = {
		id: 0,
		name: "On Mouse",
		type: "OnMouseNode",
		x: 200,
		y: 200,
		inputs: [],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Out",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			}
		],
		buttons: [
			{
				name: "mouseEventType",
				type: "ENUM",
				data: ["Pressed", "Down", "Released", "Moved"],
				output: 0,
				default_value: 0
			},
			{
				name: "mouseButton",
				type: "ENUM",
				data: ["Left", "Middle", "Right"],
				output: 0,
				default_value: 0
			}
		],
		color: -4962746
	};
	public static var mouseCoordNode:TNode = {
		id: 0,
		name: "Mouse Coord",
		type: "MouseCoordNode",
		x: 200,
		y: 200,
		inputs: [],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Position",
				type: "VECTOR2",
				color: -7929601,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name: "Movement",
				type: "VECTOR2",
				color: -7929601,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name: "Wheel Delta",
				type: "VALUE",
				color: -10183681,
				default_value: ""
			}
		],
		buttons: [],
		color: -4962746
	};
	public static var onKeyboardNode:TNode = {
		id: 0,
		name: "On Keyboard",
		type: "OnKeyboardNode",
		x: 200,
		y: 200,
		inputs: [],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Out",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			}
		],
		buttons: [
			{
				name: "keyboardEventType",
				type: "ENUM",
				data: ["Pressed", "Down", "Released"],
				output: 0,
				default_value: 0
			},
			{
				name: "keyCode",
				type: "ENUM",
				data: [
					"Up", "Down", "Left", "Right", "Space", "Return", "Shift", "Tab", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O",
					"P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
				],
				output: 0,
				default_value: 0
			}
		],
		color: -4962746
	};
	public static var gamepadAxisInputNode:TNode = {
		id: 0,
		name: "Gamepad Axis Input",
		type: "GamepadAxisInputNode",
		x: 200,
		y: 200,
		inputs: [],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Float",
				type: "VALUE",
				color: -10183681,
				default_value: 0.0
			}
		],
		buttons: [
			{
				name: "axisName",
				type: "ENUM",
				data: [
					"Left Joystick X",
					"Left Joystick Y",
					"Right Joystick X",
					"Right Joystick Y",
					"Left Trigger",
					"Right Trigger"
				],
				output: 0,
				default_value: 0
			}
		],
		color: -4962746
	};
	public static var gamepadButtonInputNode:TNode = {
		id: 0,
		name: "Gamepad Button Input",
		type: "GamepadButtonInputNode",
		x: 200,
		y: 200,
		inputs: [],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Out",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			}
		],
		buttons: [
			{
				name: "selectedButtonEventType",
				type: "ENUM",
				data: ["Pressed", "Down", "Released"],
				output: 0,
				default_value: 0
			},
			{
				name: "selectedButtonName",
				type: "ENUM",
				data: [
					"a", "b", "x", "y", "l1", "r1", "l2", "r2", "share", "options", "l3", "r3", "up", "down", "left", "right", "home", "touchpad"
				],
				output: 0,
				default_value: 0
			}
		],
		color: -4962746
	};
	public static var splitVec2Node:TNode = {
		id: 0,
		name: "Split Vec2",
		type: "SplitVec2Node",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name: "Vec2",
				type: "VECTOR2",
				color: -7929601,
				default_value: [0.0, 0.0]
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "X",
				type: "VALUE",
				color: -10183681,
				default_value: 0.0
			},
			{
				id: 1,
				node_id: 0,
				name: "Y",
				type: "VALUE",
				color: -10183681,
				default_value: 0.0
			}
		],
		buttons: []
	};
	public static var joinVec2Node:TNode = {
		id: 0,
		name: "Join Vec2",
		type: "JoinVec2Node",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name: "X",
				type: "VALUE",
				color: -10183681,
				default_value: 0.0
			},
			{
				id: 0,
				node_id: 0,
				name: "Y",
				type: "VALUE",
				color: -10183681,
				default_value: 0.0
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Vec2",
				type: "VECTOR2",
				color: -7929601,
				default_value: [0.0, 0.0]
			}
		],
		buttons: []
	};
	public static var setObjectLocationNode:TNode = {
		id: 0,
		name: "Set Object Location",
		type: "SetObjectLocationNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name: "In",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name: "Object",
				type: "OBJECT",
				color: -4934476,
				default_value: null
			},
			{
				id: 0,
				node_id: 0,
				name: "Vec2",
				type: "VECTOR2",
				color: -7929601,
				default_value: new kha.math.FastVector2(0.0, 0.0)
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Out",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			}
		],
		buttons: []
	};
	public static var translateObjectNode:TNode = {
		id: 0,
		name: "Translate Object",
		type: "TranslateObjectNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name: "In",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name: "Object",
				type: "OBJECT",
				color: -4934476,
				default_value: null
			},
			{
				id: 0,
				node_id: 0,
				name: "Vec2",
				type: "VECTOR2",
				color: -7929601,
				default_value: new kha.math.FastVector2(0.0, 0.0)
			},
			{
				id: 0,
				node_id: 0,
				name: "Speed",
				type: "VALUE",
				color: -10183681,
				default_value: 1.0
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Out",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			}
		],
		buttons: []
	};
	public static var getObjectNode:TNode = {
		id: 0,
		name: "Get Object",
		type: "GetObjectNode",
		x: 200,
		y: 200,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name: "In",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Out",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name: "Selected Object",
				type: "OBJECT",
				color: -4934476,
				default_value: null
			}
		],
		buttons: [
			{
				name: "selectedObjectName",
				type: "ENUM",
				data: [""],
				output: 0,
				default_value: 0
			}
		],
		color: -4962746
	};
	public static var applyForceToRigidbodyNode:TNode = {
		id: 0,
		name: "Apply Force To Rigidbody",
		type: "ApplyForceToRigidbodyNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name: "In",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name: "Object",
				type: "OBJECT",
				color: -4934476,
				default_value: null
			},
			{
				id: 0,
				node_id: 0,
				name: "Vec2",
				type: "VECTOR2",
				color: -7929601,
				default_value: new kha.math.FastVector2(0.0, 0.0)
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Out",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			}
		],
		buttons: []
	};
	public static var applyImpulseToRigidbodyNode:TNode = {
		id: 0,
		name: "Apply Impulse To Rigidbody",
		type: "ApplyImpulseToRigidbodyNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name: "In",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name: "Object",
				type: "OBJECT",
				color: -4934476,
				default_value: null
			},
			{
				id: 0,
				node_id: 0,
				name: "Vec2",
				type: "VECTOR2",
				color: -7929601,
				default_value: new kha.math.FastVector2(0.0, 0.0)
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Out",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			}
		],
		buttons: []
	};
	public static var topDownControllerNode:TNode = {
		id: 0,
		name: "Top-down Controller",
		type: "TopDownControllerNode",
		x: 200,
		y: 200,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name: "Input Vec2",
				type: "VECTOR2",
				color: -7929601,
				default_value: new kha.math.FastVector2(0.0, 0.0)
			},
			{
				id: 1,
				node_id: 0,
				name: "Speed",
				type: "VALUE",
				color: -10183681,
				default_value: 300.0
			}
		],
		outputs: [],
		buttons: [
			{
				name: "inputType",
				type: "ENUM",
				data: ["Use default input", "Use custom input"],
				output: 0,
				default_value: 0
			}
		],
		color: -4962746
	};
	public static var platformer2DControllerNode:TNode = {
		id: 0,
		name: "Platformer 2D Controller",
		type: "Platformer2DControllerNode",
		x: 200,
		y: 200,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name: "Custom Input Vec2",
				type: "VECTOR2",
				color: -7929601,
				default_value: new kha.math.FastVector2(0.0, 0.0)
			},
			{
				id: 1,
				node_id: 0,
				name: "Speed",
				type: "VALUE",
				color: -10183681,
				default_value: 300.0
			},
			{
				id: 2,
				node_id: 0,
				name: "Jump Force",
				type: "VALUE",
				color: -10183681,
				default_value: 1000.0
			}
		],
		outputs: [],
		buttons: [
			{
				name: "inputType",
				type: "ENUM",
				data: ["Use default input", "Use custom input"],
				output: 0,
				default_value: 0
			},
			{
				name: "defaultLeftKeyCode",
				type: "ENUM",
				data: [
					"Up", "Down", "Left", "Right", "Space", "Return", "Shift", "Tab", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O",
					"P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
				],
				output: 0,
				default_value: 2
			},
			{
				name: "defaultRightKeyCode",
				type: "ENUM",
				data: [
					"Up", "Down", "Left", "Right", "Space", "Return", "Shift", "Tab", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O",
					"P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
				],
				output: 0,
				default_value: 3
			},
			{
				name: "defaultJumpKeyCode",
				type: "ENUM",
				data: [
					"Up", "Down", "Left", "Right", "Space", "Return", "Shift", "Tab", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O",
					"P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
				],
				output: 0,
				default_value: 4
			}
		],
		color: -4962746
	};
}
