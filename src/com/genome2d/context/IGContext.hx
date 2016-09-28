/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.context;
import com.genome2d.callbacks.GCallback;
import com.genome2d.context.IGRenderer;

#if flash
typedef IGContext = com.genome2d.context.GStage3DContext;
#elseif js
typedef IGContext = com.genome2d.context.GWebGLContext;
#else
#if swc
import flash.utils.Object;
#end
import com.genome2d.context.filters.GFilter;
import com.genome2d.geom.GMatrix3D;
import com.genome2d.geom.GRectangle;
import com.genome2d.input.GKeyboardInput;
import com.genome2d.input.GMouseInput;
import com.genome2d.textures.GTexture;
import com.genome2d.callbacks.GCallback;
import com.genome2d.context.GCamera;

/**
    Interface for all Genome2D contexts
**/
interface IGContext {
    function hasFeature(p_feature:Int):Bool;
	
	var g2d_onMouseInputInternal:GMouseInput->Void;
	
    #if flash
    var onInitialized(get,null):GCallback0;
    var onFailed(get,null):GCallback1<String>;
    var onInvalidated(get,null):GCallback0;
    var onFrame(get,null):GCallback1<Float>;
    var onMouseInput(get, null):GCallback1<GMouseInput>;
    var onKeyboardInput(get,null):GCallback1<GKeyboardInput>;
    var onResize(get,null):GCallback2<Int,Int>;
    #else
    var onInitialized(default,null):GCallback0;
    var onFailed(default,null):GCallback1<String>;
    var onInvalidated(default,null):GCallback0;
    var onFrame(default,null):GCallback1<Float>;
    var onMouseInput(default, null):GCallback1<GMouseInput>;
    var onKeyboardInput(default,null):GCallback1<GKeyboardInput>;
    var onResize(default,null):GCallback2<Int,Int>;
    #end
    function getStageViewRect():GRectangle;
    function getDefaultCamera():GCamera;
    #if swc
    function getNativeStage():Object;
    function getNativeContext():Object;
    #else
    function getNativeStage():Dynamic;
    function getNativeContext():Dynamic;
    #end

    function getMaskRect():GRectangle;
    function setMaskRect(p_maskRect:GRectangle):Void;

    function setActiveCamera(p_camera:GCamera):Bool;
    function getActiveCamera():GCamera;

    function init():Void;
    function dispose():Void;

    function setBackgroundColor(p_color:Int, p_alpha:Float = 1):Void;
    function begin():Bool;
    function end():Void;

    function draw(p_texture:GTexture, p_x:Float, p_y:Float, p_scaleX:Float = 1, p_scaleY:Float = 1, p_rotation:Float = 0, p_red:Float = 1, p_green:Float = 1, p_blue:Float = 1, p_alpha:Float = 1, p_blendMode:Int = 1, p_filter:GFilter = null):Void;

    function drawSource(p_texture:GTexture, p_sourceX:Float, p_sourceY:Float, p_sourceWidth:Float, p_sourceHeight:Float, p_sourcePivotX:Float, p_sourcePivotY:Float, p_x:Float, p_y:Float, p_scaleX:Float = 1, p_scaleY:Float = 1, p_rotation:Float = 0, p_red:Float = 1, p_green:Float = 1, p_blue:Float = 1, p_alpha:Float = 1, p_blendMode:Int = 1, p_filter:GFilter = null):Void;

    function drawMatrix(p_texture:GTexture, p_a:Float, p_b:Float, p_c:Float, p_d:Float, p_tx:Float, p_ty:Float, p_red:Float = 1, p_green:Float = 1, p_blue:Float = 1, p_alpha:Float=1, p_blendMode:Int=1, p_filter:GFilter = null):Void;

    function drawPoly(p_texture:GTexture, p_vertices:Array<Float>, p_uvs:Array<Float>, p_x:Float, p_y:Float, p_scaleX:Float = 1, p_scaleY:Float = 1, p_rotation:Float = 0, p_red:Float = 1, p_green:Float = 1, p_blue:Float = 1, p_alpha:Float = 1, p_blendMode:Int=1, p_filter:GFilter = null):Void;

    function setBlendMode(p_blendMode:Int, p_premultiplied:Bool):Void;

    function setRenderer(p_renderer:IGRenderer):Void;
	function flushRenderer():Void;
	function getRenderer():IGRenderer;

    function resize(p_rect:GRectangle):Void;

    function clearStencil():Void;
    function renderToStencil(p_stencilLayer:Int):Void;
    function renderToColor(p_stencilLayer:Int):Void;
    function setDepthTest(p_depthMask:Bool, p_compareMode:Dynamic):Void;
    function getRenderTarget():GTexture;
	function getRenderTargetMatrix():GMatrix3D;
    function setRenderTarget(p_texture:GTexture = null, p_transform:GMatrix3D = null, p_clear:Bool = false):Void;
    function setRenderTargets(p_textures:Array<GTexture>, p_transform:GMatrix3D = null, p_clear:Bool = false):Void;
}
#end