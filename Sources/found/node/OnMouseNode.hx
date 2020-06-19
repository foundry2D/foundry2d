package found.node;

class OnMouseNode extends LogicNode {
	public var mouseEventType:String;
	public var mouseButton:String;

	static var mouseEventTypes:Array<String> = ["Pressed", "Down", "Released", "Moved"];

	public static function getMouseButtonEventTypes() {
		return mouseEventTypes;
	}

	public function new(tree:LogicTree) {
		super(tree);

		tree.notifyOnUpdate(update);
	}

	function update(dt:Float) {
		var mouse = Input.getMouse();
		var mouseEventOccured:Bool = false;

		switch (mouseEventType) {
			case "Pressed":
				mouseEventOccured = mouse.started(mouseButton);
			case "Down":
				mouseEventOccured = mouse.down(mouseButton);
			case "Released":
				mouseEventOccured = mouse.released(mouseButton);
			case "Moved":
				mouseEventOccured = mouse.moved;
		}

		if (mouseEventOccured) runOutput(0);
	}
}
