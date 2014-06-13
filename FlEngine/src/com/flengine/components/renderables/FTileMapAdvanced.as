package com.flengine.components.renderables
{
    import __AS3__.vec.*;
    import com.flengine.components.*;
    import com.flengine.context.*;
    import com.flengine.core.*;
    import com.flengine.textures.*;
    import flash.geom.*;

    public class FTileMapAdvanced extends FRenderable
    {
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

        public function FTileMapAdvanced(param1:FNode)
        {
            super(param1);
            _tempPoint = new Point();
            __aNewTileIndices = new Vector.<int>;
            return;
        }

        override public function dispose() : void
        {
            var _loc_1:* = null;
            if (!__aTiles)
            {
                return;
            }
            __aTiles.length = 0;
            __aTiles = null;
            while (__aTileset.length > 0)
            {
                
                _loc_1 = __aTileset.pop();
                if ("destroy" in _loc_1)
                {
                    this.Object(_loc_1).destroy();
                }
                if ("dispose" in _loc_1)
                {
                    this.Object(_loc_1).dispose();
                }
            }
            __aTileset.length = 0;
            __aTileset = null;
            __aNewTileIndices.length = 0;
            __aNewTileIndices = null;
            super.dispose();
            return;
        }

        public function setTileSet(param1:Vector.<FTile>) : void
        {
            __aTileset = param1;
            return;
        }

        public function setTiles(param1:Vector.<int>, param2:int, param3:int, param4:int, param5:int) : void
        {
            if (param1 == null || param2 * param3 != param1.length)
            {
                throw new Error("Cols x Rows don\'t match the length of Tiles supplied! - " + [param2, param3, param1.length].join(" : "));
            }
            __aTiles = param1;
            __iCols = param2;
            __iRows = param3;
            setTileSize(param4, param5);
            return;
        }

        public function setTileSize(param1:int, param2:int) : void
        {
            __iTileWidth = param1;
            __iTileHeight = param2;
            __iWidth = __iCols * __iTileWidth;
            __iHeight = __iRows * __iTileHeight;
            __iTileWidthHalf = __iTileWidth * 0.5;
            __iTileHeightHalf = __iTileHeight * 0.5;
            return;
        }

        public function pivotCentered() : void
        {
            pivotX = (-__iWidth) * 0.5;
            pivotY = (-__iHeight) * 0.5;
            return;
        }

        public function setTileAtIndex(param1:int, param2:int) : void
        {
            if (param1 < 0 || param1 >= __aTiles.length)
            {
                return;
            }
            __aTiles[param1] = param2;
            return;
        }

        public function getTileAtColRow(param1:int, param2:int) : FTile
        {
            if (param1 < 0 || param1 >= __iCols || param2 < 0 || param2 >= __iRows)
            {
                return null;
            }
            return inline_getTileAtColRow(param1, param2);
        }

        public function getTileAtXAndY(param1:Number, param2:Number) : FTile
        {
            var _loc_3:* = param1 / (__iTileWidth * node.transform.nWorldScaleX);
            var _loc_4:* = param2 / (__iTileHeight * node.transform.nWorldScaleY);
            return inline_getTileAtColRow(_loc_3, _loc_4);
        }

        public function getTileAtIndex(param1:int) : FTile
        {
            if (param1 < 0 || param1 >= __aTiles.length)
            {
                return null;
            }
            inline_applyNewTileIndices();
            var _loc_2:* = __aTiles[param1];
            if (_loc_2 < 0 || _loc_2 >= __aTileset.length)
            {
                return null;
            }
            return __aTileset[_loc_2];
        }

        public function setTileAtPosition(param1:Number, param2:Number, param3:int) : int
        {
            var _loc_5:* = node.transform;
            inline_getColRowAtPosition(param1, param2, _loc_5.nWorldX, _loc_5.nWorldY, _loc_5.nWorldScaleX, _loc_5.nWorldScaleY, _loc_5.nWorldRotation);
            var _loc_4:* = inline_setTileIndexAtColRow(_tempCol, _tempRow, param3);
            return inline_setTileIndexAtColRow(_tempCol, _tempRow, param3);
        }

        public function getColRowAtPosition(param1:Number, param2:Number) : Point
        {
            var _loc_3:* = node.transform;
            inline_getColRowAtPosition(param1, param2, _loc_3.nWorldX, _loc_3.nWorldY, _loc_3.nWorldScaleX, _loc_3.nWorldScaleY, _loc_3.nWorldRotation);
            _tempPoint.setTo(_tempCol, _tempRow);
            return _tempPoint;
        }

        final private function inline_getColRowAtPosition(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : void
        {
            var _loc_10:* = param1 - param3;
            var _loc_9:* = param2 - param4;
            var _loc_8:* = Math.atan2(_loc_9, _loc_10) - param7;
            var _loc_11:* = Math.sqrt(_loc_10 * _loc_10 + _loc_9 * _loc_9);
            _loc_10 = Math.cos(_loc_8) * _loc_11;
            _loc_9 = Math.sin(_loc_8) * _loc_11;
            _tempCol = (_loc_10 - pivotX * param5) / param5 / __iTileWidth;
            _tempRow = (_loc_9 - pivotY * param6) / param6 / __iTileHeight;
            return;
        }

        final private function inline_getTileAtColRow(param1:int, param2:int) : FTile
        {
            var _loc_3:* = __aTiles[param1 + param2 * __iCols];
            if (_loc_3 < 0 || _loc_3 >= __aTileset.length)
            {
                return null;
            }
            return __aTileset[_loc_3];
        }

        final private function inline_setTileIndexAtColRow(param1:int, param2:int, param3:int) : int
        {
            if (param1 < 0 || param1 >= __iCols || param2 < 0 || param2 >= __iRows)
            {
                return -1;
            }
            var _loc_5:* = param1 + param2 * __iCols;
            var _loc_4:* = __aTiles[_loc_5];
            __aNewTileIndices[__aNewTileIndices.length] = _loc_5;
            __aNewTileIndices[__aNewTileIndices.length] = param3;
            return _loc_4;
        }

        final private function inline_applyNewTileIndices() : void
        {
            var _loc_2:* = 0;
            var _loc_1:* = 0;
            while (__aNewTileIndices.length > 0)
            {
                
                _loc_2 = __aNewTileIndices[(__aNewTileIndices.length - 1)];
                _loc_1 = __aNewTileIndices[__aNewTileIndices.length - 2];
                __aTiles[_loc_1] = _loc_2;
                __aNewTileIndices.length = __aNewTileIndices.length - 2;
            }
            return;
        }

        override public function render(param1:FContext, param2:FCamera, param3:Rectangle) : void
        {
            var _loc_17:* = NaN;
            var _loc_6:* = NaN;
            var _loc_4:* = NaN;
            var _loc_11:* = NaN;
            var _loc_30:* = NaN;
            var _loc_29:* = NaN;
            var _loc_14:* = 0;
            var _loc_9:* = 0;
            var _loc_26:* = 0;
            var _loc_5:* = 0;
            var _loc_27:* = null;
            var _loc_8:* = null;
            if (!__aTiles || __aTiles.length == 0)
            {
                return;
            }
            tilesDrawn = 0;
            inline_applyNewTileIndices();
            var _loc_20:* = 57.2958;
            var _loc_12:* = node.transform;
            var _loc_16:* = __iTileWidth * _loc_12.nWorldScaleX;
            var _loc_10:* = __iTileHeight * _loc_12.nWorldScaleY;
            var _loc_22:* = param2.rViewRectangle.width;
            var _loc_7:* = param2.rViewRectangle.height;
            var _loc_21:* = _loc_12.nWorldScaleX;
            var _loc_18:* = _loc_12.nWorldScaleY;
            var _loc_28:* = _loc_12.nWorldRotation;
            var _loc_15:* = _loc_12.nWorldRed;
            var _loc_24:* = _loc_12.nWorldGreen;
            var _loc_13:* = _loc_12.nWorldBlue;
            var _loc_25:* = _loc_12.nWorldAlpha;
            var _loc_19:* = _loc_12.nWorldX;
            var _loc_23:* = _loc_12.nWorldY;
            _loc_26 = 0;
            _loc_5 = __iRows;
            while (_loc_26 < _loc_5)
            {
                
                _loc_29 = (_loc_26 * __iTileHeight + pivotY + __iTileHeightHalf) * _loc_18;
                _loc_14 = 0;
                _loc_9 = __iCols;
                while (_loc_14 < _loc_9)
                {
                    
                    _loc_27 = inline_getTileAtColRow(_loc_14, _loc_26);
                    if (_loc_27)
                    {
                        _loc_8 = FTexture.getTextureById(_loc_27.textureId);
                        _loc_30 = (_loc_14 * __iTileWidth + pivotX + __iTileWidthHalf) * _loc_21;
                        _loc_17 = Math.sqrt(_loc_30 * _loc_30 + _loc_29 * _loc_29);
                        _loc_6 = Math.atan2(_loc_29, _loc_30) + _loc_28;
                        _loc_4 = _loc_19 + Math.cos(_loc_6) * _loc_17;
                        _loc_11 = _loc_23 + Math.sin(_loc_6) * _loc_17;
                        if (!(_loc_4 + _loc_16 < debugMargin || _loc_4 - _loc_16 + debugMargin > _loc_22 || _loc_11 + _loc_10 < debugMargin || _loc_11 - _loc_10 + debugMargin > _loc_7))
                        {
                            (tilesDrawn + 1);
                            param1.draw(_loc_8, _loc_4, _loc_11, _loc_21, _loc_18, _loc_28, _loc_15, _loc_24, _loc_13, _loc_25, 1, param3);
                        }
                    }
                    _loc_14++;
                }
                _loc_26++;
            }
            return;
        }

        public function get mapCols() : int
        {
            return __iCols;
        }

        public function get mapRows() : int
        {
            return __iRows;
        }

        public function get mapWidth() : int
        {
            return __iWidth;
        }

        public function get mapHeight() : int
        {
            return __iHeight;
        }

        public function get tileWidth() : int
        {
            return __iTileWidth;
        }

        public function get tileHeight() : int
        {
            return __iTileHeight;
        }

    }
}
