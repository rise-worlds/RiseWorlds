package com.flengine.utils
{
   public class FBasicPacker extends FPacker
   {
      
      public function FBasicPacker(param1:int = 1, param2:int = 1, param3:int = 2048, param4:int = 2048) {
         super(param1,param2,param3,param4);
      }
      
      private var __iXOffset:int = 0;
      
      private var __iYOffset:int = 0;
      
      private var __iRowOffset:int = 0;
      
      override public function packRectangles(param1:Vector.<FPackerRectangle>, param2:int = 0, param3:int = 2) : Boolean {
         var _loc10_:* = false;
         var _loc11_:* = 0;
         var _loc5_:* = false;
         var _loc8_:* = undefined;
         var _loc7_:* = 0;
         var _loc9_:* = null;
         if(param3 == 1 || param3 == 2)
         {
            param1.sort(param3 == 1?sortOnHeightAscending:sortOnHeightDescending);
         }
         var _loc4_:int = param1.length;
         var _loc6_:Vector.<FPackerRectangle> = _bAutoExpand?new Vector.<FPackerRectangle>():null;
         _loc11_ = 0;
         while(_loc11_ < _loc4_)
         {
            _loc9_ = param1[_loc11_];
            _loc5_ = addRectangle(_loc9_.width,_loc9_.height,param2);
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
            if(_iSortOnExpand == 1 || _iSortOnExpand == 2)
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
      
      private function addRectangles(param1:Vector.<FPackerRectangle>, param2:int = 0, param3:Boolean = true) : Boolean {
         var _loc7_:* = 0;
         var _loc5_:* = null;
         var _loc4_:int = param1.length;
         var _loc6_:* = true;
         _loc7_ = 0;
         while(_loc7_ < _loc4_)
         {
            _loc5_ = param1[_loc7_];
            _loc6_ = addRectangle(_loc5_.width,_loc5_.height,param2);
            if(!_loc6_ && !param3)
            {
               return false;
            }
            _loc7_++;
         }
         return _loc6_;
      }
      
      private function addRectangle(param1:int, param2:int, param3:int = 0) : Boolean {
         var _loc4_:int = param3 * 2;
         var _loc6_:int = __iXOffset;
         var _loc7_:int = __iYOffset;
         var _loc5_:int = __iRowOffset;
         if(__iXOffset + param1 + _loc4_ > _iWidth)
         {
            __iXOffset = 0;
            __iYOffset = __iYOffset + __iRowOffset;
            __iRowOffset = 0;
         }
         if(param2 + _loc4_ > __iRowOffset)
         {
            __iRowOffset = param2 + _loc4_;
         }
         if(__iYOffset + param2 + _loc4_ > _iHeight)
         {
            __iXOffset = _loc6_;
            __iYOffset = _loc7_;
            __iRowOffset = _loc5_;
            return false;
         }
         _aRectangles.push(FPackerRectangle.get(__iXOffset + param3,__iYOffset + param3,param1,param2));
         __iXOffset = __iXOffset + (param1 + _loc4_);
         return true;
      }
      
      override public function clear() : void {
         super.clear();
         __iXOffset = 0;
         __iYOffset = 0;
         __iRowOffset = 0;
      }
   }
}
