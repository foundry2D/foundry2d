package found;

import haxe.io.Bytes;

class Url {
    
    public static function explorer(url: String) {
		#if krom_windows
		Krom.sysCommand('explorer "' + url + '"');
		#elseif krom_linux
		Krom.sysCommand('xdg-open "' + url + '"');
		#elseif (krom_android || krom_ios)
        Krom.loadUrl(url);
		#elseif krom
        Krom.sysCommand('open "' + url + '"');
        #else
        kha.System.loadUrl(url);
		#end
    }

    public static function download(url: String, dstPath: String) {
		#if krom_windows
		Krom.sysCommand('powershell -c "Invoke-WebRequest -Uri ' + url + " -OutFile '" + dstPath + "'");
		#elseif krom
		Krom.sysCommand("curl " + url + " -o " + dstPath);
		#end
	}

	public static function downloadBytes(url: String): Bytes {
        #if krom
		var save = Path.data() + Path.sep + "download.bin";
		download(url, save);
		try {
			return Bytes.ofData(Krom.loadBlob(save));
		}
		catch (e: Dynamic) {
			return null;
        }
        #else
        return null;
        #end
	}
}