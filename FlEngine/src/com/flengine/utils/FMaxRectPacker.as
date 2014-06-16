package com.flengine.utils
{
   public class FMaxRectPacker extends FPacker
   {
      
      public function FMaxRectPacker(param1:int = 1, param2:int = 1, param3:int = 2048, param4:int = 2048, param5:Boolean = false, param6:int = 0) {
         __cNewBoundingArea = FPackerRectangle.get(0,0,0,0);
         super(param1,param2,param3,param4,param5);
         __iHeuristics = param6;
      }
      
      public static const BOTTOM_LEFT:int = 0;
      
      public static const SHORT_SIDE_FIT:int = 1;
      
      public static const LONG_SIDE_FIT:int = 2;
      
      public static const AREA_FIT:int = 3;
      
      private var __iHeuristics:int = 0;
      
      private var __cFirstAvailableArea:FPackerRectangle;
      
      private var __cLastAvailableArea:FPackerRectangle;
      
      private var __cFirstNewArea:FPackerRectangle;
      
      private var __cLastNewArea:FPackerRectangle;
      
      private var __cNewBoundingArea:FPackerRectangle;
      
      private var __cNegativeArea:FPackerRectangle;
      
      override public function packRectangles(param1:Vector.<FPackerRectangle>, param2:int = 0, param3:int = 2) : Boolean {
         var _loc5_:* = false;
         var _loc8_:* = undefined;
         var _loc7_:* = 0;
         var _loc9_:FPackerRectangle = null;
         if(param3 != 0)
         {
            param1.sort(param3 == 1?sortOnHeightAscending:sortOnHeightDescending);
         }
         var _loc4_:int = param1.length;
         var _loc10_:* = true;
         var _loc6_:Vector.<FPackerRectangle> = _bAutoExpand?new Vector.<FPackerRectangle>():null;
         var _loc11_:* = 0;
         while(_loc11_ < _loc4_)
         {
            _loc9_ = param1[_loc11_];
            _loc5_ = addRectangle(_loc9_,param2);
            if(!_loc5_ && _bAutoExpand)
            {
               _loc6_.push(param1[_loc11_]);
            }
            _loc10_ = _loc10_ && _loc5_;
            _loc11_++;
         }
         if(!_loc10_ && _bAutoExpand)
         {
            _loc8_ = rectangles;
            _loc8_ = _loc8_.concat(_loc6_);
            if(_iSortOnExpand != 0)
            {
               _loc8_.sort(_iSortOnExpand == 1?sortOnHeightAscending:sortOnHeightDescending);
            }
            _loc7_ = getRectanglesArea(_loc8_);
            do
            {
               if((_iWidth <= _iHeight || _iHeight == _iMaxHeight) && _iWidth < _iMaxWidth)
               {
                  _iWidth = _bForceValidTextureSizeOnExpand?_iWidth * 2:_iWidth + 1;
               }
               else
               {
                  _iHeight = _bForceValidTextureSizeOnExpand?_iHeight * 2:_iHeight + 1;
               }
            }
            while(_iWidth * _iHeight < _loc7_ && (_iWidth < _iMaxWidth || _iHeight < _iMaxHeight));
            
            clear();
            _loc10_ = addRectangles(_loc8_,param2);
            while(!_loc10_ && (_iWidth < _iMaxWidth || _iHeight < _iMaxHeight))
            {
               if((_iWidth <= _iHeight || _iHeight == _iMaxHeight) && _iWidth < _iMaxWidth)
               {
                  _iWidth = _bForceValidTextureSizeOnExpand?_iWidth * 2:_iWidth + nonValidTextureSizePrecision;
               }
               else
               {
                  _iHeight = _bForceValidTextureSizeOnExpand?_iHeight * 2:_iHeight + nonValidTextureSizePrecision;
               }
               clear();
               _loc10_ = addRectangles(_loc8_,param2);
            }
            _loc10_ = _iWidth <= _iMaxWidth && _iHeight <= _iMaxHeight;
         }
         return _loc10_;
      }
      
      override public function packRectangle(param1:FPackerRectangle, param2:int = 0, param3:Boolean = true) : Boolean {
         var _loc4_:* = undefined;
         var _loc5_:Boolean = addRectangle(param1,param2);
         if(!_loc5_ && _bAutoExpand)
         {
            _loc4_ = rectangles;
            _loc4_.push(param1);
            clear();
            packRectangles(_loc4_,param2,_iSortOnExpand);
            _loc5_ = true;
         }
         return _loc5_;
      }
      
      private function addRectangles(param1:Vector.<FPackerRectangle>, param2:int = 0, param3:Boolean = true) : Boolean {
         var _loc5_:FPackerRectangle = null;
         var _loc4_:int = param1.length;
         var _loc6_:* = true;
         var _loc7_:* = 0;
         while(_loc7_ < _loc4_)
         {
            _loc5_ = param1[_loc7_];
            _loc6_ = _loc6_ && addRectangle(_loc5_,param2);
            if(!_loc6_ && !param3)
            {
               return false;
            }
            _loc7_++;
         }
         return _loc6_;
      }
      
      private function addRectangle(param1:FPackerRectangle, param2:int) : Boolean {
         var _loc3_:FPackerRectangle = getAvailableArea(param1.width + (param2 - param1.padding) * 2,param1.height + (param2 - param1.padding) * 2);
         if(_loc3_ == null)
         {
            return false;
         }
         param1.set(_loc3_.x,_loc3_.y,param1.width + (param2 - param1.padding) * 2,param1.height + (param2 - param1.padding) * 2);
         param1.padding = param2;
         splitAvailableAreas(param1);
         pushNewAreas();
         if(param2 != 0)
         {
            param1.setPadding(0);
         }
         _aRectangles.push(param1);
         return true;
      }
      
      private function createNewArea(param1:int, param2:int, param3:int, param4:int) : FPackerRectangle {
         var _loc6_:FPackerRectangle = null;
         var _loc7_:FPackerRectangle = null;
         var _loc5_:* = true;
         _loc6_ = __cFirstNewArea;
         while(_loc6_)
         {
            _loc7_ = _loc6_.cNext;
            if(!(_loc6_.x > param1 || _loc6_.y > param2 || _loc6_.right < param1 + param3 || _loc6_.bottom < param2 + param4))
            {
               _loc5_ = false;
               break;
            }
            if(!(_loc6_.x < param1 || _loc6_.y < param2 || _loc6_.right > param1 + param3 || _loc6_.bottom > param2 + param4))
            {
               if(_loc6_.cNext)
               {
                  _loc6_.cNext.cPrevious = _loc6_.cPrevious;
               }
               else
               {
                  __cLastNewArea = _loc6_.cPrevious;
               }
               if(_loc6_.cPrevious)
               {
                  _loc6_.cPrevious.cNext = _loc6_.cNext;
               }
               else
               {
                  __cFirstNewArea = _loc6_.cNext;
               }
               _loc6_.dispose();
            }
            _loc6_ = _loc7_;
         }
         if(!_loc5_)
         {
            return null;
         }
         _loc6_ = FPackerRectangle.get(param1,param2,param3,param4);
         if(__cNewBoundingArea.x < param1)
         {
            __cNewBoundingArea.x = param1;
         }
         if(__cNewBoundingArea.right > _loc6_.right)
         {
            __cNewBoundingArea.right = _loc6_.right;
         }
         if(__cNewBoundingArea.y < param2)
         {
            __cNewBoundingArea.y = param2;
         }
         if(__cNewBoundingArea.bottom < _loc6_.bottom)
         {
            __cNewBoundingArea.bottom = _loc6_.bottom;
         }
         if(__cLastNewArea)
         {
            _loc6_.cPrevious = __cLastNewArea;
            __cLastNewArea.cNext = _loc6_;
            __cLastNewArea = _loc6_;
         }
         else
         {
            __cLastNewArea = _loc6_;
            __cFirstNewArea = _loc6_;
         }
         return _loc6_;
      }
      
      private function splitAvailableAreas(param1:FPackerRectangle) : void {
         var _loc6_:FPackerRectangle = null;
         var _loc7_:FPackerRectangle = null;
         var _loc5_:int = param1.x;
         var _loc4_:int = param1.y;
         var _loc2_:int = param1.right;
         var _loc3_:int = param1.bottom;
         _loc6_ = __cFirstAvailableArea;
         while(_loc6_)
         {
            _loc7_ = _loc6_.cNext;
            if(!(_loc5_ >= _loc6_.right || _loc2_ <= _loc6_.x || _loc4_ >= _loc6_.bottom || _loc3_ <= _loc6_.y))
            {
               if(_loc5_ > _loc6_.x)
               {
                  createNewArea(_loc6_.x,_loc6_.y,_loc5_ - _loc6_.x,_loc6_.height);
               }
               if(_loc2_ < _loc6_.right)
               {
                  createNewArea(_loc2_,_loc6_.y,_loc6_.right - _loc2_,_loc6_.height);
               }
               if(_loc4_ > _loc6_.y)
               {
                  createNewArea(_loc6_.x,_loc6_.y,_loc6_.width,_loc4_ - _loc6_.y);
               }
               if(_loc3_ < _loc6_.bottom)
               {
                  createNewArea(_loc6_.x,_loc3_,_loc6_.width,_loc6_.bottom - _loc3_);
               }
               if(_loc6_.cNext)
               {
                  _loc6_.cNext.cPrevious = _loc6_.cPrevious;
               }
               else
               {
                  __cLastAvailableArea = _loc6_.cPrevious;
               }
               if(_loc6_.cPrevious)
               {
                  _loc6_.cPrevious.cNext = _loc6_.cNext;
               }
               else
               {
                  __cFirstAvailableArea = _loc6_.cNext;
               }
               _loc6_.dispose();
            }
            _loc6_ = _loc7_;
         }
      }
      
      private function pushNewAreas() : void {
         var _loc1_:FPackerRectangle = null;
         while(__cFirstNewArea)
         {
            _loc1_ = __cFirstNewArea;
            if(_loc1_.cNext)
            {
               __cFirstNewArea = _loc1_.cNext;
               __cFirstNewArea.cPrevious = null;
            }
            else
            {
               __cFirstNewArea = null;
            }
            _loc1_.cPrevious = null;
            _loc1_.cNext = null;
            if(__cLastAvailableArea)
            {
               _loc1_.cPrevious = __cLastAvailableArea;
               __cLastAvailableArea.cNext = _loc1_;
               __cLastAvailableArea = _loc1_;
            }
            else
            {
               __cLastAvailableArea = _loc1_;
               __cFirstAvailableArea = _loc1_;
            }
         }
         __cLastNewArea = null;
         __cNewBoundingArea.set(0,0,0,0);
      }
      
      private function getAvailableArea(param1:int, param2:int) : FPackerRectangle {
         var _loc3_:* = 0;
         var _loc11_:* = 0;
         var _loc7_:* = 0;
         var _loc9_:* = 0;
         var _loc6_:* = 0;
         var _loc8_:* = 0;
         var _loc5_:FPackerRectangle = null;
         var _loc10_:FPackerRectangle = __cNegativeArea;
         var _loc4_:* = -1;
      }
      
      override public function clear() : void {
         var _loc1_:* = null;
         super.clear();
         while(__cFirstAvailableArea)
         {
            _loc1_ = __cFirstAvailableArea;
            __cFirstAvailableArea = _loc1_.cNext;
            _loc1_.dispose();
         }
         __cLastAvailableArea = FPackerRectangle.get(0,0,_iWidth,_iHeight);
         __cFirstAvailableArea = FPackerRectangle.get(0,0,_iWidth,_iHeight);
         __cNegativeArea = FPackerRectangle.get(_iWidth + 1,_iHeight + 1,_iWidth + 1,_iHeight + 1);
      }
   }
}
