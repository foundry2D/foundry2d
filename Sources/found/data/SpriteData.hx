package found.data;

import kha.Image;
import kha.Blob;

import found.anim.Animation;
import found.data.SceneFormat;

class SpriteData {
	public var name:String;
	public var image:Image;
	public var animation(get,null):Animation;
	function get_animation(){
		return anims[curAnim];
	}
	private var anims:Array<Animation>;
	public var animatable(get,never):Bool;
	@:access(found.anim.Animation)
	function get_animatable(){
		if(anims == null)return false;
		return animation._frames.length >1;
	}
	public var curAnim(default,set):Int = 0;
	function set_curAnim(index:Int){
		if(anims.length < index){
			trace('Trying to set animation with index: $index but the number of animations is:'+anims.length);
		}else{
			curAnim =index;
		}
		return curAnim;
	}
	public var raw:TSpriteData;

	public function new(raw:TSpriteData,done:SpriteData->Void){
		this.raw = raw;
		Data.getImage(raw.imagePath,function (img:Image){
			this.image = img;
			anims = [];
			name = this.raw.imagePath;
			if( raw.anims != null && raw.anims.length != 0){
				for(a in raw.anims){
					animLoad(a);
				}
				done(this);
			}
			else {
				addSubSprite(0);
				done(this);
			}
		});
	}
	public function addSubSprite(index:Int,?width:Null<Int>,?height:Null<Int>){
		var w = width != null  ? width: Std.int(raw.width);
		var h = height != null ? height: Std.int(raw.height);
		var frame:TFrame = {id:index,start:0.0,tw:w,th:h};
		return anims.push(Animation.create(frame))-1;
	}

	public function setCurrentAnimationByName(animationName:String) {
		for (i in 0...anims.length) {
			if (anims[i].name == animationName) {
				curAnim = i;
				return;
			}				
		}

		trace('Animation with name: $animationName does not exist');
	}

	function animLoad(anim:TAnimation) {
		anims.push(Animation.fromDefinition(anim));
	}
}