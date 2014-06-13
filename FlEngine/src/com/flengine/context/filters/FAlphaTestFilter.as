package com.flengine.context.filters
{
    import __AS3__.vec.*;

    public class FAlphaTestFilter extends FFilter
    {
        protected var _nTreshold:Number = 0.5;

        public function FAlphaTestFilter(param1:Number)
        {
            iId = 1;
            fragmentCode = "sub ft1.w, ft0.w, fc1.x   \nkil ft1.w                 \n";
            new Vector.<Number>(4)[0] = 0.5;
            new Vector.<Number>(4)[1] = 0;
            new Vector.<Number>(4)[2] = 0;
            new Vector.<Number>(4)[3] = 1;
            _aFragmentConstants = new Vector.<Number>(4);
            treshold = param1;
            return;
        }// end function

        public function get treshold() : Number
        {
            return _nTreshold;
        }// end function

        public function set treshold(param1:Number) : void
        {
            _nTreshold = param1;
            _aFragmentConstants[0] = _nTreshold;
            return;
        }// end function

    }
}
