package coin.anim;

import coin.tool.TileEditor;
import kha.Canvas;
import coin.anim.Tile;
import coin.object.Object;
import coin.data.SpriteData;
import coin.data.SceneFormat;
import kha.math.Vector2;

class Tilemap extends Object{
    
    /* width */         public var w : Int;
    /* height */        public var h : Int;
    /* tile width */    public var tw : Int;
    /* tile height */   public var th : Int;
    public var data : Array<Int>;
    var tiles:Map<Int,Tile>;
    public var imageData:Array<SpriteData>;
    
    public function new(data:TTilemapData,done:Tilemap->Void) {
        super(data.position.x,data.position.y,data.width,data.height);
        this.w = Std.int(data.width);
        this.h = Std.int(data.height);
        this.tw = data.tileWidth;
        this.th = data.tileHeight;
        this.data = data.map.length == 0 ? [for (i in 0...w * h) -1]: data.map;
        this.imageData = [];
        this.tiles = [];
        for(tile in data.images){
            Tile.createTile(this,tile,0,done);
        }
        if(data.images.length == 0){
            done(this);
        }
        this.raw = data;
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
    public function addData(data:SpriteData) {
        var id = -1;
        var padding = 0;
        for(i in 0...imageData.length){
            if(imageData[i] == data){
                id = i;
                break;
            }
        }
        if(id == -1){
            id = imageData.push(data)-1;
        }
        return id;
    }
    override public function render(canvas:Canvas) {
        var x = 0;
        var y = 0;
        while(x+position.x < w){
            var pos = posXY2Id(x,y);
            if(pos != -1){
                var tileId = data[pos];
                // trace('Tileid was: $tileId');
                if(tileId != -1){
                    var tile = tiles[tileId];
                    if(tile != null){
                        // trace('Tile was not null');
                        tile.render(canvas,new Vector2(x+position.x,y+position.y));
                    }
                }
            }
            x+=tw;
            if(x+position.x >= w && y < h){
                y+=th;
                x = 0;
            }
        }
        #if tile_editor
        if(TileEditor.selectedMap != -1 && TileEditor.tilemapIds[TileEditor.selectedMap] == this.uid){
            drawCountour(canvas);
        }
        #end
    }
    function drawCountour(canvas:Canvas){
        var g = canvas.g2;
        g.drawRect(position.x,position.y,w,h,3.0);

    }
}