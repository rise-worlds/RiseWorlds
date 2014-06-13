package com.flengine.geom
{
    import __AS3__.vec.*;
    import flash.geom.*;

    public class FNurbsCurve extends FCurve
    {
        public var knot:Array;
        protected var _d:int;

        public function FNurbsCurve(param1:Vector.<Number> = null, param2:int = 3, param3:Array = null)
        {
            super(param1);
            _d = param2;
            if (param3 != null)
            {
                knot = param3;
            }
            else
            {
                generateKnotVector();
            }
            return;
        }// end function

        public function generateKnotVector() : void
        {
            var _loc_2:* = 0;
            knot = [];
            var _loc_1:* = _aPoints.length / 2;
            _loc_2 = 0;
            while (_loc_2 < _d + _loc_1)
            {
                
                if (_loc_2 <= _d)
                {
                    knot.push(0);
                }
                else if (_loc_2 >= _loc_1)
                {
                    knot.push(1);
                }
                else
                {
                    knot.push((_loc_2 - _d) / (_loc_1 - _d));
                }
                _loc_2++;
            }
            knot.push(2);
            return;
        }// end function

        public function set d(param1:int) : void
        {
            _d = param1;
            return;
        }// end function

        public function get d() : int
        {
            return _d;
        }// end function

        override public function addPoint(param1:Number, param2:Number, param3:Number = -1) : void
        {
            super.addPoint(param1, param2, param3);
            generateKnotVector();
            return;
        }// end function

        private function Nik(param1:int, param2:int, param3:Number) : Number
        {
            if (param2 == 0)
            {
                if (param3 >= knot[param1] && param3 < knot[(param1 + 1)])
                {
                    return 1;
                }
                return 0;
            }
            var _loc_4:* = 0;
            if (knot[param1 + param2] != knot[param1])
            {
                _loc_4 = _loc_4 + (param3 - knot[param1]) / (knot[param1 + param2] - knot[param1]) * Nik(param1, (param2 - 1), param3);
            }
            if (knot[param1 + param2 + 1] != knot[(param1 + 1)])
            {
                _loc_4 = _loc_4 + (knot[param1 + param2 + 1] - param3) / (knot[param1 + param2 + 1] - knot[(param1 + 1)]) * Nik((param1 + 1), (param2 - 1), param3);
            }
            return _loc_4;
        }// end function

        private function Nikd(param1:int, param2:int, param3:Number) : Number
        {
            if (param2 == 0)
            {
                return 0;
            }
            var _loc_4:* = 0;
            if (knot[param1 + param2] != knot[param1])
            {
                _loc_4 = _loc_4 + (Nik(param1, (param2 - 1), param3) + (param3 - knot[param1]) * Nikd(param1, (param2 - 1), param3)) / (knot[param1 + param2] - knot[param1]);
            }
            if (knot[param1 + param2 + 1] != knot[(param1 + 1)])
            {
                _loc_4 = _loc_4 + (-Nik((param1 + 1), (param2 - 1), param3) + (knot[param1 + param2 + 1] - param3) * Nikd((param1 + 1), (param2 - 1), param3)) / (knot[param1 + param2 + 1] - knot[(param1 + 1)]);
            }
            return _loc_4;
        }// end function

        override public function getNormalAtDistance(param1:Number) : Point
        {
            var _loc_4:* = 0;
            var _loc_3:* = NaN;
            var _loc_2:* = new Point();
            _loc_4 = 0;
            while (_loc_4 < _aPoints.length)
            {
                
                _loc_3 = Nikd(_loc_4 / 2, d, param1);
                _loc_2.x = _loc_2.x + _aPoints[(_loc_4 + 1)] * _loc_3;
                _loc_2.y = _loc_2.y - _aPoints[_loc_4] * _loc_3;
                _loc_4 = _loc_4 + 2;
            }
            return _loc_2;
        }// end function

        override public function interpolateByDistance(param1:Number) : Point
        {
            var _loc_4:* = 0;
            var _loc_3:* = NaN;
            var _loc_2:* = new Point();
            _loc_4 = 0;
            while (_loc_4 < _aPoints.length)
            {
                
                _loc_3 = Nik(_loc_4 / 2, _d, param1);
                _loc_2.x = _loc_2.x + _aPoints[_loc_4] * _loc_3;
                _loc_2.y = _loc_2.y + _aPoints[(_loc_4 + 1)] * _loc_3;
                _loc_4 = _loc_4 + 2;
            }
            return _loc_2;
        }// end function

    }
}
