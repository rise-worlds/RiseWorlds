package com.flengine.context
{
   import flash.display3D.Context3D;
   import flash.display3D.textures.Texture;
   import flash.display.BitmapData;
   import flash.utils.ByteArray;
   
   public class FContextTexture extends Object
   {
      
      public function FContextTexture(param1:Context3D, param2:int, param3:int, param4:String, param5:Boolean) {
         super();
         __cContext = param1;
         if(__cContext.driverInfo == "Disposed")
         {
            return;
         }
         iWidth = param2;
         iHeight = param3;
         tTexture = param1.createTexture(iWidth,iHeight,param4,param5);
      }
      
      private var __cContext:Context3D;
      
      fl2d var iWidth:int;
      
      fl2d var iHeight:int;
      
      fl2d var tTexture:Texture;
      
      fl2d function getTexture() : Texture {
         return tTexture;
      }
      
      fl2d function dispose() : void {
         if(tTexture != null)
         {
            tTexture.dispose();
         }
      }
      
      fl2d function uploadFromBitmapData(param1:BitmapData) : void {
         if(tTexture == null || __cContext.driverInfo == "Disposed")
         {
            return;
         }
         tTexture.uploadFromBitmapData(param1,0);
      }
      
      fl2d function uploadFromCompressedByteArray(param1:ByteArray, param2:uint, param3:Boolean) : void {
         if(tTexture == null || __cContext.driverInfo == "Disposed")
         {
            return;
         }
         tTexture.uploadCompressedTextureFromByteArray(param1,param2,param3);
      }
      
      fl2d function uploadFromByteArray(param1:ByteArray, param2:uint) : void {
         if(tTexture == null || __cContext.driverInfo == "Disposed")
         {
            return;
         }
         tTexture.uploadFromByteArray(param1,param2,0);
      }
   }
}
