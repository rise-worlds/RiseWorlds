package com.flengine.components.renderables.jointanim
{
   public class JASpriteInst extends Object
   {
      
      public function JASpriteInst() {
         super();
         children = new Vector.<JAObjectInst>();
         curTransform = new JATransform();
         spriteDef = null;
      }
      
      public var parent:JASpriteInst;
      
      public var delayFrames:int;
      
      public var frameNum:Number;
      
      public var lastFrameNum:Number;
      
      public var frameRepeats:int;
      
      public var onNewFrame:Boolean;
      
      public var lastUpdated:int;
      
      public var curTransform:JATransform;
      
      public var curColor:JAColor;
      
      public var children:Vector.<JAObjectInst>;
      
      public var spriteDef:JASpriteDef;
      
      public function Dispose() : void {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < children.length)
         {
            children[_loc1_].Dispose();
            _loc1_++;
         }
         children.splice(0,children.length);
         children = null;
         curTransform = null;
         spriteDef = null;
         curColor = null;
      }
      
      public function Reset() : void {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < children.length)
         {
            children[_loc1_].Dispose();
            _loc1_++;
         }
         children.splice(0,children.length);
      }
   }
}
