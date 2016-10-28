/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.textures;
import com.genome2d.proto.GPrototypeExtras;
import com.genome2d.proto.GPrototype;
import com.genome2d.proto.IGPrototypable;

/**
    Used to prototype texture settings
**/
class GTextureSettings implements IGPrototypable {

    private var g2d_texture:GTexture;
    public function getTexture():GTexture {
        return g2d_texture;
    }

    #if swc @:extern #end
    @prototype
    public var repeatable(get, set):Bool;
    #if swc @:getter(repeatable) #end
    inline private function get_repeatable():Bool {
        return g2d_texture.repeatable;
    }
    #if swc @:setter(repeatable) #end
    inline public function set_repeatable(p_value:Bool):Bool {
        g2d_texture.repeatable = p_value;
        g2d_texture.invalidateNativeTexture(true);
        return p_value;
    }

    #if swc @:extern #end
    @tick(.1)
    @prototype
    public var u(get, set):Float;
    #if swc @:getter(u) #end
    inline private function get_u():Float {
        return g2d_texture.u;
    }
    #if swc @:setter(u) #end
    inline public function set_u(p_value:Float):Float {
        return g2d_texture.u = p_value;
    }

    #if swc @:extern #end
    @tick(.1)
    @prototype
    public var v(get, set):Float;
    #if swc @:getter(v) #end
    inline private function get_v():Float {
        return g2d_texture.v;
    }
    #if swc @:setter(v) #end
    inline public function set_v(p_value:Float):Float {
        return g2d_texture.v = p_value;
    }

    #if swc @:extern #end
    @tick(.1)
    @prototype
    public var uScale(get, set):Float;
    #if swc @:getter(uScale) #end
    inline private function get_uScale():Float {
        return g2d_texture.uScale;
    }
    #if swc @:setter(uScale) #end
    inline public function set_uScale(p_value:Float):Float {
        return g2d_texture.uScale = p_value;
    }

    #if swc @:extern #end
    @editable(false)
    @tick(.1)
    @prototype
    public var vScale(get, set):Float;
    #if swc @:getter(vScale) #end
    inline private function get_vScale():Float {
        return g2d_texture.vScale;
    }
    #if swc @:setter(vScale) #end
    inline public function set_vScale(p_value:Float):Float {
        return g2d_texture.vScale = p_value;
    }

    #if swc @:extern #end
    @prototype
    public var filteringType(get, set):GTextureFilteringType;
        #if swc @:getter(filteringType) #end
    inline private function get_filteringType():GTextureFilteringType {
        return g2d_texture.filteringType;
    }
        #if swc @:setter(filteringType) #end
    inline public function set_filteringType(p_value:GTextureFilteringType):GTextureFilteringType {
        return g2d_texture.filteringType = p_value;
    }

    public function new(p_texture:GTexture = null) {
        g2d_texture = p_texture;
    }

    public function getPrototype(p_prototype:GPrototype = null):GPrototype {
        p_prototype = getPrototypeDefault(p_prototype);
        p_prototype.createPrototypeProperty("texture", "String", GPrototypeExtras.IGNORE_AUTO_BIND, null, g2d_texture==null?"":g2d_texture.toReference());

        return p_prototype;
    }

    public function bindPrototype(p_prototype:GPrototype):Void {
        g2d_texture = GTexture.fromReference(p_prototype.getProperty("texture").value);

        bindPrototypeDefault(p_prototype);
    }
}
