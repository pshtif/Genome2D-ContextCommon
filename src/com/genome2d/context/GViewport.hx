package com.genome2d.context;

import com.genome2d.components.GCameraController;
import com.genome2d.Genome2D;
import com.genome2d.geom.GRectangle;
import com.genome2d.utils.GHAlignType;
import com.genome2d.utils.GVAlignType;
class GViewport {

    private var g2d_vAlign:GVAlignType;
    #if swc @:extern #end
    public var vAlign(get, set):GVAlignType;
    #if swc @:getter(vAlign) #end
    inline private function get_vAlign():GVAlignType {
        return g2d_vAlign;
    }
    #if swc @:setter(vAlign) #end
    inline private function set_vAlign(p_value:GVAlignType):GVAlignType {
        return g2d_vAlign = p_value;
    }

    private var g2d_hAlign:GHAlignType;
    #if swc @:extern #end
    public var hAlign(get, set):GHAlignType;
    #if swc @:getter(hAlign) #end
    inline private function get_hAlign():GHAlignType {
        return g2d_hAlign;
    }
    #if swc @:setter(hAlign) #end
    inline private function set_hAlign(p_value:GHAlignType):GHAlignType {
        return g2d_hAlign = p_value;
    }

    private var g2d_width:Float;
    private var g2d_height:Float;

    private var g2d_screenLeft:Float;
    #if swc @:extern #end
    public var screenLeft(get, null):Float;
        #if swc @:getter(screenLeft) #end
    inline private function get_screenLeft():Float {
        return g2d_screenLeft;
    }

    private var g2d_screenTop:Float;
    #if swc @:extern #end
    public var screenTop(get, null):Float;
        #if swc @:getter(screenTop) #end
    inline private function get_screenTop():Float {
        return g2d_screenTop;
    }

    private var g2d_screenRight:Float;
    #if swc @:extern #end
    public var screenRight(get, null):Float;
        #if swc @:getter(screenRight) #end
    inline private function get_screenRight():Float {
        return g2d_screenRight;
    }

    private var g2d_screenBottom:Float;
    #if swc @:extern #end
    public var screenBottom(get, null):Float;
        #if swc @:getter(screenBottom) #end
    inline private function get_screenBottom():Float {
        return g2d_screenBottom;
    }

    private var g2d_zoom:Float;
    #if swc @:extern #end
    public var zoom(get, null):Float;
        #if swc @:getter(zoom) #end
    inline private function get_zoom():Float {
        return g2d_zoom;
    }

    private var g2d_aspectRatio:Float;
    #if swc @:extern #end
    public var aspectRatio(get, null):Float;
        #if swc @:getter(aspectRatio) #end
    inline private function get_aspectRatio():Float {
        return g2d_aspectRatio;
    }

    private var g2d_cameraController:GCameraController;

    public function new(p_cameraController:GCameraController, p_viewWidth:Int, p_viewHeight:Int, p_autoResize:Bool = true) {
        g2d_vAlign = GVAlignType.MIDDLE;
        g2d_hAlign = GHAlignType.CENTER;
        g2d_cameraController = p_cameraController;

        g2d_width = p_viewWidth;
        g2d_height = p_viewHeight;

        var rect:GRectangle = Genome2D.getInstance().getContext().getStageViewRect();
        resize_handler(rect.width, rect.height);

        if (p_autoResize) {
            Genome2D.getInstance().getContext().onResize.addWithPriority(resize_handler);
        }
    }

    private var g2d_previousZoom:Int = 1;
	
	public function dispose():Void {
		Genome2D.getInstance().getContext().onResize.remove(resize_handler);
	}

    private function resize_handler(p_width:Float, p_height:Float):Void {
		p_width *= g2d_cameraController.contextCamera.normalizedViewWidth;
		p_height *= g2d_cameraController.contextCamera.normalizedViewHeight;
        var aw:Float = p_width/g2d_width;
        var ah:Float = p_height/g2d_height;

        g2d_aspectRatio = p_width/p_height;
        g2d_zoom = Math.min(aw, ah);
        g2d_cameraController.zoom = g2d_zoom;

        if (aw<ah) {
            g2d_screenLeft = 0;
            g2d_screenRight = g2d_width;
            switch (vAlign) {
                case GVAlignType.MIDDLE:
                    g2d_screenTop = (g2d_height*g2d_zoom-p_height)/(2*g2d_zoom);
                    g2d_screenBottom = g2d_height+(p_height-g2d_zoom*g2d_height)/(2*g2d_zoom);
                    g2d_cameraController.node.setPosition(g2d_width*.5, g2d_height*.5);
                case GVAlignType.TOP:
                    g2d_screenTop = 0;
                    g2d_screenBottom = g2d_height+(p_height-g2d_zoom*g2d_height)/g2d_zoom;
                    g2d_cameraController.node.setPosition(g2d_width*.5, g2d_height*.5 + (p_height-g2d_zoom*g2d_height)/(2*g2d_zoom));
                case GVAlignType.BOTTOM:
                    g2d_screenTop = (g2d_height*g2d_zoom-p_height)/g2d_zoom;
                    g2d_screenBottom = p_height;
                    g2d_cameraController.node.setPosition(g2d_width*.5, g2d_height*.5 - (p_height-g2d_zoom*g2d_height)/(2*g2d_zoom));
            }
        } else {
            switch (hAlign) {
                case GHAlignType.CENTER:
                    g2d_screenLeft = (g2d_zoom*g2d_width-p_width)/(2*g2d_zoom);
                    g2d_screenRight = g2d_width+(p_width-g2d_zoom*g2d_width)/(2*g2d_zoom);
                    g2d_cameraController.node.setPosition(g2d_width*.5, g2d_height*.5);
                case GHAlignType.LEFT:
                    g2d_screenLeft = 0;
                    g2d_screenRight = g2d_width+(p_width-g2d_zoom*g2d_width)/g2d_zoom;
                    g2d_cameraController.node.setPosition(g2d_width*.5 + (p_width-g2d_zoom*g2d_width)/(2*g2d_zoom), g2d_height*.5);
                case GHAlignType.RIGHT:
                    g2d_screenLeft = (g2d_zoom*g2d_width-p_width)/g2d_zoom;
                    g2d_screenRight = p_width;
                    g2d_cameraController.node.setPosition(g2d_width*.5 - (p_width-g2d_zoom*g2d_width)/(2*g2d_zoom), g2d_height*.5);
            }
            g2d_screenTop = 0;
            g2d_screenBottom = g2d_height;
        }
    }
}
