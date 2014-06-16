package com.flengine.utils
{
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   
   public class FPacker extends Object
   {
      
      public function FPacker(param1:int = 1, param2:int = 1, param3:int = 2048, param4:int = 2048, param5:Boolean = false) {
         super();
         if(param1 <= 0 || param2 <= 0)
         {
            throw new Error("Invalid packer size");
         }
         else
         {
            _iWidth = param1;
            _iHeight = param2;
            _iMaxWidth = param3;
            _iMaxHeight = param4;
            _bAutoExpand = param5;
            clear();
            return;
         }
      }
      
      public static const SORT_NONE:int = 0;
      
      public static const SORT_ASCENDING:int = 1;
      
      public static const SORT_DESCENDING:int = 2;
      
      public static var nonValidTextureSizePrecision:int = 5;
      
      protected var _iMaxWidth:int;
      
      protected var _iMaxHeight:int;
      
      protected var _bAutoExpand:Boolean = false;
      
      protected var _iSortOnExpand:int = 2;
      
      protected var _bForceValidTextureSizeOnExpand:Boolean = true;
      
      protected var _iWidth:int;
      
      protected var _iHeight:int;
      
      protected var _aRectangles:Vector.<FPackerRectangle>;
      
      public function get width() : int {
         return _iWidth;
      }
      
      public function get height() : int {
         return _iHeight;
      }
      
      public function get rectangles() : Vector.<FPackerRectangle> {
         return _aRectangles.concat();
      }
      
      public function packRectangles(param1:Vector.<FPackerRectangle>, param2:int = 0, param3:int = 2) : Boolean {
         return false;
      }
      
      public function packRectangle(param1:FPackerRectangle, param2:int = 0, param3:Boolean = true) : Boolean {
         return false;
      }
      
      protected function getRectanglesArea(param1:Vector.<FPackerRectangle>) : int {
         var _loc2_:* = 0;
         var _loc3_:int = param1.length - 1;
         while(_loc3_ >= 0)
         {
            _loc2_ = _loc2_ + param1[_loc3_].width * param1[_loc3_].height;
            _loc3_--;
         }
         return _loc2_;
      }
      
      protected function sortOnAreaAscending(param1:FPackerRectangle, param2:FPackerRectangle) : Number {
         var _loc4_:int = param1.width * param1.height;
         var _loc3_:int = param2.width * param2.height;
         if(_loc4_ < _loc3_)
         {
            return -1;
         }
         if(_loc4_ > _loc3_)
         {
            return 1;
         }
         return 0;
      }
      
      protected function sortOnAreaDescending(param1:FPackerRectangle, param2:FPackerRectangle) : Number {
         var _loc4_:int = param1.width * param1.height;
         var _loc3_:int = param2.width * param2.height;
         if(_loc4_ > _loc3_)
         {
            return -1;
         }
         if(_loc4_ < _loc3_)
         {
            return 1;
         }
         return 0;
      }
      
      protected function sortOnHeightAscending(param1:FPackerRectangle, param2:FPackerRectangle) : Number {
         if(param1.height < param2.height)
         {
            return -1;
         }
         if(param1.height > param2.height)
         {
            return 1;
         }
         return 0;
      }
      
      protected function sortOnHeightDescending(param1:FPackerRectangle, param2:FPackerRectangle) : Number {
         if(param1.height > param2.height)
         {
            return -1;
         }
         if(param1.height < param2.height)
         {
            return 1;
         }
         return 0;
      }
      
      public function clear() : void {
         _aRectangles = new Vector.<FPackerRectangle>();
      }
      
      public function draw(param1:BitmapData) : void {
         var _loc4_:* = 0;
         var _loc3_:* = null;
         var _loc2_:Matrix = new Matrix();
         _loc4_ = 0;
         while(_loc4_ < _aRectangles.length)
         {
            _loc3_ = _aRectangles[_loc4_];
            _loc2_.tx = _aRectangles[_loc4_].x;
            _loc2_.ty = _aRectangles[_loc4_].y;
            param1.draw(_loc3_.bitmapData,_loc2_);
            _loc4_++;
         }
      }
   }
}
