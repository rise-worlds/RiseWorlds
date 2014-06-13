package com.flengine.utils
{
    import flash.display.*;
    import flash.geom.*;

    public class FPackerRectangle extends Object
    {
        var cNext:FPackerRectangle;
        var cPrevious:FPackerRectangle;
        private var __cNextInstance:FPackerRectangle;
        public var x:int = 0;
        public var y:int = 0;
        public var width:int = 0;
        public var height:int = 0;
        public var right:int = 0;
        public var bottom:int = 0;
        public var id:String;
        public var bitmapData:BitmapData;
        public var pivotX:Number;
        public var pivotY:Number;
        public var padding:int = 0;
        private static var availableInstance:FPackerRectangle;

        public function FPackerRectangle()
        {
            return;
        }

        public function set(param1:int, param2:int, param3:int, param4:int) : void
        {
            x = param1;
            y = param2;
            width = param3;
            height = param4;
            right = param1 + param3;
            bottom = param2 + param4;
            return;
        }

        public function dispose() : void
        {
            cNext = null;
            cPrevious = null;
            __cNextInstance = availableInstance;
            availableInstance = this;
            bitmapData = null;
            return;
        }

        public function setPadding(param1:int) : void
        {
            x = x - (param1 - padding);
            y = y - (param1 - padding);
            width = width + (param1 - padding) * 2;
            height = height + (param1 - padding) * 2;
            right = right + (param1 - padding);
            bottom = bottom + (param1 - padding);
            padding = param1;
            return;
        }

        public function get rect() : Rectangle
        {
            return new Rectangle(x, y, width, height);
        }

        public function toString() : String
        {
            return "[" + id + "] x: " + x + " y: " + y + " w: " + width + " h: " + height + " bd: " + bitmapData.rect + " p: " + padding;
        }

        public static function get(param1:int, param2:int, param3:int, param4:int, param5:String = null, param6:BitmapData = null, param7:Number = 0, param8:Number = 0) : FPackerRectangle
        {
            var _loc_9:* = availableInstance;
            if (availableInstance)
            {
                availableInstance = _loc_9.__cNextInstance;
                _loc_9.__cNextInstance = null;
            }
            else
            {
                _loc_9 = new FPackerRectangle;
            }
            _loc_9.x = param1;
            _loc_9.y = param2;
            _loc_9.width = param3;
            _loc_9.height = param4;
            _loc_9.right = param1 + param3;
            _loc_9.bottom = param2 + param4;
            _loc_9.id = param5;
            _loc_9.bitmapData = param6;
            _loc_9.pivotX = param7;
            _loc_9.pivotY = param8;
            return _loc_9;
        }

    }
}
