package com.flengine.rand
{
	
	public class MersenneTwister extends Object implements PseudoRandomNumberGenerator
	{
		
		public function MersenneTwister()
		{
			mt = new Vector.<Number>();
			super();
		}
		
		private static const MTRAND_N:Number = 624;
		private static const MTRAND_M:Number = 397;
		private static const MATRIX_A:Number = 2567483615;
		private static const UPPER_MASK:Number = 2147483648;
		private static const LOWER_MASK:Number = 2147483647;
		private static const TEMPERING_MASK_B:Number = 2636928640;
		private static const TEMPERING_MASK_C:Number = 4022730752;
		private var mt:Vector.<Number>;
		private var y:Number = 0;
		private var z:Number = 0;
		private var mSeed:Number = 0;
		
		public function SetSeed(param1:Number):void
		{
			if (param1 == 0)
			{
				param1 = 4357;
			}
			mSeed = param1;
			mt[0] = param1 & 4.294967295E9;
			z = 1;
			while (z < 624)
			{
				mt[z] = 1812433253 + (mt[z - 1] ^ mt[z - 1] >> 30 & 3) + z;
				_loc2_ = z;
				_loc3_ = mt[_loc2_] & 4.294967295E9;
				mt[_loc2_] = _loc3_;
				z = z + 1;
			}
		}
		
		public function Next():Number
		{
			var _loc4_:* = 0;
			var _loc2_:* = 0;
			var _loc1_:* = 0;
			var _loc3_:Array = [0, 2.567483615E9];
			if (z >= 624)
			{
				_loc4_ = 0;
				_loc2_ = 227;
				_loc4_ = 0;
				while (_loc4_ < _loc2_)
				{
					y = mt[_loc4_] & 2.147483648E9 | mt[_loc4_ + 1] & 2147483647;
					mt[_loc4_] = mt[_loc4_ + 397] ^ y >> 1 & 2147483647 ^ _loc3_[y & 1];
					_loc4_++;
				}
				_loc1_ = 623;
				while (_loc4_ < _loc1_)
				{
					y = mt[_loc4_] & 2.147483648E9 | mt[_loc4_ + 1] & 2147483647;
					mt[_loc4_] = mt[_loc4_ + (397 - 624)] ^ y >> 1 & 2147483647 ^ _loc3_[y & 1];
					_loc4_++;
				}
				y = mt[624 - 1] & 2.147483648E9 | mt[0] & 2147483647;
				mt[624 - 1] = mt[397 - 1] ^ y >> 1 & 2147483647 ^ _loc3_[y & 1];
				z = 0;
			}
			z = z + 1;
			y = mt[z];
			y = y ^ y >> 11 & 2097151;
			y = y ^ y << 7 & 2.63692864E9;
			y = y ^ y << 15 & 4.022730752E9;
			y = y ^ y >> 18 & 16383;
			y = y & 2147483647;
			return y / 2147483647;
		}
		
		public function Reset():void
		{
			SetSeed(mSeed);
		}
	}
}
