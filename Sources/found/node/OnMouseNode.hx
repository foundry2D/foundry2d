package found.node;

class OnMouseNode extends LogicNode {

	public var mouseEventType: String;
	public var mouseButton: String;
    var func:(Int, Int, Int) -> Void;
    var moveFunc:(Int, Int, Int,Int) -> Void;
	public function new(tree: LogicTree) {
		super(tree);
        tree.notifyOnUpdate(update);
        func = function(button:Int, x:Int, y:Int){
            if(getMouseButton(mouseButton)==button){
                runOutput(0);
            }
        };
        moveFunc = function (x:Int, y:Int, cx:Int, cy:Int){
            runOutput(0);
        };
	}

	function update(dt:Float) {
		switch (mouseEventType) {
            case "Released":
                State.active.notifyOnMouseUp(func);
                State.active.removeOnMouseDown(func);
                State.active.removeOnMouseMove(moveFunc);
            case "Down":
                State.active.notifyOnMouseDown(func);
                State.active.removeOnMouseUp(func);
                State.active.removeOnMouseMove(moveFunc);
            case "Move":
                State.active.notifyOnMouseMove(moveFunc);
                State.active.removeOnMouseUp(func);
                State.active.removeOnMouseDown(func);
		}
	}

    function getMouseButton(string:String):Int {
        var btn: Int = 0;
        switch (string){
            case "Left": btn = 0;
            case "Right": btn = 1;
            case "Middle": btn = 2;
        }
        return btn;
    }
}