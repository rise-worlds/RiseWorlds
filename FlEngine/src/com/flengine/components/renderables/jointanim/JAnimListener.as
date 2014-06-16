package com.flengine.components.renderables.jointanim
{
   import com.flengine.context.FContext;
   import com.flengine.components.renderables.JAMemoryImage;
   import flash.geom.Matrix;
   
   public interface JAnimListener
   {
      
      function JAnimPLaySample(param1:String, param2:int, param3:Number, param4:Number) : void;
      
      function JAnimObjectPredraw(param1:int, param2:JAnim, param3:FContext, param4:JASpriteInst, param5:JAObjectInst, param6:JATransform, param7:JAColor) : Boolean;
      
      function JAnimObjectPostdraw(param1:int, param2:JAnim, param3:FContext, param4:JASpriteInst, param5:JAObjectInst, param6:JATransform, param7:JAColor) : Boolean;
      
      function JAnimImagePredraw(param1:JASpriteInst, param2:JAObjectInst, param3:JATransform, param4:JAMemoryImage, param5:FContext, param6:int) : int;
      
      function JAnimStopped(param1:int, param2:JAnim) : void;
      
      function JAnimCommand(param1:int, param2:JAnim, param3:JASpriteInst, param4:String, param5:String) : Boolean;
      
      function JAnimImageNotExistDraw(param1:String, param2:FContext, param3:Matrix, param4:Number, param5:Number, param6:Number, param7:Number, param8:int) : void;
   }
}
