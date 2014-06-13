package com.flengine.context.filters
{
    import __AS3__.vec.*;

    public class FPosterizeFilter extends FFilter
    {
        protected var _iRed:int = 0;
        protected var _iGreen:int = 0;
        protected var _iBlue:int = 0;

        public function FPosterizeFilter(param1:int, param2:int, param3:int)
        {
            iId = 11;
            fragmentCode = "mul ft0.xyz, ft0.xyz, fc1.xyz \nfrc ft1.xyz, ft0.xyz \t\t   \nsub ft0.xyz, ft0.xyz, ft1.xyz \ndiv ft0.xyz, ft0.xyz, fc1.xyz \n";
            new Vector.<Number>(4)[0] = 0;
            new Vector.<Number>(4)[1] = 0;
            new Vector.<Number>(4)[2] = 0;
            new Vector.<Number>(4)[3] = 0;
            _aFragmentConstants = new Vector.<Number>(4);
            red = param1;
            green = param2;
            blue = param3;
            return;
        }// end function

        public function get red() : int
        {
            return _iRed;
        }// end function

        public function set red(param1:int) : void
        {
            _iRed = param1;
            _aFragmentConstants[0] = _iRed;
            return;
        }// end function

        public function get green() : int
        {
            return _iGreen;
        }// end function

        public function set green(param1:int) : void
        {
            _iGreen = param1;
            _aFragmentConstants[1] = _iGreen;
            return;
        }// end function

        public function get blue() : int
        {
            return _iBlue;
        }// end function

        public function set blue(param1:int) : void
        {
            _iBlue = param1;
            _aFragmentConstants[2] = _iBlue;
            return;
        }// end function

    }
}
