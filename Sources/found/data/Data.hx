package found.data;

import haxe.Json;
import haxe.io.BytesInput;
import found.data.SceneFormat;
// import iron.system.ArmPack;
using StringTools;

// Global data list and asynchronous data loading
class Data {

	public static var cachedSceneRaws:Map<String, TSceneFormat> = new Map();
    public static var cachedSprites:Map<String, SpriteData> = new Map();
    public static var cachedRects:Map<String, RectData> = new Map();
    public static var cachedEmitters:Map<String, EmitterData> = new Map();

	public static var cachedBlobs:Map<String, kha.Blob> = new Map();
	public static var cachedImages:Map<String, kha.Image> = new Map();
    
	public static var cachedSounds:Map<String, kha.Sound> = new Map();
	public static var cachedVideos:Map<String, kha.Video> = new Map();
	public static var cachedFonts:Map<String, kha.Font> = new Map();

    public static var assetsLoaded = 0;
    static var loadingSceneRaws:Map<String, Array<TSceneFormat->Void>> = new Map();
    static var loadingEmitters:Map<String, Array<EmitterData->Void>> = new Map();
    static var loadingSprites:Map<String, Array<SpriteData->Void>> = new Map();
    static var loadingRects:Map<String, Array<RectData->Void>> = new Map();

    static var loadingBlobs:Map<String, Array<kha.Blob->Void>> = new Map();
	static var loadingImages:Map<String, Array<kha.Image->Void>> = new Map();
	
	static var loadingSounds:Map<String, Array<kha.Sound->Void>> = new Map();
	static var loadingVideos:Map<String, Array<kha.Video->Void>> = new Map();
	static var loadingFonts:Map<String, Array<kha.Font->Void>> = new Map();

    #if data_dir
	public static var dataPath = './data/';
	#else
	public static var dataPath = '';
	#end

    public function new() {}

    public static function deleteAll() {
		// for (c in cachedSprites) c.delete();
		cachedSprites = new Map();
		// for (c in cachedRects) c.delete();
		cachedRects = new Map();
		cachedSceneRaws = new Map();
		// cachedLights = new Map();
		// cachedCameras = new Map();
		cachedEmitters = new Map();
		

		for (c in cachedBlobs) c.unload();
		cachedBlobs = new Map();
		for (c in cachedImages) c.unload();
		cachedImages = new Map();
		#if arm_audio
		for (c in cachedSounds) c.unload();
		cachedSounds = new Map();
		#end
		for (c in cachedVideos) c.unload();
		cachedVideos = new Map();
		for (c in cachedFonts) c.unload();
		cachedFonts = new Map();
	}

    public static function getSceneRaw(file:String, done:TSceneFormat->Void) {
		var cached = cachedSceneRaws.get(file);
		if (cached != null) { done(cached); return; }

		var loading = loadingSceneRaws.get(file);
		if (loading != null) { loading.push(done); return; }

		loadingSceneRaws.set(file, [done]);

		// If no extension specified, set to .arm
		var compressed = file.endsWith('.lz4');
		var isJson = file.endsWith('.json');
		var ext = (compressed || isJson || file.endsWith('.arm')) ? '' : '.arm';

		getBlob(file + ext, function(b:kha.Blob) {
			if (compressed) {
				#if arm_compress
				#end
			}

			var parsed:TSceneFormat = null;
			if (isJson) {
				var s = b.toString();
				parsed = /*s.charAt(0) == "{" ? */Json.parse(s) /*: ArmPack.decode(b.toBytes())*/;
			}
			else {
				// parsed = ArmPack.decode(b.toBytes());
			}

			returnSceneRaw(file, parsed);
		});
	}

	static function returnSceneRaw(file:String, parsed:TSceneFormat) {
		var separated = file.split('/');
		var name = separated[separated.length-1];
		cachedSceneRaws.set(name, parsed);
		for (f in loadingSceneRaws.get(file)) f(parsed);
		loadingSceneRaws.remove(file);
	}

    // Raw assets
	public static function getBlob(file:String, done:kha.Blob->Void) {
		var cached = cachedBlobs.get(file); // Is already cached
		if (cached != null) { done(cached); return; }

		var loading = loadingBlobs.get(file); // Is already being loaded
		if (loading != null) { loading.push(done); return; }

		loadingBlobs.set(file, [done]); // Start loading

		var p = (file.charAt(0) == '/' || file.charAt(1) == ':') ? file : dataPath + file;

		kha.Assets.loadBlobFromPath(p, function(b:kha.Blob) {
			cachedBlobs.set(file, b);
			for (f in loadingBlobs.get(file)) f(b);
			loadingBlobs.remove(file);
			assetsLoaded++;
		},function(failed:kha.AssetError){
			var error = failed.error;
			var path = failed.url; 
			trace('Asset at path: $path failed to load because of $error');
		});
	}

    public static function deleteBlob(handle:String) {
		var blob = cachedBlobs.get(handle);
		if (blob == null) return;
		blob.unload();
		cachedBlobs.remove(handle);
	}

    public static function getImage(file:String, done:kha.Image->Void, readable = false, format = 'RGBA32') {
		#if (cpp || hl)
		file = file.substring(0, file.length - 4) + '.k';
		#end

		var cached = cachedImages.get(file);
		if (cached != null) { done(cached); return; }

		var loading = loadingImages.get(file);
		if (loading != null) { loading.push(done); return; }

		loadingImages.set(file, [done]);

		var p = (file.charAt(0) == '/' || file.charAt(1) == ':') ? file : dataPath + file;

		if(Reflect.hasField(kha.Assets.images,file)){
			kha.Assets.loadImage(file,function(b:kha.Image) {
				cachedImages.set(file, b);
				for (f in loadingImages.get(file)) f(b);
				loadingImages.remove(file);
				assetsLoaded++;
			});
		}else{
			// @:Incomplete: process format in Kha
			kha.Assets.loadImageFromPath(p, readable, function(b:kha.Image) {
				cachedImages.set(file, b);
				for (f in loadingImages.get(file)) f(b);
				loadingImages.remove(file);
				assetsLoaded++;
			},function (e:kha.AssetError){
				if(e.url == "")e.url = 'Null';
				trace("Error occurred file " + e.url + " does not exist");
			});
		}
	}

	public static function deleteImage(handle:String) {
		var image = cachedImages.get(handle);
		if (image == null) return;
		image.unload();
		cachedImages.remove(handle);
	}

	/**
	 * Load sound file from disk into ram.
	 *
	 * @param	file A String matching the file name of the sound file on disk.
	 * @param	done Completion handler function to do something after the sound is loaded.
	 */
	public static function getSound(file:String, done:kha.Sound->Void) {
		#if soundcompress
		if (file.endsWith('.wav')) file = file.substring(0, file.length - 4) + '.ogg';
		#end

		var cached = cachedSounds.get(file);
		if (cached != null) { done(cached); return; }

		var loading = loadingSounds.get(file);
		if (loading != null) { loading.push(done); return; }

		loadingSounds.set(file, [done]);

		var p = (file.charAt(0) == '/' || file.charAt(1) == ':') ? file : dataPath + file;

		kha.Assets.loadSoundFromPath(p, function(b:kha.Sound) {
			#if soundcompress
			b.uncompress(function () {
			#end
				cachedSounds.set(file, b);
				for (f in loadingSounds.get(file)) f(b);
				loadingSounds.remove(file);
				assetsLoaded++;
			#if soundcompress
			});
			#end
		});
	}

	public static function deleteSound(handle:String) {
		var sound = cachedSounds.get(handle);
		if (sound == null) return;
		sound.unload();
		cachedSounds.remove(handle);
	}

	public static function getVideo(file:String, done:kha.Video->Void) {
		#if (cpp || hl)
		file = file.substring(0, file.length - 4) + '.avi';
		#elseif krom
		file = file.substring(0, file.length - 4) + '.webm';
		#end
		var cached = cachedVideos.get(file);
		if (cached != null) { done(cached); return; }

		var loading = loadingVideos.get(file);
		if (loading != null) { loading.push(done); return; }

		loadingVideos.set(file, [done]);

		var p = (file.charAt(0) == '/' || file.charAt(1) == ':') ? file : dataPath + file;

		kha.Assets.loadVideoFromPath(p, function(b:kha.Video) {
			cachedVideos.set(file, b);
			for (f in loadingVideos.get(file)) f(b);
			loadingVideos.remove(file);
			assetsLoaded++;
		});
	}

	public static function deleteVideo(handle:String) {
		var video = cachedVideos.get(handle);
		if (video == null) return;
		video.unload();
		cachedVideos.remove(handle);
	}

	public static function getFont(file:String, done:kha.Font->Void) {
		var cached = cachedFonts.get(file);
		if (cached != null) { done(cached); return; }

		var loading = loadingFonts.get(file);
		if (loading != null) { loading.push(done); return; }

		loadingFonts.set(file, [done]);

		var p = (file.charAt(0) == '/' || file.charAt(1) == ':') ? file : dataPath + file;

		kha.Assets.loadFontFromPath(p, function(b:kha.Font) {
			cachedFonts.set(file, b);
			for (f in loadingFonts.get(file)) f(b);
			loadingFonts.remove(file);
			assetsLoaded++;
		});
	}

	public static function deleteFont(handle:String) {
		var font = cachedFonts.get(handle);
		if (font == null) return;
		font.unload();
		cachedFonts.remove(handle);
	}
}