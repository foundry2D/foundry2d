package found.tool;


import found.math.Util;
import found.data.SceneFormat;
import kha.math.Vector2;

import zui.Id;
import zui.Zui;
import zui.Ext;

@:access(zui.Zui)
class AnimationEditor {
        var ui: Zui;
        public var visible:Bool;
        public static var width:Int;
        public static var height:Int;
        public static var x:Int;
        public static var y:Int;
        static var timeline:kha.Image = null;
        var curSprite:found.anim.Sprite;
        public var selectedUID(default,set):Int = -1;
        var windowHandle:zui.Zui.Handle = Id.handle();
        var timelineHandle:zui.Zui.Handle = Id.handle();
        public function new(px:Int,py:Int,w:Int,h:Int) {
            this.visible = false;
            ui = new Zui({font: kha.Assets.fonts.font_default});
            setAll(px,py,w,h);
            windowHandle.scrollEnabled = true;

        }
    
        public function setAll(px:Int,py:Int,w:Int,h:Int){
            x = px;
            y = py;
            width = w;
            height = h;
        }

        function set_selectedUID(value:Int):Int{
            var oldUid = selectedUID;
            if(value < 0 && value > found.State.active._entities.length){
                selectedUID = -1;
            }
            else{
                var object = found.State.active._entities[value];
                if(object.raw.type == "sprite_object"){
                    curSprite = cast(object);
                    selectedUID = value;
                }
                else {
                    selectedUID = -1;
                }
            }
            if(oldUid != selectedUID){
                windowHandle.redraws = 2;
            }
            return selectedUID;
        }

        var delta = 0.0;
        var lastImage:String = "";
        var doUpdate:Bool = false;
        var numberOfFrames:Float = 67.0;
        var animAction:Array<Float> = [];
        var curFrames:Array<TFrame> = [];
        @:access(found.anim.Sprite)
        public function render(g:kha.graphics2.Graphics){
            if(!visible)return;
            g.end();
            var sc = ui.SCALE();
            var timelineLabelsHeight = Std.int(30 * sc);
            var timelineFramesHeight = Std.int(40 * sc);

            if(timeline==null || timeline.height != timelineLabelsHeight + timelineFramesHeight){
                drawTimeline(timelineLabelsHeight, timelineFramesHeight);
            }

            numberOfFrames = timeline.width / (11 * sc)-1;
            ui.begin(g);
            if(curSprite != null && lastImage != curSprite.data.raw.imagePath){
                lastImage = curSprite.data.raw.imagePath;
                curFrames = curSprite.data.raw.anims != null ? curSprite.data.raw.anims[0].frames : [];
                frameHandles = []; 
                timelineHandle.redraws = windowHandle.redraws = 2;//redraw
            }
            var ty = AnimationEditor.height - timeline.height;
            if(ui.window(windowHandle, AnimationEditor.x, AnimationEditor.y, AnimationEditor.width, ty)){
                ui.row([0.5,0.5]);
                if(delta > numberOfFrames){
                    delta = numberOfFrames;
                    doUpdate = false;
                }
                var state:String = doUpdate ? "Pause": "Play";
                if(ui.button(state)){
                    if(doUpdate){
                        doUpdate = false;
                    }
                    else if (delta >= numberOfFrames) {
                        delta = 0.0;
                        doUpdate = true;
                    }
                    else {
                        doUpdate = true;
                    }
                }
                if(ui.button("Reset")){
                    delta = 0.0;
                    doUpdate = false;
                }

                ui.row([0.75,0.25]);

                if(ui.panel(Id.handle({selected: true}),'',false,false,false)){
                    animationPreview(delta,AnimationEditor.width,ty);
                }
                Ext.panelList(ui,Id.handle({selected: true,layout:0}),curFrames,addItem,null,getName,setName,drawItem,false);

            }
            if(ui.window(timelineHandle,AnimationEditor.x, AnimationEditor.y+ty,AnimationEditor.width, timeline.height)){
                var state = ui.image(timeline);
                if(state == zui.Zui.State.Down ) {
                    delta = Std.int(Math.abs(ui._windowX-ui.inputX) / 11 / ui.SCALE());
                }
                //Select Frame
                ui.g.color = 0xff205d9c;
                ui.g.fillRect(delta*11*sc,timelineLabelsHeight, 10 * sc, timelineFramesHeight);

                // Show selected frame number
                ui.g.font = kha.Assets.fonts.font_default;
                ui.g.fontSize = Std.int(16 * sc);

                var frameIndicatorMargin = 4 * sc;
                var frameIndicatorPadding = 4 * sc;
                var frameIndicatorWidth = 30 * sc;
                var frameIndicatorHeight = timelineLabelsHeight - frameIndicatorMargin * 2;

                var frameTextWidth = kha.Assets.fonts.font_default.width(ui.g.fontSize, "" + 99.00 );
                
                // Scale the indicator if the contained text is too long
                if (frameTextWidth > frameIndicatorWidth + frameIndicatorPadding) {
                    frameIndicatorWidth = frameTextWidth + frameIndicatorPadding;
                }
                ui.g.fillRect(delta * 11 * sc + 5 * sc - frameIndicatorWidth / 2,frameIndicatorMargin, frameIndicatorWidth, frameIndicatorHeight);
                ui.g.color = 0xffffffff;
                ui.g.drawString("" + Util.fround(delta,2), delta * 11 * sc + 5 * sc - frameTextWidth / 2,timelineLabelsHeight / 2 - g.fontSize / 2);
            }
            
            ui.end();
		    g.begin(false);
        }
        function addItem(name:String){
            var frame:TFrame =  {id:0,start:delta,tw: 0,th:0};
            var id = curFrames.push(frame)-1;
            var handles = [];
            for(i in 0...5){
                handles.push(Id.handle({value:0}));
            }
            frameHandles.push(handles);
            frame.id = id;
        }
        function getName(i:Int){
            return "Index : "+curFrames[i].id;
        }
        function setName(i:Int,name:String){
            return;
        }
        var frameHandles:Array<Array<zui.Zui.Handle>> = [];
        function drawItem(handle:Handle,i:Int){
            var cur:TFrame = curFrames[i];
            
            var startHandle = frameHandles[i][0];
            var xHandle = frameHandles[i][1];
            var yHandle = frameHandles[i][2];
            var wHandle = frameHandles[i][3];
            var hHandle = frameHandles[i][4];

            startHandle.value = cur.start;
            cur.start = Std.int(Ext.floatInput(ui,startHandle,"Start"));

            xHandle.value = cur.tx != null ? cur.tx :0;
            cur.tx = Std.int(Ext.floatInput(ui,xHandle,"Tile X"));

            yHandle.value = cur.ty != null ? cur.ty :0;
            cur.ty = Std.int(Ext.floatInput(ui,yHandle,"Tile Y"));

            wHandle.value = cur.tw;
            cur.tw = Std.int(Ext.floatInput(ui,wHandle,"Tile Width"));

            hHandle.value = cur.th;
            cur.th = Std.int(Ext.floatInput(ui,hHandle,"Tile Height"));

        }
        public function update(dt:Float) {
            if(!visible)return;

            if(doUpdate){
                delta+=dt;
                timelineHandle.redraws = windowHandle.redraws = 2;//redraw
            }
        }
        var canvas:kha.Image;
        var origDimensions:Vector2 = new Vector2();
        function animationPreview(delta:Float,width:Int,height:Int){

            ui.g.color = 0xffffffff;
            var size = (width > height ? width:height)*0.25;
            if(canvas == null){
                canvas = kha.Image.createRenderTarget(Std.int(width*0.25),Std.int(height*0.25));
            }
            
            var rx = width*0.5 - size * 0.5;
            var ry = height*0.5 - size * 0.5+ui.BUTTON_H()*0.5;
            if(selectedUID > 0){
                var scale = 1.0;
                if(width > height){
                    scale = curSprite.width > width*0.25 ? width*0.25/curSprite.width:1.0;
                }
                else{
                    scale = curSprite.height > height*0.25 ? height*0.25/curSprite.height:1.0;
                }
                origDimensions.x = curSprite.scale.x;
                origDimensions.y = curSprite.scale.y;
                curSprite.scale.x = scale;
                curSprite.scale.y = scale;
                canvas.g2.pushTranslation(-curSprite.position.x+rx+size*0.25,-curSprite.position.y+ry+size*0.25);
                curSprite.render(canvas);
                canvas.g2.popTransformation();
                ui.g.drawImage(canvas,rx,ry);
                curSprite.scale.x = origDimensions.x;
                curSprite.scale.y = origDimensions.y;
            }
            ui.g.drawRect(rx,ry,size,size);
        }
        function onResize(width:Int,height:Int){
            canvas = kha.Image.createRenderTarget(Std.int(width*0.25),Std.int(height*0.25));
            canvas.g2.clear(kha.Color.Transparent);
        }
        function drawTimeline(timelineLabelsHeight:Int, timelineFramesHeight:Int) {
            var sc = ui.SCALE();
    
            var timelineHeight = timelineLabelsHeight + timelineFramesHeight;
    
            timeline = kha.Image.createRenderTarget(AnimationEditor.width, timelineHeight);
    
            var g = timeline.g2;
            g.begin(true, 0xff222222);
            g.font = kha.Assets.fonts.font_default;
            g.fontSize = Std.int(16 * sc);
    
            // Labels
            var frames = Std.int(timeline.width / (11 * sc));
            for (i in 0...Std.int(frames / 5) + 1) {
                var frame = i * 5;
    
                var frameTextWidth = kha.Assets.fonts.font_default.width(g.fontSize, frame + "");
                g.drawString(frame + "", i * 55 * sc + 5 * sc - frameTextWidth / 2, timelineLabelsHeight / 2 - g.fontSize / 2);
            }
    
            // Frames
            for (i in 0...frames) {
                g.color = i % 5 == 0 ? 0xff444444 : 0xff333333;
                g.fillRect(i * 11 * sc, timelineHeight - timelineFramesHeight, 10 * sc, timelineFramesHeight);
            }
    
            g.end();
        }
}