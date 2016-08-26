/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.textures;

import com.genome2d.callbacks.GCallback.GCallback0;
import com.genome2d.callbacks.GCallback.GCallback1;
import com.genome2d.context.GContextFeature;
import com.genome2d.context.IGContext;
import com.genome2d.debug.GDebug;
import com.genome2d.geom.GRectangle;
import com.genome2d.proto.IGPrototypable;
import com.genome2d.textures.GTextureManager;
import com.genome2d.textures.GTextureSourceType;

@:access(com.genome2d.textures.GTextureManager)
class GTextureBase implements IGPrototypable
{
	private var g2d_context:IGContext;
	
	private var g2d_onInvalidated:GCallback1<GTexture>;
	
	public var rotate:Bool = false;
	
	/**
	 * 	Callback after the texture was invalidated on GPU
	 */
	#if swc @:extern #end
    public var onInvalidated(get,never):GCallback1<GTexture>;
    #if swc @:getter(onInvalidated) #end
    inline private function get_onInvalidated():GCallback1<GTexture> {
		if (g2d_onInvalidated == null) g2d_onInvalidated = new GCallback1(GTexture);
        return g2d_onInvalidated;
    }
	
	private var g2d_onDisposed:GCallback1<GTexture>;
	/**
	 * 	Callback after the texture was disposed
	 */
	#if swc @:extern #end
    public var onDisposed(get,never):GCallback1<GTexture>;
    #if swc @:getter(onDisposed) #end
    inline private function get_onDisposed():GCallback1<GTexture> {
		if (g2d_onDisposed == null) g2d_onDisposed = new GCallback1(GTexture);
        return g2d_onDisposed;
    }
	
    private var g2d_dirty:Bool = true;
    inline public function isDirty():Bool {
        return g2d_dirty;
    }
	
	private var g2d_id:String;
	/**
	 * 	Id
	 */
    #if swc @:extern #end
    public var id(get,never):String;
    #if swc @:getter(id) #end
    inline private function get_id():String {
        return g2d_id;
    }
    #if swc @:setter(id) #end
    inline private function set_id(p_value:String):String {
        GTextureManager.g2d_removeTexture(cast this);
        g2d_id = p_value;
        GTextureManager.g2d_addTexture(cast this);
        return g2d_id;
    }

	private var g2d_pivotX:Float;
	/**
	 * 	X pivot
	 */
    #if swc @:extern #end
    public var pivotX(get, set):Float;
    #if swc @:getter(pivotX) #end
    inline private function get_pivotX():Float {
        return g2d_pivotX * scaleFactor;
    }
    #if swc @:setter(pivotX) #end
    inline private function set_pivotX(p_value:Float):Float {
        return g2d_pivotX = p_value / scaleFactor;
    }

    private var g2d_pivotY:Float;
	/**
	 * 	Y pivot
	 */
    #if swc @:extern #end
    public var pivotY(get, set):Float;
    #if swc @:getter(pivotY) #end
    inline private function get_pivotY():Float {
        return g2d_pivotY * scaleFactor;
    }
    #if swc @:setter(pivotY) #end
    inline private function set_pivotY(p_value:Float):Float {
        return g2d_pivotY = p_value / scaleFactor;
    }
	
	private var g2d_nativeWidth:Int;
	/**
	 * 	Native width
	 */
    #if swc @:extern #end
    public var nativeWidth(get, never):Int;
    #if swc @:getter(nativeWidth) #end
    inline private function get_nativeWidth():Int {
        return g2d_nativeWidth;
    }

	private var g2d_nativeHeight:Int;
	/**
	 * 	Native height
	 */
    #if swc @:extern #end
    public var nativeHeight(get, never):Int;
    #if swc @:getter(nativeHeight) #end
    inline private function get_nativeHeight():Int {
        return g2d_nativeHeight;
    }
	
	/**
	 * 	Width of the texture calculating with the scaleFactor
	 */
    #if swc @:extern #end
    public var width(get, never):Float;
    #if swc @:getter(width) #end
    inline private function get_width():Float {
        return g2d_nativeWidth*scaleFactor;
    }

	/**
	 * 	Height of the texture calculating with the scaleFactor
	 */
    #if swc @:extern #end
    public var height(get, never):Float;
    #if swc @:getter(height) #end
    inline private function get_height():Float {
        return g2d_nativeHeight*scaleFactor;
    }

	/**
	 * 	Scale factor
	 */
    private var g2d_scaleFactor:Float;
    #if swc @:extern #end
    public var scaleFactor(get, set):Float;
    #if swc @:getter(scaleFactor) #end
    inline private function get_scaleFactor():Float {
        return g2d_scaleFactor;
    }
    #if swc @:setter(scaleFactor) #end
    inline private function set_scaleFactor(p_value:Float):Float {
        g2d_scaleFactor = p_value;
        return g2d_scaleFactor;
    }

    private var g2d_filteringType:Int;
	/**
	 * 	Filtering type
	 */
    #if swc @:extern #end
    public var filteringType(get,set):Int;
    #if swc @:getter(filteringType) #end
    inline private function get_filteringType():Int {
        return g2d_filteringType;
    }
    #if swc @:setter(filteringType) #end
    inline private function set_filteringType(p_value:Int):Int {
        return g2d_filteringType = p_value;
    }

    private var g2d_sourceType:Int;
	/**
	 * 	Source type
	 */
    #if swc @:extern #end
    public var sourceType(get,never):Int;
    #if swc @:getter(sourceType) #end
    public function get_sourceType():Int {
        return g2d_sourceType;
    }
	
	private var g2d_format:String;
	/**
	 * 	Texture format
	 */
    #if swc @:extern #end
    public var format(get,set):String;
    #if swc @:getter(format) #end
    inline private function get_format():String {
        return g2d_format;
    }
    #if swc @:setter(format) #end
    inline private function set_format(p_value:String):String {
        g2d_format = p_value;
        g2d_dirty = true;
        return p_value;
    }

    private var g2d_u:Float;
	/**
	 * 	U
	 */
	#if swc @:extern #end
    public var u(get, never):Float;
    #if swc @:getter(u) #end
    inline private function get_u():Float {
        return g2d_u;
    }
	
    private var g2d_v:Float;
	/**
	 * 	V
	 */
	#if swc @:extern #end
    public var v(get, never):Float;
    #if swc @:getter(v) #end
    inline private function get_v():Float {
        return g2d_v;
    }
	
    private var g2d_uScale:Float;
	/**
	 * 	U scale
	 */
	#if swc @:extern #end
    public var uScale(get, never):Float;
    #if swc @:getter(uScale) #end
    inline private function get_uScale():Float {
        return g2d_uScale;
    }
	
    private var g2d_vScale:Float;
	/**
	 * 	V scale
	 */
	#if swc @:extern #end
    public var vScale(get, never):Float;
    #if swc @:getter(vScale) #end
    inline private function get_vScale():Float {
        return g2d_vScale;
    }

    private var g2d_repeatable:Bool;
	/**
	 * 	Repeatable
	 */
    #if swc @:extern #end
    public var repeatable(get,set):Bool;
    #if swc @:getter(repeatable) #end
    inline private function get_repeatable():Bool {
        return g2d_repeatable;
    }
    #if swc @:setter(repeatable) #end
    inline private function set_repeatable(p_value:Bool):Bool {
        g2d_repeatable = p_value;
        g2d_dirty = true;
        return p_value;
    }
	
	private var g2d_frame:GRectangle;

    private var g2d_region:GRectangle;
	/**
	 * 	Region of the texture
	 */
    #if swc @:extern #end
    public var region(get,set):GRectangle;
    #if swc @:getter(region) #end
    inline private function get_region():GRectangle {
        return g2d_region;
    }
    #if swc @:setter(region) #end
    inline private function set_region(p_value:GRectangle):GRectangle {
        g2d_region = p_value;

        g2d_nativeWidth = Std.int(g2d_region.width);
        g2d_nativeHeight = Std.int(g2d_region.height);

        invalidateUV();

        return g2d_region;
    }

    private var g2d_source:Dynamic;
	
	public function getSource():Dynamic {
        return g2d_source;
    }
	
	public function setSource(p_value:Dynamic):Dynamic {
		g2d_source = p_value;
        return g2d_source;
    }	

    public var premultiplied:Bool;
	
    private var g2d_initializedRenderTarget:Bool;

    private var g2d_contextId:Int;

	static private var g2d_instanceCount:Int = 0;

    public function new(p_context:IGContext, p_id:String, p_source:Dynamic, p_format:String) {
		g2d_context = p_context;
		g2d_id = p_id;
        g2d_nativeWidth = g2d_nativeHeight = 0;
		g2d_gpuWidth = g2d_gpuHeight = 0;
		g2d_region = new GRectangle(0, 0, 1, 1);
        g2d_u = g2d_v = 0;
        g2d_uScale = g2d_vScale = 1;
		g2d_pivotX = g2d_pivotY = 0;
        g2d_initializedRenderTarget = false;
        premultiplied = true;
        g2d_dirty = true;
        g2d_scaleFactor = 1;

		g2d_instanceCount++;
		g2d_contextId = g2d_instanceCount;
        g2d_format = p_format;//"bgra";
        g2d_repeatable = false;

        g2d_filteringType = GTextureManager.defaultFilteringType;
        setSource(p_source);
		
		GTextureManager.g2d_addTexture(cast this);
	}

	private function invalidateUV():Void {
		g2d_u = g2d_region.x / gpuWidth;
		g2d_v = g2d_region.y / gpuHeight;

		g2d_uScale = g2d_region.width / gpuWidth;
		g2d_vScale = g2d_region.height / gpuHeight;
    }

	/**
	 * 	Check if this texture uses rectangle texture
	 */
    inline public function usesRectangle():Bool {
        return !g2d_repeatable && Genome2D.getInstance().getContext().hasFeature(GContextFeature.RECTANGLE_TEXTURES);
    }

    public function needClearAsRenderTarget(p_clear:Bool):Bool {
        if (!g2d_initializedRenderTarget || p_clear) {
            g2d_initializedRenderTarget = true;
            return true;
        }
        return false;
    }

    public function dispose(p_disposeSource:Bool = false):Void {		
        g2d_source = null;
        GTextureManager.g2d_removeTexture(cast this);
		
		if (g2d_onDisposed != null) {
			g2d_onDisposed.dispatch(cast this);
			g2d_onDisposed.removeAll();
		}
		if (g2d_onInvalidated != null) g2d_onInvalidated.removeAll();
    }

    public function getAlphaAtUV(p_u:Float, p_v:Float):Float {
		return 1;
    }
	
	private function parentInvalidated_handler(p_texture:GTexture):Void {
		g2d_gpuWidth = p_texture.g2d_gpuWidth;
		g2d_gpuHeight = p_texture.g2d_gpuHeight;
		
		invalidateUV();
		
		if (g2d_onInvalidated != null) g2d_onInvalidated.dispatch(cast this);
	}
	
	private function parentDisposed_handler(p_texture:GTexture):Void {
		dispose();
	}
	
    public function toString():String {
        return "@"+g2d_id;
    }
	
	/*
	 *	Get a reference value
	 */
	public function toReference():String {
		return "@"+g2d_id;
	}
	
	/*
	 * 	Get an instance from reference
	 */
	static public function fromReference(p_reference:String) {
		return GTextureManager.getTexture(p_reference.substr(1));
	}
	
	/****************************************************************************************************
	 * 	GPU DEPENDANT PROPERTIES
	 ****************************************************************************************************/
	
	private var g2d_gpuWidth:Int;
	/**
	 * 	Gpu width
	 */
    #if swc @:extern #end
    public var gpuWidth(get, never):Int;
    #if swc @:getter(gpuWidth) #end
    inline private function get_gpuWidth():Int {
        return g2d_gpuWidth;
    }

	private var g2d_gpuHeight:Int;
	/**
	 * 	Gpu height
	 */
    #if swc @:extern #end
    public var gpuHeight(get, never):Int;
    #if swc @:getter(gpuHeight) #end
    inline private function get_gpuHeight():Int {
        return g2d_gpuHeight;
    }
}