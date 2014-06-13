package com.flengine.textures
{
    import flash.display.*;
    import flash.geom.*;

    public class FTextureUtils extends Object
    {
        private static const ZERO_POINT:Point = new Point();

        public function FTextureUtils()
        {
            return;
        }

        public static function isBitmapDataTransparent(param1:BitmapData) : Boolean
        {
            return param1.getColorBoundsRect(4278190080, 4278190080, false).width != 0;
        }

        public static function isValidTextureSize(param1:int) : Boolean
        {
            var _loc_2:* = 1;
            while (_loc_2 < param1)
            {
                
                _loc_2 = _loc_2 * 2;
            }
            return _loc_2 == param1;
        }

        public static function getNextValidTextureSize(param1:int) : int
        {
            var _loc_2:* = 1;
            while (param1 > _loc_2)
            {
                
                _loc_2 = _loc_2 * 2;
            }
            return _loc_2;
        }

        public static function getPreviousValidTextureSize(param1:int) : int
        {
            var _loc_2:* = 1;
            while (param1 > _loc_2)
            {
                
                _loc_2 = _loc_2 * 2;
            }
            _loc_2 = _loc_2 / 2;
            return _loc_2;
        }

        public static function getNearestValidTextureSize(param1:int) : int
        {
            var _loc_2:* = getPreviousValidTextureSize(param1);
            var _loc_3:* = getNextValidTextureSize(param1);
            return param1 - _loc_2 < _loc_3 - param1 ? (_loc_2) : (_loc_3);
        }

        public static function resampleBitmapData(param1:BitmapData, param2:int, param3:int) : BitmapData
        {
            var _loc_11:* = 0;
            var _loc_10:* = 0;
            var _loc_7:* = null;
            var _loc_9:* = null;
            var _loc_4:* = NaN;
            var _loc_6:* = NaN;
            var _loc_5:* = NaN;
            var _loc_8:* = param1.width;
            var _loc_12:* = param1.height;
            switch(param2) branch count is:<4>[68, 68, 20, 20, 44] default offset is:<88>;
            _loc_11 = getNextValidTextureSize(_loc_8);
            _loc_10 = getNextValidTextureSize(_loc_12);
            ;
            _loc_11 = getPreviousValidTextureSize(_loc_8);
            _loc_10 = getPreviousValidTextureSize(_loc_12);
            ;
            _loc_11 = getNearestValidTextureSize(_loc_8);
            _loc_10 = getNearestValidTextureSize(_loc_12);
            if (_loc_11 == _loc_8 && _loc_10 == _loc_12 && param3 == 1)
            {
                return param1;
            }
            switch(param2) branch count is:<4>[95, 153, 20, 95, 95] default offset is:<236>;
            _loc_9 = new Matrix();
            _loc_9.scale(1 / param3, 1 / param3);
            _loc_7 = new BitmapData(_loc_11 / param3, _loc_10 / param3, true, 0);
            if (param3 == 1)
            {
                _loc_7.copyPixels(param1, param1.rect, ZERO_POINT);
            }
            else
            {
                _loc_7.draw(param1, _loc_9);
            }
            ;
            _loc_9 = new Matrix();
            _loc_9.scale(_loc_11 / (_loc_8 * param3), _loc_10 / (_loc_12 * param3));
            _loc_7 = new BitmapData(_loc_11 / param3, _loc_10 / param3, true, 0);
            _loc_7.draw(param1, _loc_9);
            ;
            _loc_9 = new Matrix();
            _loc_4 = _loc_11 / _loc_8;
            _loc_6 = _loc_10 / _loc_12;
            _loc_5 = _loc_4 > _loc_6 ? (_loc_6) : (_loc_4);
            _loc_9.scale(_loc_5 / param3, _loc_5 / param3);
            _loc_7 = new BitmapData(_loc_11 / param3, _loc_10 / param3, true, 0);
            _loc_7.draw(param1, _loc_9);
            return _loc_7;
        }

    }
}
