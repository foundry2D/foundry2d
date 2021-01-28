package found.data;

import found.tool.Log;
import kha.Assets;
import kha.arrays.Float32Array;
import kha.Sound;
import haxe.Json;
import haxe.io.BytesInput;
import found.data.SceneFormat;
// import iron.system.ArmPack;
using StringTools;

// Global data list and asynchronous data loading
class Data {

	public static var version = 0.1;
	public static var cachedSceneRaws:Map<String, TSceneFormat> = new Map();

	public static var cachedBlobs:Map<String, kha.Blob> = new Map();
	public static var cachedImages:Map<String, kha.Image> = new Map();
    
	public static var cachedSounds:Map<String, kha.Sound> = new Map();
	public static var cachedVideos:Map<String, kha.Video> = new Map();
	public static var cachedFonts:Map<String, kha.Font> = new Map();

    public static var assetsLoaded = 0;
    static var loadingSceneRaws:Map<String, Array<TSceneFormat->Void>> = new Map();

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
		cachedSceneRaws = new Map();
		// cachedLights = new Map();
		// cachedCameras = new Map();
		

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
		var isJson = file.endsWith('.json') || file.endsWith('_json');
		var ext = (compressed || isJson || file.endsWith('.arm')) ? '' : '.arm';
		
		getBlob(file,function(b:kha.Blob) {
			if (compressed) {
				#if arm_compress
				#end
			}
			var parsed:TSceneFormat = null;
			try{
				parsed = /*s.charAt(0) == "{" ? */DataLoader.parse(b.toString()) /*: ArmPack.decode(b.toBytes())*/;
			}
			catch(e:Dynamic){
				error(e);
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

	static var getData = #if wasmfs khafs.Fs.getData#else kha.Assets.loadBlobFromPath#end;
    // Raw assets
	public static function getBlob(file:String, done:kha.Blob->Void, ?reload:Bool = false) {
		
		var cached = cachedBlobs.get(file); // Is already cached
		if (cached != null && !reload) { done(cached); return; }

		var loading = loadingBlobs.get(file); // Is already being loaded
		if (loading != null) { loading.push(done); return; }

		loadingBlobs.set(file, [done]); // Start loading

		var p = (file.charAt(0) == '/' || file.charAt(1) == ':') ? file : dataPath + file;

		if(Reflect.hasField(Assets.blobs,file)){
			var onDone = function(b:kha.Blob) {
				cachedBlobs.set(file, b);
				for (f in loadingBlobs.get(file)) f(b);
				loadingBlobs.remove(file);
				assetsLoaded++;
			};
			if(Assets.progress >= 1.0){
				onDone(Assets.blobs.get(file));
			}else {
				kha.Assets.loadBlob(file,onDone);
			}
		}
		else {
			getData(p, function(b:kha.Blob) {
				cachedBlobs.set(file, b);
				for (f in loadingBlobs.get(file)) f(b);
				loadingBlobs.remove(file);
				assetsLoaded++;
			},function(failed:kha.AssetError){
				var error = failed.error;
				var path = failed.url;
				Log.error('Asset at path: $path failed to load because of $error');
			});
		}
	}

    public static function deleteBlob(handle:String) {
		var blob = cachedBlobs.get(handle);
		if (blob == null) return;
		blob.unload();
		cachedBlobs.remove(handle);
	}

	#if wasmfs
	static function getImageFromPath(path:String, readable:Bool, done:kha.Image -> Void, ?failed:Null<kha.AssetError -> Void>, ?pos:Null<haxe.PosInfos>){
		var splitted = path.split('/');
		var extension:String = splitted[splitted.length-1].split('.')[1];
		getBlob(path,function(data:kha.Blob){
			var bytes = data.toBytes();
			kha.Image.fromEncodedBytes(bytes,extension,done,function(err:String){
				if(failed != null){
					var error:kha.AssetError = {url: path,error: err};
					Log.error(err);
					failed(error);
				}
			},readable);
		});
	}
	#else
	static var getImageFromPath = kha.Assets.loadImageFromPath; 
	#end
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
			getImageFromPath(p, readable, function(b:kha.Image) {
				cachedImages.set(file, b);
				for (f in loadingImages.get(file)) f(b);
				loadingImages.remove(file);
				assetsLoaded++;
			},function (e:kha.AssetError){
				if(e.url == "")e.url = 'Null';
				error("file " + e.url + " does not exist");
			});
		}
	}

	public static function deleteImage(handle:String) {
		var image = cachedImages.get(handle);
		if (image == null) return;
		image.unload();
		cachedImages.remove(handle);
	}


	#if wasmfs
	static function getSoundFromPath(path:String, done:kha.Sound -> Void, ?failed:Null<kha.AssetError -> Void>, ?pos:Null<haxe.PosInfos>){
		getBlob(path,function(data:kha.Blob){
			var bytes = data.toBytes();
			var snd = new kha.Sound();
			snd.compressedData = bytes;
			done(snd);
		});
	}
	#else
	static var getSoundFromPath = kha.Assets.loadSoundFromPath; 
	#end
	/**
	 * Load sound file from disk into ram.
	 *
	 * @param	file A String matching the file name of the sound file on disk.
	 * @param	done Completion handler function to do something after the sound is loaded.
	 */
	public static function getSound(file:String, done:kha.Sound->Void, ?alias:String) {
		#if soundcompress
		if (file.endsWith('.wav')) file = file.substring(0, file.length - 4) + '.ogg';
		#end

		var cached = cachedSounds.get(file);
		if (cached != null) { done(cached); return; }

		var loading = loadingSounds.get(file);
		if (loading != null) { loading.push(done); return; }

		loadingSounds.set(file, [done]);

		var p = (file.charAt(0) == '/' || file.charAt(1) == ':') ? file : dataPath + file;

		getSoundFromPath(p, function(b:kha.Sound) {
			#if soundcompress
			b.uncompress(function () {
			#end
				var key = alias != null ? alias: file;
				cachedSounds.set(key, b);
				for (f in loadingSounds.get(file)) f(b);
				loadingSounds.remove(file);
				assetsLoaded++;
			#if soundcompress
			});
			#end
		},function(error:kha.AssetError){
			Log.error('Couldn\'t load $p because of $error');
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