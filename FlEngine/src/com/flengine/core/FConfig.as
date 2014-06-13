package com.flengine.core
{
    import flash.display.*;
    import flash.geom.*;

    public class FConfig extends Object
    {
        public var backgroundRed:Number = 0;
        public var backgroundGreen:Number = 0;
        public var backgroundBlue:Number = 0;
        public var renderMode:String = "auto";
        public var useSeparatedAlphaShaders:Boolean = true;
        public var enableStats:Boolean = false;
        public var showExtendedStats:Boolean = false;
        public var enableNativeContentMouseCapture:Boolean = true;
        public var useFastMem:Boolean = false;
        protected var _sProfile:String;
        protected var _rViewRect:Rectangle;
        private var __iAntiAliasing:int = 0;
        private var __bEnableDepthAndStencil:Boolean = false;
        public var enableFixedTimeStep:Boolean = false;
        public var fixedTimeStep:int = 30;
        public var renderFrameSkip:int = 0;
        public var timeStepScale:Number = 1;
        protected var _st3ExternalStage3D:Stage3D;

        public function FConfig(param1:Rectangle, param2:String = "baselineConstrained", param3:Stage3D = null)
        {
            _rViewRect = param1;
            _sProfile = param2;
            _st3ExternalStage3D = param3;
            return;
        }// end function

        public function set backgroundColor(param1:int) : void
        {
            backgroundRed = (param1 >> 16 & 255) / 255;
            backgroundGreen = (param1 >> 8 & 255) / 255;
            backgroundBlue = (param1 & 255) / 255;
            return;
        }// end function

        public function get profile() : String
        {
            return _sProfile;
        }// end function

        public function get viewRect() : Rectangle
        {
            return _rViewRect;
        }// end function

        public function set viewRect(param1:Rectangle) : void
        {
            _rViewRect = param1;
            if (FlEngine.getInstance().cContext)
            {
                FlEngine.getInstance().cContext.invalidate();
            }
            return;
        }// end function

        public function get antiAliasing() : int
        {
            return __iAntiAliasing;
        }// end function

        public function set antiAliasing(param1:int) : void
        {
            __iAntiAliasing = param1;
            if (FlEngine.getInstance().cContext)
            {
                FlEngine.getInstance().cContext.invalidate();
            }
            return;
        }// end function

        public function get enableDepthAndStencil() : Boolean
        {
            return __bEnableDepthAndStencil;
        }// end function

        public function set enableDepthAndStencil(param1:Boolean) : void
        {
            __bEnableDepthAndStencil = param1;
            if (FlEngine.getInstance().cContext)
            {
                FlEngine.getInstance().cContext.invalidate();
            }
            return;
        }// end function

        public function get externalStage3D() : Stage3D
        {
            return _st3ExternalStage3D;
        }// end function

    }
}
