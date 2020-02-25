package found.anim;


import found.data.SceneFormat.TFrame;

class Animation {
	private var _frames: Array<TFrame>;
	private var _speeddiv: Int;
	private var _count: Int;
	private var _index: Int;
	
	public static function create(frame: TFrame) {
		return new Animation([frame], 1);
	}
	
	public static function createFrames(width:Int,height:Int,maxindex: Int, speeddiv: Int): Animation {
		var frames = new Array<TFrame>();
		for (i in 0...maxindex) frames.push({id:i,tw:width,th:height});
		return new Animation(frames, speeddiv);
	}
	
	public function new(frames:Array<TFrame>,speeddiv: Int) {
		this._frames = frames;
		_index = 0;
		this._speeddiv = speeddiv;
	}
	
	public function take(animation: Animation) {
		if (_frames == animation._frames) return;
		_frames = animation._frames;
		_speeddiv = animation._speeddiv;
		reset();
	}
	
	public function get(): TFrame {
		return _frames[_index];
	}
	
	public function getIndex(): Int {
		return _index;
	}
	
	public function setIndex(index: Int): Void {
		if (index < _frames.length) this._index = index;
	}
	
	public function next(): Bool {
		++_count;
		if (_count % _speeddiv == 0) {
			++_index;
			if (_index >= _frames.length) {
				_index = 0;
				return false;
			}
		}
		return true;
	}
	
	public function reset(): Void {
		_count = 0;
		_index = 0;
	}
}