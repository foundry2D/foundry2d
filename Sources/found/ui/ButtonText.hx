package found.ui;

import kha.Canvas;
import kha.Color;
import kha.math.Vector2;

import found.object.Entity;
// import found.ui.Text;

class ButtonText extends Entity {
  public var offset:Vector2 = new Vector2(12, 8);
  public var text:Text;

  public var string:String;
  public var fontname:String;

	public var onClick:Void -> Void;
	public var isClicked:Bool;

	public var colorFrame:Color = Color.White;
	public var colorOn:Color = Color.Green;
	public var colorOff:Color = Color.Black;

	public function new(fontname:String, string:String, ?x:Float = 0, ?y:Float = 0, ?size:Int = 32){
    this.fontname = fontname;
    this.string = string;
    text = new Text(fontname, string, x, y, size);
		super(x, y, offset.x + text.font.width(size, string), offset.y + text.font.height(size));

		isClicked = false;
	}

	override public function update(){
		super.update();
    text.position.x = position.x + offset.x / 2;
    text.position.y = position.y + offset.y / 2;
	}

	override public function render(canvas:Canvas){
    update();
		super.render(canvas);
		if (isClicked){
			canvas.g2.color = colorOn;
			canvas.g2.fillRect(position.x, position.y, width, height);
			canvas.g2.color = colorFrame;
			canvas.g2.drawRect(position.x, position.y, width, height);
		} else {
			canvas.g2.color = colorOff;
			canvas.g2.fillRect(position.x, position.y, width, height);
			canvas.g2.color = colorFrame;
			canvas.g2.drawRect(position.x, position.y, width, height);
		}
    text.render(canvas);
		isClicked = false;
	}

	public function onButtonDown(x:Int, y:Int){
		if (x >= position.x && x <= position.x + width && y >= position.y && y <= position.y + height){
			isClicked = true;
			if (this.onClick != null){
				onClick();
			}
			return true;
		}
		return false;
	}
}