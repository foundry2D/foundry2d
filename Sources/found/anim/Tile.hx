package found.anim;

import kha.math.FastMatrix3;
import kha.Canvas;
import kha.math.Vector2;

import found.data.SpriteData;
import found.data.SceneFormat;

class Tile {
	private var map:Tilemap;
	//Id in the tilesheet
	public var tileId(default,never):Int;
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

	public var animIndex(default,never):Int =0;

	public var flip:Vector2;

	public var raw:TTileData;

	@:access(found.anim.Tilemap)
    public function new(tilemap:Tilemap,sprite:TTileData,index:Int,done:Tile->Void){
		// super(sprite.position.x, sprite.position.y, sprite.width, sprite.height);
		this.map = tilemap;
		// this.active = sprite.active;
		this.flip = Reflect.hasField(sprite,"flip") ? sprite.flip:new Vector2();
		_w = sprite.tileWidth;
		_h = sprite.tileHeight;
		this.raw = sprite;
		//Every tilesheet will have the 0 tile be created
		if(index == 0){
			new SpriteData(sprite,function(p_data){
				dataId = map.addData(p_data);
				Reflect.setField(this,"tileId",sprite.usedIds[index]);
				map.pivotTiles.push(this);
				done(this);
				for(index in 0...sprite.usedIds.length){
					if(index ==0)continue;
					createTile(map,sprite,index);
				}
			});
		} 
		else{
			dataId = map.addData(map.imageData[map.imageData.length-1]);
			Reflect.setField(this,"tileId",sprite.usedIds[index]);
			var value = data.addSubSprite(tileId);
			Reflect.setField(this,"animIndex",value);
			done(this);
		}

	}
	@:access(found.anim.Tilemap)
	public static function createTile(map:Tilemap,sprite:TTileData,index:Int,?done:Tilemap->Void){
		return new Tile(map,sprite,index,function(tile:Tile){
			map.tiles.set(tile.tileId,tile);
			if(tile.raw.usedIds.length == index+1 && done != null){
				trace('done was called $index');
				done(map);
			}
			
		});
	}
	public function setAnimation(animation: Int): Void {
		data.curAnim = animation;
	}
	
	public function render(canvas: Canvas,position:Vector2,?color:kha.Color=null,?scale:kha.math.Vector2): Void {
		if(data == null)return;
		setAnimation(animIndex);
		if(data.animatable)
			data.animation.next();
		// super.render(canvas);
		var width = _w;
		var height =_h;
		if (data.image != null) {
			canvas.g2.color = color != null ? color:kha.Color.White;
			if(scale != null)
				canvas.g2.transformation = FastMatrix3.scale(scale.x,scale.y);
			canvas.g2.pushTranslation(position.x,position.y);
			// canvas.g2.rotate(Util.degToRad(rotation), position.x + width/ 2,position.y + height/ 2);
			canvas.g2.drawScaledSubImage(data.image, offsetx+Std.int(data.animation.get().id * map.tw) % data.image.width, offsety+Math.floor(data.animation.get().id * map.tw / data.image.width) * _h, _w, _h, (flip.x > 0.0 ? width:0), (flip.y > 0.0 ? height:0), (flip.x > 0.0 ? -width:width), (flip.y > 0.0 ? -height:height));
			canvas.g2.popTransformation();
			if(scale != null)
				canvas.g2.transformation = FastMatrix3.identity();
		}
	}
}