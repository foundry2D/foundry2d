package coin;

#if editor
import coin.tool.Util.Cli;
#end
import coin.collide.Rectangle;
import coin.anim.Sprite;
import haxe.ds.ArraySort;
import kha.Canvas;
import kha.math.Vector2;
import coin.object.Object;
import coin.object.Executor;
import coin.data.SceneFormat;

class Scene {
  
	public var raw:TSceneFormat;
  public var root:Object;
  public static var ready:Bool = false;
  public var cam:Vector2;

  public var countEntities(get, null):Int;
  public var _entities:Array<Object>;

  public var traitInits:Array<Void->Void> = [];
	public var traitRemoves:Array<Void->Void> = [];

  private var _depth:Bool;
  /**
   *  If the engine should use ysort: 2DRPG or zsort: platformer drawing method.
   *  Can vary on a Scene to Scene basis i.e. Menu Scene uses zsort Gameplay Scene uses ysort 
   */
  public static var zsort(default,null):Bool = false;


  public function new(raw:TSceneFormat){
    this.raw = raw; 
    _entities = new Array<Object>();
    // root = new Object();
    cam = new Vector2();
    if(Reflect.hasField(raw,"_entities")){
      for(e in raw._entities){
        addEntity(e);
      }
    }
    // createTraits(raw.traits,root);
    #if debug
		// root.name = "Root";
    #end
  }

  #if editor
  public function addEntity(e:TObj,?isEditor = false){
    if(!isEditor)
      trace(Cli.byellow+"WARNING:"+Cli.reset+" This function should only be used for "+Cli.bred+"EDITOR"+Cli.reset+" developpement");
  #else
  function addEntity(e:TObj){
  #end  
    switch(e.type){
        case "sprite_object":
          var data:TSpriteData = SceneFormat.getData(e);
          var out = new Sprite(data,function (s:Sprite){
              createTraits(data.traits,s);
              _entities.push(s);
          });
        case "rect_object":
          var data:TRectData = SceneFormat.getData(e);
          var out = new Rectangle(data.position.x,data.position.y,Std.int(data.width),Std.int(data.height));
          out.raw = data;
          createTraits(data.traits,out);
          _entities.push(out);
        case "emitter_object":
        default://Object
          // var data:TSpriteData = SceneFormat.getData(e);
          // var out = new Sprite(data._imagePath,data.position.x,data.position.y,Std.int(data.width),Std.int(data.height));
          // out.raw = data;
          // _entities.push(out);

      }
  }

  @:access(coin.App,coin.object.Object)
  public function update(dt:Float){
    if(!Scene.ready && raw._entities.length == _entities.length)
      Scene.ready = true;
    for (entity in _entities) entity.update(dt);

    var i = 0;
		var l = App.traitUpdates.length;
		while (i < l) {
			if (traitInits.length > 0) {
				for (f in traitInits) { traitInits.length > 0 ? f() : break; }
				traitInits.splice(0, traitInits.length);
   
			}
			App.traitUpdates[i](dt);
			// Account for removed traits
			l <= App.traitUpdates.length ? i++ : l = App.traitUpdates.length;
		}

    // Call deferred actions
    for(exe in Executor.executors){
      exe.execute();
    }

		i = 0;
		l = App.traitLateUpdates.length;
		while (i < l) {
			App.traitLateUpdates[i]();
			l <= App.traitLateUpdates.length ? i++ : l = App.traitLateUpdates.length;
		}
    //@:Incomplete: We should maybe add the possibility to have multithreaded
    // calls in LateUpdate and execute them after. For now we will focus on having this in the normal update.
  }

  @:access(coin.App)
  public function render(canvas:Canvas){
    if (_depth) depth(_entities);

    for (entity in _entities) entity.render(canvas);

    if (App.traitRenders2D.length > 0) {
			for (f in App.traitRenders2D) { App.traitRenders2D.length > 0 ? f(canvas.g2) : break; }
		}

    if (App.traitInits.length > 0) {
			for (f in App.traitInits) { App.traitInits.length > 0 ? f() : break; }
			App.traitInits.splice(0, App.traitInits.length);
      for(exe in Executor.executors){
        exe.execute();
      }
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
    if(zsort){
      ArraySort.sort(entities, function(ent1:Object, ent2:Object){
        if (ent1.depth < ent2.depth){
          return -1;
        } else if (Math.floor(ent1.depth) == Math.floor(ent2.depth)){
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

  public function sort(?value:Bool = false,?p_zsort:Bool = false):Bool {
    zsort = p_zsort;
    return _depth = value;
  }

  @:access(coin.Trait)
  static function createTraits(traits:Array<TTrait>, object:Object) {
		if (traits == null) return;
		for (t in traits) {
			if (t.type == "Script") {
				// Assign arguments if any
				var args:Array<Dynamic> = [];
				if (t.parameters != null) {
					for (param in t.parameters) {
						args.push(parseArg(param));
					}
				}
				var traitInst = createTraitClassInstance(t.class_name, args);
				if (traitInst == null) {
					trace("Error: Trait '" + t.class_name + "' referenced in object '" + object.name + "' not found");
					continue;
				}
				if (t.props != null) {
					for (i in 0...Std.int(t.props.length / 2)) {
						var pname = t.props[i * 2];
						var pval = t.props[i * 2 + 1];
						if (pval != "") {
							Reflect.setProperty(traitInst, pname, parseArg(pval));
						}
					}
				}
				object.addTrait(traitInst);
        var t = traitInst;
        if (t._init != null) {
          for (f in t._init) App.notifyOnInit(f);
          // t._init = null;
        }
        if (t._update != null) {
          for (f in t._update) App.notifyOnUpdate(f);
          // t._update = null;
        }
        if (t._lateUpdate != null) {
          for (f in t._lateUpdate) App.notifyOnLateUpdate(f);
          // t._lateUpdate = null;
        }
        if (t._render != null) {
          for (f in t._render) App.notifyOnRender(f);
          // t._render = null;
        }
        if (t._render2D != null) {
          for (f in t._render2D) App.notifyOnRender2D(f);
          // t._render2D = null;
        }
			}
		}
	}

  static function parseArg(str:String):Dynamic {
		if (str == "true") return true;
		else if (str == "false") return false;
		else if (str == "null") return null;
		else if (str.charAt(0) == "'") return StringTools.replace(str,"'", "");
		else if (str.charAt(0) == '"') return StringTools.replace(str,'"', "");
		else if (str.charAt(0) == "[") { // Array
			// Remove [] and recursively parse into array, then append into parent
			str = StringTools.replace(str,"[", "");
			str = StringTools.replace(str,"]", "");
			str = StringTools.replace(str," ", "");
			var ar:Dynamic = [];
			var vals = str.split(",");
			for (v in vals) ar.push(parseArg(v));
			return ar;
		}
		else {
			var f = Std.parseFloat(str);
			var i = Std.parseInt(str);
			return f == i ? i : f;
		}
	}

  static function createTraitClassInstance(traitName:String, args:Array<Dynamic>):Dynamic {
    var cname = Type.resolveClass(traitName);
		if (cname == null) return null;
		return Type.createInstance(cname, args);
	}


}