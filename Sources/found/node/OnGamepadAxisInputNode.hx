package found.node;

import found.Input.Gamepad;

class OnGamepadAxisInputNode extends LogicNode {
	public var selectedAxisName:String;

	var deadZone = 0.1;
	var selectedAxisValue:Float = 0;

	public function new(tree:LogicTree) {
		super(tree);

		tree.notifyOnUpdate(update);
	}

	function update(dt:Float) {
		var gamepadIndex:Int = inputs[0].get();
		var gamepad:Gamepad = Input.getGamepad(gamepadIndex);

		if (gamepad == null)
			return;

		selectedAxisValue = gamepad.getAxisInformation(selectedAxisName).value;
		if (selectedAxisValue < deadZone && selectedAxisValue > -deadZone) {
			selectedAxisValue = 0;
		}

		if (gamepad.getAxisInformation(selectedAxisName).moved) {
			runOutput(0);
		}
	}

	override function get(from:Int):Dynamic {
		return selectedAxisValue;
	}
}
