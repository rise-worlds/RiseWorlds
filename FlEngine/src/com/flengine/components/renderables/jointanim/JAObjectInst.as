package com.flengine.components.renderables.jointanim
{
   public class JAObjectInst extends Object
   {
      
      public function JAObjectInst() {
         super();
         name = null;
         spriteInst = null;
         predrawCallback = true;
         predrawCallback = true;
         imagePredrawCallback = true;
         isBlending = false;
         transform = new JATransform2D();
         colorMult = new JAColor();
         blendSrcColor = new JAColor();
         blendSrcTransform = new JATransform();
      }
      
      public var name:String;
      
      public var spriteInst:JASpriteInst;
      
      public var blendSrcTransform:JATransform;
      
      public var blendSrcColor:JAColor;
      
      public var isBlending:Boolean;
      
      public var transform:JATransform2D;
      
      public var colorMult:JAColor;
      
      public var predrawCallback:Boolean;
      
      public var imagePredrawCallback:Boolean;
      
      public var postdrawCallback:Boolean;
      
      public function Dispose() : void {
      }
   }
}
