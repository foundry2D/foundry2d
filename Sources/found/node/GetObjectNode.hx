package found.node;

@:keep
class GetObjectNode extends LogicNode {
	public var objectList:Array<Dynamic>;

	public function new(tree:LogicTree) {
		super(tree);
    }
    
    // function update(dt:Float) {
    //     trace()
    // }

	// override function get(from: Int): Dynamic {
	// 	return value;
	// }
}
