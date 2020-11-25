package found.node;

import kha.input.KeyCode;
import found.Input.Keyboard;

class OnKeyboardNode extends LogicNode {
	public var keyboardEventType:String;
	public var keyCode:KeyCode;

	static var keyboardEventTypes:Array<String> = ["Pressed", "Down", "Released"];
	var isDown:Bool = false;
	public static function getKeyboardEventTypes() {
		return keyboardEventTypes;
	}

	public function new(tree:LogicTree) {
		super(tree);

		tree.notifyOnUpdate(update);
	}
	var lastKey:KeyCode;
	var keyName:String;
	function update(dt:Float) {
		var keyboard:Keyboard = Input.getKeyboard();
		var keyboardEventOccured:Bool = false;

		if(lastKey != keyCode){
			keyName = Input.Keyboard.keyCode(keyCode);
			lastKey = keyCode;
		}
		
		switch (keyboardEventType) {
			case "Pressed":
				keyboardEventOccured = keyboard.started(keyName);
			case "Down":
				keyboardEventOccured = keyboard.down(keyName);
			case "Released":
				keyboardEventOccured = keyboard.released(keyName);
		}

		isDown = keyboardEventOccured;
		
		if (keyboardEventOccured)
			runOutput(0);
	}
	override function get(from:Int):Dynamic {
		return isDown;
	}
}
