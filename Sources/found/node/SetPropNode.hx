package found.node;

import found.data.SceneFormat.TTrait;

class SetPropNode extends LogicNode {

	public var classname:String;
	public var propertyName:String;

	public function new(tree: LogicTree) {
		super(tree);
		tree.notifyOnRemove(reset);
	}
	@:access(found.Trait)
	function reset(){
		for(t in tree.object.raw.traits){
			if(t.classname == classname && t.props != null){
				Trait.props.set(classname+tree.object.uid,t.props);
			}
		}
	}
	@:access(found.Trait)
	override function run(from:Int) {
		var props = Trait.getProps(classname+tree.object.uid);
		var i = 0;
		for(p in props){
			if(StringTools.contains(p,propertyName)){
				var prop = p.split("~");
				prop.pop();
				var newValue = inputs[1].get();
				prop.push('$newValue');
				props[i] = prop.join('~');
				Trait.props.set(classname+tree.object.uid,props);
				break;
			}
			i++;
		}
		
	}
}
