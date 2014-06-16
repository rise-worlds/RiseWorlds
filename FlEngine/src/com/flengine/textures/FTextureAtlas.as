package com.flengine.textures
{
   import flash.utils.Dictionary;
   import flash.geom.Rectangle;
   import com.flengine.error.FError;
   
   public class FTextureAtlas extends FTextureBase
   {
      
      public function FTextureAtlas(param1:String, param2:int, param3:int, param4:int, param5:*, param6:Boolean, param7:Function) {
         super(param1,param2,param5,param6,param7);
         if(!FTextureUtils.isValidTextureSize(param3) || !FTextureUtils.isValidTextureSize(param4))
         {
            throw new FError("FError: Invalid atlas size, it needs to be power of 2.");
         }
         else
         {
            iWidth = param3;
            iHeight = param4;
            __dTextures = new Dictionary();
            return;
         }
      }
      
      public static function getTextureAtlasById(param1:String) : FTextureAtlas {
         return FTextureBase.getTextureBaseById(param1) as FTextureAtlas;
      }
      
      private var __dTextures:Dictionary;
      
      public function get textures() : Dictionary {
         return __dTextures;
      }
      
      override public function set filteringType(param1:int) : void {
         .super.filteringType = param1;
         var _loc4_:* = 0;
         var _loc3_:* = __dTextures;
         for each(_loc2_ in __dTextures)
         {
            _loc2_.iFilteringType = param1;
         }
      }
      
      public function getTexture(param1:String) : FTexture {
         return __dTextures[param1];
      }
      
      override protected function invalidateContextTexture(param1:Boolean) : void {
         super.invalidateContextTexture(param1);
         var _loc4_:* = 0;
         var _loc3_:* = __dTextures;
         for each(_loc2_ in __dTextures)
         {
            _loc2_.cContextTexture = cContextTexture;
            _loc2_.iAtfType = iAtfType;
         }
      }
      
      public function addSubTexture(param1:String, param2:Rectangle, param3:Number, param4:Number, param5:Number = 0, param6:Number = 0, param7:Boolean = false) : FTexture {
         var _loc8_:FTexture = new FTexture(_sId + "_" + param1,iSourceType,getSource(),param2,bTransparent,param3,param4,param5,param6,null,this);
         _loc8_.sSubId = param1;
         _loc8_.filteringType = filteringType;
         _loc8_.cContextTexture = cContextTexture;
         __dTextures[param1] = _loc8_;
         if(param7)
         {
            invalidate();
         }
         return _loc8_;
      }
      
      public function removeSubTexture(param1:String) : void {
         __dTextures[param1] = null;
      }
      
      private function disposeSubTextures() : void {
         var _loc2_:* = null;
         var _loc4_:* = 0;
         var _loc3_:* = __dTextures;
         for(_loc1_ in __dTextures)
         {
            _loc2_ = __dTextures[_loc1_];
            _loc2_.dispose();
            delete __dTextures[_loc1_];
         }
         __dTextures = new Dictionary();
      }
      
      override public function dispose() : void {
         disposeSubTextures();
         if(baByteArray)
         {
            baByteArray = null;
         }
         if(bdBitmapData)
         {
            bdBitmapData.dispose();
            bdBitmapData = null;
         }
         if(cContextTexture)
         {
            cContextTexture.dispose();
         }
         super.dispose();
      }
   }
}
