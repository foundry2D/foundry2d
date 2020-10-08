package found.node;

@:keep
@:access(found.Trait)
class EventListenNode extends LogicNode {

	public function new(tree:LogicTree) {
		super(tree);
		tree.notifyOnInit(addEvent);
		tree.notifyOnRemove(removeEvent);
	}
	var eventName:String;
	function addEvent() {
		eventName = inputs[0].get();
		if(eventName != "" && eventName != null){
			Event.add(eventName,onEvent,tree.object.uid);
		}
	}
	function removeEvent(){
		if(eventName != null)
			Event.remove(eventName);
	}
	function onEvent(){
		runOutput(0);
	}
}
