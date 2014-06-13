package com.flengine.physics
{

    public class FPhysics extends Object
    {
        protected var _bRunning:Boolean = true;
        public var minimumTimeStep:int = 0;

        public function FPhysics()
        {
            return;
        }

        public function step(param1:Number) : void
        {
            return;
        }

        public function setGravity(param1:Number, param2:Number) : void
        {
            return;
        }

        public function stop() : void
        {
            _bRunning = false;
            return;
        }

        public function start() : void
        {
            _bRunning = true;
            return;
        }

        public function pause() : void
        {
            _bRunning = !_bRunning;
            return;
        }

        public function dispose() : void
        {
            return;
        }

    }
}
