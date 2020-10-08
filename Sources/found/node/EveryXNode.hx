package found.node;

import kha.Scheduler;

class EveryXNode extends LogicNode {

	public function new(tree:LogicTree) {
		super(tree);
		tree.notifyOnInit(init);
        tree.notifyOnUpdate(update);
	}
	function init(){
		everyX = inputs[0].get();
	}
	var everyX:Float;
	var lastTime:Float;
	function update(dt:Float) {
		var dif = Scheduler.time() - lastTime;
		if(dif >= everyX){
			lastTime = Scheduler.time();
			runOutput(0);
		}
		
	}
}
