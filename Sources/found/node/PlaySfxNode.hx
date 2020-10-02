package found.node;

import found.audio.Sfx;

@:keep
class PlaySfxNode extends LogicNode {
    public var volume:Float;
    
	override function run(from:Int) {
        var name:String = inputs[1].get();
		Sfx.play(name,volume);
	}
}
