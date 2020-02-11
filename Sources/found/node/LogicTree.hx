package found.node;

@:keep
class LogicTree extends found.Trait {

	public var loopBreak = false; // Trigger break from loop nodes

	public function new() {
		super();
	}

	public function add() {}

	var paused = false;

	public function pause() {
		if (paused) return;
		paused = true;

		if (_update != null) for (f in _update) found.App.removeUpdate(f);
	}

	public function resume() {
		if (!paused) return;
		paused = false;

		if (_update != null) for (f in _update) found.App.notifyOnUpdate(f);
	}
}
