package com.flengine.rand
{
    import __AS3__.vec.*;

    public class MTRand extends Object
    {
        protected var mt:Vector.<uint>;
        protected var mti:int;
        private static const MTRAND_N:int = 624;
        private static const mag01:Array = [0, 2567483615];
        private static const UPPER_MASK:uint = 2147483648;
        private static const LOWER_MASK:uint = 2147483647;
        private static const MTRAND_M:uint = 397;
        private static const TEMPERING_MASK_B:uint = 2636928640;
        private static const TEMPERING_MASK_C:uint = 4022730752;

        public function MTRand()
        {
            mt = new Vector.<uint>;
            mt.fixed = false;
            mt.length = 624;
            mt.fixed = true;
            SRand(4357);
            return;
        }

        public function SRand(param1:uint) : void
        {
            if (param1 == 0)
            {
                param1 = 4357;
            }
            mt[0] = param1 & 4294967295;
            mti = 1;
            while (mti < 624)
            {
                
                mt[mti] = 1812433253 * (mt[(mti - 1)] ^ mt[(mti - 1)] >> 30 & 3) + mti;
                var _loc_2:* = mti;
                var _loc_3:* = mt[_loc_2] & 4294967295;
                mt[_loc_2] = _loc_3;
                (mti + 1);
            }
            return;
        }

        public function Next() : uint
        {
            var _loc_2:* = 0;
            var _loc_1:* = 0;
            if (mti >= 624)
            {
                _loc_1 = 0;
                while (_loc_1 < 624 - 397)
                {
                    
                    _loc_2 = mt[_loc_1] & 2147483648 | mt[(_loc_1 + 1)] & 2147483647;
                    mt[_loc_1] = mt[_loc_1 + 397] ^ _loc_2 >> 1 & 2147483647 ^ mag01[_loc_2 & 1];
                    _loc_1++;
                }
                while (_loc_1 < (624 - 1))
                {
                    
                    _loc_2 = mt[_loc_1] & 2147483648 | mt[(_loc_1 + 1)] & 2147483647;
                    mt[_loc_1] = mt[_loc_1 + (397 - 624)] ^ _loc_2 >> 1 & 2147483647 ^ mag01[_loc_2 & 1];
                    _loc_1++;
                }
                _loc_2 = mt[(624 - 1)] & 2147483648 | mt[0] & 2147483647;
                mt[(624 - 1)] = mt[(397 - 1)] ^ _loc_2 >> 1 & 2147483647 ^ mag01[_loc_2 & 1];
                mti = 0;
            }
            (mti + 1);
            _loc_2 = mt[mti];
            _loc_2 = _loc_2 ^ _loc_2 >> 11 & 2097151;
            _loc_2 = _loc_2 ^ _loc_2 << 7 & 2636928640;
            _loc_2 = _loc_2 ^ _loc_2 << 15 & 4022730752;
            _loc_2 = _loc_2 ^ _loc_2 >> 18 & 16383;
            _loc_2 = _loc_2 & 2147483647;
            return _loc_2;
        }

        public function NextRange(param1:uint) : uint
        {
            return Next() % param1;
        }

        public function NextFloat(param1:Number) : Number
        {
            return Next() / 2147483647 * param1;
        }

        public function Dispose() : void
        {
            mt.splice(0, mt.length);
            mt = null;
            return;
        }

    }
}
