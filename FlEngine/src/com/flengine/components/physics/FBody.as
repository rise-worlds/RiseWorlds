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
        }// end function

        public function get x() : Number
        {
            return 0;
        }// end function

        public function set x(param1:Number) : void
        {
            return;
        }// end function

        public function get y() : Number
        {
            return 0;
        }// end function

        public function set y(param1:Number) : void
        {
            return;
        }// end function

        public function get scaleX() : Number
        {
            return 1;
        }// end function

        public function set scaleX(param1:Number) : void
        {
            return;
        }// end function

        public function get scaleY() : Number
        {
            return 1;
        }// end function

        public function set scaleY(param1:Number) : void
        {
            return;
        }// end function

        public function get rotation() : Number
        {
            return 0;
        }// end function

        public function set rotation(param1:Number) : void
        {
            return;
        }// end function

        public function isDynamic() : Boolean
        {
            return false;
        }// end function

        public function isKinematic() : Boolean
        {
            return false;
        }// end function

        function addToSpace() : void
        {
            return;
        }// end function

        function removeFromSpace() : void
        {
            return;
        }// end function

        function invalidateKinematic(param1:FTransform) : void
        {
            return;
        }// end function

    }
}
