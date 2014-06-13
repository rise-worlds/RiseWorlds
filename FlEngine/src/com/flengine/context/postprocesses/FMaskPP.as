package com.flengine.context.postprocesses
{
    import com.flengine.components.*;
    import com.flengine.context.*;
    import com.flengine.context.filters.*;
    import com.flengine.core.*;
    import com.flengine.textures.*;
    import flash.geom.*;

    public class FMaskPP extends FPostProcess
    {
        protected var _cMask:FNode;
        protected var _cMaskFilter:FMaskPassFilter;

        public function FMaskPP()
        {
            super(2);
            _cMaskFilter = new FMaskPassFilter(_aPassTextures[1]);
            return;
        }// end function

        public function get mask() : FNode
        {
            return _cMask;
        }// end function

        public function set mask(param1:FNode) : void
        {
            if (_cMask != null)
            {
                (_cMask.iUsedAsPPMask - 1);
            }
            _cMask = param1;
            (_cMask.iUsedAsPPMask + 1);
            return;
        }// end function

        override public function render(param1:FContext, param2:FCamera, param3:Rectangle, param4:FNode, param5:Rectangle = null, param6:FTexture = null, param7:FTexture = null) : void
        {
            var _loc_10:* = 0;
            var _loc_8:* = param5;
            if (param5 == null)
            {
                _loc_8 = _rDefinedBounds ? (_rDefinedBounds) : (param4.getWorldBounds(_rActiveBounds));
            }
            if (_loc_8.x == 17976931348623161000000000000)
            {
                return;
            }
            updatePassTextures(_loc_8);
            if (param6 == null)
            {
                _cMatrix.identity();
                _cMatrix.prependTranslation(-_loc_8.x + _iLeftMargin, -_loc_8.y + _iTopMargin, 0);
                param1.setRenderTarget(_aPassTextures[0], _cMatrix);
                param1.setCamera(FlEngine.getInstance().defaultCamera);
                param4.render(param1, param2, _aPassTextures[0].region, false);
            }
            var _loc_9:* = _aPassTextures[0];
            if (param6)
            {
                _aPassTextures[0] = param6;
            }
            var _loc_11:* = null;
            if (_cMask != null)
            {
                param1.setRenderTarget(_aPassTextures[1]);
                _loc_10 = _cMask.iUsedAsPPMask;
                _cMask.iUsedAsPPMask = 0;
                _cMask.render(param1, param2, _aPassTextures[1].region, false);
                _cMask.iUsedAsPPMask = _loc_10;
                _loc_11 = _cMaskFilter;
            }
            if (param7 == null)
            {
                param1.setRenderTarget(null);
                param1.setCamera(param2);
                param1.draw(_aPassTextures[0], _loc_8.x - _iLeftMargin, _loc_8.y - _iTopMargin, 1, 1, 0, 1, 1, 1, 1, 1, param3, _loc_11);
            }
            else
            {
                param1.setRenderTarget(param7);
                param1.draw(_aPassTextures[0], 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, param7.region, _loc_11);
            }
            _aPassTextures[0] = _loc_9;
            return;
        }// end function

    }
}
