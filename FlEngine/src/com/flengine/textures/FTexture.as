package com.flengine.textures
{
   import flash.display.DisplayObject;
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   
   public class FTexture extends FTextureBase
   {
      
      public function FTexture(param1:String, param2:int, param3:*, param4:Rectangle, param5:Boolean, param6:Number, param7:Number, param8:Number = 0, param9:Number = 0, param10:Function = null, param11:FTextureAtlas = null) {
         super(param1,param2,param3,param5,param10);
         rRegion = param4;
         iWidth = rRegion.width;
         iHeight = rRegion.height;
         nPivotX = param8;
         nPivotY = param9;
         nFrameWidth = param6;
         nFrameHeight = param7;
         cParent = param11;
         if(cParent != null)
         {
            nUvX = param4.x / cParent.iWidth;
            nUvY = param4.y / cParent.iHeight;
            nUvScaleX = param4.width / cParent.iWidth;
            nUvScaleY = param4.height / cParent.iHeight;
         }
         else
         {
            invalidate();
         }
      }
      
      public static function getTextureById(param1:String) : FTexture {
         return FTextureBase.getTextureBaseById(param1) as FTexture;
      }
      
      fl2d var doNativeObject:DisplayObject;
      
      public function get nativeObject() : DisplayObject {
         return doNativeObject;
      }
      
      public function set bitmapData(param1:BitmapData) : void {
         if(cParent)
         {
            return;
         }
         bdBitmapData = param1;
         rRegion = bdBitmapData.rect;
         iWidth = rRegion.width;
         iHeight = rRegion.height;
         invalidateContextTexture(false);
      }
      
      fl2d var nUvX:Number = 0;
      
      public function get uvX() : Number {
         return nUvX;
      }
      
      fl2d var nUvY:Number = 0;
      
      public function get uvY() : Number {
         return nUvY;
      }
      
      public function set uvY(param1:Number) : void {
         nUvY = param1;
      }
      
      fl2d var nUvScaleX:Number = 1;
      
      public function get uvScaleX() : Number {
         return nUvScaleX;
      }
      
      fl2d var nUvScaleY:Number = 1;
      
      public function get uvScaleY() : Number {
         return nUvScaleY;
      }
      
      fl2d var nFrameWidth:Number = 0;
      
      public function get frameWidth() : Number {
         return nFrameWidth;
      }
      
      public function set frameWidth(param1:Number) : void {
         nFrameWidth = param1;
      }
      
      fl2d var nFrameHeight:Number = 0;
      
      public function get frameHeight() : Number {
         return nFrameHeight;
      }
      
      public function set frameHeight(param1:Number) : void {
         nFrameHeight = param1;
      }
      
      fl2d var nPivotX:Number = 0;
      
      public function get pivotX() : Number {
         return nPivotX;
      }
      
      public function set pivotX(param1:Number) : void {
         nPivotX = param1;
      }
      
      fl2d var nPivotY:Number = 0;
      
      public function get pivotY() : Number {
         return nPivotY;
      }
      
      public function set pivotY(param1:Number) : void {
         nPivotY = param1;
      }
      
      override public function get gpuWidth() : int {
         if(cParent)
         {
            return cParent.gpuWidth;
         }
         return FTextureUtils.getNextValidTextureSize(iWidth);
      }
      
      override public function get gpuHeight() : int {
         if(cParent)
         {
            return cParent.gpuHeight;
         }
         return FTextureUtils.getNextValidTextureSize(iHeight);
      }
      
      override public function hasParent() : Boolean {
         return !(cParent == null);
      }
      
      public function alignTexture(param1:int) : void {
      }
      
      override public function get resampleType() : int {
         if(cParent != null)
         {
            return cParent.resampleType;
         }
         return _iResampleType;
      }
      
      override public function set resampleType(param1:int) : void {
         if(cParent != null)
         {
            return;
         }
         .super.resampleType = param1;
      }
      
      override public function get resampleScale() : int {
         if(cParent != null)
         {
            return cParent.resampleScale;
         }
         return _iResampleScale;
      }
      
      override public function set resampleScale(param1:int) : void {
         if(cParent != null)
         {
            return;
         }
         .super.resampleScale = param1;
      }
      
      override public function set filteringType(param1:int) : void {
         if(cParent != null)
         {
            return;
         }
         .super.filteringType = param1;
      }
      
      fl2d var cParent:FTextureAtlas;
      
      public function get parent() : FTextureAtlas {
         return cParent;
      }
      
      fl2d var sSubId:String = "";
      
      fl2d var rRegion:Rectangle;
      
      public function get region() : Rectangle {
         return rRegion;
      }
      
      public function set region(param1:Rectangle) : void {
         rRegion = param1;
         iWidth = rRegion.width;
         iHeight = rRegion.height;
         if(cParent)
         {
            nUvX = rRegion.x / cParent.iWidth;
            nUvY = rRegion.y / cParent.iHeight;
            nUvScaleX = iWidth / cParent.iWidth;
            nUvScaleY = iHeight / cParent.iHeight;
         }
         else
         {
            invalidateContextTexture(false);
         }
      }
      
      public function set width(param1:int) : void {
         iWidth = param1;
         rRegion.width = param1;
         nUvScaleX = iWidth / cParent.iWidth;
      }
      
      public function getAlphaAtUV(param1:Number, param2:Number) : uint {
         if(bdBitmapData == null)
         {
            return 255;
         }
         return bdBitmapData.getPixel32(rRegion.x + param1 * rRegion.width,rRegion.y + param2 * rRegion.height) >> 24 & 255;
      }
      
      protected function updateUVScale() : void {
         var _loc4_:* = 0;
         var _loc3_:* = 0;
         var _loc1_:* = NaN;
         var _loc2_:* = NaN;
      }
      
      override protected function invalidateContextTexture(param1:Boolean) : void {
         if(cParent != null)
         {
            return;
         }
         updateUVScale();
         super.invalidateContextTexture(param1);
      }
      
      fl2d function setParent(param1:FTextureAtlas, param2:Rectangle) : void {
         cParent = param1;
         region = param2;
      }
      
      override public function dispose() : void {
         if(cParent == null)
         {
            if(doNativeObject)
            {
               doNativeObject = null;
            }
            if(baByteArray)
            {
               baByteArray = null;
            }
            if(bdBitmapData)
            {
               bdBitmapData = null;
            }
            if(cContextTexture)
            {
               cContextTexture.dispose();
            }
         }
         cParent = null;
         super.dispose();
      }
      
      public function toString() : String {
         return "[FTexture id:" + _sId + ", width:" + width + ", height:" + height + "]";
      }
   }
}
