package com.flengine.components.renderables
{
    import __AS3__.vec.*;
    import com.flengine.components.*;
    import com.flengine.context.*;
    import com.flengine.core.*;
    import com.flengine.textures.*;
    import flash.geom.*;

    public class FTileMap extends FRenderable
    {
        protected var _iWidth:int;
        protected var _iHeight:int;
        protected var _aTiles:Vector.<FTile>;
        protected var _iTileWidth:int = 0;
        protected var _iTileHeight:int = 0;
        protected var _bIso:Boolean = false;

        public function FTileMap(param1:FNode)
        {
            super(param1);
            return;
        }

        public function setTiles(param1:Vector.<FTile>, param2:int, param3:int, param4:int, param5:int, param6:Boolean = false) : void
        {
            if (param2 * param3 != param1.length)
            {
                throw new Error("Invalid tile map.");
            }
            _aTiles = param1;
            _iWidth = param2;
            _iHeight = param3;
            _bIso = param6;
            setTileSize(param4, param5);
            return;
        }

        public function setTile(param1:int, param2:int) : void
        {
            if (param1 < 0 || param1 >= _aTiles.length)
            {
                return;
            }
            _aTiles[param1] = param2;
            return;
        }

        public function setTileSize(param1:int, param2:int) : void
        {
            _iTileWidth = param1;
            _iTileHeight = param2;
            return;
        }

        override public function render(param1:FContext, param2:FCamera, param3:Rectangle) : void
        {
            var _loc_14:* = 0;
            var _loc_13:* = 0;
            var _loc_22:* = NaN;
            var _loc_21:* = NaN;
            var _loc_5:* = 0;
            var _loc_18:* = null;
            if (_aTiles == null)
            {
                return;
            }
            var _loc_6:* = _iTileWidth * _iWidth * 0.5;
            var _loc_11:* = _iTileHeight * _iHeight * (_bIso ? (0.25) : (0.5));
            var _loc_16:* = param2.cNode.cTransform.nWorldX - cNode.cTransform.nWorldX - param2.rViewRectangle.width * 0.5;
            var _loc_17:* = param2.cNode.cTransform.nWorldY - cNode.cTransform.nWorldY - param2.rViewRectangle.height * 0.5;
            var _loc_9:* = -_loc_6 + (_bIso ? (_iTileWidth / 2) : (0));
            var _loc_7:* = -_loc_11 + (_bIso ? (_iTileHeight / 2) : (0));
            var _loc_19:* = (_loc_16 - _loc_9) / _iTileWidth;
            if ((_loc_16 - _loc_9) / _iTileWidth < 0)
            {
                _loc_19 = 0;
            }
            var _loc_20:* = (_loc_17 - _loc_7) / (_bIso ? (_iTileHeight / 2) : (_iTileHeight));
            if ((_loc_17 - _loc_7) / (_bIso ? (_iTileHeight / 2) : (_iTileHeight)) < 0)
            {
                _loc_20 = 0;
            }
            var _loc_8:* = param2.cNode.cTransform.nWorldX - cNode.cTransform.nWorldX + param2.rViewRectangle.width * 0.5 - (_bIso ? (_iTileWidth / 2) : (_iTileWidth));
            var _loc_10:* = param2.cNode.cTransform.nWorldY - cNode.cTransform.nWorldY + param2.rViewRectangle.height * 0.5 - (_bIso ? (0) : (_iTileHeight));
            var _loc_15:* = (_loc_8 - _loc_9) / _iTileWidth - _loc_19 + 2;
            if ((_loc_8 - _loc_9) / _iTileWidth - _loc_19 + 2 > _iWidth - _loc_19)
            {
                _loc_15 = _iWidth - _loc_19;
            }
            var _loc_4:* = (_loc_10 - _loc_7) / (_bIso ? (_iTileHeight / 2) : (_iTileHeight)) - _loc_20 + 2;
            if ((_loc_10 - _loc_7) / (_bIso ? (_iTileHeight / 2) : (_iTileHeight)) - _loc_20 + 2 > _iHeight - _loc_20)
            {
                _loc_4 = _iHeight - _loc_20;
            }
            var _loc_12:* = _loc_15 * _loc_4;
            _loc_14 = 0;
            while (_loc_14 < _loc_12)
            {
                
                _loc_13 = _loc_14 / _loc_15;
                _loc_22 = cNode.cTransform.nWorldX + (_loc_19 + _loc_14 % _loc_15) * _iTileWidth - _loc_6 + (_bIso && (_loc_20 + _loc_13) % 2 == 1 ? (_iTileWidth) : (_iTileWidth / 2));
                _loc_21 = cNode.cTransform.nWorldY + (_loc_20 + _loc_13) * (_bIso ? (_iTileHeight / 2) : (_iTileHeight)) - _loc_11 + _iTileHeight / 2;
                _loc_5 = _loc_20 * _iWidth + _loc_19 + _loc_14 / _loc_15 * _iWidth + _loc_14 % _loc_15;
                _loc_18 = _aTiles[_loc_5];
                if (_loc_18 != null && _loc_18.textureId != null)
                {
                    param1.draw(FTexture.getTextureById(_loc_18.textureId), _loc_22, _loc_21, 1, 1, 0, 1, 1, 1, 1, 1, param3);
                }
                _loc_14++;
            }
            return;
        }

        public function getTileAt(param1:Number, param2:Number, param3:FCamera = null) : FTile
        {
            if (param3 == null)
            {
                param3 = node.core.defaultCamera;
            }
            param1 = param1 - (param3.rViewRectangle.x + param3.rViewRectangle.width / 2);
            param2 = param2 - (param3.rViewRectangle.y + param3.rViewRectangle.height / 2);
            var _loc_7:* = _iTileWidth * _iWidth * 0.5;
            var _loc_10:* = _iTileHeight * _iHeight * (_bIso ? (0.25) : (0.5));
            var _loc_8:* = -_loc_7 + (_bIso ? (_iTileWidth / 2) : (0));
            var _loc_6:* = -_loc_10 + (_bIso ? (_iTileHeight / 2) : (0));
            var _loc_5:* = param3.cNode.cTransform.nWorldX - cNode.cTransform.nWorldX + param1;
            var _loc_4:* = param3.cNode.cTransform.nWorldY - cNode.cTransform.nWorldY + param2;
            var _loc_9:* = Math.floor((_loc_5 - _loc_8) / _iTileWidth);
            var _loc_11:* = Math.floor((_loc_4 - _loc_6) / _iTileHeight);
            if (_loc_9 < 0 || _loc_9 >= _iWidth || _loc_11 < 0 || _loc_11 >= _iHeight)
            {
                return null;
            }
            return _aTiles[_loc_11 * _iWidth + _loc_9];
        }

    }
}
