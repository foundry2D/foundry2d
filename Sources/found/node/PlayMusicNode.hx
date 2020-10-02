package found.node;

import found.audio.Music;

@:keep
class PlayMusicNode extends LogicNode {
    public var loop:Bool = false; 
    public var volume:Float = 1.0;
    
	override function run(from:Int) {
        var name:String = inputs[1].get();
		Music.play(name,volume,loop);
	}
}
