/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.context.stats;

import com.genome2d.context.IContext;

/**
    Interface for implementing custom stats class
**/
interface IStats {

    /**
        Clear stats at the beginning of the rendering
    **/
    function clear():Void;

    /**
        Render stats
    **/
    function render(p_context:IContext):Void;
}
