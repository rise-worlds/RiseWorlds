package com.flengine.textures.factories
{
   import com.flengine.textures.FTexture;
   import flash.display.Bitmap;
   import com.flengine.textures.FTextureUtils;
   import flash.display.BitmapData;
   import com.flengine.error.FError;
   import flash.utils.ByteArray;
   import flash.geom.Rectangle;
   
   public class FTextureFactory extends Object
   {
      
      public function FTextureFactory() {
         super();
      }
      
      public static function createFromAsset(param1:String, param2:Class) : FTexture {
         var _loc3_:Bitmap = new param2();
         return new FTexture(param1,3,_loc3_.bitmapData,_loc3_.bitmapData.rect,FTextureUtils.isBitmapDataTransparent(_loc3_.bitmapData),_loc3_.bitmapData.rect.width,_loc3_.bitmapData.rect.height);
      }
      
      public static function createFromColor(param1:String, param2:uint, param3:int, param4:int) : FTexture {
         var _loc5_:BitmapData = new BitmapData(param3,param4,false,param2);
         return new FTexture(param1,3,_loc5_,_loc5_.rect,false,_loc5_.rect.width,_loc5_.rect.height);
      }
      
      public static function createFromBitmapData(param1:String, param2:BitmapData) : FTexture {
         if(param2 == null)
         {
            throw new FError("FError: BitmapData cannot be null.");
         }
         else
         {
            return new FTexture(param1,3,param2,param2.rect,FTextureUtils.isBitmapDataTransparent(param2),param2.rect.width,param2.rect.height);
         }
      }
      
      public static function createFromATF(param1:String, param2:ByteArray, param3:Function = null) : FTexture {
         var _loc8_:* = 0;
         var _loc6_:String = String.fromCharCode(param2[0],param2[1],param2[2]);
         if(_loc6_ != "ATF")
         {
            throw new FError("FError: Invalid ATF data.");
         }
         else
         {
            _loc7_ = true;
            _loc9_ = param2[6];
            if(1 !== _loc9_)
            {
               if(3 !== _loc9_)
               {
                  if(5 === _loc9_)
                  {
                     _loc8_ = 2;
                  }
               }
               else
               {
                  _loc8_ = 1;
                  _loc7_ = false;
               }
            }
            else
            {
               _loc8_ = 0;
            }
            _loc5_ = Math.pow(2,param2[7]);
            _loc4_ = Math.pow(2,param2[8]);
            return new FTexture(param1,_loc8_,param2,new Rectangle(0,0,_loc5_,_loc4_),_loc7_,_loc5_,_loc4_,0,0,param3);
         }
      }
      
      public static function createFromByteArray(param1:String, param2:ByteArray, param3:int, param4:int, param5:Boolean) : FTexture {
         return new FTexture(param1,2,param2,new Rectangle(0,0,param3,param4),param5,param3,param4);
      }
      
      public static function createRenderTexture(param1:String, param2:int, param3:int, param4:Boolean) : FTexture {
         return new FTexture(param1,4,null,new Rectangle(0,0,param2,param3),param4,param2,param3);
      }
   }
}
