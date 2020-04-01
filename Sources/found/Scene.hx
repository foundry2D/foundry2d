package found;

import kha.math.FastMatrix3;
import kha.simd.Float32x4;
import found.node.Logic;
import found.node.Logic.TNodeCanvas;
import kha.Blob;
import found.anim.Tilemap;
#if editor
import found.math.Util.Cli;
#end
import found.anim.Sprite;
import haxe.ds.ArraySort;
import kha.Canvas;
import kha.math.Vector2;
import found.object.Object;
import found.object.Camera;
import found.object.Executor;
import found.data.SceneFormat;
import found.data.Data;

class Scene {
  
	public final raw:TSceneFormat;
  public var root:Object;
  public static var ready:Bool = false;
  public var cam:Camera;

  
  public var countEntities(get, null):Int;
  public var _entities:Array<Object>;
  var activeEntities:Array<Object>;
  var inactiveEntities:Array<Object>;

  public var physics_world: echo.World;

  public var traitInits:Array<Void->Void> = [];
  public var traitRemoves:Array<Void->Void> = [];
  
  public var physicsUpdate:Float->Void = function(f:Float){};

  public var cullOffset(get,null):Int = 0;
  function get_cullOffset(){
    if(cullOffset == 0 && raw.cullOffset != null) cullOffset = raw.cullOffset;
    return cullOffset;
  }

  static var STEP = 16/1000;

  private var _depth:Bool = true;
  /**
   *  If the engine should use ysort: 2DRPG or zsort: platformer drawing method.
   *  Can vary on a Scene to Scene basis i.e. Menu Scene uses zsort Gameplay Scene uses ysort 
   */
  public static var zsort(default,null):Bool = true;

  @:access(found.object.Object)
  public function new(raw:TSceneFormat){

    Object.uidCounter = -1;// When loading a scene the object counter always goes back to 0;
    Object._positions.resize(0);
    Object._rotations.resize(0);
    Object._scales.resize(0);

    this.raw = raw; 
    _entities = new Array<Object>();
    // root = new Object();
    activeEntities = [];
    inactiveEntities = [];
    if(raw.physicsWorld != null){
      addPhysicsWorld(raw.physicsWorld);
    }
    

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
  function addToStateArray(object:Object){
      if(object.active){
        activeEntities.push(object);
      }
      else{
        inactiveEntities.push(object);
      }
  }

  #if editor
  public function addEntity(e:TObj,?isEditor = false){
    if(!isEditor && this.raw._entities.length == this._entities.length)
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
              addToStateArray(s);
          });
        // case "rect_object":
        //   var data:TRectData = SceneFormat.getData(e);
        //   var out = new Rectangle(data.position.x,data.position.y,Std.int(data.width),Std.int(data.height));
        //   out.raw = data;
        //   createTraits(data.traits,out);
        //   _entities.push(out);
        case "tilemap_object":
          var data:TTilemapData = SceneFormat.getData(e);
          new Tilemap(data,function(tilemap:Tilemap){
            _entities.push(tilemap);
            addToStateArray(tilemap);
          });
        case "camera_object":
          var data:TCameraData = SceneFormat.getData(e);
          var out = new Camera(data);
          if(out.uid == 0)
            cam = out;
          out.raw = data;
          createTraits(data.traits,out);
          _entities.push(out);
          addToStateArray(out);
        case "emitter_object":
        default://Object
          // var data:TSpriteData = SceneFormat.getData(e);
          // var out = new Sprite(data._imagePath,data.position.x,data.position.y,Std.int(data.width),Std.int(data.height));
          // out.raw = data;
          // _entities.push(out);
          trace("Data with name"+e.name+"was not added because it's type is not implemented");

      }
  }

  function addPhysicsWorld(opts:echo.data.Options.WorldOptions) {
    physics_world = echo.Echo.start(opts);
    physics_world.listen();
    physicsUpdate = physics_world.step;
  }

  @:access(found.App,found.object.Object)
  public function update(dt:Float){
    if(!Scene.ready && raw._entities.length == _entities.length)
      Scene.ready = true;
    if(!Scene.ready)
      return;
      

    for (entity in activeEntities) entity.update(dt);

    physicsUpdate(STEP);

    var i = 0;
		var l = App.traitUpdates.length;
		while (i < l #if editor && App.editorui.isPlayMode #end) {
			if (App.traitInits.length > 0) {
				for (f in App.traitInits) { App.traitInits.length > 0 ? f() : break; }
				App.traitInits.splice(0, App.traitInits.length);
   
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
		while (i < l #if editor && App.editorui.isPlayMode #end) {
			App.traitLateUpdates[i]();
			l <= App.traitLateUpdates.length ? i++ : l = App.traitLateUpdates.length;
		}
    //@:Incomplete: We should maybe add the possibility to have multithreaded
    // calls in LateUpdate and execute them after. For now we will focus on having this in the normal update.

    #if debug_physics
    if(physics_world != null)
      echo.util.Debug.log(physics_world);
    #end
  }

  @:access(found.App)
  public function render(canvas:Canvas){
    var ordered = _entities.copy();
    if(cullOffset != 0){
      var data:Float32x4 = Float32x4.loadFast(cam.position.x,cam.position.y,Found.WIDTH,Found.HEIGHT);
      var objects:Array<Object> = [];
      for(i in 0...ordered.length) {
        if(ordered[i].isVisible(cullOffset,data)){
          objects.push(ordered[i]);
        }
      }
      ordered = objects;
    }

    if (_depth) depth(ordered);

    var lastz = -1;
    for (entity in ordered){
      if(entity.depth != lastz){
        if(lastz > -1)
          canvas.g2.popTransformation();
        lastz = Std.int(entity.depth);
        var layer:TLayer = raw.layers != null ? raw.layers[lastz]: {name: "No layers",zIndex: 0, speed:1.0};
        canvas.g2.pushTransformation(FastMatrix3.translation(-cam.position.x * layer.speed,-cam.position.y * layer.speed));

      }
      entity.render(canvas);
    }
    canvas.g2.popTransformation();

    #if debug
    if(Found.collisionsDraw && physics_world != null){
      for(body in physics_world.members){
        canvas.g2.color = kha.Color.fromBytes(255,0,0,64);
        for(shape in body.shapes) {
          drawShape(canvas.g2,shape,shape.x,shape.y);
        }
        canvas.g2.color = kha.Color.fromBytes(0,0,255,128);
      }
      canvas.g2.color = kha.Color.White;
    }
    #end

    if (App.traitRenders2D.length > 0 #if editor && App.editorui.isPlayMode #end) {
			for (f in App.traitRenders2D) { App.traitRenders2D.length > 0 ? f(canvas.g2) : break; }
		}

    if (App.traitInits.length > 0 #if editor && App.editorui.isPlayMode #end) {
			for (f in App.traitInits) { App.traitInits.length > 0 ? f() : break; }
			App.traitInits.splice(0, App.traitInits.length);
      for(exe in Executor.executors){
        exe.execute();
      }
    }

  }

  #if debug
  function drawShape(g:kha.graphics2.Graphics,shape:echo.Shape,x:Float,y:Float){
    switch(shape.type){
      case echo.data.Types.ShapeType.RECT:
        var bounds = shape.bounds();
        g.fillRect(x + shape.x, y + shape.y,bounds.width,bounds.height);
      default:
    }
  } 
  #end

  public function getObjectNames():Array<String>{
    var names = [];
    for(object in _entities){
      names.push(object.raw.name);
    }
    return names;
  }

  public function getObject(name:String){
    if(name=="" || name == null)return null;
    for(object in _entities){
      if(object.raw.name == name){
          return object;
      }
    }
    return null;

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

  static function createTraits(traits:Array<TTrait>, object:Object) {
		if (traits == null) return;
		for (t in traits) {
      if (t.type == "VisualScript") {
        Data.getBlob(t.classname, function(blob:kha.Blob) {
          var node:LogicTreeData = haxe.Json.parse(blob.toString());
          var visualTrait = Logic.parse(node);
          visualTrait.name = t.classname;
          var existentTrait = object.getTrait(Type.getClass(visualTrait), visualTrait.name);
          if (existentTrait != null) {
            object.removeTrait(existentTrait);
          }
          object.addTrait(visualTrait);
          addToApp(visualTrait);
        }, true);
      }
			else if (t.type == "Script") {
				// Assign arguments if any
				var args:Array<Dynamic> = [];
				if (t.parameters != null) {
					for (param in t.parameters) {
						args.push(parseArg(param));
					}
				}
				var traitInst = createTraitClassInstance(t.classname, args);
				if (traitInst == null) {
					trace("Error: Trait '" + t.classname + "' referenced in object '" + object.name + "' not found");
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
        addToApp(traitInst);
      }
		}
  }
  @:access(found.Trait)
  static function addToApp(t:Trait){
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