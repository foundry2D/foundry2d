package found.anim;

import found.tool.TileEditor;
import kha.Canvas;
import found.anim.Tile;
import found.object.Object;
import found.data.SpriteData;
import found.data.SceneFormat;
import kha.math.Vector2;

@:access(found.anim.Tile)
class Tilemap extends Object{
    static function deserialize(data:Any):Map<Int,Array<Int>>{
        var map = new Map<Int, Array<Int>>();
        for(field in Reflect.fields(Reflect.getProperty(data,"h"))){
            map.set(Std.parseInt(field),Reflect.getProperty(Reflect.getProperty(data,"h"),field));
        }
        return map;

    }
    //@TODO: Set data array to new array 
    //when changing the width or height of the tilemap
    public var w(default,set) : Int;
    function set_w(width:Int){
        super.width = width;
        return w = width;
    }
    public var h(default,set) : Int;
    function set_h(height:Int){
        super.height = height;
        return h = height;
    }
    public var tw : Int;
    public var th : Int;
    public var data : Array<Int>;
    var tiles:Map<Int,Tile>;
    var pivotTiles:Array<Tile>;
    public var imageData:Array<SpriteData>;
    
    public function new(data:TTilemapData,done:Tilemap->Void) {
        super(data);
        this.w = Std.int(data.width);
        this.h = Std.int(data.height);
        this.tw = data.tileWidth;
        this.th = data.tileHeight;
        this.data = [for (i in 0...w * h) -1];
        this.imageData = [];
        this.tiles = [];
        this.pivotTiles = [];
        this.raw = data;
        data.map = Tilemap.deserialize(data.map);
        for(tileid in data.map.keys()){
            for(pos in data.map.get(tileid)){
                this.data[pos] = tileid;
            }
        }
        
        for(tile in data.images){
            Tile.createTile(this,tile,tile.id,true,done);
        }
        if(data.images.length == 0){
            done(this);
        }
    }

    override function set_body(b:echo.Body) {
        var out = super.set_body(b);
        if(b == null){
            removeBodies(State.active);
        }
        return out;
    }
    
    public inline function x(id : Int) : Int {
        return id % w;
    }
    
    public inline function y(id : Int) : Int {
        return Std.int(id / w);
    }
    
    public inline function i(x : Int, y : Int) : Int {
        if (x < 0) return -1;
        else if (x >= w) return -1;
        else if (y < 0) return -1;
        else if (y >= h) return -1;
        else return y * w + x;
    }

    // tile -> pixel
    public inline function x2p(x : Float) : Float {
        return x * tw;
    }
    
    public inline function y2p(y : Float) : Float {
        return y * th;
    }
    
    // pixel -> tile
    public inline function p2x(p : Float) : Float {
        return p / tw;
    }
    
    public inline function p2y(p : Float) : Float {
        return p / th;
    }

    public inline function pos2Id(pos:Vector2) : Int {
        var tx = Std.int(pos.x / tw);
        var ty = Std.int(pos.y / th);
        return i(tx, ty);
    }

    public inline function posXY2Id(x : Float, y : Float) : Int {
        var tx = Std.int(x / tw);
        var ty = Std.int(y / th);
        return i(tx, ty);
    }
    public function addData(data:TSpriteData,onDone:Int->Void) {
        var id = -1;
        for(i in 0...imageData.length){
            if(imageData[i].raw.imagePath == data.imagePath){
                onDone(i);
                return;
            }
        }
        if(id == -1){
            new SpriteData(data,function(p_data){
                onDone(imageData.push(p_data)-1);
            });
        }
    }
    #if tile_editor
    @:access(found.tool.TileEditor)
    #end
    override public function render(canvas:Canvas) {
        super.render(canvas);
        var x = 0;
        var y = 0;
        while(x < w){
            var pos = posXY2Id(x,y);
            if(pos != -1){
                var tileId = data[pos];
                if(tileId != -1){
                    var tile = tiles[tileId];
                    if(tile != null){
                        var pos:Vector2 = new Vector2(x,y);
                        tile.render(canvas,pos);
                        tile.updateBody(pos.add(this.position));
                    }
                }
            }
            x+=tw;
            if(x>= w && y < h){
                y+=th;
                x = 0;
            }
        }
        for(tile in tiles){
            tile.bodyCount = -1;
        }
        #if tile_editor
        if(TileEditor.selectedTilemapIdIndex != -1 && TileEditor.tilemapIds[TileEditor.selectedTilemapIdIndex] == this.uid){
            drawCountour(canvas);
        }
        #end
    }
    
    #if tile_editor
    function drawCountour(canvas:Canvas){
        var g = canvas.g2;
        var stren = State.active.cam.zoom < 1.0 ? 9.0 * (1.0 - State.active.cam.zoom) : 0.0;  
        g.drawRect(0,0,w,h,3.0+stren);

    }
    #end

    public function makeBodies(scene:Scene,?p_tileid:Int){
        var data:TTilemapData = cast(this.raw);
        var addAllIds:()->Null<Int> =  function(){
            for(tileid in data.map.keys())
                makeBodies(scene,tileid);
            return null;
        };
        var tileId:Null<Int> = p_tileid != null ? p_tileid : addAllIds();
        if(tileId != null && data.map.exists(tileId)){
            for(index in data.map.get(tileId) ){
                var tile = this.tiles[tileId];
                if(tile != null && tile.raw.rigidBodies != null && tile.raw.rigidBodies.exists(tile.tileId)){
                    var body = tile.raw.rigidBodies.get(tile.tileId);
                    body.x = this.x2p(this.x(index))+this.position.x;
                    body.y = this.y2p(this.y(index))+this.position.y;
                    var addBody:Bool = true;
                    for(bod in tile.bodies){
                        if(bod.x == body.x && bod.y == body.y){
                            addBody = false;
                            break;
                        }
                    }
                    if(addBody){
                        var bod = new echo.Body(body);
                        bod.object = this;
                        tile.bodies.push(scene.physics_world.add(bod));
                    }
                        
                }
            }
        }
        
    }

    public function removeBodies(scene:Scene,?p_tileid:Int){
        var data:TTilemapData = cast(this.raw);
        var rmAllIds:()->Null<Int> =  function(){
            for(tileid in data.map.keys())
                removeBodies(scene,tileid);
            return null;
        };
        var tileId:Null<Int> = p_tileid != null ? p_tileid : rmAllIds();
        if(tileId != null){
            var tile = this.tiles[tileId];
            for(body in tile.bodies){
                scene.physics_world.remove(body);
            }
            tile.bodies.splice(0,tile.bodies.length);
        }
    }
}