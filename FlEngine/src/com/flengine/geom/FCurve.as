package com.flengine.geom
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.geom.*;

    public class FCurve extends Object
    {
        protected var _nNormalEpsilon:Number = 0.001;
        protected var _bLengthDirty:Boolean = true;
        protected var _aPoints:Vector.<Number>;
        protected var _nLength:Number = 0;

        public function FCurve(param1:Vector.<Number>)
        {
            if (param1 == null)
            {
                _aPoints = new Vector.<Number>;
            }
            else
            {
                _aPoints = param1;
            }
            return;
        }// end function

        public function get length() : Number
        {
            var _loc_1:* = NaN;
            var _loc_4:* = NaN;
            var _loc_2:* = null;
            var _loc_3:* = null;
            if (_bLengthDirty)
            {
                _nLength = 0;
                _loc_1 = 1 / _aPoints.length;
                _loc_4 = 0;
                while (_loc_4 < 100)
                {
                    
                    _loc_2 = interpolateByDistance(_loc_4 * _loc_1);
                    if (_loc_3 != null)
                    {
                        _nLength = _nLength + Point.distance(_loc_3, _loc_2);
                    }
                    _loc_3 = _loc_2;
                    _loc_4++;
                }
                _bLengthDirty = false;
            }
            return _nLength;
        }// end function

        public function set points(param1:Vector.<Number>) : void
        {
            _aPoints = param1;
            _bLengthDirty = true;
            return;
        }// end function

        public function get points() : Vector.<Number>
        {
            return _aPoints;
        }// end function

        public function addPoint(param1:Number, param2:Number, param3:Number = -1) : void
        {
            if (param3 == -1)
            {
                _aPoints.push(param1, param2);
            }
            else
            {
                _aPoints.splice(param3 * 2, 0, param1, param2);
            }
            _bLengthDirty = true;
            return;
        }// end function

        public function removePoint(param1:Number) : void
        {
            _aPoints.splice(param1, 1);
            return;
        }// end function

        public function getNormalAtDistance(param1:Number) : Point
        {
            var _loc_3:* = interpolateByDistance(param1 - _nNormalEpsilon);
            var _loc_2:* = interpolateByDistance(param1 + _nNormalEpsilon);
            var _loc_5:* = _loc_2.x - _loc_3.x;
            var _loc_4:* = _loc_2.y - _loc_3.y;
            return new Point(_loc_4, -_loc_5);
        }// end function

        public function interpolateByDistance(param1:Number) : Point
        {
            return new Point();
        }// end function

        public function drawPath(param1:Graphics, param2:Number) : void
        {
            var _loc_3:* = NaN;
            var _loc_5:* = NaN;
            var _loc_4:* = null;
            _loc_3 = 1 / (param2 - 1);
            _loc_5 = 0;
            while (_loc_5 < param2)
            {
                
                _loc_4 = interpolateByDistance(_loc_5 * _loc_3);
                if (_loc_5 == 0)
                {
                    param1.moveTo(_loc_4.x, _loc_4.y);
                }
                else
                {
                    param1.lineTo(_loc_4.x, _loc_4.y);
                }
                _loc_5++;
            }
            return;
        }// end function

    }
}
