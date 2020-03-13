package found.tool;


import found.math.Vec2;
import found.math.Util;
import found.data.SceneFormat;
import found.anim.Animation;

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
        static var dot:kha.Image = null;
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

        @:access(found.anim.Sprite,found.anim.Animation)
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
                    if(curSprite != null){
                        curFrames = curSprite.data.animation._frames.copy();
                        lastImage = "";
                        curSprite = null;
                        animIndex = -1;
                    }
                    curFrames.resize(0);
                    animations.resize(0);
                }
            }
            if(oldUid != selectedUID){
                timelineHandle.redraws = windowHandle.redraws = 2;
            }
            return selectedUID;
        }

        var delta = 0.0;
        var lastImage:String = "";
        var doUpdate:Bool = false;
        var numberOfFrames:Float = 67.0;
        var animAction:Array<Float> = [];
        var curFrames(default,set):Array<TFrame> = [];
        function set_curFrames(data:Array<TFrame>){
            if(curFrames.length != data.length){
                for(frame in data){
                    var handles = [];
                    for(i in 0...5){
                        handles.push(new zui.Zui.Handle({value:0}));
                    }
      
                    frameHandles.push(handles);
                }
            }
            return curFrames = data; 
        }
        var animations:Array<String> = [];
        var animIndex:Int  = -1;
        var animHandle:zui.Zui.Handle = new zui.Zui.Handle();
        var fpsHandle:zui.Zui.Handle =  new zui.Zui.Handle();
        @:access(found.anim.Sprite,found.anim.Animation)
        public function render(g:kha.graphics2.Graphics){
            if(!visible)return;
            g.end();
            var sc = ui.SCALE();
            var timelineLabelsHeight = Std.int(30 * sc);
            var timelineFramesHeight = Std.int(40 * sc);

            if(timeline==null || timeline.height != timelineLabelsHeight + timelineFramesHeight){
                drawTimeline(timelineLabelsHeight, timelineFramesHeight);
                drawDot();
            }

            numberOfFrames = timeline.width / (11 * sc)-1;
            ui.begin(g);
            if(curSprite != null && lastImage != curSprite.data.raw.imagePath){
                lastImage = curSprite.data.raw.imagePath;
                frameHandles = []; 
                if(curSprite.data.raw.anims.length > 0){
                    for(anim in curSprite.data.raw.anims){
                        animations.push(anim.name);
                    }
                    animIndex = curSprite.data.curAnim;
                    curFrames = curSprite.data.animation._frames;
                }
                else {
                    // curFrames.resize(0);
                    animations.resize(0);
                }
                 
                timelineHandle.redraws = windowHandle.redraws = 2;//redraw
            }
            var viewHeight = AnimationEditor.height - timeline.height;
            if(ui.window(windowHandle, AnimationEditor.x, AnimationEditor.y, AnimationEditor.width, viewHeight)){
                ui.row([0.5,0.25,0.25]);
                animHandle.position = animIndex;
                animIndex = ui.combo(animHandle,animations);
                if(curSprite != null && animHandle.changed){
                    curSprite.data.curAnim = animIndex;
                }
                if(ui.button("New Animation") && curSprite != null){
                    var id = animations.length;
                    animIndex = animations.push('Animation $id')-1;
                    if(animIndex == 0){
                        var frame:TFrame = {id:0,start:0.0,tw:Std.int(curSprite.data.raw.width),th:Std.int(curSprite.data.raw.height)};
                        curSprite.data.animation.take(Animation.create(frame));
                        curFrames = curSprite.data.animation._frames;

                    }
                    else {
                        curSprite.data.curAnim = curSprite.data.addSubSprite(0);
                        curFrames = curSprite.data.animation._frames;
                    }
                    for(frame in curFrames){
                        var handles = [];
                        for(i in 0...5){
                            handles.push(new zui.Zui.Handle({value:0}));
                        }
                        frameHandles.push(handles);
                    }
                    curSprite.data.animation.name = animations[animIndex];
                    timelineHandle.redraws = 2;
                }

                if(ui.button("Save Animations") && curSprite != null){
                    saveAnimations();
                    #if editor
                    EditorHierarchy.makeDirty();
                    #end
                }

                if(animIndex > -1){
                    var editable = false;
                    fpsHandle.text = ""+curSprite.data.animation._speeddiv;
                    curSprite.data.animation._speeddiv = Std.parseInt(ui.textInput(fpsHandle,"Fps: ",Align.Left,editable));
                }
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
                    timelineHandle.redraws = 2;
                }

                ui.row([0.75,0.25]);

                ui.panel(Id.handle({selected: true}),'',false,false,false);
                var oldY = ui._y;
                Ext.panelList(ui,Id.handle({selected: true,layout:0}),curFrames,addItem,removeItem,getName,setName,drawItem,false);
                animationPreview(delta,AnimationEditor.width,viewHeight,oldY);

            }

            if(ui.window(timelineHandle,AnimationEditor.x, AnimationEditor.y+viewHeight,AnimationEditor.width, timeline.height)){
                
                ui.imageScrollAlign =false;// This makes its so that we can cheat the image drawing to draw well to make it easier to have valid input
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

                ui.g.color = kha.Color.fromBytes(255,100,100,255);
                var old = new Vec2(ui._x,ui._y);
                for(frame in curFrames){
                    var frameWidth = 10 * sc;
                    ui._x = frame.start * 11 * sc;
                    ui._y = timelineLabelsHeight*0.5 + timelineFramesHeight*0.5+frameWidth*0.75;
                    var state = ui.image(dot,0xffffff00,null,0,0,Std.int(frameWidth*0.5),Std.int(frameWidth*0.5));
                    ui._x = frame.start * 11 * sc;
                    ui._y = timelineLabelsHeight*0.5 + timelineFramesHeight*0.5 + frameWidth*0.75;
                    if(ui.getHover()){
                        ui.tooltip("Frame: " + frame.id);
                    }
                    
                    // ui.g.drawString(, frame.start * 11 * sc + 5 * sc - frameTextWidth / 2 +frameWidth* 0.25,timeline.height*0.5+frameWidth*0.5);
                }
                ui._x = old.x;
                ui._y = old.y;
                ui.imageScrollAlign =true;
            }
            
            ui.end();
		    g.begin(false);
        }
        
        @:access(found.anim.Sprite,found.anim.Animation)
        function addItem(name:String){
            if(animIndex < 0) return;
            for(frame in  curFrames){
                if(frame.start == delta){
                    //@TODO: Implement warning popup in zui or in editor
                    return;
                }
            }

            var frame:TFrame =  {id:0,start:delta,tw: 0,th:0};
            var id = curFrames.push(frame)-1; // @:TODO: We seem to add the frames back when we reload( I.e. doubling the frames we should investigate here)
            var handles = [];
            for(i in 0...5){
                handles.push(new zui.Zui.Handle({value:0}));
            }

            frameHandles.push(handles);
            frame.id = id;

            if( curFrames.length > 1){
                var firstFrame = curFrames[0];
                curSprite.data.animation._speeddiv = Std.int(Math.abs(firstFrame.start-frame.start)*10);
            }

            timelineHandle.redraws = 2;
        }
        function removeItem(i:Int){
            curFrames.splice(i,1);
            for( index in 0...curFrames.length){
                if(curFrames[index].id != index){
                    curFrames[index].id = index;
                }
            }
            frameHandles.splice(i,1);
            timelineHandle.redraws = 2;
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
        @:access(found.anim.Sprite,found.data.SpriteData,found.anim.Animation)
        public function update(dt:Float) {
            if(!visible)return;

            if(doUpdate && curSprite != null){
                var currentCount = curSprite.data.animation._speeddiv - (curSprite.data.animation._count % curSprite.data.animation._speeddiv); 
                delta = currentCount/curSprite.data.animation._speeddiv;
                timelineHandle.redraws = windowHandle.redraws = 1;//redraw
            }
        }
        var canvas:kha.Image;
        var origDimensions:Vec2 = new Vec2();
        @:access(found.anim.Sprite,found.data.SpriteData,found.anim.Animation)
        function animationPreview(delta:Float,width:Int,height:Int,oldY:Float){

            var size = (width > height ? width:height)*0.25;
            var rx = width*0.5 - size * 0.5;
            // var ry = height*0.5 - size * 0.5+ui.BUTTON_H()*0.5;
            if(canvas == null){
                canvas = kha.Image.createRenderTarget(Std.int(width*0.25),Std.int(height*0.25));
            }

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
                canvas.g2.pushTranslation(-curSprite.position.x+rx+size*0.25,-curSprite.position.y+oldY+size*0.25);
                if(!doUpdate){
                    curSprite.data.animation._count = 0;
                    curSprite.data.animation._index = 0;
                }
                curSprite.render(canvas);
                if( doUpdate && curSprite.data.animation._index == 0){
                    this.delta = 0.0;
                    timelineHandle.redraws = 2;
                }
                canvas.g2.popTransformation();

                curSprite.scale.x = origDimensions.x;
                curSprite.scale.y = origDimensions.y;
            }

            ui.image(canvas,0xffffffff,size,Std.int(rx),Std.int(oldY));
            ui.g.drawRect(rx,oldY,size,size);
            
        }
        function onResize(width:Int,height:Int){
            canvas = kha.Image.createRenderTarget(Std.int(width*0.25),Std.int(height*0.25));
            canvas.g2.clear(kha.Color.Transparent);
        }
        function drawDot(){
            var frameWidth = Std.int(10 * ui.SCALE())*4;
            dot = kha.Image.createRenderTarget(frameWidth, frameWidth);
            var g = dot.g2;
            g.begin(true);
            g.color = kha.Color.Red;
            g.fillTriangle(0,frameWidth,frameWidth*0.5,0,frameWidth,frameWidth);
            g.end();
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

        @:access(found.anim.Sprite,found.data.SpriteData,found.anim.Animation)
        public function saveAnimations(){
            if(curSprite == null)return;
            var animations:Array<TAnimation> = [];
            for(anim in curSprite.data.anims){
                var isWholeImage = anim._frames.length == 1 && anim._frames[0].tw == curSprite.data.image.width && anim._frames[0].th == curSprite.data.image.height;   
                if(!isWholeImage){
                    var out:TAnimation = {name: anim.name,frames: anim._frames,fps: anim._speeddiv,time:0.0};
                    for( frame in out.frames){
                        if(out.time < frame.start) out.time = frame.start;
                    }
                    animations.push(out);
                    curSprite.dataChanged = true;
                }
            }

            curSprite.data.raw.anims = animations;
        }
}