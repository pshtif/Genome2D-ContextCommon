package com.genome2d.text;
import com.genome2d.context.GBlendMode;
import com.genome2d.utils.GHAlignType;
import com.genome2d.utils.GVAlignType;
import com.genome2d.Genome2D;
import com.genome2d.context.IGContext;
class GTextRenderer {
    private var g2d_context:IGContext;

    /*
     *  Blend mode used for rendering
     */
    public var blendMode:GBlendMode;

    private var g2d_dirty:Bool = false;
    inline public function isDirty():Bool {
        return g2d_dirty;
    }

	private var g2d_fontScale:Float = 1;
    #if swc @:extern #end
    public var fontScale(get, set):Float;
    #if swc @:getter(fontScale) #end
    inline private function get_fontScale():Float {
        return g2d_fontScale;
    }
    #if swc @:setter(fontScale) #end
    inline private function set_fontScale(p_value:Float):Float {
        g2d_fontScale = p_value;
        g2d_dirty = true;
        return g2d_fontScale;
    }

    private var g2d_tracking:Float = 0;
    /*
     *  Character tracking
     *  Default 0
     */
    #if swc @:extern #end
    @prototype public var tracking(get, set):Float;
    #if swc @:getter(tracking) #end
    inline private function get_tracking():Float {
        return g2d_tracking;
    }
    #if swc @:setter(tracking) #end
    inline private function set_tracking(p_tracking:Float):Float {
        g2d_tracking = p_tracking;
        g2d_dirty = true;
        return g2d_tracking;
    }

    private var g2d_lineSpace:Float = 0;
    /*
     *  Line spacing
     *  Default 0
     */
    #if swc @:extern #end
    @prototype public var lineSpace(get, set):Float;
    #if swc @:getter(lineSpace) #end
    inline private function get_lineSpace():Float {
        return g2d_lineSpace;
    }
    #if swc @:setter(lineSpace) #end
    inline private function set_lineSpace(p_value:Float):Float {
        g2d_lineSpace = p_value;
        g2d_dirty = true;
        return g2d_lineSpace;
    }

    private var g2d_vAlign:GVAlignType;
    #if swc @:extern #end
    @prototype public var vAlign(get,set):GVAlignType;
    #if swc @:getter(vAlign) #end
    inline private function get_vAlign():GVAlignType {
        return g2d_vAlign;
    }
    #if swc @:setter(vAlign) #end
    inline private function set_vAlign(p_value:GVAlignType):GVAlignType {
        g2d_vAlign = p_value;
        g2d_dirty = true;
        return g2d_vAlign;
    }

    private var g2d_hAlign:GHAlignType;
    #if swc @:extern #end
    @prototype public var hAlign(get,set):GHAlignType;
    #if swc @:getter(hAlign) #end
    inline private function get_hAlign():GHAlignType {
        return g2d_hAlign;
    }
    #if swc @:setter(hAlign) #end
    inline private function set_hAlign(p_value:GHAlignType):GHAlignType {
        g2d_hAlign = p_value;
        g2d_dirty = true;
        return g2d_hAlign;
    }

	private var g2d_textLength:Int;
    private var g2d_text:String = "";
    /*
     *  Text
     */
    #if swc @:extern #end
    @prototype public var text(get, set):String;
    #if swc @:getter(text) #end
    inline private function get_text():String {
        return g2d_text;
    }
    #if swc @:setter(text) #end
    inline private function set_text(p_value:String):String {
        g2d_text = p_value;
		g2d_textLength = g2d_text.length;
        g2d_dirty = true;
        return g2d_text;
    }

    private var g2d_autoSize:Bool = false;
    /*
        Text should automatically resize width/height
     */
    #if swc @:extern #end
    @prototype public var autoSize(get, set):Bool;
    #if swc @:getter(autoSize) #end
    inline private function get_autoSize():Bool {
        return g2d_autoSize;
    }
    #if swc @:setter(autoSize) #end
    inline private function set_autoSize(p_value:Bool):Bool {
        g2d_autoSize = p_value;
        g2d_dirty = true;
        return g2d_autoSize;
    }

    private var g2d_width:Float = 100;
    /*
        Width of the text renderer
     */
    #if swc @:extern #end
    @prototype public var width(get, set):Float;
    #if swc @:getter(width) #end
    inline private function get_width():Float {
        if (g2d_autoSize && g2d_dirty) invalidate();
        return g2d_width;
    }
    #if swc @:setter(width) #end
    inline private function set_width(p_value:Float):Float {
        if (p_value != g2d_width) {
            g2d_width = p_value;
            g2d_dirty = true;
        }
        return g2d_width;
    }

    private var g2d_height:Float = 100;
    /*
        Height of the text renderer
     */
    #if swc @:extern #end
    @prototype public var height(get, set):Float;
    #if swc @:getter(height) #end
    inline private function get_height():Float {
        if (g2d_autoSize && g2d_dirty) invalidate();

        return g2d_height;
    }
    #if swc @:setter(height) #end
    inline private function set_height(p_value:Float):Float {
        if (p_value != g2d_height) {
            g2d_height = p_value;
            g2d_dirty = true;
        }
        return g2d_height;
    }

    private var g2d_textWidth:Float = 0;
    /*
        Width of the text
     */
    #if swc @:extern #end
    @prototype public var textWidth(get, null):Float;
    #if swc @:getter(textWidth) #end
    inline private function get_textWidth():Float {
        if (g2d_dirty) invalidate();
        return g2d_textWidth;
    }

    private var g2d_textHeight:Float = 0;
    /*
        Height of the text
     */
    #if swc @:extern #end
    @prototype public var textHeight(get, null):Float;
    #if swc @:getter(textHeight) #end
    inline private function get_textHeight():Float {
        if (g2d_dirty) invalidate();
        return g2d_textHeight;
    }

    public function new():Void {
        blendMode = GBlendMode.NORMAL;
        g2d_vAlign = GVAlignType.TOP;
        g2d_hAlign = GHAlignType.LEFT;
        g2d_context = Genome2D.getInstance().getContext();
    }

    public function render(p_x:Float, p_y:Float, p_scaleX:Float, p_scaleY:Float, p_rotation:Float, p_red:Float, p_green:Float, p_blue:Float, p_alpha:Float):Void {
    }

    public function invalidate():Void {
    }
}
