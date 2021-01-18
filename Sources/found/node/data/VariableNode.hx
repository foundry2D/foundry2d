package found.node.data;

import kha.Color;
import zui.Nodes.TNode;

class VariableNode {
	public static inline function _tr(s: String) { return s; }
	public static var string:TNode = {
		id: 0,
		name:_tr("String"),
		type: "StringNode",
		x: 200,
		y: 200,
		color: -16067936,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("String"),
				type: "STRING",
				color: -4934476,
				default_value: ""
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("String"),
				type: "STRING",
				color: -4934476,
				default_value: ""
			}
		],
		buttons: []
	}

	public static var float:TNode = {
		id: 0,
		name:_tr("Float"),
		type: "FloatNode",
		x: 200,
		y: 200,
		color: -16067936,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Float"),
				type: "VALUE",
				color: -10183681,
				default_value: 0.0,
				max: 100.0
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Float"),
				type: "VALUE",
				color: -10183681,
				default_value: 0.0
			}
		],
		buttons: []
	}

	public static var int:TNode = {
		id: 0,
		name:_tr("Int"),
		type: "IntegerNode",
		x: 200,
		y: 200,
		color: -16067936,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Int"),
				type: "VALUE",
				color: -10183681,
				default_value: 0,
				max: 100,
				// precision: 1
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Int"),
				type: "VALUE",
				color: -10183681,
				default_value: 0
			}
		],
		buttons: []
	}

	public static var boolean:TNode = {
		id: 0,
		name:_tr("Boolean"),
		type: "BoolNode",
		x: 200,
		y: 200,
		color: -16067936,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Bool"),
				type: "BOOLEAN",
				color: -10822566,
				default_value: ""
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Bool"),
				type: "BOOLEAN",
				color: -10822566,
				default_value: ""
			}
		],
		buttons: []
	}

	public static var vector2:TNode = {
		id: 0,
		name:_tr("Vector2"),
		type: "Vector2Node",
		x: 200,
		y: 200,
		color: -16067936,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("X"),
				type: "VALUE",
				color: -10183681,
				default_value: 0.0,
				max: 100.0
			},
			{
				id: 1,
				node_id: 0,
				name:_tr("Y"),
				type: "VALUE",
				color: -10183681,
				default_value: 0.0,
				max: 100.0
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
			},
			{
				id: 1,
				node_id: 0,
				name:_tr("Normalised Vec2"),
				type: "VECTOR2",
				color: -7929601,
				default_value: [0.0, 0.0]
			}
		],
		buttons: []
	}
	public static var getProp:TNode = {
		id: 0,
		name:_tr("Get Property"),
		type: "GetPropNode",
		x: 200,
		y: 200,
		color: -16067936,
		inputs: [
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Prop"),
				type: "VALUE",
				color: -10183681,
				default_value: null
			}
		],
		buttons: [
			{
				name:_tr("classname"),
				type: "ENUM",
				data: [],
				output:0,
				default_value: 0
			},
			{
				name:_tr("propertyName"),
				type: "ENUM",
				data: [],
				output: 0,
				default_value: 0
			}
		]
	}
	public static var setProp:TNode = {
		id: 0,
		name:_tr("Set Property"),
		type: "SetPropNode",
		x: 200,
		y: 200,
		color: -16067936,
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
				name:_tr("Value"),
				type: "VALUE",
				color: -10183681,
				default_value: null
			}
		],
		outputs: [
			
		],
		buttons: [
			{
				name:_tr("classname"),
				type: "ENUM",
				data: [],
				output:0,
				default_value: 0
			},
			{
				name:_tr("propertyName"),
				type: "ENUM",
				data: [],
				output: 0,
				default_value: 0
			}
		]
	}
}
