package found.node;

import found.anim.Sprite;
import found.object.Object;

@:keep
class FlipSpriteNode extends LogicNode {
    public var selectedSpriteName:String = "";

    public var value: Bool;
    var lastselectedSpriteName:String = "";
	var selectedSprite:Sprite = null;

	public function new(tree:LogicTree) {
		super(tree);
	}

	override function run(from:Int) {
        var sprite:Null<Object> = inputs[1].get();
        if(sprite != null && sprite.raw.type == "sprite_object"){
            selectedSprite = cast(sprite);
        }
        else {
            selectedSprite = get(0);
        }
        var flipX = inputs[2].get();
        var flipY = inputs[3].get();
        if(selectedSprite != null){
            selectedSprite.flip.x = flipX ? 1.0 : -1.0;
            selectedSprite.flip.y = flipY ? 1.0 : -1.0;
        }
        #if debug
        else{
            var x  = flipX != null;
            var y  = flipY != null;
            error('The boolean value for flipX/Y: $x : $y  and the sprite was $selectedSprite');
        }
        #end
	}

	override function get(from:Int):Dynamic {
		if (selectedSprite == null || lastselectedSpriteName != selectedSpriteName) {
			lastselectedSpriteName = selectedSpriteName;
			selectedSprite = cast(State.active.getObject(selectedSpriteName),Sprite);
		}
		return selectedSprite;
	}

}
