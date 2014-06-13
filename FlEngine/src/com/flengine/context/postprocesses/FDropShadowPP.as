package com.flengine.context.postprocesses
{

    public class FDropShadowPP extends FGlowPP
    {

        public function FDropShadowPP(param1:int = 2, param2:int = 2, param3:int = 0, param4:Number = 0, param5:int = 1)
        {
            _iOffsetX = param3;
            _iOffsetY = param4;
            super(param1, param2, param5);
            return;
        }

        public function get offsetX() : int
        {
            return _iOffsetX;
        }

        public function set offsetX(param1:int) : void
        {
            _iOffsetX = param1;
            return;
        }

        public function get offsetY() : int
        {
            return _iOffsetY;
        }

        public function set offsetY(param1:int) : void
        {
            _iOffsetY = param1;
            return;
        }

    }
}
