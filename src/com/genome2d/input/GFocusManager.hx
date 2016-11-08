/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */

package com.genome2d.input;
import com.genome2d.input.IGFocusable;

class GFocusManager
{
	static private var g2d_focusInstance:IGFocusable;

	static public function hasFocus(p_focusInstance:IGFocusable):Bool {
		return g2d_focusInstance == p_focusInstance;
	}

	@:access(com.genome2d.input.IGFocusable)
	static public function setFocus(p_focusInstance:IGFocusable):Void {
		if (g2d_focusInstance != null) g2d_focusInstance.lostFocus();
		g2d_focusInstance = p_focusInstance;
		if (g2d_focusInstance != null) g2d_focusInstance.gotFocus();
	}
}