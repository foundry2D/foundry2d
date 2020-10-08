package found.node;

import kha.Scheduler;

class CooldownNode extends LogicNode {

	public function new(tree:LogicTree) {
		super(tree);
		tree.notifyOnInit(init);
	}
	function init(){
		cooldown = inputs[1].get();
		lastTime = Scheduler.time();
	}
	var cooldown:Float;
	var lastTime:Float;
	override function run(from:Int) {
		var dif = Scheduler.time() - lastTime;
		if(dif >= cooldown){
			lastTime = Scheduler.time();
			runOutput(0);
		}
	}
}
