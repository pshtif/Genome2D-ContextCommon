/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.geom;

import com.genome2d.proto.IGPrototypable;

class GIntRectangle implements IGPrototypable {

    public var bottom (get, set):Int;
    private function get_bottom() { return y + height; }
    private function set_bottom(p_value:Int) { height = p_value - y; return p_value; }

    public var left (get, set):Int;
    private function get_left() { return x; }
    private function set_left(p_value:Int) { width -= p_value - x; x = p_value; return p_value; }

    public var right (get, set):Int;
    private function get_right() { return x + width; }
    private function set_right(p_value:Int) { width = p_value - x; return p_value; }

    public var top (get, set):Int;
    private function get_top() { return y; }
    private function set_top(p_value:Int) { height -= p_value - y; y = p_value; return p_value; }

    @prototype
    public var x:Int;

    @prototype
    public var y:Int;

    @prototype
    public var width:Int;

    @prototype
    public var height:Int;

    private var g2d_native:flash.geom.Rectangle;

    public function new(p_x:Int=0, p_y:Int=0, p_width:Int=0, p_height:Int=0) {
        x = p_x;
        y = p_y;
        width = p_width;
        height = p_height;

        g2d_native = new flash.geom.Rectangle(x, y, width, height);
    }

    public function setTo(p_x:Int, p_y:Int, p_width:Int, p_height:Int):Void {
        x = p_x;
        y = p_y;
        width = p_width;
        height = p_height;
    }

    public function clone():GIntRectangle {
        return new GIntRectangle(x,y,width,height);
    }

    public function intersection(p_rect:GIntRectangle):GIntRectangle {
        var result:GIntRectangle;

        var x0 = x < p_rect.x ? p_rect.x : x;
        var x1 = right > p_rect.right ? p_rect.right : right;
        if (x1 <= x0) {
            result = new GIntRectangle ();
        } else {
            var y0 = y < p_rect.y ? p_rect.y : y;
            var y1 = bottom > p_rect.bottom ? p_rect.bottom : bottom;
            if (y1 <= y0) {
                result = new GIntRectangle ();
            } else {
                result = new GIntRectangle (x0, y0, x1 - x0, y1 - y0);
            }
        }

        return result;
    }

    public function intersects(p_rect:GIntRectangle):Bool {
        var result:Bool = false;

        var x0 = x < p_rect.x ? p_rect.x : x;
        var x1 = right > p_rect.right ? p_rect.right : right;
        if (x1 > x0) {
            var y0 = y < p_rect.y ? p_rect.y : y;
            var y1 = bottom > p_rect.bottom ? p_rect.bottom : bottom;
            if (y1 > y0) {
                result = true;
            }
        }

        return result;
    }

    public function contains (p_x:Int, p_y:Int):Bool {
        return p_x >= x && p_y >= y && p_x <= right && p_y <= bottom;
    }
}