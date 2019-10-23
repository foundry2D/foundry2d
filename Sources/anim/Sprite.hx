package anim;

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

import object.Entity;
import tool.Util;
import data.Data;
import data.SpriteData;
import data.SceneFormat;


class Sprite extends Entity {
	private var data:SpriteData;
	
	private var _w: Float;
	private var _h: Float;

	public var flip:Vector2;
	
	public function new(sprite:TSpriteData){
		super(sprite.position.x, sprite.position.y, sprite.width, sprite.height);
		this.active = sprite.active;
		this.flip = sprite.flip;
		new SpriteData(sprite,function(p_data){
			this.data = p_data;
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
	
	override public function update(): Void {
		super.update();
		data.animation.next();
	}
	
	override public function render(canvas: Canvas): Void {
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
	
	function get_width(): Float {
		return _w;
	}
	
	function set_width(value: Float): Float {
		return _w = value;
	}
	
	function get_height(): Float {
		return _h;
	}
	
	function set_height(value: Float): Float {
		return _h = value;
	}
}
