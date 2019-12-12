package coin.anim;

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
    var tiles:Array<Tile>;
    public var imageData:Array<SpriteData>;
    var tileCounter:Array<Int>= [];
    
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
            new Tile(this,tile,function(tile:Tile){
                if(tiles.length+1 > tile.baseId+tile.tileId || tile.baseId+tile.tileId ==0){
                    tiles.push(tile);
                }
                else{
                    for(i in tiles.length...tile.baseId){
                        tiles.push(null);
                    }
                    tiles.push(tile);
                }
                if(data.images.length == imageData.length){
                    done(this);
                }
                
            });
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
                padding = Std.int(data.image.realWidth/tw)*Std.int(data.image.realHeight/tw);
                tileCounter[id]+=1;
                break;
            }
        }
        if(id == -1){
            id = imageData.push(data)-1;
            padding = id == 0 ? 0:Std.int(data.image.realWidth/tw)*Std.int(data.image.realHeight/tw);
            tileCounter.push(padding);
        }
        return {dataId:id,tileId:tileCounter[id],baseId:padding};
    }
    override public function render(canvas:Canvas) {
        var x = 0;
        var y = 0;
        while(x+position.x < w){
            var pos = posXY2Id(x,y);
            if(pos != -1){
                var tileId = data[pos];
                if(tileId != -1){
                    var tile = tiles[tileId];
                    trace('tile id was: $tileId.');
                    if(tile != null){
                        trace("X: "+(x+position.x));
                        trace("Y: "+(y+position.y));
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
    }
}