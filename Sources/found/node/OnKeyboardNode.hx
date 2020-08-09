package found.node;

import found.Input.Keyboard;

class OnKeyboardNode extends LogicNode {
	public var keyboardEventType:String;
	public var keyCode:String;

	static var keyboardEventTypes:Array<String> = ["Pressed", "Down", "Released"];

	public static function getKeyboardEventTypes() {
		return keyboardEventTypes;
	}

	public function new(tree:LogicTree) {
		super(tree);

		tree.notifyOnUpdate(update);
	}

	function update(dt:Float) {
		var keyboard:Keyboard = Input.getKeyboard();
		var keyboardEventOccured:Bool = false;

		switch (keyboardEventType) {
			case "Pressed":
				keyboardEventOccured = keyboard.started(keyCode);
			case "Down":
				keyboardEventOccured = keyboard.down(keyCode);
			case "Released":
				keyboardEventOccured = keyboard.released(keyCode);
		}

		if (keyboardEventOccured)
			
			runOutput(0);
	}
}
