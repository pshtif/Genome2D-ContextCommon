package com.genome2d.textures;
import js.html.ImageData;
import com.genome2d.assets.GImageAsset;
import com.genome2d.assets.GImageAssetType;
import com.genome2d.context.IGContext;
import com.genome2d.debug.GDebug;
import com.genome2d.geom.GRectangle;
import com.genome2d.textures.GTexture;

#if flash
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.utils.ByteArray;
#end

#if js
import js.html.ImageElement;
#end

@:access(com.genome2d.textures.GTexture)
class GTextureManager {
	static private var g2d_context:IGContext;
    static public function init(p_context:IGContext):Void {
		g2d_context = p_context;
        g2d_textures = new Map<String,GTexture>();
        g2d_textureAtlases = new Map<String,GTextureAtlas>();
    }

    static public var defaultFilteringType:GTextureFilteringType = GTextureFilteringType.LINEAR;

    static private var g2d_textures:Map<String,GTexture>;
    static public function getAllTextures():Map<String,GTexture> {
        return g2d_textures;
    }

    static private function g2d_addTexture(p_texture:GTexture):Void {
        if (p_texture.id == null || p_texture.id.length == 0) GDebug.error("Invalid texture id");
        if (g2d_textures.exists(p_texture.id)) GDebug.error("Duplicate textures id: "+p_texture.id);
        g2d_textures.set(p_texture.id, p_texture);
    }

    static private function g2d_removeTexture(p_texture:GTexture):Void {
        g2d_textures.remove(p_texture.id);
    }

    static public function getTexture(p_id:String):GTexture {
        return g2d_textures.get(p_id);
    }
	
	static public function getTextures(p_ids:Array<String>):Array<GTexture> {
		var textures:Array<GTexture> = new Array<GTexture>();
		for (id in p_ids) textures.push(g2d_textures.get(id));
        return textures;
    }
	
	static public function findTextures(p_regExp:EReg = null):Array<GTexture> {
        var found:Array<GTexture> = new Array<GTexture>();
        for (tex in g2d_textures) {
            if (p_regExp != null) {
                if (p_regExp.match(tex.id)) {
                    found.push(tex);
                }
            } else {
                found.push(tex);
            }
        }

        return found;
    }

    static private var g2d_textureAtlases:Map<String,GTextureAtlas>;
    static public function getAllTextureAtlases():Map<String,GTextureAtlas> {
        return g2d_textureAtlases;
    }

    static private function addTextureAtlas(p_textureAtlas:GTextureAtlas):Void {
        if (p_textureAtlas.id == null || p_textureAtlas.id.length == 0) GDebug.error("Invalid texture atlas id");
        if (g2d_textureAtlases.exists(p_textureAtlas.id)) GDebug.error("Duplicate textures id: "+p_textureAtlas.id);
        g2d_textureAtlases.set(p_textureAtlas.id, p_textureAtlas);
    }

    static private function removeTextureAtlas(p_textureAtlas:GTextureAtlas):Void {
        g2d_textureAtlases.remove(p_textureAtlas.id);
    }

    static public function getTextureAtlas(p_id:String):GTextureAtlas {
        return g2d_textureAtlases.get(p_id);
    }

    static public function disposeAll(p_disposeSource:Bool = false):Void {
        for (texture in g2d_textures) {
            #if js
            if (texture == null) continue;
            #end
            GDebug.info(texture.id);
			if (texture.id.indexOf("g2d_") != 0) texture.dispose(p_disposeSource);
        }
    }

    static private var g2d_asyncForce:Bool = false;
    static private var g2d_asyncCallback:Void->Void;
    static private var g2d_asyncTextureQueue:Array<GTexture>;
    static public function invalidateAll(p_force:Bool, p_async:Bool = false, p_callback:Void->Void = null):Void {
        if (p_async) {
            g2d_asyncForce = p_force;
            g2d_asyncCallback = p_callback;
            g2d_asyncTextureQueue = new Array<GTexture>();
            for (texture in g2d_textures) {
                if (texture.getSourceType() != GTextureSourceType.TEXTURE) g2d_asyncTextureQueue.push(texture);
            }
            invalidateNextInQueue();
        } else {
		    for (texture in g2d_textures) {
			    texture.invalidateNativeTexture(p_force);
            }
        }
    }

    static private function invalidateNextInQueue():Void {
        if (g2d_asyncTextureQueue.length > 0) {
            g2d_asyncTextureQueue.shift().invalidateNativeTexture(g2d_asyncForce);
            g2d_context.callNextFrame(invalidateNextInQueue);
        } else {
            g2d_asyncCallback();
        }
    }
	
	static public function createTexture(p_id:String, p_source:Dynamic, p_scaleFactor:Float = 1, p_repeatable:Bool = false, p_format:String = "bgra"):GTexture {
		var texture:GTexture = null;
		// Create from asset
		if (Std.is(p_source, GImageAsset)) {
			var imageAsset:GImageAsset = cast p_source;
			switch (imageAsset.type) {
				#if flash
				case GImageAssetType.BITMAPDATA:
					texture = new GTexture(g2d_context, p_id, imageAsset.bitmapData, p_format);
				case GImageAssetType.ATF:
					texture = new GTexture(g2d_context, p_id, imageAsset.bytes, p_format);
				#elseif js
				case GImageAssetType.IMAGEELEMENT:
					texture = new GTexture(g2d_context, p_id, imageAsset.imageElement, p_format);
				#end
                case _:
			}
		#if flash
		// Create from bitmap data
		} else if (Std.is(p_source, BitmapData)) {
			texture = new GTexture(g2d_context, p_id, p_source, p_format);
		// Create from ATF byte array
		} else if (Std.is(p_source, ByteArray)) {
			texture = new GTexture(g2d_context, p_id, p_source, p_format);
			
		// Create from uncompressed byte array			
		} else if (Std.is(p_source, GByteArrayRectangle)) {
			texture = new GTexture(g2d_context, p_id, p_source, p_format);
			
		// Create from Embedded
		} else if (Std.is(p_source, Class)) {
			var bitmap:Bitmap = cast Type.createInstance(p_source, []);
			texture = new GTexture(g2d_context, p_id, bitmap.bitmapData, p_format);
		#elseif js
		} else if (Std.is(p_source, ImageElement)) {
			texture = new GTexture(g2d_context, p_id, p_source, p_format);
		} else if (Std.is(p_source, ImageData)) {
		    texture = new GTexture(g2d_context, p_id, p_source, p_format);
		#end
		// Create render texture
		} else if (Std.is(p_source, GRectangle)) {
			texture = new GTexture(g2d_context, p_id, p_source, p_format);
		}

		if (texture != null) {
			texture.repeatable = p_repeatable;
			texture.scaleFactor = p_scaleFactor;
			texture.invalidateNativeTexture(false);
		} else {
			GDebug.error("Invalid texture source.");
		}

        return texture;
    }
	
	static public function createSubTexture(p_id:String, p_texture:GTexture, p_region:GRectangle, p_frame:GRectangle = null, p_prefixParentId:Bool = true):GTexture {
		var texture:GTexture = new GTexture(g2d_context, p_prefixParentId?p_texture.id+"_"+p_id:p_id, p_texture, p_texture.g2d_format);
		
		texture.region = (p_texture.g2d_inverted) ? new GRectangle(p_region.left, p_texture.g2d_nativeHeight - p_region.top - p_region.height, p_region.width, p_region.height) : p_region;
        texture.g2d_dirty = false;
		
		if (p_frame != null) {
            texture.g2d_frame = p_frame;
			texture.pivotX = (p_frame.width - p_region.width)*.5 + p_frame.x;
			texture.pivotY = (p_frame.height - p_region.height) * .5 + p_frame.y;
        }

        return texture;
	}

    static public function createRenderTexture(p_id:String, p_width:Int, p_height:Int, p_scaleFactor:Float = 1):GTexture {
        var texture:GTexture = new GTexture(g2d_context, p_id, new GRectangle(0,0,p_width, p_height), "bgra");
        texture.invalidateNativeTexture(false);
        return texture;
    }
	 
	static public function createSubTextures(p_texture:GTexture, p_xml:Xml, p_prefixParentId:Bool = true):Array<GTexture> {
        var textures:Array<GTexture> = new Array<GTexture>();

        var root = p_xml.firstElement();
        var it:Iterator<Xml> = root.elements();

        while(it.hasNext()) {
            var node:Xml = it.next();

            var region:GRectangle = new GRectangle(Std.parseInt(node.get("x")), Std.parseInt(node.get("y")), Std.parseInt(node.get("width")), Std.parseInt(node.get("height")));
			var frame:GRectangle = null;
			
            if (node.get("frameX") != null && node.get("frameWidth") != null && node.get("frameY") != null && node.get("frameHeight") != null) {
                frame = new GRectangle(Std.parseInt(node.get("frameX")), Std.parseInt(node.get("frameY")), Std.parseInt(node.get("frameWidth")), Std.parseInt(node.get("frameHeight")));
            }
			textures.push(createSubTexture(node.get("name"), p_texture, region, frame, p_prefixParentId));
        }

        return textures;
	}

    static public function createTextureAtlas(p_texture:GTexture, p_xml:Xml, p_prefixParentId:Bool = true):GTextureAtlas {
        var textureAtlas:GTextureAtlas = new GTextureAtlas();
        textureAtlas.id = p_texture.id;

        textureAtlas.addSubTexturesFromXml(p_xml, p_prefixParentId);

        return textureAtlas;
    }
}
