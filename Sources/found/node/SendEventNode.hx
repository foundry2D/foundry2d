package found.node;

import found.object.Object;

@:keep
@:access(found.Trait)
class SendEventNode extends LogicNode {

	public function new(tree:LogicTree) {
		super(tree);
		
	}
	override function run(from:Int) {
		var eventName:String = inputs[1].get();
		var object:Object = inputs[2].get();
		var mask = object != null ? object.uid: -1;
		Event.send(eventName,mask);
	}
}
