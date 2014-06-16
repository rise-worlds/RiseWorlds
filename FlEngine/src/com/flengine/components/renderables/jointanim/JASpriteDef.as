package com.flengine.components.renderables.jointanim
{
   public class JASpriteDef extends Object
   {
      
      public function JASpriteDef() {
         super();
         frames = new Vector.<JAFrame>();
         objectDefVector = new Vector.<JAObjectDef>();
         label = {};
      }
      
      public var name:String;
      
      public var animRate:Number;
      
      public var workAreaStart:int;
      
      public var workAreaDuration:int;
      
      public var frames:Vector.<JAFrame>;
      
      public var objectDefVector:Vector.<JAObjectDef>;
      
      public var label:Object;
      
      public function GetLabelFrame(param1:String) : int {
         var _loc2_:String = param1.toUpperCase();
         if(label[_loc2_] != null)
         {
            return label[_loc2_];
         }
         return -1;
      }
   }
}
