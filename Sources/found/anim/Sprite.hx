package found.anim;

/*
Originally coded & created by Robert Konrad
http://robdangero.us
https://github.com/Kha-Samples/Kha2D

Edited for the Kha Tutorial Series by Lewis Lepton
https://lewislepton.com
https://github.com/lewislepton/kha-tutorial-series

Edited for the Foundry Engine by Jean-Sébastien Nadeau
https://github.com/foundry2D/foundry2d
*/


import kha.Canvas;
import kha.Color;
import kha.math.Vector2;
import kha.Assets;
import found.object.Object;
import found.math.Util;
import found.data.Data;
import found.data.SpriteData;
import found.data.SceneFormat;


class Sprite extends Object {
	private var data:SpriteData;
	private var _w: Float;
	private var _h: Float;

	public var flip:Vector2;
	
	public function new(sprite:TSpriteData,?done:Sprite->Void){
		super(sprite);
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
	
	override function get_raw():TObj {
		return this.data.raw;
	}

	public function setAnimation(animation: Int): Void {
		data.curAnim = animation;
	}

	public function setAnimationByName(animationName: String): Void {		
		data.setCurrentAnimationByName(animationName);
	}
	
	override function update(dt:Float): Void {
		if(data == null)return;
		super.update(dt);
		data.animation.next();
	}
	
	override public function render(canvas: Canvas): Void {
		if(data == null)return;
		super.render(canvas);
		if (data.image != null) {
			var frame = data.animation.get();
			var tx = frame.tx != null ? frame.tx: Std.int(frame.id * _w) % data.image.width;
			var ty = frame.ty != null ? frame.ty: Math.floor(frame.id * _w / data.image.width) * _h;
			var w = width*scale.x;
			var h = height*scale.y;
			canvas.g2.color = Color.White;
			canvas.g2.pushTranslation(position.x,position.y);
			canvas.g2.rotate(Util.degToRad(rotation.z), position.x + w * 0.5,position.y + h * 0.5);
			canvas.g2.drawScaledSubImage(data.image,tx , ty, frame.tw, frame.th, (flip.x > 0.0 ? w:0), (flip.y > 0.0 ? h:0), (flip.x > 0.0 ? -w:w), (flip.y > 0.0 ? -h:h));
			canvas.g2.popTransformation();
		}
	}
	
	// @:Incomplete we set this but we never change the animations...
	public function set(sprite:TSpriteData): Void {
		if(data.name != sprite.imagePath){
			new SpriteData(sprite,function(p_data){
				this.data = p_data;
				this.width = this.data.raw.width = p_data.image.width;
				this.height = this.data.raw.height= p_data.image.height;
				this.raw = this.data.raw;
				if(!this.data.animatable){
					this.data.animation.get().tw = Std.int(width);
					this.data.animation.get().th = Std.int(height);
				}
				#if editor
				if(found.App.editorui.inspector != null)
					found.App.editorui.inspector.updateField(uid,"imagePath",this.raw);
				#end
			});
		}
	}
	
	override function set_width(value: Float): Float {
		super.set_width(value);
		return _w = value;
	}
	
	override function set_height(value: Float): Float {
		super.set_height(value);
		return _h = value;
	}

	override function set_raw(data:TObj):TObj {
		return this.data.raw = cast(super.set_raw(data));
	}
}
