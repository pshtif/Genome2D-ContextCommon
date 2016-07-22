/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.assets;

import com.genome2d.callbacks.GCallback;
import com.genome2d.macros.MGDebug;
import com.genome2d.text.GFontManager;
import com.genome2d.text.GTextureFont;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureBase;
import com.genome2d.textures.GTextureManager;

class GAssetManager {
    static public var PATH_REGEX:EReg = ~/([^\?\/\\]+?)(?:\.([\w\-]+))?(?:\?.*)?$/;
	
	inline static private function getFileName(p_path:String):String {
        PATH_REGEX.match(p_path);
        return PATH_REGEX.matched(1);
    }

    inline static private function getFileExtension(p_path:String):String {
        PATH_REGEX.match(p_path);
        return PATH_REGEX.matched(2);
    }
	
    public var ignoreFailed:Bool = false;

    private var g2d_references:Map<String,GAsset>;
    public function getAssets():Map<String,GAsset> {
        return g2d_references;
    }

    private var g2d_loadQueue:Array<GAsset>;

    private var g2d_loading:Bool;
    public function isLoading():Bool {
        return g2d_loading;
    }

    private var g2d_onQueueLoaded:GCallback0;
    #if swc @:extern #end
    public var onQueueLoaded(get,never):GCallback0;
    #if swc @:getter(onQueueLoaded) #end
    inline private function get_onQueueLoaded():GCallback0 {
        return g2d_onQueueLoaded;
    }

    private var g2d_onQueueFailed:GCallback1<GAsset>;
    #if swc @:extern #end
    public var onQueueFailed(get,never):GCallback1<GAsset>;
    #if swc @:getter(onQueueFailed) #end
    inline private function get_onQueueFailed():GCallback1<GAsset> {
        return g2d_onQueueFailed;
    }

	@:access(com.genome2d.assets.GStaticAssetManager)
    public function new() {
		GStaticAssetManager.g2d_instance = this;
		
        g2d_loadQueue = new Array<GAsset>();
        g2d_references = new Map<String,GAsset>();

        g2d_onQueueLoaded = new GCallback0();
        g2d_onQueueFailed = new GCallback1(GAsset);
    }

    public function getAssetById(p_id:String):GAsset {
        return g2d_references.get(p_id);
    }

    public function getXmlAssetById(p_id:String):GXmlAsset {
        return cast g2d_references.get(p_id);
    }

    public function getImageAssetById(p_id:String):GImageAsset {
        return cast g2d_references.get(p_id);
    }

    public function addFromUrl(p_url:String, p_id:String = ""):GAsset {
		var asset:GAsset = null;
        switch (getFileExtension(p_url)) {
            case "jpg" | "jpeg" | "png" | "atf":
                asset = new GImageAsset(this, p_url, p_id);
            case "xml" | "fnt":
                asset = new GXmlAsset(this, p_url, p_id);
        }

		if (asset != null) addToQueue(asset);
		return asset;
    }
	
	public function disposeAssets():Void {
		for (asset in g2d_references) {
			asset.dispose();
		}
	}
	
	private function addToQueue(p_asset:GAsset):Void {
		g2d_loadQueue.push(p_asset);
	}

    public function loadQueue():Void {
        if (!g2d_loading) g2d_loadQueueNext();
    }

    private function g2d_loadQueueNext():Void {
        if (g2d_loadQueue.length==0) {
            g2d_loading = false;
            g2d_onQueueLoaded.dispatch();
        } else {
            g2d_loading = true;
            var asset:GAsset = g2d_loadQueue.shift();

            asset.onLoaded.addOnce(assetLoaded_handler);
            asset.onFailed.addOnce(assetFailed_handler);
            asset.load();
        }
    }

    private function assetLoaded_handler(p_asset:GAsset):Void {
        g2d_loadQueueNext();
    }

    private function assetFailed_handler(p_asset:GAsset):Void {
        g2d_onQueueFailed.dispatch(p_asset);
        if (ignoreFailed) g2d_loadQueueNext();
    }

    public function generate(p_scaleFactor:Float = 1, p_overwrite:Bool = false):Void {
        for (asset in g2d_references) {
            if (!Std.is(asset, GImageAsset) || !asset.isLoaded()) continue;
			
			var id:String = asset.id.substring(0, asset.id.lastIndexOf("."));
			var texture:GTexture = GTextureManager.getTexture(id);
            if (texture != null) {
				if (p_overwrite) {
					texture.dispose();
				} else {
					continue;
				}
			}

			texture = GTextureManager.createTexture(id, cast asset);
			
            if (getXmlAssetById(id + ".xml") != null) {
				GTextureManager.createSubTextures(texture, getXmlAssetById(id + ".xml").xml);
            } else if (getXmlAssetById(id + ".fnt") != null) {
				GFontManager.createTextureFont(texture.id, texture, getXmlAssetById(id + ".fnt").xml);
            }
			
			texture.invalidateNativeTexture(false);
        }
    }
}
