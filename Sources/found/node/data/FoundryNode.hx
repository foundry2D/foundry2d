package found.node.data;

import kha.input.KeyCode;
import zui.Nodes.TNode;
import kha.math.FastVector2;

@:access(Input.Keyboard)
class FoundryNode {
	public static inline function _tr(s: String) { return s; }
	public static var onAddNode:TNode = {
		id: 0,
		name:_tr("On Add"),
		type: "OnAddNode",
		x: 200,
		y: 200,
		inputs: [],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Out"),
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
		name:_tr("On Init"),
		type: "InitNode",
		x: 200,
		y: 200,
		inputs: [],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Out"),
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
		name:_tr("On Update"),
		type: "UpdateNode",
		x: 200,
		y: 200,
		inputs: [],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Out"),
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
		name:_tr("Multiple Events"),
		type: "MultiEventNode",
		x: 200,
		y: 200,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("In"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 1,
				node_id: 0,
				name:_tr("In"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Out"),
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
		name:_tr("Event Listener"),
		type: "EventListenNode",
		x: 200,
		y: 200,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("In"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Event Name"),
				type: "STRING",
				color: -4934476,
				default_value: ""
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Out"),
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
		name:_tr("Send Event"),
		type: "SendEventNode",
		x: 200,
		y: 200,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("In"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Event Name"),
				type: "STRING",
				color: -4934476,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Object"),
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
		name:_tr("On Mouse"),
		type: "OnMouseNode",
		x: 200,
		y: 200,
		inputs: [],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Out"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			}
		],
		buttons: [
			{
				name:_tr("mouseEventType"),
				type: "ENUM",
				data: OnMouseNode.getMouseButtonEventTypes(),
				output: 0,
				default_value: 0
			},
			{
				name:_tr("mouseButton"),
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
		name:_tr("Mouse Coord"),
		type: "MouseCoordNode",
		x: 200,
		y: 200,
		inputs: [],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Position"),
				type: "VECTOR2",
				color: -7929601,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Movement"),
				type: "VECTOR2",
				color: -7929601,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Wheel Delta"),
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
		name:_tr("On Keyboard"),
		type: "OnKeyboardNode",
		x: 200,
		y: 200,
		inputs: [],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Out"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 1,
				node_id: 0,
				name:_tr("isActive"),
				type: "BOOLEAN",
				color: -10822566,
				default_value: 0.0
			},
		],
		buttons: [
			{
				name:_tr("keyboardEventType"),
				type: "ENUM",
				data: OnKeyboardNode.getKeyboardEventTypes(),
				output: 0,
				default_value: 0
			},
			{
				name:_tr("keyCode"),
				type: "KEY",
				output: 0,
				default_value: KeyCode.A
			}
		],
		color: -4962746
	};
	public static var onGamepadAxisInputNode:TNode = {
		id: 0,
		name:_tr("On Gamepad Axis Input"),
		type: "OnGamepadAxisInputNode",
		x: 200,
		y: 200,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Gamepad Index"),
				type: "VALUE",
				color: -10183681,
				default_value: 0
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Out"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 1,
				node_id: 0,
				name:_tr("Float Axis Value"),
				type: "FLOAT",
				color: -10183681,
				default_value: 0.0
			}
		],
		buttons: [
			{
				name:_tr("selectedAxisName"),
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
		name:_tr("On Gamepad Button Input"),
		type: "OnGamepadButtonInputNode",
		x: 200,
		y: 200,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Gamepad Index"),
				type: "VALUE",
				color: -10183681,
				default_value: 0
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Out"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 1,
				node_id: 0,
				name:_tr("Int Button Value"),
				type: "INT",
				color: -10183681,
				default_value: 0.0
			}
		],
		buttons: [
			{
				name:_tr("selectedButtonEventType"),
				type: "ENUM",
				data: OnGamepadButtonInputNode.getButtonEventTypes(),
				output: 0,
				default_value: 0
			},
			{
				name:_tr("selectedButtonName"),
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
		name:_tr("Split Vec2"),
		type: "SplitVec2Node",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Vec2"),
				type: "VECTOR2",
				color: -7929601,
				default_value: [0.0, 0.0]
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("X"),
				type: "VALUE",
				color: -10183681,
				default_value: 0.0
			},
			{
				id: 1,
				node_id: 0,
				name:_tr("Y"),
				type: "VALUE",
				color: -10183681,
				default_value: 0.0
			}
		],
		buttons: []
	};
	public static var joinVec2Node:TNode = {
		id: 0,
		name:_tr("Join Vec2"),
		type: "JoinVec2Node",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("X"),
				type: "VALUE",
				color: -10183681,
				default_value: 0.0
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Y"),
				type: "VALUE",
				color: -10183681,
				default_value: 0.0
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Vec2"),
				type: "VECTOR2",
				color: -7929601,
				default_value: [0.0, 0.0]
			}
		],
		buttons: []
	};
	public static var addVec2Node:TNode = {
		id: 0,
		name:_tr("Add Vec2"),
		type: "AddVec2Node",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Fisrt Vec2"),
				type: "VECTOR2",
				color: -7929601,
				default_value: [0.0, 0.0]
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Second Vec2"),
				type: "VECTOR2",
				color: -7929601,
				default_value: [0.0, 0.0]
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Vec2"),
				type: "VECTOR2",
				color: -7929601,
				default_value: [0.0, 0.0]
			}
		],
		buttons: []
	};
	public static var multiplyVec2Node:TNode = {
		id: 0,
		name:_tr("Multiply Vec2"),
		type: "MultiplyVec2Node",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Fisrt Vec2"),
				type: "VECTOR2",
				color: -7929601,
				default_value: [0.0, 0.0]
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Multiplier"),
				type: "VALUE",
				color: -10183681,
				default_value: 0.0
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Vec2"),
				type: "VECTOR2",
				color: -7929601,
				default_value: [0.0, 0.0]
			}
		],
		buttons: []
	};
	public static var multiplyVec2sNode:TNode = {
		id: 0,
		name:_tr("Multiply Vec2's"),
		type: "MultiplyVec2sNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Fisrt Vec2"),
				type: "VECTOR2",
				color: -7929601,
				default_value: [0.0, 0.0]
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Second Vec2"),
				type: "VECTOR2",
				color: -7929601,
				default_value: [0.0, 0.0]
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Vec2"),
				type: "VECTOR2",
				color: -7929601,
				default_value: [0.0, 0.0]
			}
		],
		buttons: []
	};
	public static var everyXNode:TNode = {
		id: 0,
		name:_tr("Every X sec"),
		type: "EveryXNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Number of sec"),
				type: "VALUE",
				color: -10183681,
				default_value: 0.0
			}
			
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Out"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			}
		],
		buttons: []
	};
	public static var cooldownNode:TNode = {
		id: 0,
		name:_tr("X s Cooldown"),
		type: "CooldownNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("In"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Number of sec"),
				type: "VALUE",
				color: -10183681,
				default_value: 0.0
			}
			
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Out"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			}
		],
		buttons: []
	};
	public static var getPositionNode:TNode = {
		id: 0,
		name:_tr("Get Position"),
		type: "GetPositionNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Object"),
				type: "OBJECT",
				color: -4934476,
				default_value: null
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Position Vec2"),
				type: "VECTOR2",
				color: -7929601,
				default_value: new kha.math.FastVector2(0.0, 0.0)
			}
		],
		buttons: []
	};
	public static var getCenterNode:TNode = {
		id: 0,
		name:_tr("Get Center"),
		type: "GetCenterNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Object"),
				type: "OBJECT",
				color: -4934476,
				default_value: null
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Center Vec2"),
				type: "VECTOR2",
				color: -7929601,
				default_value: new kha.math.FastVector2(0.0, 0.0)
			}
		],
		buttons: []
	};
	public static var getForwardNode:TNode = {
		id: 0,
		name:_tr("Get Forward"),
		type: "GetForwardNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Object"),
				type: "OBJECT",
				color: -4934476,
				default_value: null
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Forward Vec2"),
				type: "VECTOR2",
				color: -7929601,
				default_value: new kha.math.FastVector2(0.0, 0.0)
			}
		],
		buttons: []
	};
	public static var getWidthHeightNode:TNode = {
		id: 0,
		name:_tr("Get Width/Height"),
		type: "GetWidthHeightNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Object"),
				type: "OBJECT",
				color: -4934476,
				default_value: null
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Width/Height Vec2"),
				type: "VECTOR2",
				color: -7929601,
				default_value: new kha.math.FastVector2(0.0, 0.0)
			}
		],
		buttons: []
	};
	public static var setObjectLocationNode:TNode = {
		id: 0,
		name:_tr("Set Object Location"),
		type: "SetObjectLocationNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("In"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Object"),
				type: "OBJECT",
				color: -4934476,
				default_value: null
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Vec2"),
				type: "VECTOR2",
				color: -7929601,
				default_value: new kha.math.FastVector2(0.0, 0.0)
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Out"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			}
		],
		buttons: []
	};
	public static var getRotationNode:TNode = {
		id: 0,
		name:_tr("Get Rotation"),
		type: "GetRotationNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Object"),
				type: "OBJECT",
				color: -4934476,
				default_value: null
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Rotation"),
				type: "VALUE",
				color: -10183681,
				default_value: 0
			}
		],
		buttons: []
	};
	public static var translateObjectNode:TNode = {
		id: 0,
		name:_tr("Translate Object"),
		type: "TranslateObjectNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("In"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Object"),
				type: "OBJECT",
				color: -4934476,
				default_value: null
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Position Vec2"),
				type: "VECTOR2",
				color: -7929601,
				default_value: new kha.math.FastVector2(0.0, 0.0)
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Speed"),
				type: "VALUE",
				color: -10183681,
				default_value: 1.0
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Out"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			}
		],
		buttons: []
	};
	public static var rotateTowardPositionNode:TNode = {
		id: 0,
		name:_tr("Rotate Toward Position"),
		type: "RotateTowardPositionNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("In"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Object to Rotate"),
				type: "OBJECT",
				color: -4934476,
				default_value: null
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Position Vec2"),
				type: "VECTOR2",
				color: -7929601,
				default_value: new kha.math.FastVector2(0.0, 0.0)
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Out"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			}
		],
		buttons: []
	};
	public static var getObjectNode:TNode = {
		id: 0,
		name:_tr("Get Object"),
		type: "GetObjectNode",
		x: 200,
		y: 200,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("In"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Out"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Selected Object"),
				type: "OBJECT",
				color: -4934476,
				default_value: null
			}
		],
		buttons: [
			{
				name:_tr("selectedObjectName"),
				type: "ENUM",
				data: [""],
				output: 0,
				default_value: 0
			}
		],
		color: -4962746
	};
	public static var getRandomObjectNode:TNode = {
		id: 0,
		name:_tr("Get Random Object"),
		type: "GetRandomObjectNode",
		x: 200,
		y: 200,
		inputs: [],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Random Object from list"),
				type: "OBJECT",
				color: -4934476,
				default_value: null
			}
		],
		buttons: [
			{
				name:_tr("listOfObjects"),
				type: "ARRAY",
				data: [],
				output: 0,
				default_value: []
			}
		],
		color: -4962746
	};
	public static var spawnObjectNode:TNode = {
		id: 0,
		name:_tr("Spawn Object"),
		type: "SpawnObjectNode",
		x: 200,
		y: 200,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("In"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Object"),
				type: "OBJECT",
				color: -4934476,
				default_value: null
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Position Vec2"),
				type: "VECTOR2",
				color: -7929601,
				default_value: new kha.math.FastVector2(0.0, 0.0)
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Rotation"),
				type: "VALUE",
				color: -10183681,
				default_value: 0.0
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Out"),
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
		name:_tr("Destroy Object"),
		type: "DestroyObjectNode",
		x: 200,
		y: 200,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("In"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Object"),
				type: "OBJECT",
				color: -4934476,
				default_value: null
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Out"),
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
		name:_tr("Destroy Object Outside View"),
		type: "DestroyObjectOutsideViewNode",
		x: 200,
		y: 200,
		inputs: [			
			{
				id: 0,
				node_id: 0,
				name:_tr("Object"),
				type: "OBJECT",
				color: -4934476,
				default_value: null
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("OffsetFromView"),
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
		name:_tr("Is Object Outside View"),
		type: "IsObjectOutsideViewNode",
		x: 200,
		y: 200,
		inputs: [			
			{
				id: 0,
				node_id: 0,
				name:_tr("Object"),
				type: "OBJECT",
				color: -4934476,
				default_value: null
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("OffsetFromView"),
				type: "VALUE",
				color: -10183681,
				default_value: 0.0
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Out"),
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
		name:_tr("Flip Sprite"),
		type: "FlipSpriteNode",
		x: 200,
		y: 200,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("In"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 1,
				node_id: 0,
				name:_tr("selectedSpriteName"),
				type: "OBJECT",
				color: -4934476,
				default_value: null
			},
			{
				id: 2,
				node_id: 0,
				name:_tr("FlipX"),
				type: "BOOLEAN",
				color: -10822566,
				default_value: 0.0
			},
			{
				id: 3,
				node_id: 0,
				name:_tr("FlipY"),
				type: "BOOLEAN",
				color: -10822566,
				default_value: 0.0
			}
		],
		outputs: [],
		buttons: [
			{
				name:_tr("selectedSpriteName"),
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
		name:_tr("Apply Force To Rigidbody"),
		type: "ApplyForceToRigidbodyNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("In"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Object"),
				type: "OBJECT",
				color: -4934476,
				default_value: null
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Vec2"),
				type: "VECTOR2",
				color: -7929601,
				default_value: new kha.math.FastVector2(0.0, 0.0)
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Out"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			}
		],
		buttons: []
	};
	public static var applyImpulseToRigidbodyNode:TNode = {
		id: 0,
		name:_tr("Apply Impulse To Rigidbody"),
		type: "ApplyImpulseToRigidbodyNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("In"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Object"),
				type: "OBJECT",
				color: -4934476,
				default_value: null
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Vec2"),
				type: "VECTOR2",
				color: -7929601,
				default_value: new kha.math.FastVector2(0.0, 0.0)
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Out"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			}
		],
		buttons: []
	};
	public static var topDownControllerNode:TNode = {
		id: 0,
		name:_tr("Top-down Controller"),
		type: "TopDownControllerNode",
		x: 200,
		y: 200,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Custom Input Vec2"),
				type: "VECTOR2",
				color: -7929601,
				default_value: new kha.math.FastVector2(0.0, 0.0)
			},
			{
				id: 1,
				node_id: 0,
				name:_tr("Speed"),
				type: "VALUE",
				color: -10183681,
				default_value: 300.0
			}
		],
		outputs: [],
		buttons: [
			{
				name:_tr("inputType"),
				type: "ENUM",
				data: ["Use default input", "Use custom input"],
				output: 0,
				default_value: 0
			},
			{
				name:_tr("defaultUpKeyCode"),
				type: "KEY",
				output: 0,
				default_value: KeyCode.Up
			},
			{
				name:_tr("defaultDownKeyCode"),
				type: "KEY",
				output: 0,
				default_value: KeyCode.Down
			},
			{
				name:_tr("defaultLeftKeyCode"),
				type: "KEY",
				output: 0,
				default_value: KeyCode.Left
			},
			{
				name:_tr("defaultRightKeyCode"),
				type: "KEY",
				output: 0,
				default_value: KeyCode.Right
			}
		],
		color: -4962746
	};
	public static var platformer2DControllerNode:TNode = {
		id: 0,
		name:_tr("Platformer 2D Controller"),
		type: "Platformer2DControllerNode",
		x: 200,
		y: 200,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Custom Input Vec2"),
				type: "VECTOR2",
				color: -7929601,
				default_value: new kha.math.FastVector2(0.0, 0.0)
			},
			{
				id: 1,
				node_id: 0,
				name:_tr("Speed"),
				type: "VALUE",
				color: -10183681,
				default_value: 300.0
			},
			{
				id: 2,
				node_id: 0,
				name:_tr("Jump Force"),
				type: "VALUE",
				color: -10183681,
				default_value: 1000.0
			}
		],
		outputs: [],
		buttons: [
			{
				name:_tr("inputType"),
				type: "ENUM",
				data: ["Use default input", "Use custom input"],
				output: 0,
				default_value: 0
			},
			{
				name:_tr("defaultLeftKeyCode"),
				type: "KEY",
				output: 0,
				default_value: KeyCode.Left
			},
			{
				name:_tr("defaultRightKeyCode"),
				type: "KEY",
				output: 0,
				default_value: KeyCode.Right
			},
			{
				name:_tr("defaultJumpKeyCode"),
				type: "KEY",
				output: 0,
				default_value: KeyCode.Space
			}
		],
		color: -4962746
	};
	public static var bulletMovementNode:TNode = {
		id: 0,
		name:_tr("Bullet Movement"),
		type: "BulletMovementNode",
		x: 200,
		y: 200,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Reset Vel & angle"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Speed"),
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
		name:_tr("Set Camera Target Position"),
		type: "SetCameraTargetPositionNode",
		x: 200,
		y: 200,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("In"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 1,
				node_id: 0,
				name:_tr("Target Position Vec2"),
				type: "VECTOR2",
				color: -7929601,
				default_value: new kha.math.FastVector2(0.0, 0.0)
			},
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Out"),
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
		name:_tr("Set Camera Follow Target"),
		type: "SetCameraFollowTargetNode",
		x: 200,
		y: 200,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("In"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Object"),
				type: "OBJECT",
				color: -4934476,
				default_value: null
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Out"),
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
		name:_tr("Play Animation"),
		type: "PlayAnimationNode",
		x: 200,
		y: 200,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("In"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Animation Name"),
				type: "STRING",
				color: -4934476,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Object"),
				type: "OBJECT",
				color: -16067936,
				default_value: null
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Out"),
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
		name:_tr("On Collision"),
		type: "OnCollisionNode",
		x: 200,
		y: 200,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("In"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Selected Object"),
				type: "OBJECT",
				color: -4934476,
				default_value: null
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("On Enter"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("On Stay"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("On Exit"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Object collided"),
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
		name:_tr("Play Music"),
		type: "PlayMusicNode",
		x: 200,
		y: 200,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("In"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 1,
				node_id: 1,
				name:_tr("Music alias"),
				type: "STRING",
				color: -4934476,
				default_value: ""
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("OnFinished"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			}
		],
		buttons: [
			{
				name:_tr("loop"),
				type: "BOOL",
				output: 0,
				default_value: false
			},
			{
				name:_tr("volume"),
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
		name:_tr("Play Sound"),
		type: "PlaySfxNode",
		x: 200,
		y: 200,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("In"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 1,
				node_id: 1,
				name:_tr("Sound alias"),
				type: "STRING",
				color: -4934476,
				default_value: ""
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("OnFinished"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
		],
		buttons: [
			{
				name:_tr("volume"),
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
