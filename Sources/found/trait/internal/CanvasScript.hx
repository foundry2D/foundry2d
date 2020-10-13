package found.trait.internal;

import kha.math.Vector2;
import kha.Assets;
import found.Trait;
import zui.Zui;
import zui.Canvas;

class CanvasScript extends Trait {


	var cui: Zui;
	var canvas: TCanvas = null;
	var baseWidth:Int;
	var baseHeight:Int;
    
    var customDraw:Map<String,kha.graphics2.Graphics->TElement->Void>;

	public var ready(get, null): Bool;
	function get_ready(): Bool { return canvas != null; }

    public var visible(default,set):Bool = true;
    function set_visible(visible: Bool){
        this.visible = visible; 
        for (e in canvas.elements) e.visible = visible;
        return this.visible;
	}


	/**
	 * Create new CanvasScript from canvas
	 * @param canvasName Name of the canvas
	 * @param font font file (Optional)
	 */
	public function new(canvasName: String, font: String = "font_default.ttf",b_canvas:kha.Blob=null,?noWarn:Bool=false) {
        super();
        
        customDraw = new Map<String,kha.graphics2.Graphics->TElement->Void>();
        var done = function(blob: kha.Blob) {
            var tBlob = kha.Assets.blobs.get("_themes.json");
        
            if (tBlob != null) {
                Canvas.themes = haxe.Json.parse(tBlob.toString());
            }
            else if(!noWarn){
				warn("\"_themes.json\" is empty! Using default theme instead.");
            }

            if (Canvas.themes.length == 0) {
                Canvas.themes.push(zui.Themes.dark);
            }

            var onFontDone =  function(f: kha.Font) {
                var c: TCanvas = haxe.Json.parse(blob.toString());
                if (c.theme == null) c.theme = Canvas.themes[0].NAME;
                cui = new Zui({font: f, theme: Canvas.getTheme(c.theme)});

                if (c.assets == null || c.assets.length == 0) canvas = c;
                else { // Load canvas assets
                    var loaded = 0;
                    for (asset in c.assets) {
                        var file = asset.name;
                        found.data.Data.getImage(file, function(image: kha.Image) {
                            Canvas.assetMap.set(asset.id, image);
                            if (++loaded >= c.assets.length) canvas = c;
                        });
                    }
                }
            }
            if(font == "font_default.ttf"){
                onFontDone(kha.Assets.fonts.font_default);
            }
            else {
                found.data.Data.getFont(font,onFontDone);
            }
        };

        if(b_canvas != null){
            done(b_canvas);
        }
        else{
            found.data.Data.getBlob(canvasName + ".json",done);
        }
		
		notifyOnReady(function(){
			baseWidth = canvas.width;
			baseHeight = canvas.height;
		});

		notifyOnRender2D(function(g: kha.graphics2.Graphics) {
			if (canvas == null || !visible) return;
			
			if (onReady != null) { onReady(); onReady = null; }
			var hasPos:Bool = this.object != null;
			
			if(hasPos){
				g.pushTranslation(this.object.position.x,this.object.position.y);
			}

			setCanvasDimensions(kha.System.windowWidth(), kha.System.windowHeight());
			var events = Canvas.draw(cui, canvas, g);

			if(hasPos)
				g.popTransformation();

			g.end();
            for(key in customDraw.keys()){
                var element = getElement(key);
                if(element != null){
                    customDraw.get(key)(g,element);
                }
			}
			g.begin(false);

			for (e in events) {
				var all = found.Event.get(e);
				if (all != null) for (entry in all) entry.onEvent();
			}
		});
	}
	
	var onReady: Void->Void = null;
	public function notifyOnReady(f: Void->Void) {
		onReady = f;
	}

	/**
	 * Returns an element of the canvas.
	 * @param name The name of the element
	 * @return TElement
	 */
	public function getElement(name: String): TElement {
		for (e in canvas.elements) if (e.name == name) return e;
		return null;
	}

	/**
	 * Returns an array of the elements of the canvas.
	 * @return Array<TElement>
	 */
	public function getElements(): Array<TElement> {
		return canvas.elements;
	}

	/**
	 * Returns the canvas object of this trait.
	 * @return TCanvas
	 */
	public function getCanvas(): Null<TCanvas> {
		return canvas;
	}

	/**
	 * Set UI scale factor.
	 * @param factor Scale factor.
	 */
	 public function setUiScale(factor:Float) {
		cui.setScale(factor);
	}

	
	
	/**
	 * Set dimensions of canvas
	 * @param x Width
	 * @param y Height
	 */
	public function setCanvasDimensions(x: Int, y: Int){
		if(canvas.width != x || canvas.height != y){
			canvas.width = x;
			canvas.height = y;
			for (i in 0...canvas.elements.length){
				canvas.elements[i] = getScaledElement(canvas.elements[i]);
			}
		}
		
	}
	/**
	 * Set font size of the canvas
	 * @param fontSize Size of font to be setted
	 */
	public function setCanvasFontSize(fontSize: Int) {
		cui.t.FONT_SIZE = fontSize;
	}

	// Contains data
	@:access(zui.Canvas)
	@:access(zui.Handle)
	public function getHandle(name: String): Handle {
		// Consider this a temporary solution
		return Canvas.h.children[getElement(name).id];
	}
	
	@:access(zui.Canvas)
    function getScaledElement(elem:TElement):TElement{
		//@TODO: add anchor code to position elements based the anchors set.
		var element = Reflect.copy(elem);
        element.x = Math.floor((elem.x/baseWidth)*canvas.width);
        element.y = Math.floor((elem.y/baseHeight)*canvas.height);
        element.width = Math.floor((elem.width/baseWidth)*canvas.width);
        element.height = Math.floor((elem.height/baseHeight)*canvas.height);
        return element;
    }
    
    public function addCustomDraw(name:String, func:kha.graphics2.Graphics->TElement->Void){
		customDraw.set(name,func);
    }
    public function removeCustomDraw(name:String){
		customDraw.remove(name);
    }
}
