package com.flengine.components.renderables.jointanim
{

    public class JAVec2 extends Object
    {
        public var x:Number;
        public var y:Number;

        public function JAVec2(param1:Number = 0, param2:Number = 0)
        {
            x = param1;
            y = param2;
            return;
        }

        public function Magnitude() : Number
        {
            return Math.sqrt(x * x + y * y);
        }

        public function Normalize() : JAVec2
        {
            var _loc_1:* = Magnitude();
            if (_loc_1 != 0)
            {
                x = x / _loc_1;
                y = y / _loc_1;
            }
            return this;
        }

        public function Perp() : void
        {
            var _loc_1:* = this.x;
            this.x = -this.y;
            this.y = this.x;
            return;
        }

        public function Dot(param1:JAVec2) : Number
        {
            return x * param1.x + y * param1.y;
        }

    }
}
