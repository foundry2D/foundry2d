package found.node.data;

import kha.Color;
import zui.Nodes.TNode;

class StdNode {
	public static inline function _tr(s: String) { return s; }
	public static var parseInt: TNode = {
		id: 0,
		name:_tr("Parse Int"),
		type: "ParseIntNode",
		x: 200,
		y: 200,
		color: -4962746,
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
				name:_tr("Int"),
				type: "VALUE",
				color: -10183681,
				default_value: ""
			}
		],
		buttons: []
	}

	public static var parseFloat: TNode = {
		id: 0,
		name:_tr("Parse Float"),
		type: "ParseFloatNode",
		x: 200,
		y: 200,
		color: -4962746,
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
				name:_tr("Float"),
				type: "VALUE",
				color: -10183681,
				default_value: ""
			}
		],
		buttons: []
	}

	public static var floatToInt: TNode = {
		id: 0,
		name:_tr("Float to Int"),
		type: "FloatToIntNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Float"),
				type: "VALUE",
				color: -10183681,
				default_value: ""
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Int"),
				type: "VALUE",
				color: -10183681,
				default_value: ""
			}
		],
		buttons: []
	}

	public static var print: TNode = {
		id: 0,
		name:_tr("Print"),
		type: "PrintNode",
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
				id: 1,
				node_id: 0,
				name:_tr("Value"),
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
		buttons: []
	}

}
