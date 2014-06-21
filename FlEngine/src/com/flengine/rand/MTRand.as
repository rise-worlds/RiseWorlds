package com.flengine.rand
{
	
	public class MTRand extends Object
	{
		
		public function MTRand()
		{
			super();
			mt = new Vector.<uint>();
			mt.fixed = false;
			mt.length = 624;
			mt.fixed = true;
			SRand(4357);
		}
		
		private static const MTRAND_N:int = 624;
		private static const mag01:Array = [0, 2567483615];
		private static const UPPER_MASK:uint = 2147483648;
		private static const LOWER_MASK:uint = 2147483647;
		private static const MTRAND_M:uint = 397;
		private static const TEMPERING_MASK_B:uint = 2636928640;
		private static const TEMPERING_MASK_C:uint = 4022730752;
		protected var mt:Vector.<uint>;
		protected var mti:int;
		
		public function SRand(param1:uint):void
		{
			if (param1 == 0)
			{
				param1 = 4357;
			}
			mt[0] = param1 & 4.294967295E9;
			mti = 1;
			while (mti < 624)
			{
				mt[mti] = (1812433253 * (mt[mti - 1] ^ (mt[mti - 1] >> 30 & 3))) + mti;
				_loc2_ = mti;
				_loc3_ = mt[_loc2_] & 4.294967295E9;
				mt[_loc2_] = _loc3_;
				mti = mti + 1;
			}
		}
		
		public function Next():uint
		{
			var _loc2_:* = 0;
			var _loc1_:* = 0;
			if (mti >= 624)
			{
				_loc1_ = 0;
				while (_loc1_ < 624 - 397)
				{
					_loc2_ = mt[_loc1_] & 2147483648 | mt[_loc1_ + 1] & 2147483647;
					mt[_loc1_] = mt[_loc1_ + 397] ^ _loc2_ >> 1 & 2147483647 ^ mag01[_loc2_ & 1];
					_loc1_++;
				}
				while (_loc1_ < 624 - 1)
				{
					_loc2_ = mt[_loc1_] & 2147483648 | mt[_loc1_ + 1] & 2147483647;
					mt[_loc1_] = mt[_loc1_ + (397 - 624)] ^ _loc2_ >> 1 & 2147483647 ^ mag01[_loc2_ & 1];
					_loc1_++;
				}
				_loc2_ = mt[624 - 1] & 2147483648 | mt[0] & 2147483647;
				mt[624 - 1] = mt[397 - 1] ^ _loc2_ >> 1 & 2147483647 ^ mag01[_loc2_ & 1];
				mti = 0;
			}
			mti = mti + 1;
			_loc2_ = mt[mti];
			_loc2_ = _loc2_ ^ _loc2_ >> 11 & 2097151;
			_loc2_ = _loc2_ ^ _loc2_ << 7 & 2636928640;
			_loc2_ = _loc2_ ^ _loc2_ << 15 & 4022730752;
			_loc2_ = _loc2_ ^ _loc2_ >> 18 & 16383;
			_loc2_ = _loc2_ & 2147483647;
			return _loc2_;
		}
		
		public function NextRange(param1:uint):uint
		{
			return Next() % param1;
		}
		
		public function NextFloat(param1:Number):Number
		{
			return (Next()) / 2147483647 * param1;
		}
		
		public function Dispose():void
		{
			mt.splice(0, mt.length);
			mt = null;
		}
	}
}
