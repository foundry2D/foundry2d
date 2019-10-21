package coin.data;

import haxe.Json;
import haxe.io.BytesInput;
import iron.data.SceneFormat;
import iron.system.ArmPack;
using StringTools;

// Global data list and asynchronous data loading
class Data {

	public static var cachedSceneRaws:Map<String, TSceneFormat> = new Map();
    public static var cachedSprites:Map<String, SpriteData> = new Map();
    public static var cachedRects:Map<String, RectData> = new Map();