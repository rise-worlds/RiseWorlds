package com.flengine.components
{

    public class FPrototypePropertyType extends Object
    {
        public static const UNKNOWN:String = "unknown";
        public static const NUMBER:String = "number";
        public static const INT:String = "int";
        public static const BOOLEAN:String = "boolean";
        public static const OBJECT:String = "object";
        public static const STRING:String = "string";

        public function FPrototypePropertyType()
        {
            return;
        }// end function

        public static function getPrototypeType(param1) : String
        {
            var _loc_2:* = typeof(param1);
            var _loc_3:* = _loc_2;
            while (_loc_3 === "number")
            {
                
                return "number";
                
                return "boolean";
                
                return "string";
                
                return "object";
            }
            if ("boolean" === _loc_3) goto 16;
            if ("string" === _loc_3) goto 20;
            if ("object" === _loc_3) goto 24;
            return "unknown";
        }// end function

    }
}
