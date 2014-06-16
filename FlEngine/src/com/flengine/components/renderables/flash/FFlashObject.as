package com.flengine.components.renderables.flash
{
   import com.flengine.components.renderables.FTexturedQuad;
   import com.flengine.textures.FTextureResampleType;
   import com.flengine.error.FError;
   import flash.display.DisplayObject;
   import flash.geom.Matrix;
   import com.flengine.context.FContext;
   import com.flengine.components.FCamera;
   import flash.geom.Rectangle;
   import flash.display.BitmapData;
   import com.flengine.textures.factories.FTextureFactory;
   import com.flengine.core.FNode;
   
   public class FFlashObject extends FTexturedQuad
   {
      
      public function FFlashObject(param1:FNode) {
         _iResampleScale = defaultSampleScale;
         _iResampleType = __iDefaultResampleType;
         updateFrameRate = defaultUpdateFrameRate;
         super(param1);
         iBlendMode = 0;
         __iCount = __iCount + 1;
         __sTextureId = "G2DFlashObject#" + (__iCount);
         __mNativeMatrix = new Matrix();
      }
      
      public static var defaultSampleScale:int = 1;
      
      public static var defaultUpdateFrameRate:int = 20;
      
      private static var __iDefaultResampleType:int = 2;
      
      public static function get defaultResampleType() : int {
         return __iDefaultResampleType;
      }
      
      public static function set defaultResampleType(param1:int) : void {
         if(!FTextureResampleType.isValid(param1))
         {
            throw new FError("FError: Invalid resample type.");
         }
         else
         {
            __iDefaultResampleType = param1;
            return;
         }
      }
      
      private static var __iCount:int = 0;
      
      protected var _iAlign:int = 1;
      
      public function get align() : int {
         return _iAlign;
      }
      
      public function set align(param1:int) : void {
         _iAlign = param1;
         invalidateTexture(true);
      }
      
      protected var _doNative:DisplayObject;
      
      public function get native() : DisplayObject {
         return _doNative;
      }
      
      public function set native(param1:DisplayObject) : void {
         _doNative = param1;
      }
      
      private var __mNativeMatrix:Matrix;
      
      private var __sTextureId:String;
      
      protected var _bInvalidate:Boolean = false;
      
      public function invalidate(param1:Boolean = false) : void {
         if(param1)
         {
            invalidateTexture(true);
         }
         else
         {
            _bInvalidate = true;
         }
      }
      
      protected var _iResampleScale:int;
      
      public function get resampleScale() : int {
         return _iResampleScale;
      }
      
      public function set resampleScale(param1:int) : void {
         if(param1 <= 0)
         {
            return;
         }
         _iResampleScale = param1;
         if(_doNative != null)
         {
            invalidateTexture(true);
         }
      }
      
      protected var _iFilteringType:int = 0;
      
      public function get filteringType() : int {
         return _iFilteringType;
      }
      
      public function set filteringType(param1:int) : void {
         _iFilteringType = param1;
         if(cTexture)
         {
            cTexture.filteringType = _iFilteringType;
         }
      }
      
      protected var _iResampleType:int;
      
      public function get resampleType() : int {
         return _iResampleType;
      }
      
      public function set resampleType(param1:int) : void {
         if(!FTextureResampleType.isValid(param1))
         {
            throw new FError("FError: Invalid resample type.");
         }
         else
         {
            _iResampleType = param1;
            if(_doNative != null)
            {
               invalidateTexture(true);
            }
            return;
         }
      }
      
      private var __nLastNativeWidth:Number = 0;
      
      private var __nLastNativeHeight:Number = 0;
      
      private var __nAccumulatedTime:Number = 0;
      
      public var updateFrameRate:int;
      
      protected var _bTransparent:Boolean = false;
      
      public function set transparent(param1:Boolean) : void {
         _bTransparent = param1;
         if(_doNative != null)
         {
            invalidateTexture(true);
         }
      }
      
      public function get transparent() : Boolean {
         return _bTransparent;
      }
      
      override public function update(param1:Number, param2:Boolean, param3:Boolean) : void {
         if(_doNative == null)
         {
            return;
         }
         invalidateTexture(false);
         __nAccumulatedTime = __nAccumulatedTime + param1;
         var _loc4_:Number = 1000 / updateFrameRate;
         if(_bInvalidate || __nAccumulatedTime > _loc4_)
         {
            cTexture.bitmapData.fillRect(cTexture.bitmapData.rect,0);
            cTexture.bitmapData.draw(_doNative,__mNativeMatrix);
            cTexture.invalidate();
            __nAccumulatedTime = __nAccumulatedTime % _loc4_;
         }
         _bInvalidate = false;
      }
      
      override public function render(param1:FContext, param2:FCamera, param3:Rectangle) : void {
         cNode.cTransform.nWorldScaleX = cNode.cTransform.nWorldScaleX * _iResampleScale;
         cNode.cTransform.nWorldScaleY = cNode.cTransform.nWorldScaleY * _iResampleScale;
         super.render(param1,param2,param3);
         cNode.cTransform.nWorldScaleX = cNode.cTransform.nWorldScaleX / _iResampleScale;
         cNode.cTransform.nWorldScaleY = cNode.cTransform.nWorldScaleY / _iResampleScale;
      }
      
      protected function invalidateTexture(param1:Boolean) : void {
         if(_doNative == null)
         {
            return;
         }
         if(!param1 && __nLastNativeWidth == _doNative.width && __nLastNativeHeight == _doNative.height)
         {
            return;
         }
         __nLastNativeWidth = _doNative.width;
         __nLastNativeHeight = _doNative.height;
         __mNativeMatrix.identity();
         __mNativeMatrix.scale(_doNative.scaleX / _iResampleScale,_doNative.scaleY / _iResampleScale);
         var _loc2_:BitmapData = new BitmapData(__nLastNativeWidth / _iResampleScale,__nLastNativeHeight / _iResampleScale,_bTransparent,0);
         if(cTexture == null)
         {
            cTexture = FTextureFactory.createFromBitmapData(__sTextureId,_loc2_);
            cTexture.resampleType = _iResampleType;
            cTexture.filteringType = _iFilteringType;
         }
         else
         {
            cTexture.bitmapData = _loc2_;
         }
         cTexture.alignTexture(_iAlign);
         _bInvalidate = true;
      }
      
      override public function dispose() : void {
         cTexture.dispose();
         super.dispose();
      }
   }
}
