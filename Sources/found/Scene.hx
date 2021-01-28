package found;

import found.math.Util;
import kha.math.FastMatrix3;
import kha.simd.Float32x4;
import found.node.Logic;
import found.node.Logic.TNodeCanvas;
import kha.Blob;
import found.anim.Tilemap;
#if editor
import found.math.Util.Cli;
#end
#if debug
import kha.graphics2.GraphicsExtension;
#end
import found.anim.Sprite;
import haxe.ds.ArraySort;
import kha.Canvas;
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

  function onReady(){
    var sort = function(ent0:Object,ent1:Object){
      if(ent0.uid < ent1.uid){
        return -1;
      }
      else {
        return 1;
      }
    };
    ArraySort.sort(_entities,sort);
  }

  @:access(found.object.Object)
  function addToStateArray(object:Object){

    _entities.push(object);

    if(physics_world != null){// Add rigidbody to Object
      if(object.raw.rigidBody != null){
        _entities[_entities.length-1].makeBody(this,object.raw);
      } 
      if(Std.is(object, Tilemap)){
        var map:Tilemap = cast(object,Tilemap);
        map.makeBodies(this);
      }
    }
    if(object.active){
      activeEntities.push(object);
    }
    else{
      inactiveEntities.push(object);
    }

    createTraits(object.raw.traits,object);

    if(!Scene.ready && raw._entities.length == _entities.length){
      Scene.ready = true;
      onReady();
    }
  }

  #if editor
  public function addEntity(e:TObj,onDone:Object->Void = null,?isEditor = false) : Void {
    if(!isEditor && this.raw._entities.length == this._entities.length)
      error("This function should only be used for EDITOR developpement");
  #else
  function addEntity(e:TObj,onDone:Object->Void = null) : Void {
  #end  
    switch(e.type){
        case "object":
            var obj = new Object(e);
            addToStateArray(obj);
            if(onDone != null)
              onDone(obj);
        case "sprite_object":
          var data:TSpriteData = SceneFormat.getData(e);
          new Sprite(data,function (s:Sprite){
              addToStateArray(s);
              if(onDone != null)
                onDone(s);
          });
        case "tilemap_object":
          var data:TTilemapData = SceneFormat.getData(e);
          new Tilemap(data,function(tilemap:Tilemap){
            addToStateArray(tilemap);
            if(onDone != null)
              onDone(tilemap);
          });
        case "camera_object":
          var data:TCameraData = SceneFormat.getData(e);
          var out = new Camera(data);
          if(out.uid == 0)
            cam = out;
          out.raw = data;
          addToStateArray(out);
          if(onDone != null)
            onDone(out);
        case "emitter_object":
        default:
          warn("Data with name"+e.name+"was not added because it's type is not implemented");

      }
  }

  function addPhysicsWorld(opts:echo.data.Options.WorldOptions) {
    physics_world = echo.Echo.start(opts);
    physics_world.listen();
    physicsUpdate = physics_world.step;
  }

  @:access(found.App,found.object.Object)
  public function update(dt:Float){
    if(!Scene.ready #if editor ||  !App.editorui.isPlayMode #end){
      #if editor
      for(exe in Executor.executors){
        exe.execute();
      }
      #end
      return;
    }
    
    if (App.traitAwakes.length > 0) {
      for (f in App.traitAwakes) { App.traitAwakes.length > 0 ? f() : break; }
      App.traitAwakes.splice(0, App.traitAwakes.length);
 
    }
    
    if (App.traitInits.length > 0) {
      for (f in App.traitInits) { App.traitInits.length > 0 ? f() : break; }
      App.traitInits.splice(0, App.traitInits.length);

        // Call deferred actions for init and awake
      for(exe in Executor.executors){
        exe.execute();
      }
    }
    
    physicsUpdate(STEP);

    // Call deferred actions
    for(exe in Executor.executors){
      exe.execute();
    }

    var i = 0;
		var l = App.traitUpdates.length;
		while (i < l) {
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

    #if debug_physics
    if(physics_world != null)
      echo.util.Debug.log(physics_world);
    #end
  }

  @:access(found.App,found.object.Object,found.Trait)
  public function render(canvas:Canvas){
    if(!Scene.ready)
      return;// This scene is not ready to render

    var ordered = #if editor !App.editorui.isPlayMode ? _entities.copy(): #end activeEntities.copy() ;
    if(cullOffset != 0){
      var objects:Array<Object> = [];
      for(i in 0...ordered.length) {
        if(ordered[i].isVisible(cullOffset,getCameraView())){
          objects.push(ordered[i]);
        }
      }
      ordered = objects;
    }

    if (_depth) depth(ordered);

    var lastz = -1;
    for (entity in ordered){
      if(entity.layer != lastz){
        if(lastz > -1)
          canvas.g2.popTransformation();
        lastz = entity.layer;
        var layer:TLayer = raw.layers != null && raw.layers.length > 0 ? raw.layers[lastz]: {name: "No layers",zIndex: 0, speed:1.0};
        canvas.g2.pushTransformation(cam.getTransformation(layer.speed));
      }

      var pos = entity.position.mult(cam.zoom);
      canvas.g2.pushTranslation(pos.x,pos.y);
			if(entity.rotation.z>0){
				canvas.g2.pushTransformation(
					canvas.g2.transformation.multmat(FastMatrix3.translation(entity.width *0.5,entity.height *0.5)).multmat(
						FastMatrix3.rotation(Util.degToRad(entity.rotation.z))).multmat(
							FastMatrix3.translation(-entity.width *0.5,-entity.height *0.5)));
      }
      entity.render(canvas);
      for(t in entity.traits){
        if(t._render2D != null){
          for (f in t._render2D) { t._render2D.length > 0 ? f(canvas.g2) : break; }
        }
      }

      if(entity.rotation.z>0)canvas.g2.popTransformation();
      canvas.g2.popTransformation();
    }
    #if debug
    if(physics_world != null && Found.collisionsDraw){
      physics_world.for_each(function(f:echo.Body){
        if(f == null || f.shapes.length <= 0 || !f.active)return;
        canvas.g2.color = kha.Color.fromBytes(255,0,0,64);
        for(shape in f.shapes){
          var bds = shape.bounds();
          switch(shape.type){
            case RECT:
              canvas.g2.fillRect(bds.min_x,bds.min_y,bds.width,bds.height);
            case CIRCLE:
              var radius = bds.height * 0.5;
              GraphicsExtension.fillCircle(canvas.g2,bds.min_x+radius,bds.min_y+radius,radius);
            case POLYGON:
              var poly = cast(shape,echo.shape.Polygon);
              GraphicsExtension.fillPolygon(canvas.g2,0,0,cast(poly.vertices));
          }
          
        }
        canvas.g2.color = kha.Color.White;
      });
    }
    #end
    
    if(ordered.length > 0)
      canvas.g2.popTransformation();

  }

  public function getCameraView() : Float32x4 {
    return Float32x4.loadFast(cam.position.x,cam.position.y,Found.WIDTH,Found.HEIGHT);
  }

  public function getObjectNames(?type:String):Array<String>{
    var names = [];
    for(object in _entities){
      if(type == null){
        names.push(object.raw.name);
      }
      else if(object.raw.type == type){
        names.push(object.raw.name);
      }
    }
    return names;
  }

  public function getObjects(name:String){
    if(name=="")return null;
    var objects:Array<Object> = [];
    for(object in _entities){
      if(object.raw.name == name){
          objects.push(object);
      }
    }
    return objects;

  }

  public function getObject(name:String){
    if(name=="")return null;
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

  @:access(found.object.Object)
  public function spawn(objectData:TObj,onDone:Object->Void = null) : Void {    
    addEntity(objectData,function(obj:Object){
      onDone(obj);
      obj.spawned = true;
    } #if editor ,true#end);
  }

  public function add(entity:Object){
    entity.active = true;
    _entities.push(entity);
  }

  @:access(found.object.Object)
  public function remove(entity:Object){
    entity.active = false;
    if(entity.spawned) {
      entity.delete();
    }
  }

  function depth(entities:Array<Object>){
    if (entities.length == 0) return;
    if(zsort){
      ArraySort.sort(entities, function(ent1:Object, ent2:Object){
        if (ent1.layer < ent2.layer || (ent1.layer == ent2.layer && (ent1.depth < ent2.depth || ent1.depth == ent2.depth))){
          return -1;
        } else if (ent1.layer == ent2.layer && Math.floor(ent1.depth) == Math.floor(ent2.depth)){
          return 0;
        } else {
          return 1;
        }
      });

    }else {
      ArraySort.sort(entities, function(ent1:Object, ent2:Object){
        if ((ent1.layer < ent2.layer || ent1.layer == ent2.layer) && ent1.position.y + ent1.height < ent2.position.y + ent2.height){
          return -1;
        } else if (ent1.layer == ent2.layer && ent1.position.y == ent2.position.y){
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
      //@TODO:Test this out with ennemies
      if(!Trait.hasTrait(t.classname+object.uid) && t.props != null){
          Trait.addProps(t.classname+object.uid,t.props);
      }
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

          if(object.active) {
            addToApp(visualTrait);
          }
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
					error("Trait '" + t.classname + "' referenced in object '" + object.name + "' not found");
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
        
        if(object.active) {
          addToApp(traitInst);
        }
      }
		}
  }
  @:access(found.Trait)
  static function addToApp(t:Trait){
    if (t._awake != null) {
      for (f in t._awake) App.notifyOnAwake(f);
      // t._init = null;
    }
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