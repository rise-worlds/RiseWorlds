package com.flengine.components.renderables.jointanim
{
   public class JAAnimDef extends Object
   {
      
      public function JAAnimDef() {
         super();
         mainSpriteDef = null;
         spriteDefVector = new Vector.<JASpriteDef>();
         objectNamePool = [];
      }
      
      public var mainSpriteDef:JASpriteDef;
      
      public var spriteDefVector:Vector.<JASpriteDef>;
      
      public var objectNamePool:Array;
   }
}
