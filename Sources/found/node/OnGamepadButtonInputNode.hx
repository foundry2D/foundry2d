package found.node;

import found.Input.Gamepad;

class OnGamepadButtonInputNode extends LogicNode {
	static var buttonEventTypes:Array<String> = ["Pressed", "Down", "Released"];

	public var selectedButtonEventType:String;
	public var selectedButtonName:String;

	var selectedButtonValue:Int = 0;

	public static function getButtonEventTypes() {
		return buttonEventTypes;
	}

	public function new(tree:LogicTree) {
		super(tree);

		tree.notifyOnUpdate(update);
	}

	function update(dt:Float) {
		var gamepadIndex:Int = inputs[0].get();
		var gamepad:Gamepad = Input.getGamepad(gamepadIndex);
		var gamepadEventOccured:Bool = false;

		if (gamepad == null)
			return;

		switch (selectedButtonEventType) {
			case "Pressed":
				gamepadEventOccured = gamepad.started(selectedButtonName);
			case "Down":
				gamepadEventOccured = gamepad.down(selectedButtonName) > 0.0;
			case "Released":
				gamepadEventOccured = gamepad.released(selectedButtonName);
		}

		if (gamepadEventOccured) {
			selectedButtonValue = 1;
			runOutput(0);
		} else {
			selectedButtonValue = 0;
		}
	}

	override function get(from:Int):Dynamic {
		return selectedButtonValue;
	}
}
