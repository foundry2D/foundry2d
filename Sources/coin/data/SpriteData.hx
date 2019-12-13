package coin.data;

import kha.Image;
import kha.Blob;

import coin.anim.Animation;
import coin.data.SceneFormat;

class SpriteData {
	public var name:String;
	public var image:Image;
	public var animation(get,null):Animation;
	function get_animation(){
		return anims[curAnim];
	}
	private var anims:Array<Animation>;
	public var animatable(get,never):Bool;
	@:access(coin.anim.Animation)
	function get_animatable(){
		if(anims == null)return false;
		return animation._indices.length >1;
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
			if(raw.animsPath!= null){
				var i = 0;
				for(a in raw.animsPath){
					Data.getBlob(a,animLoaded);
				}
				done(this);
			}
			else {
				addSubSprite(0);
				done(this);
			}
		});
	}
	public function addSubSprite(index:Int){
		return anims.push(Animation.create(index))-1;
	}
	function animLoaded(data:Blob) {
		var anim:TAnimation = haxe.Json.parse(data.toString());
		anims.push(Animation.createRange(anim.min,anim.max,anim.fps));
	}
}