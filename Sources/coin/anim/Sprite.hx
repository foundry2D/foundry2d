package coin.anim;

/*
Originally coded & created by Robert Konrad
http://robdangero.us
https://github.com/Kha-Samples/Kha2D

Edited for the Kha Tutorial Series by Lewis Lepton
https://lewislepton.com
https://github.com/lewislepton/kha-tutorial-series
*/


import kha.Canvas;
import kha.Color;
import kha.math.Vector2;
import kha.Assets;

import coin.object.Entity;
import coin.tool.Util;
import coin.data.Data;
import coin.data.SpriteData;
import coin.data.SceneFormat;


class Sprite extends Entity {
	private var data:SpriteData;
	
	private var _w: Float;
	private var _h: Float;

	public var flip:Vector2;
	
	public function new(sprite:TSpriteData,?done:Sprite->Void){
		super(sprite.position.x, sprite.position.y, sprite.width, sprite.height);
		this.active = sprite.active;
		this.flip = Reflect.hasField(sprite,"flip") ? sprite.flip:new Vector2();
		new SpriteData(sprite,function(p_data){
			this.data = p_data;
			this.raw = data.raw;
			#if debug
			this.name = this.raw.name;
			#end
			done(this);
		});
		// data.image = Reflect.field(Assets.images, imagename);
		// _w = width;
		// _h = height;
		// if (this.width  == 0 && _image != null) this.width  = _image.width;
		// if (this.height == 0 && _image != null) this.height = _image.height;
		// _animation = Animation.create(0);

	}
	
	public function setAnimation(animation: Int): Void {
		data.curAnim = animation;
	}
	
	override public function update(dt:Float): Void {
		if(data == null)return;
		super.update(dt);
		data.animation.next();
	}
	
	override public function render(canvas: Canvas): Void {
		if(data == null)return;
		super.render(canvas);
		if (data.image != null) {
			canvas.g2.color = Color.White;
			canvas.g2.pushTranslation(position.x, position.y);
			canvas.g2.rotate(Util.degToRad(rotation), position.x + width / 2, position.y + height / 2);
			canvas.g2.drawScaledSubImage(data.image, Std.int(data.animation.get() * _w) % data.image.width, Math.floor(data.animation.get() * _w / data.image.width) * _h, _w, _h, (flip.x > 0.0 ? width:0), (flip.y > 0.0 ? height:0), flip.x > 0.0 ? -width:width, flip.y > 0.0 ? -height:height);
			canvas.g2.popTransformation();
		}
	}
	
	public function set(imagename:String): Void {
		Data.getImage(imagename,function(img:kha.Image){
			data.image = img;
		});
	}
	
	public function outOfView(): Void {
		
	}
	
	override function get_width(): Float {
		return _w;
	}
	
	override function set_width(value: Float): Float {
		return _w = value;
	}
	
	override function get_height(): Float {
		return _h;
	}
	
	override function set_height(value: Float): Float {
		return _h = value;
	}
}
