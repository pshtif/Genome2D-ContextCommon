/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.input;

class GKeyboardInputType {
    inline static public var KEY_DOWN:String = "keyDown";
    inline static public var KEY_UP:String = "keyUp";

	#if flash
    inline static public function fromNative(p_nativeType:String):String {
        var type:String = "";
        switch (p_nativeType) {
            case "keyDown":
                type = KEY_DOWN;
            case "keyUp":
                type = KEY_UP;
        }

        return type;
    }
	#elseif js
	inline static public function fromNative(p_nativeType:String):String {
        var type:String = "";
        switch (p_nativeType) {
            case "keyup":
                type = KEY_UP;
            case "keydown":
                type = KEY_DOWN;
        }

        return type;
    }
	#end
}
