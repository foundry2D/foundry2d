package found.node;

import found.State;

class GamepadAxisInputNode extends LogicNode {
	public var axisName:String;

	var deadZone = 0.2;
	var axisValue:Float = 0;

	public function new(tree:LogicTree) {
		super(tree);

		tree.notifyOnInit(function() {
			State.active.notifyOnGamepadAxis(onGamepadAxisEvent);
		});

		tree.notifyOnRemove(function() {
			State.active.removeOnGamepadAxis(onGamepadAxisEvent);
		});
	}

	override function get(from:Int):Dynamic {
		return axisValue;
	}

	function onGamepadAxisEvent(p_axisId:Int, p_axisValue:Float) {
		if (getAxisId(axisName) == p_axisId) {
			if (p_axisValue >= deadZone || p_axisValue <= -deadZone) {
				axisValue = p_axisValue;
			} else {
				axisValue = 0;
			}
		}
	}

	function getAxisId(string:String) {
		var axisId:Int = 0;
		switch (string) {
			case "Left Joystick X":
				axisId = 0;
			case "Left Joystick Y":
				axisId = 1;
			case "Right Joystick X":
				axisId = 2;
			case "Right Joystick Y":
				axisId = 3;
			case "Left Trigger":
				axisId = 4;
			case "Right Trigger":
				axisId = 5;
		}
		return axisId;
	}
}
