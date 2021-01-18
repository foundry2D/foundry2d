package found.node.data;

import kha.Color;
import zui.Nodes.TNode;

class LogicNode {
	public static inline function _tr(s: String) { return s; }
	public static var gate: TNode = {
		id: 0,
		name:_tr("Gate"),
		type: "GateNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 1,
				node_id: 0,
				name:_tr("Dynamic"),
				type: "BOOLEAN",
				color: 0xff99FFDB,
				default_value: null
			},
			{
				id: 2,
				node_id: 0,
				name:_tr("Dynamic"),
				type: "BOOLEAN",
				color: 0xff99FFDB,
				default_value: null
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Bool"),
				type: "BOOLEAN",
				color: -10822566,
				default_value: 0.0
			}
		],
		buttons: [
			{
				name:_tr("operations"),
				type: "ENUM",
				data: GateNode.getOperationsNames(),
				default_value: 0
			}
		]
	}
	public static var branch: TNode = {
		id: 0,
		name:_tr("Branch"),
		type: "BranchNode",
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
				default_value: 0.0
			},
			{
				id: 1,
				node_id: 0,
				name:_tr("Bool"),
				type: "BOOLEAN",
				color: -10822566,
				default_value: 0.0
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("True"),
				type: "BOOL",
				color: -10822566,
				default_value: 0.0
			},
			{
				id: 1,
				node_id: 0,
				name:_tr("False"),
				type: "BOOL",
				color: -10822566,
				default_value: 0.0
			}
		],
		buttons: []
	}
	public static var isFalse: TNode = {
		id: 0,
		name:_tr("Is False"),
		type: "IsFalseNode",
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
				default_value: 0.0
			},
			{
				id: 1,
				node_id: 0,
				name:_tr("Bool"),
				type: "BOOLEAN",
				color: -10822566,
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
				default_value: 0.0
			}
		],
		buttons: []
	}
	public static var isTrue: TNode = {
		id: 0,
		name:_tr("Is True"),
		type: "IsTrueNode",
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
				default_value: 0.0
			},
			{
				id: 1,
				node_id: 0,
				name:_tr("Bool"),
				type: "BOOLEAN",
				color: -10822566,
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
				default_value: 0.0
			}
		],
		buttons: []
	}
	public static var whileN: TNode = {
		id: 0,
		name:_tr("While"),
		type: "WhileNode",
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
				default_value: 0.0
			},
			{
				id: 1,
				node_id: 0,
				name:_tr("Condition"),
				type: "BOOLEAN",
				color: -10822566,
				default_value: 0.0
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Loop"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: 0.0
			},
			{
				id: 0,
				node_id: 0,
				name:_tr("Done"),
				type: "ACTION",
				color: 0xffaa4444,
				default_value: 0.0
			}
		],
		buttons: []
	}
}
