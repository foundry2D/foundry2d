package found.node;

import found.math.Util;
import kha.math.Vector2;
import found.object.Object;

class GetForwardNode extends LogicNode {
	#if debug_nodes
	public function new(tree:LogicTree) {
		super(tree);
		tree.notifyOnRender2D(debugDraw);
	}
	function debugDraw(g2:kha.graphics2.Graphics){
		var pos:Vector2 = tree.object.center;
		var forward:Vector2  = this.get(0);
		forward = forward.mult(50);
		g2.color = 0xaa0000ff;
		g2.fillRect(pos.x + forward.x,pos.y + forward.y,10,10);
		g2.color = 0xffffffff;
	}
	#end
	override function get(from:Int):Dynamic {
		
		var angle = Util.degToRad(inputs[0].node == null ? 
		tree.object.rotation.z:
		cast(inputs[0].get(),Object).rotation.z);
		return new Vector2(Math.cos(angle),Math.sin(angle));
	}
}
