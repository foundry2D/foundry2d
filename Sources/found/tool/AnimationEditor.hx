package found.tool;

import found.zui.Id;
import found.zui.Zui;

@:access(found.zui.Zui)
class AnimationEditor {
        var ui: Zui;
        public var visible:Bool;
        public static var width:Int;
        public static var height:Int;
        public static var x:Int;
        public static var y:Int;
        static var timeline:kha.Image = null;
        var curSprite:found.anim.Sprite;
        var selectedUID:Int = -1;
        public function new(px:Int,py:Int,w:Int,h:Int) {
            this.visible = false;
            ui = new Zui({font: kha.Assets.fonts.font_default});
            setAll(px,py,w,h);

        }
    
        public function setAll(px:Int,py:Int,w:Int,h:Int){
            x = px;
            y = py;
            width = w;
            height = h;
        }
        var delta = 0.0;
        public function render(g:kha.graphics2.Graphics){
            if(!visible)return;
            g.end();
            var sc = ui.SCALE();
            var timelineLabelsHeight = Std.int(30 * sc);
            var timelineFramesHeight = Std.int(40 * sc);

            if(timeline==null || timeline.height != timelineLabelsHeight + timelineFramesHeight){
                drawTimeline(timelineLabelsHeight, timelineFramesHeight);
            }

            ui.begin(g);
            if(ui.window(Id.handle(), AnimationEditor.x, AnimationEditor.y, AnimationEditor.width, AnimationEditor.height)){
                var ty = AnimationEditor.height - timeline.height;
                animationPreview(delta,AnimationEditor.width,ty);
                ui._y = ty;
                var state = ui.image(timeline);
                
                if(state == found.zui.Zui.State.Down ) {
                    delta = Std.int(Math.abs(ui._windowX-ui.inputX) / 11 / ui.SCALE());
                }
                //Select Frame
                ui.g.color = 0xff205d9c;
                ui.g.fillRect(delta*11*sc,ty + timelineLabelsHeight, 10 * sc, timelineFramesHeight);

                // Show selected frame number
                ui.g.font = kha.Assets.fonts.font_default;
                ui.g.fontSize = Std.int(16 * sc);

                var frameIndicatorMargin = 4 * sc;
                var frameIndicatorPadding = 4 * sc;
                var frameIndicatorWidth = 30 * sc;
                var frameIndicatorHeight = timelineLabelsHeight - frameIndicatorMargin * 2;
                var frameTextWidth = kha.Assets.fonts.font_default.width(ui.g.fontSize, "" + delta);
                
                // Scale the indicator if the contained text is too long
                if (frameTextWidth > frameIndicatorWidth + frameIndicatorPadding) {
                    frameIndicatorWidth = frameTextWidth + frameIndicatorPadding;
                }
                ui.g.fillRect(delta * 11 * sc + 5 * sc - frameIndicatorWidth / 2, ty + frameIndicatorMargin, frameIndicatorWidth, frameIndicatorHeight);
                ui.g.color = 0xffffffff;
                ui.g.drawString("" + delta, delta * 11 * sc + 5 * sc - frameTextWidth / 2, ty + timelineLabelsHeight / 2 - g.fontSize / 2);

            }
            
            ui.end();
		    g.begin(false);
        }

        function animationPreview(delta:Float,width:Int,height:Int){
            if(selectedUID >= 0 && selectedUID < found.State.active._entities.length)return;
            if(curSprite == null){
                curSprite = cast(found.State.active._entities[selectedUID]);
            }
            ui.g.color = 0xffffffff;
            var size = (width > height ? width:height)*0.25;
            var rx = width*0.5 - size * 0.5;
            var ry = height*0.5 - size * 0.5;
            ui.g.drawRect(rx,ry,size,size);
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