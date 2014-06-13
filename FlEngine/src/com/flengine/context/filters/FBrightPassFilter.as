package com.flengine.context.filters
{
    import __AS3__.vec.*;

    public class FBrightPassFilter extends FFilter
    {
        protected var _nTreshold:Number = 0.5;

        public function FBrightPassFilter(param1:Number)
        {
            iId = 4;
            fragmentCode = "sub ft0.xyz, ft0.xyz, fc1.xxx    \nmul ft0.xyz, ft0.xyz, fc1.yyy    \nsat ft0, ft0           \t\t\t \n";
            new Vector.<Number>(4)[0] = 0.5;
            new Vector.<Number>(4)[1] = 2;
            new Vector.<Number>(4)[2] = 0;
            new Vector.<Number>(4)[3] = 0;
            _aFragmentConstants = new Vector.<Number>(4);
            treshold = param1;
            return;
        }

        public function get treshold() : Number
        {
            return _nTreshold;
        }

        public function set treshold(param1:Number) : void
        {
            _nTreshold = param1;
            _aFragmentConstants[0] = _nTreshold;
            _aFragmentConstants[1] = 1 / (1 - _nTreshold);
            return;
        }

    }
}
