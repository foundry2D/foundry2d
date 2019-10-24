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
	public var curAnim:Int = 0;
	public var raw:TSpriteData;

	public function new(raw:TSpriteData,done:SpriteData->Void){
		this.raw = raw;
		Data.getImage(raw._imagePath,function (img:Image){
			this.image = img;
			anims = [];
			if(raw.animsPath!= null){
				var i = 0;
				for(a in raw.animsPath){
					Data.getBlob(a,animLoaded);
				}
				done(this);
			}
			else {
				anims.push(Animation.create(0));
				done(this);
			}
		});
	}
	function animLoaded(data:Blob) {
		var anim:TAnimation = haxe.Json.parse(data.toString());
		anims.push(Animation.createRange(anim.min,anim.max,anim.fps));
	}
}