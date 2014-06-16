package com.flengine.components.renderables
{
   import com.flengine.textures.FTextureAtlas;
   import com.flengine.core.FNode;
   import com.flengine.textures.FTexture;
   import com.flengine.error.FError;
   import com.flengine.core.FNodeFactory;
   import flash.events.MouseEvent;
   import flash.geom.Vector3D;
   import flash.geom.Matrix3D;
   
   public class FTextureText extends FRenderable
   {
      
      public function FTextureText(param1:FNode) {
         _iAlign = FTextureTextAlignType.TOP_LEFT;
         super(param1);
      }
      
      protected var _cTextureAtlas:FTextureAtlas;
      
      protected var _bInvalidate:Boolean = false;
      
      protected var _nTracking:Number = 0;
      
      public function get tracking() : Number {
         return _nTracking;
      }
      
      public function set tracking(param1:Number) : void {
         _nTracking = param1;
         _bInvalidate = true;
      }
      
      protected var _nLineSpace:Number = 0;
      
      public function get lineSpace() : Number {
         return _nLineSpace;
      }
      
      public function set lineSpace(param1:Number) : void {
         _nLineSpace = param1;
         _bInvalidate = true;
      }
      
      protected var _iAlign:int;
      
      public function get align() : int {
         return _iAlign;
      }
      
      public function set align(param1:int) : void {
         _iAlign = param1;
         _bInvalidate = true;
      }
      
      public var maxWidth:Number = 0;
      
      public function get textureAtlasId() : String {
         if(_cTextureAtlas)
         {
            return _cTextureAtlas.id;
         }
         return "";
      }
      
      public function set textureAtlasId(param1:String) : void {
         setTextureAtlas(FTextureAtlas.getTextureAtlasById(param1));
      }
      
      public function setTextureAtlas(param1:FTextureAtlas) : void {
         _cTextureAtlas = param1;
         _bInvalidate = true;
      }
      
      protected var _sText:String = "";
      
      public function get text() : String {
         return _sText;
      }
      
      public function set text(param1:String) : void {
         _sText = param1;
         _bInvalidate = true;
      }
      
      protected var _nWidth:Number = 0;
      
      public function get width() : Number {
         if(_bInvalidate)
         {
            invalidateText();
         }
         return _nWidth * cNode.cTransform.nWorldScaleX;
      }
      
      protected var _nHeight:Number = 0;
      
      public function get height() : Number {
         if(_bInvalidate)
         {
            invalidateText();
         }
         return _nHeight * cNode.cTransform.nWorldScaleY;
      }
      
      override public function update(param1:Number, param2:Boolean, param3:Boolean) : void {
         if(!_bInvalidate)
         {
            return;
         }
         invalidateText();
      }
      
      protected function invalidateText() : void {
         var _loc6_:* = null;
         var _loc3_:* = null;
         var _loc7_:* = 0;
         var _loc5_:* = null;
         if(_cTextureAtlas == null)
         {
            return;
         }
         _nWidth = 0;
         var _loc4_:* = 0.0;
         var _loc2_:* = 0.0;
         var _loc1_:FNode = cNode.firstChild;
         _loc7_ = 0;
         while(_loc7_ < _sText.length)
         {
            if(_sText.charCodeAt(_loc7_) == 10)
            {
               _nWidth = _loc4_ > _nWidth?_loc4_:_nWidth;
               _loc4_ = 0.0;
               _loc2_ = _loc2_ + (_loc3_.height + _nLineSpace);
            }
            else
            {
               _loc3_ = _cTextureAtlas.getTexture(_sText.charCodeAt(_loc7_));
               if(_loc3_ == null)
               {
                  throw new FError("Texture for character " + _sText.charAt(_loc7_) + " with code " + _sText.charCodeAt(_loc7_) + " not found!");
               }
               else
               {
                  if(_loc1_ == null)
                  {
                     _loc6_ = FNodeFactory.createNodeWithComponent(FSprite) as FSprite;
                     _loc1_ = _loc6_.cNode;
                     cNode.addChild(_loc1_);
                  }
                  else
                  {
                     _loc6_ = _loc1_.getComponent(FSprite) as FSprite;
                  }
                  _loc6_.node.cameraGroup = node.cameraGroup;
                  _loc6_.setTexture(_loc3_);
                  if(maxWidth > 0 && _loc4_ + _loc3_.width > maxWidth)
                  {
                     _nWidth = _loc4_ > _nWidth?_loc4_:_nWidth;
                     _loc4_ = 0.0;
                     _loc2_ = _loc2_ + (_loc3_.height + _nLineSpace);
                  }
                  _loc4_ = _loc4_ + _loc3_.width / 2;
                  _loc6_.cNode.cTransform.x = _loc4_;
                  _loc6_.cNode.cTransform.y = _loc2_ + _loc3_.height / 2;
                  _loc4_ = _loc4_ + (_loc3_.width / 2 + _nTracking);
                  _loc1_ = _loc1_.next;
               }
            }
            _loc7_++;
         }
         _nWidth = _loc4_ > _nWidth?_loc4_:_nWidth;
         _nHeight = _loc2_ + (_loc3_ != null?_loc3_.height:0);
         while(_loc1_)
         {
            _loc5_ = _loc1_.next;
            cNode.removeChild(_loc1_);
            _loc1_ = _loc5_;
         }
         invalidateAlign();
         _bInvalidate = false;
      }
      
      private function invalidateAlign() : void {
         var _loc1_:* = null;
         var _loc2_:* = _iAlign;
         if(FTextureTextAlignType.MIDDLE_CENTER !== _loc2_)
         {
            if(FTextureTextAlignType.TOP_RIGHT !== _loc2_)
            {
               if(FTextureTextAlignType.TOP_LEFT !== _loc2_)
               {
                  if(FTextureTextAlignType.MIDDLE_RIGHT !== _loc2_)
                  {
                     if(FTextureTextAlignType.MIDDLE_LEFT === _loc2_)
                     {
                        _loc1_ = cNode.firstChild;
                        while(_loc1_)
                        {
                           _loc1_.transform.y = _loc1_.transform.y - _nHeight / 2;
                           _loc1_ = _loc1_.next;
                        }
                     }
                  }
                  else
                  {
                     _loc1_ = cNode.firstChild;
                     while(_loc1_)
                     {
                        _loc1_.transform.x = _loc1_.transform.x - _nWidth;
                        _loc1_.transform.y = _loc1_.transform.y - _nHeight / 2;
                        _loc1_ = _loc1_.next;
                     }
                  }
               }
            }
            else
            {
               _loc1_ = cNode.firstChild;
               while(_loc1_)
               {
                  _loc1_.transform.x = _loc1_.transform.x - _nWidth;
                  _loc1_ = _loc1_.next;
               }
            }
         }
         else
         {
            _loc1_ = cNode.firstChild;
            while(_loc1_)
            {
               _loc1_.transform.x = _loc1_.transform.x - _nWidth / 2;
               _loc1_.transform.y = _loc1_.transform.y - _nHeight / 2;
               _loc1_ = _loc1_.next;
            }
         }
      }
      
      override public function processMouseEvent(param1:Boolean, param2:MouseEvent, param3:Vector3D) : Boolean {
         if(_nWidth == 0 || _nHeight == 0)
         {
            return false;
         }
         if(param1)
         {
            if(cNode.cMouseOver == cNode)
            {
               cNode.handleMouseEvent(cNode,"mouseOut",NaN,NaN,param2.buttonDown,param2.ctrlKey);
            }
            return false;
         }
         var _loc6_:Matrix3D = cNode.cTransform.getTransformedWorldTransformMatrix(_nWidth,_nHeight,0,true);
         var _loc7_:Vector3D = _loc6_.transformVector(param3);
         _loc6_.prependScale(1 / _nWidth,1 / _nHeight,1);
         var _loc5_:* = 0.0;
         var _loc4_:* = 0.0;
         var _loc8_:* = _iAlign;
         if(FTextureTextAlignType.MIDDLE_CENTER === _loc8_)
         {
            _loc5_ = -0.5;
            _loc4_ = -0.5;
         }
         if(_loc7_.x >= _loc5_ && _loc7_.x <= 1 + _loc5_ && _loc7_.y >= _loc4_ && _loc7_.y <= 1 + _loc4_)
         {
            cNode.handleMouseEvent(cNode,param2.type,_loc7_.x * _nWidth,_loc7_.y * _nHeight,param2.buttonDown,param2.ctrlKey);
            if(cNode.cMouseOver != cNode)
            {
               cNode.handleMouseEvent(cNode,"mouseOver",_loc7_.x * _nWidth,_loc7_.y * _nHeight,param2.buttonDown,param2.ctrlKey);
            }
            return true;
         }
         if(cNode.cMouseOver == cNode)
         {
            cNode.handleMouseEvent(cNode,"mouseOut",_loc7_.x * _nWidth,_loc7_.y * _nHeight,param2.buttonDown,param2.ctrlKey);
         }
         return false;
      }
   }
}
