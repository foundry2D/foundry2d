package coin.anim;

import kha.math.Vector2;

import coin.object.Entity;

import coin.data.SpriteData;
import coin.data.SceneFormat;

class Tile {
	private var map:Tilemap;
	//Id in the tilesheet
	private var tileId:Int;
    private var dataId:Int;
	// This is the tilesheet
	private var data(get,never):SpriteData;
	function get_data() {
		return map.imageData[dataId];
	}
	private var offsetx:Int = 0;
	private var offsety:Int = 0;
	private var _w: Float;
	private var _h: Float;

	public var flip:Vector2;

    public function new(tilemap:Tilemap,sprite:TSpriteData,?done:Tile->Void){
		// super(sprite.position.x, sprite.position.y, sprite.width, sprite.height);
		this.map = tilemap;
		this.active = sprite.active;
		this.flip = Reflect.hasField(sprite,"flip") ? sprite.flip:new Vector2();
		new SpriteData(sprite,function(p_data){
			var ids:{dataId:Int,tileId:Int} = map.addData(p_data);
			dataId = ids.dataId;
			tileId = ids.tileId;
			this.raw = Reflect.copy(data.raw);
			// if (this.width  == 0 && data.image != null) this.width  = data.image.width;
			// if (this.height == 0 && data.image != null) this.height = data.image.height;
			#if debug
			this.name = this.raw.name;
			#end
			if(Reflect.hasField(sprite,"scale") && sprite.scale != null){
				this.resize(function(data:Vector2){
					data.x = sprite.scale.x;
					data.y = sprite.scale.y;
					return data;
				});
			}
			done(this);
		});

	}
	public function setAnimation(animation: Int): Void {
		data.curAnim = animation;
	}
	
	// public function update(dt:Float): Void {
	// 	if(data == null)return;
	// 	super.update(dt);
	// 	data.animation.next();
	// }
	
	public function render(canvas: Canvas,position:Vector2): Void {
		if(data == null)return;
		if(data.animatable)
			data.animation.next();
		super.render(canvas);
		if (data.image != null) {
			canvas.g2.color = Color.White;
			canvas.g2.pushTranslation(position.x,position.y);
			// canvas.g2.rotate(Util.degToRad(rotation), position.x + width/ 2,position.y + height/ 2);
			canvas.g2.drawScaledSubImage(data.image, offsetx+Std.int(data.animation.get() * _w) % data.image.width, offsety+Math.floor(data.animation.get() * _w / data.image.width) * _h, _w, _h, (flip.x > 0.0 ? width:0), (flip.y > 0.0 ? height:0), (flip.x > 0.0 ? -width:width), (flip.y > 0.0 ? -height:height));
			canvas.g2.popTransformation();
		}
	}
}