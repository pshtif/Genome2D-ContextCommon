package com.genome2d.text;
import com.genome2d.Genome2D;
import com.genome2d.context.IContext;
class GTextRenderer {
    private var g2d_context:IContext;

    /*
     *  Blend mode used for rendering
     */
    public var blendMode:Int = 1;

    private var g2d_dirty:Bool = false;
    inline public function isDirty():Bool {
        return g2d_dirty;
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

    private var g2d_vAlign:Int = 0;
    #if swc @:extern #end
    @prototype public var vAlign(get,set):Int;
    #if swc @:getter(vAlign) #end
    inline private function get_vAlign():Int {
        return g2d_vAlign;
    }
    #if swc @:setter(vAlign) #end
    inline private function set_vAlign(p_value:Int):Int {
        g2d_vAlign = p_value;
        g2d_dirty = true;
        return g2d_vAlign;
    }

    private var g2d_hAlign:Int = 0;
    #if swc @:extern #end
    @prototype public var hAlign(get,set):Int;
    #if swc @:getter(hAlign) #end
    inline private function get_hAlign():Int {
        return g2d_hAlign;
    }
    #if swc @:setter(hAlign) #end
    inline private function set_hAlign(p_value:Int):Int {
        g2d_hAlign = p_value;
        g2d_dirty = true;
        return g2d_hAlign;
    }

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
        Width of the text
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
        g2d_width = p_value;
        g2d_dirty = true;
        return g2d_width;
    }

    private var g2d_height:Float = 100;
    /*
        Height of the text
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
        g2d_height = p_value;
        g2d_dirty = true;
        return g2d_height;
    }

    public function new():Void {
        g2d_context = Genome2D.getInstance().getContext();
    }

    public function render(p_x:Float, p_y:Float, p_scaleX:Float, p_scaleY:Float, p_rotation:Float):Void {
    }

    public function invalidate():Void {
    }
}
