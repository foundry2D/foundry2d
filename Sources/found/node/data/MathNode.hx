package found.node.data;

import kha.Color;
import zui.Nodes.TNode;

class MathNode {
	public static inline function _tr(s: String) { return s; }
	public static var maths: TNode = {
		id: 0,
		name:_tr("Maths"),
		type: "MathNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Value"),
				type: "VALUE",
				color: -10183681,
				default_value: 0.0,
				max: 100.0
			},
			{
				id: 1,
				node_id: 0,
				name:_tr("Value"),
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
				name:_tr("value"),
				type: "Value",
				color: -10183681,
				default_value: 0.0
			}
		],
		buttons: [
			{
				name:_tr("operations"),
				type: "ENUM",
				data: ["Add", "Subtract", "Multiply", "Divide"],
				output: 0,
				default_value: 0
			}
		]
	}

	public static var radtodeg: TNode = {
		id: 0,
		name:_tr("Radian to Degre"),
		type: "RadToDegNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Rad"),
				type: "VALUE",
				color: -10183681,
				default_value: 0.0,
				max: 6.28
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Deg"),
				type: "Value",
				color: -10183681,
				default_value: 0.0
			}
		],
		buttons: []
	}

	public static var degtorad: TNode = {
		id: 0,
		name:_tr("Degree to Radian"),
		type: "DegToRadNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Deg"),
				type: "VALUE",
				color: -10183681,
				default_value: 0.0,
				max: 360.0
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name:_tr("Rad"),
				type: "Value",
				color: -10183681,
				default_value: 0.0
			}
		],
		buttons: []
	}

	public static var randf: TNode = {
		id: 0,
		name:_tr("Random (Float)"),
		type: "RandFNode",
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
				default_value: 0.0,
				max: 100.0
			},
			{
				id: 1,
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
				type: "Value",
				color: -10183681,
				default_value: 0.0
			}
		],
		buttons: []
	}

	public static var randi: TNode = {
		id: 0,
		name:_tr("Random (Int)"),
		type: "RandINode",
		x: 200,
		y: 200,
		color: -4962746,
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
			},
			{
				id: 1,
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
				type: "Value",
				color: -10183681,
				default_value: 0
			}
		],
		buttons: []
	}
}
