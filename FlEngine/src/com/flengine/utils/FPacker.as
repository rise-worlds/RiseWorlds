package com.flengine.utils
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.geom.*;

    public class FPacker extends Object
    {
        protected var _iMaxWidth:int;
        protected var _iMaxHeight:int;
        protected var _bAutoExpand:Boolean = false;
        protected var _iSortOnExpand:int = 2;
        protected var _bForceValidTextureSizeOnExpand:Boolean = true;
        protected var _iWidth:int;
        protected var _iHeight:int;
        protected var _aRectangles:Vector.<FPackerRectangle>;
        public static const SORT_NONE:int = 0;
        public static const SORT_ASCENDING:int = 1;
        public static const SORT_DESCENDING:int = 2;
        public static var nonValidTextureSizePrecision:int = 5;

        public function FPacker(param1:int = 1, param2:int = 1, param3:int = 2048, param4:int = 2048, param5:Boolean = false) : void
        {
            if (param1 <= 0 || param2 <= 0)
            {
                throw new Error("Invalid packer size");
            }
            _iWidth = param1;
            _iHeight = param2;
            _iMaxWidth = param3;
            _iMaxHeight = param4;
            _bAutoExpand = param5;
            clear();
            return;
        }

        public function get width() : int
        {
            return _iWidth;
        }

        public function get height() : int
        {
            return _iHeight;
        }

        public function get rectangles() : Vector.<FPackerRectangle>
        {
            return _aRectangles.concat();
        }

        public function packRectangles(param1:Vector.<FPackerRectangle>, param2:int = 0, param3:int = 2) : Boolean
        {
            return false;
        }

        public function packRectangle(param1:FPackerRectangle, param2:int = 0, param3:Boolean = true) : Boolean
        {
            return false;
        }

        protected function getRectanglesArea(param1:Vector.<FPackerRectangle>) : int
        {
            var _loc_2:* = 0;
            var _loc_3:* = param1.length - 1;
            while (_loc_3 >= 0)
            {
                
                _loc_2 = _loc_2 + param1[_loc_3].width * param1[_loc_3].height;
                _loc_3--;
            }
            return _loc_2;
        }

        protected function sortOnAreaAscending(param1:FPackerRectangle, param2:FPackerRectangle) : Number
        {
            var _loc_4:* = param1.width * param1.height;
            var _loc_3:* = param2.width * param2.height;
            if (_loc_4 < _loc_3)
            {
                return -1;
            }
            if (_loc_4 > _loc_3)
            {
                return 1;
            }
            return 0;
        }

        protected function sortOnAreaDescending(param1:FPackerRectangle, param2:FPackerRectangle) : Number
        {
            var _loc_4:* = param1.width * param1.height;
            var _loc_3:* = param2.width * param2.height;
            if (_loc_4 > _loc_3)
            {
                return -1;
            }
            if (_loc_4 < _loc_3)
            {
                return 1;
            }
            return 0;
        }

        protected function sortOnHeightAscending(param1:FPackerRectangle, param2:FPackerRectangle) : Number
        {
            if (param1.height < param2.height)
            {
                return -1;
            }
            if (param1.height > param2.height)
            {
                return 1;
            }
            return 0;
        }

        protected function sortOnHeightDescending(param1:FPackerRectangle, param2:FPackerRectangle) : Number
        {
            if (param1.height > param2.height)
            {
                return -1;
            }
            if (param1.height < param2.height)
            {
                return 1;
            }
            return 0;
        }

        public function clear() : void
        {
            _aRectangles = new Vector.<FPackerRectangle>;
            return;
        }

        public function draw(param1:BitmapData) : void
        {
            var _loc_4:* = 0;
            var _loc_3:* = null;
            var _loc_2:* = new Matrix();
            _loc_4 = 0;
            while (_loc_4 < _aRectangles.length)
            {
                
                _loc_3 = _aRectangles[_loc_4];
                _loc_2.tx = _loc_3.x;
                _loc_2.ty = _loc_3.y;
                param1.draw(_loc_3.bitmapData, _loc_2);
                _loc_4++;
            }
            return;
        }

    }
}
