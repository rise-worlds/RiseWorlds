package com.flengine.utils
{
    import __AS3__.vec.*;

    public class FBasicPacker extends FPacker
    {
        private var __iXOffset:int = 0;
        private var __iYOffset:int = 0;
        private var __iRowOffset:int = 0;

        public function FBasicPacker(param1:int = 1, param2:int = 1, param3:int = 2048, param4:int = 2048) : void
        {
            super(param1, param2, param3, param4);
            return;
        }// end function

        override public function packRectangles(param1:Vector.<FPackerRectangle>, param2:int = 0, param3:int = 2) : Boolean
        {
            var _loc_10:* = false;
            var _loc_11:* = 0;
            var _loc_5:* = false;
            var _loc_8:* = undefined;
            var _loc_7:* = 0;
            var _loc_9:* = null;
            if (param3 == 1 || param3 == 2)
            {
                param1.sort(param3 == 1 ? (sortOnHeightAscending) : (sortOnHeightDescending));
            }
            var _loc_4:* = param1.length;
            var _loc_6:* = _bAutoExpand ? (new Vector.<FPackerRectangle>) : (null);
            _loc_11 = 0;
            while (_loc_11 < _loc_4)
            {
                
                _loc_9 = param1[_loc_11];
                _loc_5 = addRectangle(_loc_9.width, _loc_9.height, param2);
                if (!_loc_5 && _bAutoExpand)
                {
                    _loc_6.push(param1[_loc_11]);
                }
                _loc_10 = _loc_10 && _loc_5;
                _loc_11++;
            }
            if (!_loc_10 && _bAutoExpand)
            {
                _loc_8 = rectangles;
                _loc_8 = _loc_8.concat(_loc_6);
                if (_iSortOnExpand == 1 || _iSortOnExpand == 2)
                {
                    _loc_8.sort(_iSortOnExpand == 1 ? (sortOnHeightAscending) : (sortOnHeightDescending));
                }
                _loc_7 = getRectanglesArea(_loc_8);
                
                if ((_iWidth <= _iHeight || _iHeight == _iMaxHeight) && _iWidth < _iMaxWidth)
                {
                    _iWidth = _bForceValidTextureSizeOnExpand ? (_iWidth * 2) : ((_iWidth + 1));
                }
                else
                {
                    _iHeight = _bForceValidTextureSizeOnExpand ? (_iHeight * 2) : ((_iHeight + 1));
                }
                if (_iWidth * _iHeight < _loc_7 && (_iWidth < _iMaxWidth || _iHeight < _iMaxHeight)) goto 245;
                clear();
                _loc_10 = addRectangles(_loc_8, param2);
                while (!_loc_10 && (_iWidth < _iMaxWidth || _iHeight < _iMaxHeight))
                {
                    
                    if ((_iWidth <= _iHeight || _iHeight == _iMaxHeight) && _iWidth < _iMaxWidth)
                    {
                        _iWidth = _bForceValidTextureSizeOnExpand ? (_iWidth * 2) : (_iWidth + nonValidTextureSizePrecision);
                    }
                    else
                    {
                        _iHeight = _bForceValidTextureSizeOnExpand ? (_iHeight * 2) : (_iHeight + nonValidTextureSizePrecision);
                    }
                    clear();
                    _loc_10 = addRectangles(_loc_8, param2);
                }
                _loc_10 = _iWidth <= _iMaxWidth && _iHeight <= _iMaxHeight;
            }
            return _loc_10;
        }// end function

        private function addRectangles(param1:Vector.<FPackerRectangle>, param2:int = 0, param3:Boolean = true) : Boolean
        {
            var _loc_7:* = 0;
            var _loc_5:* = null;
            var _loc_4:* = param1.length;
            var _loc_6:* = true;
            _loc_7 = 0;
            while (_loc_7 < _loc_4)
            {
                
                _loc_5 = param1[_loc_7];
                _loc_6 = addRectangle(_loc_5.width, _loc_5.height, param2);
                if (!_loc_6 && !param3)
                {
                    return false;
                }
                _loc_7++;
            }
            return _loc_6;
        }// end function

        private function addRectangle(param1:int, param2:int, param3:int = 0) : Boolean
        {
            var _loc_4:* = param3 * 2;
            var _loc_6:* = __iXOffset;
            var _loc_7:* = __iYOffset;
            var _loc_5:* = __iRowOffset;
            if (__iXOffset + param1 + _loc_4 > _iWidth)
            {
                __iXOffset = 0;
                __iYOffset = __iYOffset + __iRowOffset;
                __iRowOffset = 0;
            }
            if (param2 + _loc_4 > __iRowOffset)
            {
                __iRowOffset = param2 + _loc_4;
            }
            if (__iYOffset + param2 + _loc_4 > _iHeight)
            {
                __iXOffset = _loc_6;
                __iYOffset = _loc_7;
                __iRowOffset = _loc_5;
                return false;
            }
            _aRectangles.push(FPackerRectangle.get(__iXOffset + param3, __iYOffset + param3, param1, param2));
            __iXOffset = __iXOffset + (param1 + _loc_4);
            return true;
        }// end function

        override public function clear() : void
        {
            super.clear();
            __iXOffset = 0;
            __iYOffset = 0;
            __iRowOffset = 0;
            return;
        }// end function

    }
}
