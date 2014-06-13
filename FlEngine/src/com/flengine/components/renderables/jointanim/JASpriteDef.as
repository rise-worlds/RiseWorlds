package com.flengine.components.renderables.jointanim
{
    import __AS3__.vec.*;

    public class JASpriteDef extends Object
    {
        public var name:String;
        public var animRate:Number;
        public var workAreaStart:int;
        public var workAreaDuration:int;
        public var frames:Vector.<JAFrame>;
        public var objectDefVector:Vector.<JAObjectDef>;
        public var label:Object;

        public function JASpriteDef()
        {
            frames = new Vector.<JAFrame>;
            objectDefVector = new Vector.<JAObjectDef>;
            label = {};
            return;
        }// end function

        public function GetLabelFrame(param1:String) : int
        {
            var _loc_2:* = param1.toUpperCase();
            if (label[_loc_2] != null)
            {
                return label[_loc_2];
            }
            return -1;
        }// end function

    }
}
