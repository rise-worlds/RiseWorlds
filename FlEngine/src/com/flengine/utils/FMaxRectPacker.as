package com.flengine.utils
{
    import __AS3__.vec.*;

    public class FMaxRectPacker extends FPacker
    {
        private var __iHeuristics:int = 0;
        private var __cFirstAvailableArea:FPackerRectangle;
        private var __cLastAvailableArea:FPackerRectangle;
        private var __cFirstNewArea:FPackerRectangle;
        private var __cLastNewArea:FPackerRectangle;
        private var __cNewBoundingArea:FPackerRectangle;
        private var __cNegativeArea:FPackerRectangle;
        public static const BOTTOM_LEFT:int = 0;
        public static const SHORT_SIDE_FIT:int = 1;
        public static const LONG_SIDE_FIT:int = 2;
        public static const AREA_FIT:int = 3;

        public function FMaxRectPacker(param1:int = 1, param2:int = 1, param3:int = 2048, param4:int = 2048, param5:Boolean = false, param6:int = 0)
        {
            __cNewBoundingArea = FPackerRectangle.get(0, 0, 0, 0);
            super(param1, param2, param3, param4, param5);
            __iHeuristics = param6;
            return;
        }

        override public function packRectangles(param1:Vector.<FPackerRectangle>, param2:int = 0, param3:int = 2) : Boolean
        {
            var _loc_5:* = false;
            var _loc_8:* = undefined;
            var _loc_7:* = 0;
            var _loc_9:* = null;
            if (param3 != 0)
            {
                param1.sort(param3 == 1 ? (sortOnHeightAscending) : (sortOnHeightDescending));
            }
            var _loc_4:* = param1.length;
            var _loc_10:* = true;
            var _loc_6:* = _bAutoExpand ? (new Vector.<FPackerRectangle>) : (null);
            var _loc_11:* = 0;
            while (_loc_11 < _loc_4)
            {
                
                _loc_9 = param1[_loc_11];
                _loc_5 = addRectangle(_loc_9, param2);
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
                if (_iSortOnExpand != 0)
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
                if (_iWidth * _iHeight < _loc_7 && (_iWidth < _iMaxWidth || _iHeight < _iMaxHeight)) goto 216;
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
        }

        override public function packRectangle(param1:FPackerRectangle, param2:int = 0, param3:Boolean = true) : Boolean
        {
            var _loc_4:* = undefined;
            var _loc_5:* = addRectangle(param1, param2);
            if (!addRectangle(param1, param2) && _bAutoExpand)
            {
                _loc_4 = rectangles;
                _loc_4.push(param1);
                clear();
                packRectangles(_loc_4, param2, _iSortOnExpand);
                _loc_5 = true;
            }
            return _loc_5;
        }

        private function addRectangles(param1:Vector.<FPackerRectangle>, param2:int = 0, param3:Boolean = true) : Boolean
        {
            var _loc_5:* = null;
            var _loc_4:* = param1.length;
            var _loc_6:* = true;
            var _loc_7:* = 0;
            while (_loc_7 < _loc_4)
            {
                
                _loc_5 = param1[_loc_7];
                _loc_6 = _loc_6 && addRectangle(_loc_5, param2);
                if (!_loc_6 && !param3)
                {
                    return false;
                }
                _loc_7++;
            }
            return _loc_6;
        }

        private function addRectangle(param1:FPackerRectangle, param2:int) : Boolean
        {
            var _loc_3:* = getAvailableArea(param1.width + (param2 - param1.padding) * 2, param1.height + (param2 - param1.padding) * 2);
            if (_loc_3 == null)
            {
                return false;
            }
            param1.set(_loc_3.x, _loc_3.y, param1.width + (param2 - param1.padding) * 2, param1.height + (param2 - param1.padding) * 2);
            param1.padding = param2;
            splitAvailableAreas(param1);
            pushNewAreas();
            if (param2 != 0)
            {
                param1.setPadding(0);
            }
            _aRectangles.push(param1);
            return true;
        }

        private function createNewArea(param1:int, param2:int, param3:int, param4:int) : FPackerRectangle
        {
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_5:* = true;
            _loc_6 = __cFirstNewArea;
            while (_loc_6)
            {
                
                _loc_7 = _loc_6.cNext;
                if (!(_loc_6.x > param1 || _loc_6.y > param2 || _loc_6.right < param1 + param3 || _loc_6.bottom < param2 + param4))
                {
                    _loc_5 = false;
                    break;
                }
                if (!(_loc_6.x < param1 || _loc_6.y < param2 || _loc_6.right > param1 + param3 || _loc_6.bottom > param2 + param4))
                {
                    if (_loc_6.cNext)
                    {
                        _loc_7.cPrevious = _loc_6.cPrevious;
                    }
                    else
                    {
                        __cLastNewArea = _loc_6.cPrevious;
                    }
                    if (_loc_6.cPrevious)
                    {
                        _loc_6.cPrevious.cNext = _loc_6.cNext;
                    }
                    else
                    {
                        __cFirstNewArea = _loc_6.cNext;
                    }
                    _loc_6.dispose();
                }
                _loc_6 = _loc_7;
            }
            if (!_loc_5)
            {
                return null;
            }
            _loc_6 = FPackerRectangle.get(param1, param2, param3, param4);
            if (__cNewBoundingArea.x < param1)
            {
                __cNewBoundingArea.x = param1;
            }
            if (__cNewBoundingArea.right > _loc_6.right)
            {
                __cNewBoundingArea.right = _loc_6.right;
            }
            if (__cNewBoundingArea.y < param2)
            {
                __cNewBoundingArea.y = param2;
            }
            if (__cNewBoundingArea.bottom < _loc_6.bottom)
            {
                __cNewBoundingArea.bottom = _loc_6.bottom;
            }
            if (__cLastNewArea)
            {
                _loc_6.cPrevious = __cLastNewArea;
                __cLastNewArea.cNext = _loc_6;
                __cLastNewArea = _loc_6;
            }
            else
            {
                __cLastNewArea = _loc_6;
                __cFirstNewArea = _loc_6;
            }
            return _loc_6;
        }

        private function splitAvailableAreas(param1:FPackerRectangle) : void
        {
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_5:* = param1.x;
            var _loc_4:* = param1.y;
            var _loc_2:* = param1.right;
            var _loc_3:* = param1.bottom;
            _loc_6 = __cFirstAvailableArea;
            while (_loc_6)
            {
                
                _loc_7 = _loc_6.cNext;
                if (!(_loc_5 >= _loc_6.right || _loc_2 <= _loc_6.x || _loc_4 >= _loc_6.bottom || _loc_3 <= _loc_6.y))
                {
                    if (_loc_5 > _loc_6.x)
                    {
                        createNewArea(_loc_6.x, _loc_6.y, _loc_5 - _loc_6.x, _loc_6.height);
                    }
                    if (_loc_2 < _loc_6.right)
                    {
                        createNewArea(_loc_2, _loc_6.y, _loc_6.right - _loc_2, _loc_6.height);
                    }
                    if (_loc_4 > _loc_6.y)
                    {
                        createNewArea(_loc_6.x, _loc_6.y, _loc_6.width, _loc_4 - _loc_6.y);
                    }
                    if (_loc_3 < _loc_6.bottom)
                    {
                        createNewArea(_loc_6.x, _loc_3, _loc_6.width, _loc_6.bottom - _loc_3);
                    }
                    if (_loc_6.cNext)
                    {
                        _loc_7.cPrevious = _loc_6.cPrevious;
                    }
                    else
                    {
                        __cLastAvailableArea = _loc_6.cPrevious;
                    }
                    if (_loc_6.cPrevious)
                    {
                        _loc_6.cPrevious.cNext = _loc_6.cNext;
                    }
                    else
                    {
                        __cFirstAvailableArea = _loc_6.cNext;
                    }
                    _loc_6.dispose();
                }
                _loc_6 = _loc_7;
            }
            return;
        }

        private function pushNewAreas() : void
        {
            var _loc_1:* = null;
            while (__cFirstNewArea)
            {
                
                _loc_1 = __cFirstNewArea;
                if (_loc_1.cNext)
                {
                    __cFirstNewArea = _loc_1.cNext;
                    _loc_1.cPrevious = null;
                }
                else
                {
                    __cFirstNewArea = null;
                }
                _loc_1.cPrevious = null;
                _loc_1.cNext = null;
                if (__cLastAvailableArea)
                {
                    _loc_1.cPrevious = __cLastAvailableArea;
                    __cLastAvailableArea.cNext = _loc_1;
                    __cLastAvailableArea = _loc_1;
                    continue;
                }
                __cLastAvailableArea = _loc_1;
                __cFirstAvailableArea = _loc_1;
            }
            __cLastNewArea = null;
            __cNewBoundingArea.set(0, 0, 0, 0);
            return;
        }

        private function getAvailableArea(param1:int, param2:int) : FPackerRectangle
        {
            var _loc_3:* = 0;
            var _loc_11:* = 0;
            var _loc_7:* = 0;
            var _loc_9:* = 0;
            var _loc_6:* = 0;
            var _loc_8:* = 0;
            var _loc_5:* = null;
            var _loc_10:* = __cNegativeArea;
            var _loc_4:* = -1;
            //switch(__iHeuristics) branch count is:<3>[17, 115, 253, 391] default offset is:<510>;
            //_loc_5 = __cFirstAvailableArea;
            //while (_loc_5)
            //{
                
            //    if (_loc_5.width >= param1 && _loc_5.height >= param2)
            //    {
            //        if (_loc_5.y < _loc_10.y || _loc_5.y == _loc_10.y && _loc_5.x < _loc_10.x)
            //        {
            //            _loc_10 = _loc_5;
            //        }
            //    }
            //    _loc_5 = _loc_5.cNext;
            //}
            ;
            //_loc_10.width = _iWidth + 1;
            //_loc_5 = __cFirstAvailableArea;
            //while (_loc_5)
            //{
                
            //    if (_loc_5.width >= param1 && _loc_5.height >= param2)
            //    {
            //        _loc_3 = _loc_5.width - param1;
            //        _loc_11 = _loc_5.height - param2;
            //        _loc_7 = _loc_3 < _loc_11 ? (_loc_3) : (_loc_11);
            //        _loc_3 = _loc_10.width - param1;
            //        _loc_11 = _loc_10.height - param2;
            //        _loc_9 = _loc_3 < _loc_11 ? (_loc_3) : (_loc_11);
            //        if (_loc_7 < _loc_9)
            //        {
            //            _loc_10 = _loc_5;
            //        }
            //    }
            //    _loc_5 = _loc_5.cNext;
            //}
            ;
            //_loc_10.width = _iWidth + 1;
            //_loc_5 = __cFirstAvailableArea;
            //while (_loc_5)
            //{
                
            //    if (_loc_5.width >= param1 && _loc_5.height >= param2)
            //    {
            //        _loc_3 = _loc_5.width - param1;
            //        _loc_11 = _loc_5.height - param2;
            //        _loc_7 = _loc_3 > _loc_11 ? (_loc_3) : (_loc_11);
            //        _loc_3 = _loc_10.width - param1;
            //        _loc_11 = _loc_10.height - param2;
            //        _loc_9 = _loc_3 > _loc_11 ? (_loc_3) : (_loc_11);
            //        if (_loc_7 < _loc_9)
            //        {
            //            _loc_10 = _loc_5;
            //        }
            //    }
            //    _loc_5 = _loc_5.cNext;
            //}
            ;
            //_loc_10.width = _iWidth + 1;
            //_loc_5 = __cFirstAvailableArea;
            //while (_loc_5)
            //{
                
            //    if (_loc_5.width >= param1 && _loc_5.height >= param2)
            //    {
            //        _loc_6 = _loc_5.width * _loc_5.height;
            //        _loc_8 = _loc_10.width * _loc_10.height;
            //        if (_loc_6 < _loc_8 || _loc_6 == _loc_8 && _loc_5.width < _loc_10.width)
            //        {
            //            _loc_10 = _loc_5;
            //        }
            //    }
            //    _loc_5 = _loc_5.cNext;
            //}
	    switch(this.__iHeuristics)
            {
                case BOTTOM_LEFT:
                {
                    _loc_5 = __cFirstAvailableArea;
	            while (_loc_5)
	            {
                
	                if (_loc_5.width >= param1 && _loc_5.height >= param2)
	                {
	                    if (_loc_5.y < _loc_10.y || _loc_5.y == _loc_10.y && _loc_5.x < _loc_10.x)
	                    {
	                        _loc_10 = _loc_5;
	                    }
	                }
	                _loc_5 = _loc_5.cNext;
	            }
                    break;
                }
                case SHORT_SIDE_FIT:
                {
                    _loc_10.width = _iWidth + 1;
	            _loc_5 = __cFirstAvailableArea;
	            while (_loc_5)
	            {
                
	                if (_loc_5.width >= param1 && _loc_5.height >= param2)
	                {
	                    _loc_3 = _loc_5.width - param1;
	                    _loc_11 = _loc_5.height - param2;
	                    _loc_7 = _loc_3 < _loc_11 ? (_loc_3) : (_loc_11);
	                    _loc_3 = _loc_10.width - param1;
	                    _loc_11 = _loc_10.height - param2;
	                    _loc_9 = _loc_3 < _loc_11 ? (_loc_3) : (_loc_11);
	                    if (_loc_7 < _loc_9)
	                    {
	                        _loc_10 = _loc_5;
	                    }
	                }
	                _loc_5 = _loc_5.cNext;
	            }
                    break;
                }
                case LONG_SIDE_FIT:
                {
                    _loc_10.width = _iWidth + 1;
	            _loc_5 = __cFirstAvailableArea;
	            while (_loc_5)
	            {
                
	                if (_loc_5.width >= param1 && _loc_5.height >= param2)
	                {
	                    _loc_3 = _loc_5.width - param1;
	                    _loc_11 = _loc_5.height - param2;
	                    _loc_7 = _loc_3 > _loc_11 ? (_loc_3) : (_loc_11);
	                    _loc_3 = _loc_10.width - param1;
	                    _loc_11 = _loc_10.height - param2;
	                    _loc_9 = _loc_3 > _loc_11 ? (_loc_3) : (_loc_11);
	                    if (_loc_7 < _loc_9)
	                    {
	                        _loc_10 = _loc_5;
	                    }
	                }
	                _loc_5 = _loc_5.cNext;
	            }
                    break;
                }
                case AREA_FIT:
                {
                    _loc_10.width = _iWidth + 1;
	            _loc_5 = __cFirstAvailableArea;
	            while (_loc_5)
	            {
                
	                if (_loc_5.width >= param1 && _loc_5.height >= param2)
	                {
	                    _loc_6 = _loc_5.width * _loc_5.height;
	                    _loc_8 = _loc_10.width * _loc_10.height;
	                    if (_loc_6 < _loc_8 || _loc_6 == _loc_8 && _loc_5.width < _loc_10.width)
	                    {
	                        _loc_10 = _loc_5;
	                    }
	                }
	                _loc_5 = _loc_5.cNext;
	            }
                    break;
                }
	    }
            return _loc_10 != __cNegativeArea ? (_loc_10) : (null);
        }

        override public function clear() : void
        {
            var _loc_1:* = null;
            super.clear();
            while (__cFirstAvailableArea)
            {
                
                _loc_1 = __cFirstAvailableArea;
                __cFirstAvailableArea = _loc_1.cNext;
                _loc_1.dispose();
            }
            __cLastAvailableArea = FPackerRectangle.get(0, 0, _iWidth, _iHeight);
            __cFirstAvailableArea = FPackerRectangle.get(0, 0, _iWidth, _iHeight);
            __cNegativeArea = FPackerRectangle.get((_iWidth + 1), (_iHeight + 1), (_iWidth + 1), (_iHeight + 1));
            return;
        }

    }
}
