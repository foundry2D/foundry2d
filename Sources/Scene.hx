package ;

import collide.Rectangle;
import anim.Sprite;
import haxe.ds.ArraySort;
import kha.Canvas;
import object.Object;
import data.SceneFormat;

class Scene {

  static var uidCounter = 0;
	public var uid:Int;
	public var raw:TSceneFormat;
  public var root:Object;
  public static var ready:Bool = false;

  public var countEntities(get, null):Int;
  private var _entities:Array<Object>;

  public var traitInits:Array<Void->Void> = [];
	public var traitRemoves:Array<Void->Void> = [];

  private var _depth:Bool;
  private var _Zsort:Bool;// Defaults to ysort: 2DRPG zsort: platformer 

  public function new(raw:TSceneFormat){
    this.raw = raw; 
    _entities = new Array<Object>();
    root = new Object();
    if(Reflect.hasField(raw,"_entities")){
      for(e in raw._entities){
        switch(e.type){
          case "Sprite":
            var data:TSpriteData = SceneFormat.getData(e);
            var out = new Sprite(data._imagePath,data.position.x,data.position.y,Std.int(data.width),Std.int(data.height));
            out.raw = data;
            _entities.push(out);
          case "Rect":
            var data:TRectData = SceneFormat.getData(e);
            var out = new Rectangle(data.position.x,data.position.y,Std.int(data.width),Std.int(data.height));
            out.raw = data;
            _entities.push(out);
          case "Emitter":
          default:
            var data:TSpriteData = SceneFormat.getData(e);
            var out = new Sprite(data._imagePath,data.position.x,data.position.y,Std.int(data.width),Std.int(data.height));
            out.raw = data;
            _entities.push(out);

        }
      }
    }
    #if debug
		root.name = "Root";
    #end
  }

  @:access(App)
  public function update(){
    for (entity in _entities) entity.update();

    var i = 0;
		var l = App.traitUpdates.length;
		while (i < l) {
			if (traitInits.length > 0) {
				for (f in traitInits) { traitInits.length > 0 ? f() : break; }
				traitInits.splice(0, traitInits.length);     
			}
			App.traitUpdates[i]();
			// Account for removed traits
			l <= App.traitUpdates.length ? i++ : l = App.traitUpdates.length;
		}

		i = 0;
		l = App.traitLateUpdates.length;
		while (i < l) {
			App.traitLateUpdates[i]();
			l <= App.traitLateUpdates.length ? i++ : l = App.traitLateUpdates.length;
		}
  }

  @:access(App)
  public function render(canvas:Canvas){
    if (_depth) depth(_entities);

    for (entity in _entities) entity.render(canvas);

    if (App.traitRenders2D.length > 0) {
			canvas.g2.begin(false);
			for (f in App.traitRenders2D) { App.traitRenders2D.length > 0 ? f(canvas.g2) : break; }
			canvas.g2.end();
		}

    if (App.traitInits.length > 0) {
			for (f in App.traitInits) { App.traitInits.length > 0 ? f() : break; }
			App.traitInits.splice(0, App.traitInits.length);     
		}
  }

  
  public function get_countEntities():Int {
    return _entities.length;
  }

  public function clear(){
    _entities = new Array<Object>();
  }

  public function add(entity:Object){
    entity.active = true;
    _entities.push(entity);
  }

  public function remove(entity:Object){
    entity.active = false;
    _entities.remove(entity);
    entity = null;
  }

  function depth(entities:Array<Object>){
    if (entities.length == 0) return;
    if(this._Zsort){
      ArraySort.sort(entities, function(ent1:Object, ent2:Object){
        if (ent1.depth < ent2.depth){
          return -1;
        } else if (ent1.depth == ent2.depth){
          return 0;
        } else {
          return 1;
        }
      });

    }else {
      ArraySort.sort(entities, function(ent1:Object, ent2:Object){
        if (ent1.position.y + ent1.height < ent2.position.y + ent2.height){
          return -1;
        } else if (ent1.position.y == ent2.position.y){
          return 0;
        } else {
          return 1;
        }
      });

    }
    
  }

  public function sort(?value:Bool = false,?zsort:Bool = false):Bool {
    this._Zsort = zsort;
    return _depth = value;
  }


}