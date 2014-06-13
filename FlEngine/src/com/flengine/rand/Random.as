package com.flengine.rand
{

    public class Random extends Object
    {
        private var mPRNG:PseudoRandomNumberGenerator;

        public function Random(param1:PseudoRandomNumberGenerator)
        {
            mPRNG = param1;
            return;
        }

        public function SetSeed(param1:Number) : void
        {
            mPRNG.SetSeed(param1);
            return;
        }

        public function Next() : Number
        {
            return mPRNG.Next();
        }

        public function Float(param1:Number, param2:Number = NaN) : Number
        {
            if (this.isNaN(param2))
            {
                param2 = param1;
                param1 = 0;
            }
            return Next() * (param2 - param1) + param1;
        }

        public function Bool(param1:Number = 0.5) : Boolean
        {
            return Next() < param1;
        }

        public function Sign(param1:Number = 0.5) : int
        {
            return Next() < param1 ? (1) : (-1);
        }

        public function Bit(param1:Number = 0.5, param2:uint = 0) : int
        {
            return Next() < param1 ? (1 << param2) : (0);
        }

        public function Int(param1:Number, param2:Number = NaN) : int
        {
            if (this.isNaN(param2))
            {
                param2 = param1;
                param1 = 0;
            }
            return Float(param1, param2);
        }

        public function Reset() : void
        {
            mPRNG.Reset();
            return;
        }

    }
}
