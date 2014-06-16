package com.flengine.components
{
   public class FPrototypePropertyType extends Object
   {
      
      public function FPrototypePropertyType() {
         super();
      }
      
      public static const UNKNOWN:String = "unknown";
      
      public static const NUMBER:String = "number";
      
      public static const INT:String = "int";
      
      public static const BOOLEAN:String = "boolean";
      
      public static const OBJECT:String = "object";
      
      public static const STRING:String = "string";
      
      public static function getPrototypeType(param1:*) : String {
         var _loc2_:String = typeof param1;
         var _loc3_:* = _loc2_;
         if("number" !== _loc3_)
         {
            if("boolean" !== _loc3_)
            {
               if("string" !== _loc3_)
               {
                  if("object" !== _loc3_)
                  {
                     return "unknown";
                  }
                  return "object";
               }
               return "string";
            }
            return "boolean";
         }
         return "number";
      }
   }
}
