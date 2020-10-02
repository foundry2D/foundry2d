package found.audio;

import kha.internal.BytesBlob;
import kha.audio2.Buffer;
import kha.Blob;
import kha.arrays.Float32Array;
import kha.audio2.AudioChannel;
import found.data.SceneFormat.TAudioData;
import found.data.Data;
import found.math.Util;

import kha.audio1.Audio;

class Sfx {
  static var sfxChannels:Map<String,AudioChannel> = new Map<String,AudioChannel>();
  static var inactiveChannels:Array<AudioChannel> = [];
  public static var allLoaded:Bool = false;
  public static function loadSounds(defs:Array<TAudioData>){
    var count = 0;
    var done = function(){
      count--;
      if(count == 0){
        allLoaded = true;
      }
    };
    for(def in defs){
      count++;
      Data.getSound(def.path,function(snd:kha.Sound){
        if(StringTools.endsWith(def.path,".wav")){
          var data = snd.compressedData;
          var arr:kha.arrays.Float32Array = new Float32Array(data.length);
          for(i in 0...data.length){
            arr[i] = data.getFloat(i);
          }
          snd.uncompressedData = arr;
        }
        else {
          snd.uncompress(done);
        }
      },def.alias);
    }
  }
  public static function bytesToSingle(bytes:haxe.io.Bytes,position:Int) {
    var first = bytes.get(position + 0);
    var second  = bytes.get(position + 1);
    var s:Float  = (second << 8) | first;
    return s/32768.0;
  }
  public static function play(name:String, ?volume:Float = 0.3){
    Data.getSound(name,function(snd:kha.Sound){
      
      var done = function(){
        var sound:Null<AudioChannel> = null;  
        if(inactiveChannels.length > 0){
          sound = inactiveChannels.pop();
          sound.data = snd.uncompressedData;
          sound.play();
        }
        else{
          sound = cast(Audio.play(snd, false));
        }
        sound.volume = volume;
        sfxChannels.set(name,sound);
        // sound.onFinishedCallback = function() {
        //   var sound = sfxChannels.get(name);
        //   if(sound != null)
        //     sfxChannels.remove(name);
        //   inactiveChannels.push(sound);
        // }
      };
      if(snd.uncompressedData == null){
        if(StringTools.endsWith(name,".wav")){
          // var data = snd.compressedData;
          
          var data  = Blob.fromBytes(snd.compressedData);
          var length = Std.int(data.length*0.5);
          var arr:kha.arrays.Float32Array = new Float32Array(length);
          var div:Float = 1.0/32768.0;
          for(i in 0...length){
            trace(bytesToSingle(snd.compressedData,i));
            arr.set(i,bytesToSingle(snd.compressedData,i));
          }
          snd.uncompressedData = arr;
          done();
        }
        else{
          snd.uncompress(done);
        }
      }
      else{
        done();
      }
    });
  }

  public static function random(name:String, ?amount:Int = 3, ?volume:Float = 0.3){
    var choiceSound:Int = Util.randomInt(amount);
    Data.getSound(name+choiceSound,function(snd:kha.Sound){
      var sound = Audio.play(snd, false);
      sound.volume = volume;
    }); 
  }
  
  public static function setVolume(name:String,volume:Float){
    var chan = sfxChannels.get(name);
    if(chan != null && !chan.finished){
        chan.volume = volume;
    }
    #if debug
    else if(chan == null){
        warn('Can\'t set volume, no sfx with name $name exists');
    }
    #end
  }

  public static function isPlaying(name:String) {
    return sfxChannels.exists(name) && !sfxChannels.get(name).finished;
  }
}