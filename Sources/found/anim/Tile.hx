package found.anim;

import kha.math.FastMatrix3;
import kha.Canvas;
import kha.math.Vector2;

import found.math.Util;
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
    public function new(tilemap:Tilemap,sprite:TTileData,index:Int,isPivot:Bool,done:Tile->Void){
		// super(sprite.position.x, sprite.position.y, sprite.width, sprite.height);
		this.map = tilemap;
		// this.active = sprite.active;
		this.flip = Reflect.hasField(sprite,"flip") ? sprite.flip:new Vector2();
		_w = sprite.tileWidth;
		_h = sprite.tileHeight;
		this.raw = sprite;
		map.addData(sprite,function(dataId:Int){
			this.dataId = dataId; 
			trace(index);
			//Every tilesheet will have the 0 tile be created
			if(index == 0 || isPivot){	
				Reflect.setField(this,"tileId",index);
				map.pivotTiles.push(this);
				done(this);
				for(i in 0...sprite.usedIds.length){
					if(i ==0)continue;
					createTile(map,sprite,sprite.usedIds[i]);
				}
			} 
			else{
				Reflect.setField(this,"tileId",index);
				var value = data.addSubSprite(this.tileId-map.pivotTiles[dataId].tileId,sprite.tileWidth,sprite.tileHeight);
				Reflect.setField(this,"animIndex",value);
				done(this);
			}
		});

	}
	//initialized in makeBodies of Tilemap
	public var body:echo.Body = null;

	static var onStaticDone:Tilemap->Void = null;
	@:access(found.anim.Tilemap)
	public static function createTile(map:Tilemap,sprite:TTileData,index:Int,?isPivot=false,?done:Tilemap->Void){
		if(done != null)
			onStaticDone = done;
		return new Tile(map,sprite,index,isPivot,function(tile:Tile){
			map.tiles.set(tile.tileId,tile);
			if(tile.raw.usedIds[tile.raw.usedIds.length-1] == index && onStaticDone != null){
				trace('done was called $index');
				onStaticDone(map);
				onStaticDone = null;
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

		if (data.image != null) {
			canvas.g2.color = color != null ? color:kha.Color.White;
			if(scale != null)
				canvas.g2.transformation = FastMatrix3.scale(scale.x,scale.y);
			canvas.g2.pushTranslation(position.x,position.y);
			// canvas.g2.rotate(Util.degToRad(rotation), position.x + width/ 2,position.y + height/ 2);
			var grid = map.tw;
			var width = Util.snap(data.image.width,grid);
			var x = Std.int(data.animation.get().id * grid) % width;
			var y = Math.floor(data.animation.get().id * grid/width)*(map.th);
			canvas.g2.drawScaledSubImage(data.image,x ,y,_w, _h, (flip.x > 0.0 ? _w:0), (flip.y > 0.0 ? _h:0), (flip.x > 0.0 ? -_w:_w), (flip.y > 0.0 ? -_h:_h));
			canvas.g2.popTransformation();
			if(scale != null)
				canvas.g2.transformation = FastMatrix3.identity();
		}
	}
}