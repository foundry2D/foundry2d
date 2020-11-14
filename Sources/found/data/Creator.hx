package found.data;

import kha.math.Vector2;
import kha.math.Vector3;

import found.data.SceneFormat;

class Creator {
    public static function createType(name:String,type:String):Null<Any>{
        var data:Null<Any> = null;
        switch(type){
            case "object":
                data = {
                    name: name,
                    type: type,
                    position: new Vector2(),
                    rotation: new Vector3(),
                    width: 0.0,
                    height:0.0,
                    scale: new Vector2(1.0,1.0),
                    center: new Vector2(),
                    layer: 0,
                    depth: 0.0,
                    active: true
                };
            case "sprite_object":
                var sprite:TSpriteData = createType(name,"object");
                sprite.width = 493.0;
                sprite.height = 512.0;
                sprite.imagePath = "foundry_icon";
                sprite.shape = 0;//Rect
                sprite.points = [new Vector2(),new Vector2(sprite.width,0),new Vector2(sprite.width,sprite.height),new Vector2(0,sprite.height)];
                sprite.anims = [];
                data = sprite;
            case "tilemap_object":
                var tilemap:TTilemapData = createType(name,"object");
                tilemap.width = 1280.0;
                tilemap.height = 960.0;
                tilemap.tileWidth = 64;
                tilemap.tileHeight = 64;
                tilemap.map = new Map<Int,Array<Int>>();
                var tile:TTileData = createType("Tile","sprite_object");
                tile.id = 0;
                tile.width = 896.0;
                tile.height = 448.0;
                tile.tileWidth = 64;
                tile.tileHeight = 64;
                tile.points = [new Vector2(),new Vector2(64,0),new Vector2(64,64),new Vector2(0,64)];
                tile.imagePath = "tilesheet";
                tile.usedIds = [0];
                tile.rigidBodies = new Map<Int,echo.data.Options.BodyOptions>();

                tilemap.images = [tile];

                data = tilemap;
        }
        Reflect.setField(data,"type",type);
        return data;
    }
}