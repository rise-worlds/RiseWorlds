package com.flengine.rand
{
    import __AS3__.vec.*;

    public class Hermite extends Object
    {
        public var points:Vector.<HermitePoint>;
        private var q:Vector.<Vector.<Number>>;
        private var z:Vector.<Number>;
        private var mPieces:Vector.<HermitePiece>;
        private var mIsBuilt:Boolean = false;
        private var mXSub:Vector.<Number>;
        public static const NUM_DIMS:int = 4;

        public function Hermite()
        {
            var _loc_1:* = 0;
            points = new Vector.<HermitePoint>;
            mPieces = new Vector.<HermitePiece>;
            mXSub = new Vector.<Number>(2, true);
            q = new Vector.<Vector.<Number>>(4, true);
            _loc_1 = 0;
            while (_loc_1 < 4)
            {
                
                q[_loc_1] = new Vector.<Number>(4, true);
                _loc_1++;
            }
            z = new Vector.<Number>(4, true);
            return;
        }// end function

        public function rebuild() : void
        {
            mIsBuilt = false;
            return;
        }// end function

        public function evaluate(param1:Number) : Number
        {
            var _loc_6:* = 0;
            var _loc_2:* = null;
            var _loc_5:* = null;
            var _loc_4:* = null;
            if (!mIsBuilt)
            {
                if (!build())
                {
                    return 0;
                }
                mIsBuilt = true;
            }
            var _loc_3:* = mPieces.length;
            _loc_6 = 0;
            while (_loc_6 < _loc_3)
            {
                
                if (param1 < points[(_loc_6 + 1)].x)
                {
                    _loc_2 = points[_loc_6];
                    _loc_5 = points[(_loc_6 + 1)];
                    _loc_4 = mPieces[_loc_6];
                    return evaluatePiece(param1, _loc_2.x, _loc_5.x, _loc_4);
                }
                _loc_6++;
            }
            return points[(points.length - 1)].fx;
        }// end function

        private function build() : Boolean
        {
            var _loc_3:* = 0;
            mPieces.length = 0;
            var _loc_1:* = points.length;
            if (_loc_1 < 2)
            {
                return false;
            }
            var _loc_2:* = _loc_1 - 1;
            _loc_3 = 0;
            while (_loc_3 < _loc_2)
            {
                
                mPieces[_loc_3] = createPiece(_loc_3);
                _loc_3++;
            }
            return true;
        }// end function

        private function createPiece(param1:int) : HermitePiece
        {
            var _loc_6:* = 0;
            var _loc_2:* = null;
            var _loc_5:* = 0;
            var _loc_3:* = 0;
            _loc_6 = 0;
            while (_loc_6 <= 1)
            {
                
                _loc_2 = points[param1 + _loc_6];
                _loc_5 = 2 * _loc_6;
                z[_loc_5] = _loc_2.x;
                z[(_loc_5 + 1)] = _loc_2.x;
                q[_loc_5][0] = _loc_2.fx;
                q[(_loc_5 + 1)][0] = _loc_2.fx;
                q[(_loc_5 + 1)][1] = _loc_2.fxp;
                if (_loc_6 > 0)
                {
                    q[_loc_5][1] = (q[_loc_5][0] - q[(_loc_5 - 1)][0]) / (z[_loc_5] - z[(_loc_5 - 1)]);
                }
                _loc_6++;
            }
            _loc_6 = 2;
            while (_loc_6 < 4)
            {
                
                _loc_3 = 2;
                while (_loc_3 <= _loc_6)
                {
                    
                    q[_loc_6][_loc_3] = (q[_loc_6][(_loc_3 - 1)] - q[(_loc_6 - 1)][(_loc_3 - 1)]) / (z[_loc_6] - z[_loc_6 - _loc_3]);
                    _loc_3++;
                }
                _loc_6++;
            }
            var _loc_4:* = new HermitePiece();
            _loc_6 = 0;
            while (_loc_6 < 4)
            {
                
                _loc_4.coeffs[_loc_6] = q[_loc_6][_loc_6];
                _loc_6++;
            }
            return _loc_4;
        }// end function

        private function evaluatePiece(param1:Number, param2:Number, param3:Number, param4:HermitePiece) : Number
        {
            var _loc_7:* = 0;
            mXSub[0] = param1 - param2;
            mXSub[1] = param1 - param3;
            var _loc_5:* = 1;
            var _loc_6:* = param4.coeffs[0];
            _loc_7 = 1;
            while (_loc_7 < 4)
            {
                
                _loc_5 = _loc_5 * mXSub[(_loc_7 - 1) / 2];
                _loc_6 = _loc_6 + _loc_5 * param4.coeffs[_loc_7];
                _loc_7++;
            }
            return _loc_6;
        }// end function

    }
}
