package found.node.data;

import zui.Nodes.TNode;
import kha.math.FastVector2;

@:access(Input.Keyboard)
class FoundryNode {
	public static var onAddNode:TNode = {
		id: 0,
		name: "On Add",
		type: "OnAddNode",
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
	public static var multiEventNode:TNode = {
		id: 0,
		name: "Multiple Events",
		type: "MultiEventNode",
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
			},
			{
				id: 1,
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
			}
		],
		buttons: [],
		color: -4962746
	};
	public static var eventListenNode:TNode = {
		id: 0,
		name: "Event Listener",
		type: "EventListenNode",
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
			},
			{
				id: 0,
				node_id: 0,
				name: "Event Name",
				type: "STRING",
				color: -4934476,
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
			}
		],
		buttons: [],
		color: -4962746
	};
	public static var sendEventNode:TNode = {
		id: 0,
		name: "Send Event",
		type: "SendEventNode",
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
			},
			{
				id: 0,
				node_id: 0,
				name: "Event Name",
				type: "STRING",
				color: -4934476,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name: "Object",
				type: "OBJECT",
				color: -4934476,
				default_value: null
			}
		],
		outputs: [],
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
				data: OnMouseNode.getMouseButtonEventTypes(),
				output: 0,
				default_value: 0
			},
			{
				name: "mouseButton",
				type: "ENUM",
				data: Input.Mouse.getMouseButtonStringValues(),
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
			},
			{
				id: 1,
				node_id: 0,
				name: "isActive",
				type: "BOOLEAN",
				color: -10822566,
				default_value: 0.0
			},
		],
		buttons: [
			{
				name: "keyboardEventType",
				type: "ENUM",
				data: OnKeyboardNode.getKeyboardEventTypes(),
				output: 0,
				default_value: 0
			},
			{
				name: "keyCode",
				type: "ENUM",
				data: Input.Keyboard.getKeyCodeStringValues(),
				output: 0,
				default_value: 0
			}
		],
		color: -4962746
	};
	public static var onGamepadAxisInputNode:TNode = {
		id: 0,
		name: "On Gamepad Axis Input",
		type: "OnGamepadAxisInputNode",
		x: 200,
		y: 200,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name: "Gamepad Index",
				type: "VALUE",
				color: -10183681,
				default_value: 0
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
				id: 1,
				node_id: 0,
				name: "Float Axis Value",
				type: "FLOAT",
				color: -10183681,
				default_value: 0.0
			}
		],
		buttons: [
			{
				name: "selectedAxisName",
				type: "ENUM",
				data: Input.Gamepad.getAxisStringValues(),
				output: 0,
				default_value: 0
			}
		],
		color: -4962746
	};
	public static var onGamepadButtonInputNode:TNode = {
		id: 0,
		name: "On Gamepad Button Input",
		type: "OnGamepadButtonInputNode",
		x: 200,
		y: 200,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name: "Gamepad Index",
				type: "VALUE",
				color: -10183681,
				default_value: 0
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
				id: 1,
				node_id: 0,
				name: "Int Button Value",
				type: "INT",
				color: -10183681,
				default_value: 0.0
			}
		],
		buttons: [
			{
				name: "selectedButtonEventType",
				type: "ENUM",
				data: OnGamepadButtonInputNode.getButtonEventTypes(),
				output: 0,
				default_value: 0
			},
			{
				name: "selectedButtonName",
				type: "ENUM",
				data: Input.Gamepad.getButtonStringValues(),
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
	public static var everyXNode:TNode = {
		id: 0,
		name: "Every X sec",
		type: "EveryXNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name: "Number of sec",
				type: "VALUE",
				color: -10183681,
				default_value: 0.0
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
	public static var cooldownNode:TNode = {
		id: 0,
		name: "X s Cooldown",
		type: "CooldownNode",
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
				name: "Number of sec",
				type: "VALUE",
				color: -10183681,
				default_value: 0.0
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
	public static var getPositionNode:TNode = {
		id: 0,
		name: "Get Position",
		type: "GetPositionNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name: "Object",
				type: "OBJECT",
				color: -4934476,
				default_value: null
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Position Vec2",
				type: "VECTOR2",
				color: -7929601,
				default_value: new kha.math.FastVector2(0.0, 0.0)
			}
		],
		buttons: []
	};
	public static var getCenterNode:TNode = {
		id: 0,
		name: "Get Center",
		type: "GetCenterNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name: "Object",
				type: "OBJECT",
				color: -4934476,
				default_value: null
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Center Vec2",
				type: "VECTOR2",
				color: -7929601,
				default_value: new kha.math.FastVector2(0.0, 0.0)
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
	public static var getRotationNode:TNode = {
		id: 0,
		name: "Get Rotation",
		type: "GetRotationNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name: "Object",
				type: "OBJECT",
				color: -4934476,
				default_value: null
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Rotation",
				type: "VALUE",
				color: -10183681,
				default_value: 0
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
				name: "Position Vec2",
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
	public static var rotateTowardPositionNode:TNode = {
		id: 0,
		name: "Rotate Toward Position",
		type: "RotateTowardPositionNode",
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
				name: "Object to Rotate",
				type: "OBJECT",
				color: -4934476,
				default_value: null
			},
			{
				id: 0,
				node_id: 0,
				name: "Position Vec2",
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
	public static var spawnObjectNode:TNode = {
		id: 0,
		name: "Spawn Object",
		type: "SpawnObjectNode",
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
				name: "Position Vec2",
				type: "VECTOR2",
				color: -7929601,
				default_value: new kha.math.FastVector2(0.0, 0.0)
			},
			{
				id: 0,
				node_id: 0,
				name: "Rotation",
				type: "VALUE",
				color: -10183681,
				default_value: 0.0
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
		buttons: [],
		color: -4962746
	};
	public static var destroyObjectNode:TNode = {
		id: 0,
		name: "Destroy Object",
		type: "DestroyObjectNode",
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
			},
			{
				id: 0,
				node_id: 0,
				name: "Object",
				type: "OBJECT",
				color: -4934476,
				default_value: null
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
		buttons: [],
		color: -4962746
	};
	public static var destroyObjectOutsideViewNode:TNode = {
		id: 0,
		name: "Destroy Object Outside View",
		type: "DestroyObjectOutsideViewNode",
		x: 200,
		y: 200,
		inputs: [			
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
				name: "OffsetFromView",
				type: "VALUE",
				color: -10183681,
				default_value: 0.0
			}
		],
		outputs: [],
		buttons: [],
		color: -4962746
	};
	public static var isObjectOutsideViewNode:TNode = {
		id: 0,
		name: "Is Object Outside View",
		type: "IsObjectOutsideViewNode",
		x: 200,
		y: 200,
		inputs: [			
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
				name: "OffsetFromView",
				type: "VALUE",
				color: -10183681,
				default_value: 0.0
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
		buttons: [],
		color: -4962746
	};
	public static var flipSpriteNode:TNode = {
		id: 0,
		name: "Flip Sprite",
		type: "FlipSpriteNode",
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
			},
			{
				id: 1,
				node_id: 0,
				name: "selectedSpriteName",
				type: "OBJECT",
				color: -4934476,
				default_value: null
			},
			{
				id: 2,
				node_id: 0,
				name: "FlipX",
				type: "BOOLEAN",
				color: -10822566,
				default_value: 0.0
			},
			{
				id: 3,
				node_id: 0,
				name: "FlipY",
				type: "BOOLEAN",
				color: -10822566,
				default_value: 0.0
			}
		],
		outputs: [],
		buttons: [
			{
				name: "selectedSpriteName",
				type: "ENUM",
				data: [""],
				output: 0,
				default_value: 0
			}
		],
		color: -4962746
	}
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
				name: "defaultUpKeyCode",
				type: "ENUM",
				data: Input.Keyboard.getKeyCodeStringValues(),
				output: 0,
				default_value: Input.Keyboard.getKeyCodeStringValues().indexOf("up")
			},
			{
				name: "defaultDownKeyCode",
				type: "ENUM",
				data: Input.Keyboard.getKeyCodeStringValues(),
				output: 0,
				default_value: Input.Keyboard.getKeyCodeStringValues().indexOf("down")
			},
			{
				name: "defaultLeftKeyCode",
				type: "ENUM",
				data: Input.Keyboard.getKeyCodeStringValues(),
				output: 0,
				default_value: Input.Keyboard.getKeyCodeStringValues().indexOf("left")
			},
			{
				name: "defaultRightKeyCode",
				type: "ENUM",
				data: Input.Keyboard.getKeyCodeStringValues(),
				output: 0,
				default_value: Input.Keyboard.getKeyCodeStringValues().indexOf("right")
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
				data: Input.Keyboard.getKeyCodeStringValues(),
				output: 0,
				default_value: Input.Keyboard.getKeyCodeStringValues().indexOf("left")
			},
			{
				name: "defaultRightKeyCode",
				type: "ENUM",
				data: Input.Keyboard.getKeyCodeStringValues(),
				output: 0,
				default_value: Input.Keyboard.getKeyCodeStringValues().indexOf("right")
			},
			{
				name: "defaultJumpKeyCode",
				type: "ENUM",
				data: Input.Keyboard.getKeyCodeStringValues(),
				output: 0,
				default_value: Input.Keyboard.getKeyCodeStringValues().indexOf("space")
			}
		],
		color: -4962746
	};
	public static var bulletMovementNode:TNode = {
		id: 0,
		name: "Bullet Movement",
		type: "BulletMovementNode",
		x: 200,
		y: 200,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name: "Reset Vel & angle",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name: "Speed",
				type: "VALUE",
				color: -10183681,
				default_value: 300.0
			}
		],
		outputs: [],
		buttons: [],
		color: -4962746
	};
	public static var setCameraTargetPositionNode:TNode = {
		id: 0,
		name: "Set Camera Target Position",
		type: "SetCameraTargetPositionNode",
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
			},
			{
				id: 1,
				node_id: 0,
				name: "Target Position Vec2",
				type: "VECTOR2",
				color: -7929601,
				default_value: new kha.math.FastVector2(0.0, 0.0)
			},
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
		buttons: [],
		color: -4962746
	};
	public static var setCameraFollowTargetNode:TNode = {
		id: 0,
		name: "Set Camera Follow Target",
		type: "SetCameraFollowTargetNode",
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
			},
			{
				id: 0,
				node_id: 0,
				name: "Object",
				type: "OBJECT",
				color: -4934476,
				default_value: null
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
		buttons: [],
		color: -4962746
	};
	public static var playAnimationNode:TNode = {
		id: 0,
		name: "Play Animation",
		type: "PlayAnimationNode",
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
			},
			{
				id: 0,
				node_id: 0,
				name: "Animation Name",
				type: "STRING",
				color: -4934476,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name: "Object",
				type: "OBJECT",
				color: -16067936,
				default_value: null
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
		buttons: [],
		color: -4962746
	};
	public static var onCollisionNode:TNode = {
		id: 0,
		name: "On Collision",
		type: "OnCollisionNode",
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
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "On Enter",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name: "On Stay",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name: "On Exit",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name: "Object collided",
				type: "OBJECT",
				color: -4934476,
				default_value: null
			}
		],
		buttons: [],
		color: -4962746
	};
	public static var playMusicNode:TNode = {
		id: 0,
		name: "Play Music",
		type: "PlayMusicNode",
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
			},
			{
				id: 1,
				node_id: 1,
				name: "Music alias",
				type: "STRING",
				color: -4934476,
				default_value: ""
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "OnFinished",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			}
		],
		buttons: [
			{
				name: "loop",
				type: "BOOL",
				output: 0,
				default_value: false
			},
			{
				name: "volume",
				type: "VALUE",
				min: 0.0,
				max: 1.0,
				output: 0,
				default_value: 1.0
			}
		],
		color: -4962746
	};
	public static var playSfxNode:TNode = {
		id: 0,
		name: "Play Sound",
		type: "PlaySfxNode",
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
			},
			{
				id: 1,
				node_id: 1,
				name: "Sound alias",
				type: "STRING",
				color: -4934476,
				default_value: ""
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "OnFinished",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
		],
		buttons: [
			{
				name: "volume",
				type: "VALUE",
				min: 0.0,
				max: 1.0,
				output: 0,
				default_value: 1.0
			}
		],
		color: -4962746
	};
}
