package found.anim;

import found.tool.TileEditor;
import kha.Canvas;
import found.anim.Tile;
import found.object.Object;
import found.data.SpriteData;
import found.data.SceneFormat;
import kha.math.Vector2;

class Tilemap extends Object{
    
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
        this.data = data.map.length == 0 ? data.map = [for (i in 0...w * h) -1]: data.map;
        this.imageData = [];
        this.tiles = [];
        this.pivotTiles = [];
        this.raw = data;
        
        for(tile in data.images){
            Tile.createTile(this,tile,tile.id,true,done);
        }
        if(data.images.length == 0){
            done(this);
        }
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
            if(imageData[i].raw == data){
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
        var x = 0;
        var y = 0;
        while(x < w){
            var pos = posXY2Id(x,y);
            if(pos != -1){
                var tileId = data[pos];
                if(tileId != -1){
                    var tile = tiles[tileId];
                    if(tile != null){
                        var pos:Vector2 = new Vector2(x+position.x,y+position.y);
                        tile.render(canvas,pos);
                        #if debug
                        if(tile.body != null){
                            Object.physicsDraw(canvas,tile.raw.rigidBody.shapes,pos);
                        }
                        #end
                    }
                }
            }
            x+=tw;
            if(x>= w && y < h){
                y+=th;
                x = 0;
            }
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
        g.drawRect(position.x,position.y,w,h,3.0);

    }
    #end

    public function makeBodies(scene:Scene){
        var x = 0;
        var y = 0;
        while(x < this.w){
            var pos = this.posXY2Id(x,y);
            if(pos != -1){
                var tileId = this.data[pos];
                if(tileId != -1){
                    var tile = this.tiles[tileId];
                    if(tile != null){
                    var p_raw = Reflect.copy(tile.raw);
                    if(p_raw.rigidBody == null){
                        p_raw.rigidBody = echo.Body.defaults;
                        p_raw.rigidBody.mass = 0;//Make the body static
                    }
                    p_raw.rigidBody.x = x+this.position.x;
                    p_raw.rigidBody.y = y+this.position.y;
                    tile.body = scene.physics_world.add(new echo.Body(p_raw.rigidBody));
                    }
                }
            }
            x+=this.tw;
            if(x>= this.w && y < this.h){
                y+=this.th;
                x = 0;
            }
        }
    }
}