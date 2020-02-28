package found.node;

import found.State;

class OnGamepadAxisNode extends LogicNode {
	public var axisName:String;

	var axisValue:Float = 0;

	public function new(tree:LogicTree) {
		super(tree);

		tree.notifyOnInit(function() {
			State.active.notifyOnGamepadAxis(onGamepadAxisEvent);
		});

		tree.notifyOnUpdate(update);

		tree.notifyOnRemove(function() {
			State.active.removeOnGamepadAxis(onGamepadAxisEvent);
		});
	}

	function update(dt:Float) {
		if (axisValue >= 0.1 || axisValue <= -0.1) {
			runOutput(0);
		}
	}

	override function get(from:Int):Dynamic {
		return axisValue;
	}

	function onGamepadAxisEvent(p_axisId:Int, p_axisValue:Float) {
		if (getAxisId(axisName) == p_axisId) {
			if (p_axisValue >= 0.1 || p_axisValue <= -0.1) {
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
			case "Left Bumper":
				axisId = 4;
			case "Right Bumper":
				axisId = 5;
		}
		return axisId;
	}
}
