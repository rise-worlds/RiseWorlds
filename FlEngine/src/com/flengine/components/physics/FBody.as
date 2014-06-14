package com.flengine.components.physics
{
    import com.flengine.components.*;
    import com.flengine.core.*;

    public class FBody extends FComponent
    {

        public function FBody(param1:FNode) : void
        {
            super(param1);
            return;
        }

        public function get x() : Number
        {
            return 0;
        }

        public function set x(param1:Number) : void
        {
            return;
        }

        public function get y() : Number
        {
            return 0;
        }

        public function set y(param1:Number) : void
        {
            return;
        }

        public function get scaleX() : Number
        {
            return 1;
        }

        public function set scaleX(param1:Number) : void
        {
            return;
        }

        public function get scaleY() : Number
        {
            return 1;
        }

        public function set scaleY(param1:Number) : void
        {
            return;
        }

        public function get rotation() : Number
        {
            return 0;
        }

        public function set rotation(param1:Number) : void
        {
            return;
        }

        public function isDynamic() : Boolean
        {
            return false;
        }

        public function isKinematic() : Boolean
        {
            return false;
        }

        public function addToSpace() : void
        {
            return;
        }

        public function removeFromSpace() : void
        {
            return;
        }

        public function invalidateKinematic(param1:FTransform) : void
        {
            return;
        }

    }
}
