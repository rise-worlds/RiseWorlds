package com.flengine.components.renderables
{
   import flash.geom.Point;
   import com.flengine.components.FTransform;
   import com.flengine.context.FContext;
   import com.flengine.components.FCamera;
   import flash.geom.Rectangle;
   import com.flengine.textures.FTexture;
   import com.flengine.core.FNode;
   
   public class FTileMapAdvanced extends FRenderable
   {
      
      public function FTileMapAdvanced(param1:FNode) {
         super(param1);
         _tempPoint = new Point();
         __aNewTileIndices = new Vector.<int>();
      }
      
      private var __iWidth:int;
      
      private var __iHeight:int;
      
      private var __iCols:int;
      
      private var __iRows:int;
      
      private var __aTiles:Vector.<int>;
      
      private var __aNewTileIndices:Vector.<int>;
      
      private var __aTileset:Vector.<FTile>;
      
      private var __iTileWidth:int;
      
      private var __iTileHeight:int;
      
      private var __iTileWidthHalf:Number;
      
      private var __iTileHeightHalf:Number;
      
      public var pivotX:Number = 0;
      
      public var pivotY:Number = 0;
      
      public var tilesDrawn:int = 0;
      
      public var debugMargin:int = 0;
      
      private var _tempCol:int = 0;
      
      private var _tempRow:int = 0;
      
      private var _tempPoint:Point;
      
      override public function dispose() : void {
         var _loc1_:* = null;
         if(!__aTiles)
         {
            return;
         }
         __aTiles.length = 0;
         __aTiles = null;
         while(__aTileset.length > 0)
         {
            _loc1_ = __aTileset.pop();
            if("destroy" in _loc1_)
            {
               Object(_loc1_).destroy();
            }
            if("dispose" in _loc1_)
            {
               Object(_loc1_).dispose();
            }
         }
         __aTileset.length = 0;
         __aTileset = null;
         __aNewTileIndices.length = 0;
         __aNewTileIndices = null;
         super.dispose();
      }
      
      public function setTileSet(param1:Vector.<FTile>) : void {
         __aTileset = param1;
      }
      
      public function setTiles(param1:Vector.<int>, param2:int, param3:int, param4:int, param5:int) : void {
         if(param1 == null || !(param2 * param3 == param1.length))
         {
            throw new Error("Cols x Rows don\'t match the length of Tiles supplied! - " + [param2,param3,param1.length].join(" : "));
         }
         else
         {
            __aTiles = param1;
            __iCols = param2;
            __iRows = param3;
            setTileSize(param4,param5);
            return;
         }
      }
      
      public function setTileSize(param1:int, param2:int) : void {
         __iTileWidth = param1;
         __iTileHeight = param2;
         __iWidth = __iCols * __iTileWidth;
         __iHeight = __iRows * __iTileHeight;
         __iTileWidthHalf = __iTileWidth * 0.5;
         __iTileHeightHalf = __iTileHeight * 0.5;
      }
      
      public function pivotCentered() : void {
         pivotX = -__iWidth * 0.5;
         pivotY = -__iHeight * 0.5;
      }
      
      public function setTileAtIndex(param1:int, param2:int) : void {
         if(param1 < 0 || param1 >= __aTiles.length)
         {
            return;
         }
         __aTiles[param1] = param2;
      }
      
      public function getTileAtColRow(param1:int, param2:int) : FTile {
         if(param1 < 0 || param1 >= __iCols || param2 < 0 || param2 >= __iRows)
         {
            return null;
         }
         return inline_getTileAtColRow(param1,param2);
      }
      
      public function getTileAtXAndY(param1:Number, param2:Number) : FTile {
         var _loc3_:int = param1 / (__iTileWidth * node.transform.nWorldScaleX);
         var _loc4_:int = param2 / (__iTileHeight * node.transform.nWorldScaleY);
         return inline_getTileAtColRow(_loc3_,_loc4_);
      }
      
      public function getTileAtIndex(param1:int) : FTile {
         if(param1 < 0 || param1 >= __aTiles.length)
         {
            return null;
         }
         inline_applyNewTileIndices();
         var _loc2_:int = __aTiles[param1];
         if(_loc2_ < 0 || _loc2_ >= __aTileset.length)
         {
            return null;
         }
         return __aTileset[_loc2_];
      }
      
      public function setTileAtPosition(param1:Number, param2:Number, param3:int) : int {
         var _loc5_:FTransform = node.transform;
         inline_getColRowAtPosition(param1,param2,_loc5_.nWorldX,_loc5_.nWorldY,_loc5_.nWorldScaleX,_loc5_.nWorldScaleY,_loc5_.nWorldRotation);
         var _loc4_:int = inline_setTileIndexAtColRow(_tempCol,_tempRow,param3);
         return _loc4_;
      }
      
      public function getColRowAtPosition(param1:Number, param2:Number) : Point {
         var _loc3_:FTransform = node.transform;
         inline_getColRowAtPosition(param1,param2,_loc3_.nWorldX,_loc3_.nWorldY,_loc3_.nWorldScaleX,_loc3_.nWorldScaleY,_loc3_.nWorldRotation);
         _tempPoint.setTo(_tempCol,_tempRow);
         return _tempPoint;
      }
      
      private final function inline_getColRowAtPosition(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : void {
         var _loc10_:Number = param1 - param3;
         var _loc9_:Number = param2 - param4;
         var _loc8_:Number = Math.atan2(_loc9_,_loc10_) - param7;
         var _loc11_:Number = Math.sqrt(_loc10_ * _loc10_ + _loc9_ * _loc9_);
         _loc10_ = Math.cos(_loc8_) * _loc11_;
         _loc9_ = Math.sin(_loc8_) * _loc11_;
         _tempCol = (_loc10_ - pivotX * param5) / param5 / __iTileWidth;
         _tempRow = (_loc9_ - pivotY * param6) / param6 / __iTileHeight;
      }
      
      private final function inline_getTileAtColRow(param1:int, param2:int) : FTile {
         var _loc3_:int = __aTiles[param1 + param2 * __iCols];
         if(_loc3_ < 0 || _loc3_ >= __aTileset.length)
         {
            return null;
         }
         return __aTileset[_loc3_];
      }
      
      private final function inline_setTileIndexAtColRow(param1:int, param2:int, param3:int) : int {
         if(param1 < 0 || param1 >= __iCols || param2 < 0 || param2 >= __iRows)
         {
            return -1;
         }
         var _loc5_:int = param1 + param2 * __iCols;
         var _loc4_:int = __aTiles[_loc5_];
         __aNewTileIndices[__aNewTileIndices.length] = _loc5_;
         __aNewTileIndices[__aNewTileIndices.length] = param3;
         return _loc4_;
      }
      
      private final function inline_applyNewTileIndices() : void {
         var _loc2_:* = 0;
         var _loc1_:* = 0;
         while(__aNewTileIndices.length > 0)
         {
            _loc2_ = __aNewTileIndices[__aNewTileIndices.length - 1];
            _loc1_ = __aNewTileIndices[__aNewTileIndices.length - 2];
            __aTiles[_loc1_] = _loc2_;
            __aNewTileIndices.length = __aNewTileIndices.length - 2;
         }
      }
      
      override public function render(param1:FContext, param2:FCamera, param3:Rectangle) : void {
         var _loc17_:* = NaN;
         var _loc6_:* = NaN;
         var _loc4_:* = NaN;
         var _loc11_:* = NaN;
         var _loc30_:* = NaN;
         var _loc29_:* = NaN;
         var _loc14_:* = 0;
         var _loc9_:* = 0;
         var _loc26_:* = 0;
         var _loc5_:* = 0;
         var _loc27_:* = null;
         var _loc8_:* = null;
         if(!__aTiles || __aTiles.length == 0)
         {
            return;
         }
         tilesDrawn = 0;
         inline_applyNewTileIndices();
         var _loc20_:* = 57.29577951308232;
         var _loc12_:FTransform = node.transform;
         var _loc16_:Number = __iTileWidth * _loc12_.nWorldScaleX;
         var _loc10_:Number = __iTileHeight * _loc12_.nWorldScaleY;
         var _loc22_:Number = param2.rViewRectangle.width;
         var _loc7_:Number = param2.rViewRectangle.height;
         var _loc21_:Number = _loc12_.nWorldScaleX;
         var _loc18_:Number = _loc12_.nWorldScaleY;
         var _loc28_:Number = _loc12_.nWorldRotation;
         var _loc15_:Number = _loc12_.nWorldRed;
         var _loc24_:Number = _loc12_.nWorldGreen;
         var _loc13_:Number = _loc12_.nWorldBlue;
         var _loc25_:Number = _loc12_.nWorldAlpha;
         var _loc19_:Number = _loc12_.nWorldX;
         var _loc23_:Number = _loc12_.nWorldY;
         _loc26_ = 0;
         _loc5_ = __iRows;
         while(_loc26_ < _loc5_)
         {
            _loc29_ = (_loc26_ * __iTileHeight + pivotY + __iTileHeightHalf) * _loc18_;
            _loc14_ = 0;
            _loc9_ = __iCols;
            while(_loc14_ < _loc9_)
            {
               _loc27_ = inline_getTileAtColRow(_loc14_,_loc26_);
               if(_loc27_)
               {
                  _loc8_ = FTexture.getTextureById(_loc27_.textureId);
                  _loc30_ = (_loc14_ * __iTileWidth + pivotX + __iTileWidthHalf) * _loc21_;
                  _loc17_ = Math.sqrt(_loc30_ * _loc30_ + _loc29_ * _loc29_);
                  _loc6_ = Math.atan2(_loc29_,_loc30_) + _loc28_;
                  _loc4_ = _loc19_ + Math.cos(_loc6_) * _loc17_;
                  _loc11_ = _loc23_ + Math.sin(_loc6_) * _loc17_;
                  if(!(_loc4_ + _loc16_ < debugMargin || _loc4_ - _loc16_ + debugMargin > _loc22_ || _loc11_ + _loc10_ < debugMargin || _loc11_ - _loc10_ + debugMargin > _loc7_))
                  {
                     tilesDrawn = tilesDrawn + 1;
                     param1.draw(_loc8_,_loc4_,_loc11_,_loc21_,_loc18_,_loc28_,_loc15_,_loc24_,_loc13_,_loc25_,1,param3);
                  }
               }
               _loc14_++;
            }
            _loc26_++;
         }
      }
      
      public function get mapCols() : int {
         return __iCols;
      }
      
      public function get mapRows() : int {
         return __iRows;
      }
      
      public function get mapWidth() : int {
         return __iWidth;
      }
      
      public function get mapHeight() : int {
         return __iHeight;
      }
      
      public function get tileWidth() : int {
         return __iTileWidth;
      }
      
      public function get tileHeight() : int {
         return __iTileHeight;
      }
   }
}
