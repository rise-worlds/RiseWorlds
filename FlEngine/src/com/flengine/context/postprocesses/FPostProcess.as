package com.flengine.context.postprocesses
{
    import __AS3__.vec.*;
    import com.flengine.components.*;
    import com.flengine.context.*;
    import com.flengine.context.filters.*;
    import com.flengine.core.*;
    import com.flengine.error.*;
    import com.flengine.textures.*;
    import com.flengine.textures.factories.*;
    import flash.geom.*;

    public class FPostProcess extends Object
    {
        protected var _iPasses:int = 1;
        protected var _aPassFilters:Vector.<FFilter>;
        protected var _aPassTextures:Vector.<FTexture>;
        protected var _cMatrix:Matrix3D;
        protected var _rDefinedBounds:Rectangle;
        protected var _rActiveBounds:Rectangle;
        protected var _iLeftMargin:int = 0;
        protected var _iRightMargin:int = 0;
        protected var _iTopMargin:int = 0;
        protected var _iBottomMargin:int = 0;
        protected var _sId:String;
        private static var __iCount:int = 0;

        public function FPostProcess(param1:int = 1)
        {
            _cMatrix = new Matrix3D();
            (__iCount + 1);
            _sId = __iCount;
            if (param1 < 1)
            {
                throw new FError("FError: Post process needs atleast one pass.");
            }
            _iPasses = param1;
            _aPassFilters = new Vector.<FFilter>(_iPasses);
            _aPassTextures = new Vector.<FTexture>(_iPasses);
            createPassTextures();
            return;
        }

        public function get passes() : int
        {
            return _iPasses;
        }

        public function setBounds(param1:Rectangle) : void
        {
            _rDefinedBounds = param1;
            return;
        }

        public function setMargins(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0) : void
        {
            _iLeftMargin = param1;
            _iRightMargin = param2;
            _iTopMargin = param3;
            _iBottomMargin = param4;
            return;
        }

        public function render(param1:FContext, param2:FCamera, param3:Rectangle, param4:FNode, param5:Rectangle = null, param6:FTexture = null, param7:FTexture = null) : void
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
            _loc_10 = 1;
            while (_loc_10 < _iPasses)
            {
                
                param1.setRenderTarget(_aPassTextures[_loc_10]);
                param1.draw(_aPassTextures[(_loc_10 - 1)], 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, _aPassTextures[_loc_10].region, _aPassFilters[(_loc_10 - 1)]);
                _loc_10++;
            }
            param1.setRenderTarget(param7);
            if (param7 == null)
            {
                param1.setCamera(param2);
                param1.draw(_aPassTextures[(_iPasses - 1)], _loc_8.x - _iLeftMargin, _loc_8.y - _iTopMargin, 1, 1, 0, 1, 1, 1, 1, 1, param3, _aPassFilters[(_iPasses - 1)]);
            }
            else
            {
                param1.draw(_aPassTextures[(_iPasses - 1)], 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, param7.region, _aPassFilters[(_iPasses - 1)]);
            }
            _aPassTextures[0] = _loc_9;
            return;
        }

        public function getPassTexture(param1:int) : FTexture
        {
            return _aPassTextures[param1];
        }

        public function getPassFilter(param1:int) : FFilter
        {
            return _aPassFilters[param1];
        }

        protected function updatePassTextures(param1:Rectangle) : void
        {
            var _loc_5:* = 0;
            var _loc_3:* = null;
            var _loc_2:* = param1.width + _iLeftMargin + _iRightMargin;
            var _loc_4:* = param1.height + _iTopMargin + _iBottomMargin;
            if (_aPassTextures[0].width != _loc_2 || _aPassTextures[0].height != _loc_4)
            {
                _loc_5 = _aPassTextures.length - 1;
                while (_loc_5 >= 0)
                {
                    
                    _loc_3 = _aPassTextures[_loc_5];
                    _loc_3.region = new Rectangle(0, 0, _loc_2, _loc_4);
                    _loc_3.pivotX = (-_loc_3.iWidth) / 2;
                    _loc_3.pivotY = (-_loc_3.iHeight) / 2;
                    _loc_5--;
                }
            }
            return;
        }

        protected function createPassTextures() : void
        {
            var _loc_2:* = 0;
            var _loc_1:* = null;
            _loc_2 = 0;
            while (_loc_2 < _iPasses)
            {
                
                _loc_1 = FTextureFactory.createRenderTexture("g2d_pp_" + _sId + "_" + _loc_2, 2, 2, true);
                _loc_1.filteringType = 0;
                _loc_1.pivotX = (-_loc_1.iWidth) / 2;
                _loc_1.pivotY = (-_loc_1.iHeight) / 2;
                _aPassTextures[_loc_2] = _loc_1;
                _loc_2++;
            }
            return;
        }

        public function dispose() : void
        {
            var _loc_1:* = 0;
            _loc_1 = _aPassTextures.length - 1;
            while (_loc_1 >= 0)
            {
                
                _aPassTextures[_loc_1].dispose();
                _loc_1--;
            }
            return;
        }

    }
}
