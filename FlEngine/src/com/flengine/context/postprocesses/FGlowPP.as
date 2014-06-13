package com.flengine.context.postprocesses
{
    import __AS3__.vec.*;
    import com.flengine.components.*;
    import com.flengine.context.*;
    import com.flengine.context.filters.*;
    import com.flengine.core.*;
    import com.flengine.textures.*;
    import flash.geom.*;

    public class FGlowPP extends FPostProcess
    {
        protected var _cEmpty:FFilterPP;
        protected var _cBlur:FBlurPP;
        protected var _iOffsetX:int;
        protected var _iOffsetY:int;

        public function FGlowPP(param1:int = 2, param2:int = 2, param3:int = 1)
        {
            super(2);
            new Vector.<FFilter>(1)[0] = null;
            _cEmpty = new FFilterPP(new Vector.<FFilter>(1));
            _cBlur = new FBlurPP(param1, param2, param3);
            _cBlur.colorize = true;
            _iRightMargin = _cBlur.blurX * _cBlur.passes * 0.5;
            _iLeftMargin = _cBlur.blurX * _cBlur.passes * 0.5;
            _iBottomMargin = _cBlur.blurY * _cBlur.passes * 0.5;
            _iTopMargin = _cBlur.blurY * _cBlur.passes * 0.5;
            _cEmpty.setMargins(_iLeftMargin, _iRightMargin, _iTopMargin, _iBottomMargin);
            return;
        }// end function

        public function get color() : int
        {
            var _loc_1:* = _cBlur.red * 255 << 16;
            var _loc_3:* = _cBlur.green * 255 << 8;
            var _loc_2:* = _cBlur.blue * 255;
            return _loc_1 + _loc_3 + _loc_2;
        }// end function

        public function set color(param1:int) : void
        {
            _cBlur.red = (param1 >> 16 & 255) / 255;
            _cBlur.green = (param1 >> 8 & 255) / 255;
            _cBlur.blue = (param1 & 255) / 255;
            return;
        }// end function

        public function get alpha() : Number
        {
            return _cBlur.alpha;
        }// end function

        public function set alpha(param1:Number) : void
        {
            _cBlur.alpha = param1;
            return;
        }// end function

        public function get blurX() : Number
        {
            return _cBlur.blurX;
        }// end function

        public function set blurX(param1:Number) : void
        {
            _cBlur.blurX = param1;
            _iRightMargin = _cBlur.blurX * _cBlur.passes * 0.5;
            _iLeftMargin = _cBlur.blurX * _cBlur.passes * 0.5;
            _cEmpty.setMargins(_iLeftMargin, _iRightMargin, _iTopMargin, _iBottomMargin);
            return;
        }// end function

        public function get blurY() : int
        {
            return _cBlur.blurY;
        }// end function

        public function set blurY(param1:int) : void
        {
            _cBlur.blurY = param1;
            _iBottomMargin = _cBlur.blurY * _cBlur.passes * 0.5;
            _iTopMargin = _cBlur.blurY * _cBlur.passes * 0.5;
            _cEmpty.setMargins(_iLeftMargin, _iRightMargin, _iTopMargin, _iBottomMargin);
            return;
        }// end function

        override public function render(param1:FContext, param2:FCamera, param3:Rectangle, param4:FNode, param5:Rectangle = null, param6:FTexture = null, param7:FTexture = null) : void
        {
            var _loc_8:* = _rDefinedBounds ? (_rDefinedBounds) : (param4.getWorldBounds(_rActiveBounds));
            if ((_loc_8).x == 17976931348623161000000000000)
            {
                return;
            }
            updatePassTextures(_loc_8);
            _cEmpty.render(param1, param2, param3, param4, _loc_8, null, _aPassTextures[0]);
            _cBlur.render(param1, param2, param3, param4, _loc_8, _aPassTextures[0], _aPassTextures[1]);
            param1.setRenderTarget(null);
            param1.setCamera(param2);
            param1.draw(_aPassTextures[1], _loc_8.x - _iLeftMargin + _iOffsetX, _loc_8.y - _iTopMargin + _iOffsetY, 1, 1, 0, 1, 1, 1, 1, 1, param3);
            param1.draw(_aPassTextures[0], _loc_8.x - _iLeftMargin, _loc_8.y - _iTopMargin, 1, 1, 0, 1, 1, 1, 1, 1, param3);
            return;
        }// end function

        override public function dispose() : void
        {
            _cEmpty.dispose();
            _cBlur.dispose();
            super.dispose();
            return;
        }// end function

    }
}
