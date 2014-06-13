package com.flengine.components.renderables.jointanim
{

    public class JAColor extends Object
    {
        public var red:int;
        public var green:int;
        public var blue:int;
        public var alpha:int;
        public static const White:JAColor = new JAColor(255, 255, 255);

        public function JAColor(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 255)
        {
            red = param1;
            green = param2;
            blue = param3;
            alpha = param4;
            return;
        }// end function

        public function clone(param1:JAColor) : void
        {
            this.red = param1.red;
            this.green = param1.green;
            this.blue = param1.blue;
            this.alpha = param1.alpha;
            return;
        }// end function

        public function Set(param1:int, param2:int, param3:int, param4:int = 255) : void
        {
            red = param1;
            green = param2;
            blue = param3;
            alpha = param4;
            return;
        }// end function

        public function IsWhite() : Boolean
        {
            return red == 255 && green == 255 && blue == 255;
        }// end function

        public function toInt() : uint
        {
            return alpha << 24 & 4278190080 | red << 16 & 16711680 | green << 8 & 65280 | blue & 255;
        }// end function

        public static function FromInt(param1:int, param2:JAColor) : JAColor
        {
            param2.Set(param1 >> 16 & 255, param1 >> 8 & 255, param1 & 255, param1 >> 24 & 255);
            return param2;
        }// end function

    }
}
