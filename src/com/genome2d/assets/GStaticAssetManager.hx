package com.genome2d.assets;
import com.genome2d.macros.MGDebug;

/**
 * ...
 * @author Peter @sHTiF Stefcek
 */
class GStaticAssetManager
{
	static private var g2d_instance:GAssetManager;
	static public function setInstance(p_instance:GAssetManager):Void {
		g2d_instance = p_instance;
	}
	
	static public function getAssetById(p_id:String):GAsset {
		if (g2d_instance == null) MGDebug.G2D_ERROR("No asset manager initialized.");
        return g2d_instance.getAssetById(p_id);
    }
	
    static public function getXmlAssetById(p_id:String):GXmlAsset {
		if (g2d_instance == null) MGDebug.G2D_ERROR("No asset manager initialized.");
        return g2d_instance.getXmlAssetById(p_id);
    }

    static public function getImageAssetById(p_id:String):GImageAsset {
		if (g2d_instance == null) MGDebug.G2D_ERROR("No asset manager initialized.");
        return g2d_instance.getImageAssetById(p_id);
    }

	static public function getBinaryAssetById(p_id:String):GBinaryAsset {
		if (g2d_instance == null) MGDebug.G2D_ERROR("No asset manager initialized.");
		return g2d_instance.getBinaryAssetById(p_id);
	}
	
	static public function getTextAssetById(p_id:String):GTextAsset {
		if (g2d_instance == null) MGDebug.G2D_ERROR("No asset manager initialized.");
        return g2d_instance.getTextAssetById(p_id);
    }

    static public function addFromUrl(p_url:String, p_id:String = ""):GAsset {
		if (g2d_instance == null) MGDebug.G2D_ERROR("No asset manager initialized.");
		return g2d_instance.addFromUrl(p_url, p_id);
    }
	
	static public function loadQueue(p_successHandler:Void->Void, p_failedHandler:GAsset->Void = null):Void {
		if (g2d_instance == null) MGDebug.G2D_ERROR("No asset manager initialized.");
		g2d_instance.loadQueue(p_successHandler, p_failedHandler);
	}
	
	static public function generate(p_scaleFactor:Float = 1, p_overwrite:Bool = false):Void {
		if (g2d_instance == null) MGDebug.G2D_ERROR("No asset manager initialized.");
		g2d_instance.generate(p_scaleFactor, p_overwrite);
	}
	
	static public function disposeAssets():Void {
		if (g2d_instance == null) MGDebug.G2D_ERROR("No asset manager initialized.");
		g2d_instance.disposeAssets();
	}	
}