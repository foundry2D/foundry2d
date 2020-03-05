package found.node;

import found.State;

class GamepadButtonInputNode extends LogicNode {
	public var selectedButtonEventType:String;
	public var selectedButtonName:String;

	var buttonsXBOX = [
		"a", "b", "x", "y", "l1", "r1", "l2", "r2", "share", "options", "l3", "r3", "up", "down", "left", "right", "home", "touchpad"
	];

	var buttonDown:Bool = false;

	public function new(tree:LogicTree) {
		super(tree);

		tree.notifyOnInit(function() {
			State.active.notifyOnGamepadButton(onGamepadButtonEvent);
		});

		tree.notifyOnUpdate(update);

		tree.notifyOnRemove(function() {
			State.active.removeOnGamepadButton(onGamepadButtonEvent);
		});
	}

	function update(dt:Float) {
		if (buttonDown) {
			runOutput(0);
		}
	}

	function onGamepadButtonEvent(p_buttonId:Int, p_buttonValue:Float) {
		if (buttonsXBOX[p_buttonId] == selectedButtonName) {
			var buttonEvent:String = getButtonEvent(p_buttonValue);
			if (buttonEvent == selectedButtonEventType) {
				runOutput(0);
			} else if (selectedButtonEventType == "Down") {
				if (buttonEvent == "Pressed") {
					buttonDown = true;
				} else {
					buttonDown = false;
				}
			}
		}
	}

	function getButtonEvent(buttonValue:Float):String {
		if (buttonValue > 0) {
			return "Pressed";
		} else {
			return "Released";
		}
	}
}
