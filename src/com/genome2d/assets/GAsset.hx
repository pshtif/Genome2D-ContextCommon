/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.assets;

import com.genome2d.assets.GAssetManager;
import com.genome2d.callbacks.GCallback.GCallback1;
import com.genome2d.debug.GDebug;

/**
    Abstract asset superclass
**/
@prototypeName("asset")
@:access(com.genome2d.assets.GAssetManager)
class GAsset
{
	private var g2d_manager:GAssetManager;
	private var g2d_id:String = "";
	/**
        Asset id
    **/
    @prototype public var id(get, set):String;
    inline private function get_id():String {
        return g2d_id;
    }
    inline private function set_id(p_value:String):String {
        if (p_value != g2d_id && p_value.length > 0) {
			// Check for asset under same id first
            if (g2d_manager.g2d_references.get(p_value) != null) GDebug.error("Duplicate asset id: " + p_value);
			// Assign this instance to the map using the new id
            g2d_manager.g2d_references.set(p_value, this);
			// Remove instance from the map with old id
            if (g2d_manager.g2d_references.get(g2d_id) != null) g2d_manager.g2d_references.remove(g2d_id);
            g2d_id = p_value;
        }
        return g2d_id;
    }
	
    private var g2d_url:String;
	/**
        Asset url path
    **/
    @prototype public var url(get, set):String;
    inline private function get_url():String {
        return g2d_url;
    }
    inline private function set_url(p_value:String):String {
        if (!isLoaded()) {
            g2d_url = p_value;
            if (g2d_id == "") id = GAssetManager.convertUrlToId(g2d_url);
        } else {
            GDebug.warning("Asset already loaded " + id);
        }
        return g2d_url;
    }

	private var g2d_loading:Bool = false;
	/**
        Check if asset is currently loading
    **/
    public function isLoading():Bool {
        return g2d_loading;
    }
	
    private var g2d_loaded:Bool = false;
	/**
        Check if asset is already loaded
    **/
    public function isLoaded():Bool {
        return g2d_loaded;
    }
	
	public var onLoaded:GCallback1<GAsset>;
    public var onFailed:GCallback1<GAsset>;

	public function new(p_manager:GAssetManager, p_url:String = "", p_id:String = "") {
		g2d_manager = p_manager;
		
        onLoaded = new GCallback1(GAsset);
        onFailed = new GCallback1(GAsset);

        id = p_id;
        url = p_url;
    }

    public function load():Void {

    }

    public function cancel():Void {
        g2d_loading = false;
    }
	
	public function toReference():String {
		return null;
	}
	
	public function dispose():Void {
		
	}
}