package com.flengine.rand
{
    import __AS3__.vec.*;
    import com.flengine.rand.*;

    public class MersenneTwister extends Object implements PseudoRandomNumberGenerator
    {
        private var mt:Vector.<Number>;
        private var y:Number = 0;
        private var z:Number = 0;
        private var mSeed:Number = 0;
        private static const MTRAND_N:Number = 624;
        private static const MTRAND_M:Number = 397;
        private static const MATRIX_A:Number = 2567483615;
        private static const UPPER_MASK:Number = 2147483648;
        private static const LOWER_MASK:Number = 2147483647;
        private static const TEMPERING_MASK_B:Number = 2636928640;
        private static const TEMPERING_MASK_C:Number = 4022730752;

        public function MersenneTwister() : void
        {
            mt = new Vector.<Number>;
            return;
        }// end function

        public function SetSeed(param1:Number) : void
        {
            if (param1 == 0)
            {
                param1 = 4357;
            }
            mSeed = param1;
            mt[0] = param1 & 4294967295;
            z = 1;
            while (z < 624)
            {
                
                mt[z] = 1812433253 + (mt[(z - 1)] ^ mt[(z - 1)] >> 30 & 3) + z;
                var _loc_2:* = z;
                var _loc_3:* = mt[_loc_2] & 4294967295;
                mt[_loc_2] = _loc_3;
                (z + 1);
            }
            return;
        }// end function

        public function Next() : Number
        {
            var _loc_4:* = 0;
            var _loc_2:* = 0;
            var _loc_1:* = 0;
            var _loc_3:* = [0, 2567483615];
            if (z >= 624)
            {
                _loc_4 = 0;
                _loc_2 = 227;
                _loc_4 = 0;
                while (_loc_4 < _loc_2)
                {
                    
                    y = mt[_loc_4] & 2147483648 | mt[(_loc_4 + 1)] & 2147483647;
                    mt[_loc_4] = mt[_loc_4 + 397] ^ y >> 1 & 2147483647 ^ _loc_3[y & 1];
                    _loc_4++;
                }
                _loc_1 = 623;
                while (_loc_4 < _loc_1)
                {
                    
                    y = mt[_loc_4] & 2147483648 | mt[(_loc_4 + 1)] & 2147483647;
                    mt[_loc_4] = mt[_loc_4 + (397 - 624)] ^ y >> 1 & 2147483647 ^ _loc_3[y & 1];
                    _loc_4++;
                }
                y = mt[(624 - 1)] & 2147483648 | mt[0] & 2147483647;
                mt[(624 - 1)] = mt[(397 - 1)] ^ y >> 1 & 2147483647 ^ _loc_3[y & 1];
                z = 0;
            }
            (z + 1);
            y = mt[z];
            y = y ^ y >> 11 & 2097151;
            y = y ^ y << 7 & 2636928640;
            y = y ^ y << 15 & 4022730752;
            y = y ^ y >> 18 & 16383;
            y = y & 2147483647;
            return y / 2147483647;
        }// end function

        public function Reset() : void
        {
            SetSeed(mSeed);
            return;
        }// end function

    }
}
