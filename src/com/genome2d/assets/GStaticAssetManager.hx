package com.genome2d.assets;
import com.genome2d.macros.MGDebug;

/**
 * ...
 * @author Peter @sHTiF Stefcek
 */
class GStaticAssetManager
{
	static private var g2d_instance:GAssetManager;
	
	static public function getAssetById(p_id:String):GAsset {
		if (g2d_instance != null) MGDebug.G2D_ERROR("No asset manager initialized.");
        return g2d_instance.getAssetById(p_id);
    }
	
    static public function getXmlAssetById(p_id:String):GXmlAsset {
		if (g2d_instance != null) MGDebug.G2D_ERROR("No asset manager initialized.");
        return g2d_instance.getXmlAssetById(p_id);
    }

    static public function getImageAssetById(p_id:String):GImageAsset {
		if (g2d_instance != null) MGDebug.G2D_ERROR("No asset manager initialized.");
        return g2d_instance.getImageAssetById(p_id);
    }

    static public function addFromUrl(p_url:String, p_id:String = ""):GAsset {
		if (g2d_instance != null) MGDebug.G2D_ERROR("No asset manager initialized.");
		return g2d_instance.addFromUrl(p_url, p_id);
    }
	
	static public function loadQueue():Void {
		if (g2d_instance != null) MGDebug.G2D_ERROR("No asset manager initialized.");
		g2d_instance.loadQueue();
	}
	
	static public function generate():Void {
		if (g2d_instance != null) MGDebug.G2D_ERROR("No asset manager initialized.");
		g2d_instance.generate();
	}
	
	static public function disposeAssets():Void {
		if (g2d_instance != null) MGDebug.G2D_ERROR("No asset manager initialized.");
		g2d_instance.disposeAssets();
	}	
}