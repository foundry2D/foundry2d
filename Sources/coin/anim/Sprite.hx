package coin.anim;

/*
Originally coded & created by Robert Konrad
http://robdangero.us
https://github.com/Kha-Samples/Kha2D

Edited for the Kha Tutorial Series by Lewis Lepton
https://lewislepton.com
https://github.com/lewislepton/kha-tutorial-series

Edited for the Coin Engine by Jean-Sébastien Nadeau
https://github.com/mundusnine/coin
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
			this.raw = Reflect.copy(data.raw);
			if (this.width  == 0 && data.image != null) this.width  = data.image.width;
			if (this.height == 0 && data.image != null) this.height = data.image.height;
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
			canvas.g2.pushTranslation(position.x,position.y);
			canvas.g2.rotate(Util.degToRad(rotation), position.x + width/ 2,position.y + height/ 2);
			canvas.g2.drawScaledSubImage(data.image, Std.int(data.animation.get() * _w) % data.image.width, Math.floor(data.animation.get() * _w / data.image.width) * _h, _w, _h, (flip.x > 0.0 ? width:0), (flip.y > 0.0 ? height:0), (flip.x > 0.0 ? -width:width), (flip.y > 0.0 ? -height:height));
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
	
	override function set_width(value: Float): Float {
		super.set_width(value);
		return _w = value;
	}
	
	override function set_height(value: Float): Float {
		super.set_height(value);
		return _h = value;
	}
	#if editor
	// @:Incomplete: this should take into account the animations but it does not
	override function refreshObjectData(obj:TObj) {
		super.refreshObjectData(obj);
		var imgPath = Reflect.getProperty(obj,"imagePath");
		if(data.name != imgPath){
			var out:TSpriteData = cast(obj);
			out.imagePath = imgPath;
			new SpriteData(out,function(p_data){
				this.data = p_data;
				this.width = this.data.raw.width = p_data.image.width;
				this.height = this.data.raw.height= p_data.image.height;
				this.raw = this.data.raw;
				if(EditorHierarchy.inspector != null)
            		EditorHierarchy.inspector.updateField(uid,"imagePath",this.raw);
			});
		}
	}
	#end
}
