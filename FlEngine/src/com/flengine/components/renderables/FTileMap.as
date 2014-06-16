package com.flengine.components.renderables
{
   import com.flengine.context.FContext;
   import com.flengine.components.FCamera;
   import flash.geom.Rectangle;
   import com.flengine.textures.FTexture;
   import com.flengine.core.FNode;
   
   public class FTileMap extends FRenderable
   {
      
      public function FTileMap(param1:FNode) {
         super(param1);
      }
      
      protected var _iWidth:int;
      
      protected var _iHeight:int;
      
      protected var _aTiles:Vector.<FTile>;
      
      protected var _iTileWidth:int = 0;
      
      protected var _iTileHeight:int = 0;
      
      protected var _bIso:Boolean = false;
      
      public function setTiles(param1:Vector.<FTile>, param2:int, param3:int, param4:int, param5:int, param6:Boolean = false) : void {
         if(param2 * param3 != param1.length)
         {
            throw new Error("Invalid tile map.");
         }
         else
         {
            _aTiles = param1;
            _iWidth = param2;
            _iHeight = param3;
            _bIso = param6;
            setTileSize(param4,param5);
            return;
         }
      }
      
      public function setTile(param1:int, param2:int) : void {
         if(param1 < 0 || param1 >= _aTiles.length)
         {
            return;
         }
         _aTiles[param1] = param2;
      }
      
      public function setTileSize(param1:int, param2:int) : void {
         _iTileWidth = param1;
         _iTileHeight = param2;
      }
      
      override public function render(param1:FContext, param2:FCamera, param3:Rectangle) : void {
         var _loc14_:* = 0;
         var _loc13_:* = 0;
         var _loc22_:* = NaN;
         var _loc21_:* = NaN;
         var _loc5_:* = 0;
         var _loc18_:* = null;
         if(_aTiles == null)
         {
            return;
         }
         var _loc6_:Number = _iTileWidth * _iWidth * 0.5;
         var _loc11_:Number = _iTileHeight * _iHeight * (_bIso?0.25:0.5);
         var _loc16_:Number = param2.cNode.cTransform.nWorldX - cNode.cTransform.nWorldX - param2.rViewRectangle.width * 0.5;
         var _loc17_:Number = param2.cNode.cTransform.nWorldY - cNode.cTransform.nWorldY - param2.rViewRectangle.height * 0.5;
         var _loc9_:Number = -_loc6_ + (_bIso?_iTileWidth / 2:0);
         var _loc7_:Number = -_loc11_ + (_bIso?_iTileHeight / 2:0);
         var _loc19_:int = (_loc16_ - _loc9_) / _iTileWidth;
         if(_loc19_ < 0)
         {
            _loc19_ = 0;
         }
         var _loc20_:int = (_loc17_ - _loc7_) / (_bIso?_iTileHeight / 2:_iTileHeight);
         if(_loc20_ < 0)
         {
            _loc20_ = 0;
         }
         var _loc8_:Number = param2.cNode.cTransform.nWorldX - cNode.cTransform.nWorldX + param2.rViewRectangle.width * 0.5 - (_bIso?_iTileWidth / 2:_iTileWidth);
         var _loc10_:Number = param2.cNode.cTransform.nWorldY - cNode.cTransform.nWorldY + param2.rViewRectangle.height * 0.5 - (_bIso?0:_iTileHeight);
         var _loc15_:int = (_loc8_ - _loc9_) / _iTileWidth - _loc19_ + 2;
         if(_loc15_ > _iWidth - _loc19_)
         {
            _loc15_ = _iWidth - _loc19_;
         }
         var _loc4_:int = (_loc10_ - _loc7_) / (_bIso?_iTileHeight / 2:_iTileHeight) - _loc20_ + 2;
         if(_loc4_ > _iHeight - _loc20_)
         {
            _loc4_ = _iHeight - _loc20_;
         }
         var _loc12_:int = _loc15_ * _loc4_;
         _loc14_ = 0;
         while(_loc14_ < _loc12_)
         {
            _loc13_ = _loc14_ / _loc15_;
            _loc22_ = cNode.cTransform.nWorldX + (_loc19_ + _loc14_ % _loc15_) * _iTileWidth - _loc6_ + (_bIso && (_loc20_ + _loc13_) % 2 == 1?_iTileWidth:_iTileWidth / 2);
            _loc21_ = cNode.cTransform.nWorldY + (_loc20_ + _loc13_) * (_bIso?_iTileHeight / 2:_iTileHeight) - _loc11_ + _iTileHeight / 2;
            _loc5_ = _loc20_ * _iWidth + _loc19_ + (_loc14_ / _loc15_) * _iWidth + _loc14_ % _loc15_;
            _loc18_ = _aTiles[_loc5_];
            if(!(_loc18_ == null) && !(_loc18_.textureId == null))
            {
               param1.draw(FTexture.getTextureById(_loc18_.textureId),_loc22_,_loc21_,1,1,0,1,1,1,1,1,param3);
            }
            _loc14_++;
         }
      }
      
      public function getTileAt(param1:Number, param2:Number, param3:FCamera = null) : FTile {
         if(param3 == null)
         {
            param3 = node.core.defaultCamera;
         }
         var param1:Number = param1 - (param3.rViewRectangle.x + param3.rViewRectangle.width / 2);
         var param2:Number = param2 - (param3.rViewRectangle.y + param3.rViewRectangle.height / 2);
         var _loc7_:Number = _iTileWidth * _iWidth * 0.5;
         var _loc10_:Number = _iTileHeight * _iHeight * (_bIso?0.25:0.5);
         var _loc8_:Number = -_loc7_ + (_bIso?_iTileWidth / 2:0);
         var _loc6_:Number = -_loc10_ + (_bIso?_iTileHeight / 2:0);
         var _loc5_:Number = param3.cNode.cTransform.nWorldX - cNode.cTransform.nWorldX + param1;
         var _loc4_:Number = param3.cNode.cTransform.nWorldY - cNode.cTransform.nWorldY + param2;
         var _loc9_:int = Math.floor((_loc5_ - _loc8_) / _iTileWidth);
         var _loc11_:int = Math.floor((_loc4_ - _loc6_) / _iTileHeight);
         if(_loc9_ < 0 || _loc9_ >= _iWidth || _loc11_ < 0 || _loc11_ >= _iHeight)
         {
            return null;
         }
         return _aTiles[_loc11_ * _iWidth + _loc9_];
      }
   }
}
