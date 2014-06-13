package com.flengine.physics
{

    public class FPhysics extends Object
    {
        protected var _bRunning:Boolean = true;
        public var minimumTimeStep:int = 0;

        public function FPhysics()
        {
            return;
        }// end function

        function step(param1:Number) : void
        {
            return;
        }// end function

        public function setGravity(param1:Number, param2:Number) : void
        {
            return;
        }// end function

        public function stop() : void
        {
            _bRunning = false;
            return;
        }// end function

        public function start() : void
        {
            _bRunning = true;
            return;
        }// end function

        public function pause() : void
        {
            _bRunning = !_bRunning;
            return;
        }// end function

        public function dispose() : void
        {
            return;
        }// end function

    }
}
