package coin;

import kha.Framebuffer;
import kha.Scheduler;
import kha.Assets;
import kha.System;
import kha.Color;
import kha.Image;

#if kha_html5
import js.html.CanvasElement;
import js.Browser.document;
import js.Browser.window;
#end

class Coin {
  private static var _app:App;
  
  public static var WIDTH(default, null):Int = 1280;
  public static var HEIGHT(default, null):Int = 720;

  public static var GRID:Int = 64;

  public static var backbuffer:Image;
  #if editor
  public static var scenebuffer:Image;
  public static var uibuffer:Image;
  public static var renderfunc:kha.graphics2.Graphics->Void;
  public static var fullscreen:Bool = false;
  
  public static var BUFFERWIDTH(default, default):Int = WIDTH;
  public static var BUFFERHEIGHT(default, default):Int = HEIGHT;
  #else 
  public static var BUFFERWIDTH(default, null):Int = WIDTH;
  public static var BUFFERHEIGHT(default, null):Int = HEIGHT;
  #end

  public static var mouseX:Int = 0;
	public static var mouseY:Int = 0;

  public static var sceneX:Float=0.0;
  public static var sceneY:Float=0.0;
  public static var backgroundcolor:Color;

  public static var smooth:Bool;

  private static var _fps:Float;

  public static function setup(config:CoinConfig){
    if (config.width == null) config.width = WIDTH;
    if (config.height == null) config.height = HEIGHT;
    if (config.bufferwidth == null) config.bufferwidth = WIDTH;
    BUFFERWIDTH = config.bufferwidth;
    if (config.bufferheight == null) config.bufferheight = HEIGHT;
    BUFFERHEIGHT = config.bufferheight;

    if (config.fps == null) config.fps = 60;
    _fps = config.fps;

    if (config.backgroundcolor == null) config.backgroundcolor = Color.Black;
    backgroundcolor = config.backgroundcolor;

    if (config.smooth == null) config.smooth = false;
    smooth = config.smooth;

    html();

    System.start({
			title:config.title,
			width:config.width,
			height:config.height
		},
		function(_){
			Assets.loadEverything(function(){
				Scheduler.addTimeTask(update, 0, 1 / _fps);
        _app = Type.createInstance(config.app, []);
				System.notifyOnFrames(function(framebuffer){
				  render(framebuffer[0]);
				});
			});
		});
  }

  static function update(){
    Timer.update();
    _app.update(Timer.delta);
  }

  static function render(framebuffer:Framebuffer){
    _app.render(framebuffer);
  }

  static function html(){
    #if kha_html5
    document.documentElement.style.padding = '0';
    document.documentElement.style.margin = '0';
    document.body.style.padding = '0';
    document.body.style.margin = '0';

    var canvas = cast(document.getElementById('khanvas'), CanvasElement);
    canvas.style.display = 'block';

    var resize = function(){
      canvas.width = Std.int(window.innerWidth * window.devicePixelRatio);
      canvas.height = Std.int(window.innerHeight * window.devicePixelRatio);
      canvas.style.width = document.documentElement.clientWidth + 'px';
      canvas.style.height = document.documentElement.clientHeight + 'px';
    }
    window.onresize = resize;
    resize();
    #end
  }
}

typedef CoinConfig = {
  app:Class<App>,
  ?timer:Timer,
  ?title:String,
  ?width:Int,
  ?height:Int,
  ?bufferwidth:Int,
  ?bufferheight:Int,
  ?backgroundcolor:Color,
  ?smooth:Bool,
  ?fps:Float
}