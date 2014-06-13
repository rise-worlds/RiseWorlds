package com.flengine.context.postprocesses
{
    import __AS3__.vec.*;
    import com.flengine.components.*;
    import com.flengine.context.*;
    import com.flengine.context.filters.*;
    import com.flengine.core.*;
    import com.flengine.textures.*;
    import flash.geom.*;

    public class FHDRPP extends FPostProcess
    {
        protected var _cEmpty:FFilterPP;
        protected var _cBlur:FBlurPP;
        protected var _cHDRPassFilter:FHDRPassFilter;

        public function FHDRPP(param1:int = 3, param2:int = 3, param3:int = 2, param4:Number = 1.3)
        {
            super(2);
            _iRightMargin = param1 * 2 * param3;
            _iLeftMargin = param1 * 2 * param3;
            _iBottomMargin = param2 * 2 * param3;
            _iTopMargin = param2 * 2 * param3;
            new Vector.<FFilter>(1)[0] = null;
            _cEmpty = new FFilterPP(new Vector.<FFilter>(1));
            _cEmpty.setMargins(_iLeftMargin, _iRightMargin, _iTopMargin, _iBottomMargin);
            _cBlur = new FBlurPP(param1, param2, param3);
            _cHDRPassFilter = new FHDRPassFilter(param4);
            return;
        }

        public function get blurX() : int
        {
            return _cBlur.blurX;
        }

        public function set blurX(param1:int) : void
        {
            _cBlur.blurX = param1;
            _iRightMargin = param1 * 2 * _cBlur.passes;
            _iLeftMargin = param1 * 2 * _cBlur.passes;
            _cEmpty.setMargins(_iLeftMargin, _iRightMargin, _iTopMargin, _iBottomMargin);
            return;
        }

        public function get blurY() : int
        {
            return _cBlur.blurY;
        }

        public function set blurY(param1:int) : void
        {
            _cBlur.blurY = param1;
            _iBottomMargin = param1 * 2 * _cBlur.passes;
            _iTopMargin = param1 * 2 * _cBlur.passes;
            _cEmpty.setMargins(_iLeftMargin, _iRightMargin, _iTopMargin, _iBottomMargin);
            return;
        }

        public function get saturation() : Number
        {
            return _cHDRPassFilter.saturation;
        }

        public function set saturation(param1:Number) : void
        {
            _cHDRPassFilter.saturation = param1;
            return;
        }

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
            _cHDRPassFilter.texture = _cEmpty.getPassTexture(0);
            param1.setRenderTarget(null);
            param1.setCamera(param2);
            param1.draw(_aPassTextures[1], _loc_8.x - _iLeftMargin, _loc_8.y - _iTopMargin, 1, 1, 0, 1, 1, 1, 1, 1, param3, _cHDRPassFilter);
            return;
        }

        override public function dispose() : void
        {
            _cBlur.dispose();
            super.dispose();
            return;
        }

    }
}
