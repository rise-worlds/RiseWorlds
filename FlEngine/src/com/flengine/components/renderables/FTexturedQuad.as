package com.flengine.components.renderables
{
   import com.flengine.context.filters.FFilter;
   import com.flengine.textures.FTexture;
   import com.flengine.context.FContext;
   import com.flengine.components.FCamera;
   import flash.geom.Rectangle;
   import com.flengine.components.FTransform;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   import flash.events.MouseEvent;
   import com.flengine.core.FNode;
   
   public class FTexturedQuad extends FRenderable
   {
      
      public function FTexturedQuad(param1:FNode) {
         _aTransformedVertices = new Vector.<Number>();
         super(param1);
      }
      
      private static const NORMALIZED_VERTICES_3D:Vector.<Number>;
      
      public var filter:FFilter;
      
      fl2d var cTexture:FTexture;
      
      public function getTexture() : FTexture {
         return cTexture;
      }
      
      protected var _aTransformedVertices:Vector.<Number>;
      
      public var mousePixelEnabled:Boolean = false;
      
      override public function render(param1:FContext, param2:FCamera, param3:Rectangle) : void {
         if(cTexture == null)
         {
            return;
         }
         var _loc4_:FTransform = cNode.cTransform;
         param1.draw(cTexture,_loc4_.nWorldX,_loc4_.nWorldY,_loc4_.nWorldScaleX,_loc4_.nWorldScaleY,_loc4_.nWorldRotation,_loc4_.nWorldRed,_loc4_.nWorldGreen,_loc4_.nWorldBlue,_loc4_.nWorldAlpha,iBlendMode,param3,filter);
      }
      
      override public function getWorldBounds(param1:Rectangle = null) : Rectangle {
         var _loc4_:* = 0;
         var _loc2_:Vector.<Number> = getTransformedVertices3D();
         if(_loc2_ == null)
         {
            return param1;
         }
         if(param1)
         {
            param1.setTo(_loc2_[0],_loc2_[1],0,0);
         }
         else
         {
            param1 = new Rectangle(_loc2_[0],_loc2_[1],0,0);
         }
         var _loc3_:int = _loc2_.length;
         _loc4_ = 3;
         while(_loc4_ < _loc3_)
         {
            if(param1.left > _loc2_[_loc4_])
            {
               param1.left = _loc2_[_loc4_];
            }
            if(param1.right < _loc2_[_loc4_])
            {
               param1.right = _loc2_[_loc4_];
            }
            if(param1.top > _loc2_[_loc4_ + 1])
            {
               param1.top = _loc2_[_loc4_ + 1];
            }
            if(param1.bottom < _loc2_[_loc4_ + 1])
            {
               param1.bottom = _loc2_[_loc4_ + 1];
            }
            _loc4_ = _loc4_ + 3;
         }
         return param1;
      }
      
      fl2d function getTransformedVertices3D() : Vector.<Number> {
         if(cTexture == null)
         {
            return null;
         }
         var _loc1_:Rectangle = cTexture.region;
         var _loc2_:Matrix3D = cNode.cTransform.worldTransformMatrix;
         _loc2_.prependTranslation(-cTexture.nPivotX,-cTexture.nPivotY,0);
         _loc2_.prependScale(_loc1_.width,_loc1_.height,1);
         _loc2_.transformVectors(NORMALIZED_VERTICES_3D,_aTransformedVertices);
         _loc2_.prependScale(1 / _loc1_.width,1 / _loc1_.height,1);
         _loc2_.prependTranslation(cTexture.nPivotX,cTexture.nPivotY,0);
         return _aTransformedVertices;
      }
      
      public function hitTestObject(param1:FTexturedQuad) : Boolean {
         var _loc3_:Vector.<Number> = param1.getTransformedVertices3D();
         var _loc2_:Vector.<Number> = getTransformedVertices3D();
         var _loc5_:Number = (_loc3_[0] + _loc3_[3] + _loc3_[6] + _loc3_[9]) / 4;
         var _loc4_:Number = (_loc3_[1] + _loc3_[4] + _loc3_[7] + _loc3_[10]) / 4;
         if(isSeparating(_loc3_[3],_loc3_[4],_loc3_[0] - _loc3_[3],_loc3_[1] - _loc3_[4],_loc5_,_loc4_,_loc2_))
         {
            return false;
         }
         if(isSeparating(_loc3_[6],_loc3_[7],_loc3_[3] - _loc3_[6],_loc3_[4] - _loc3_[7],_loc5_,_loc4_,_loc2_))
         {
            return false;
         }
         if(isSeparating(_loc3_[9],_loc3_[10],_loc3_[6] - _loc3_[9],_loc3_[7] - _loc3_[10],_loc5_,_loc4_,_loc2_))
         {
            return false;
         }
         if(isSeparating(_loc3_[0],_loc3_[1],_loc3_[9] - _loc3_[0],_loc3_[10] - _loc3_[1],_loc5_,_loc4_,_loc2_))
         {
            return false;
         }
         _loc5_ = (_loc2_[0] + _loc2_[3] + _loc2_[6] + _loc2_[9]) / 4;
         _loc4_ = (_loc2_[1] + _loc2_[4] + _loc2_[7] + _loc2_[10]) / 4;
         if(isSeparating(_loc2_[3],_loc2_[4],_loc2_[0] - _loc2_[3],_loc2_[1] - _loc2_[4],_loc5_,_loc4_,_loc3_))
         {
            return false;
         }
         if(isSeparating(_loc2_[6],_loc2_[7],_loc2_[3] - _loc2_[6],_loc2_[4] - _loc2_[7],_loc5_,_loc4_,_loc3_))
         {
            return false;
         }
         if(isSeparating(_loc2_[9],_loc2_[10],_loc2_[6] - _loc2_[9],_loc2_[7] - _loc2_[10],_loc5_,_loc4_,_loc3_))
         {
            return false;
         }
         if(isSeparating(_loc2_[0],_loc2_[1],_loc2_[9] - _loc2_[0],_loc2_[10] - _loc2_[1],_loc5_,_loc4_,_loc3_))
         {
            return false;
         }
         return true;
      }
      
      private function isSeparating(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Vector.<Number>) : Boolean {
         var _loc13_:Number = -param4;
         var _loc14_:* = param3;
         var _loc8_:Number = _loc13_ * (param5 - param1) + _loc14_ * (param6 - param2);
         var _loc11_:Number = _loc13_ * (param7[0] - param1) + _loc14_ * (param7[1] - param2);
         var _loc12_:Number = _loc13_ * (param7[3] - param1) + _loc14_ * (param7[4] - param2);
         var _loc9_:Number = _loc13_ * (param7[6] - param1) + _loc14_ * (param7[7] - param2);
         var _loc10_:Number = _loc13_ * (param7[9] - param1) + _loc14_ * (param7[10] - param2);
         if(_loc8_ < 0 && _loc11_ >= 0 && _loc12_ >= 0 && _loc9_ >= 0 && _loc10_ >= 0)
         {
            return true;
         }
         if(_loc8_ > 0 && _loc11_ <= 0 && _loc12_ <= 0 && _loc9_ <= 0 && _loc10_ <= 0)
         {
            return true;
         }
         return false;
      }
      
      public function hitTestPoint(param1:Vector3D, param2:Boolean = false) : Boolean {
         var _loc4_:Number = cTexture.width;
         var _loc6_:Number = cTexture.height;
         var _loc5_:Matrix3D = cNode.cTransform.getTransformedWorldTransformMatrix(_loc4_,_loc6_,0,true);
         var _loc3_:Vector3D = _loc5_.transformVector(param1);
         _loc3_.x = _loc3_.x + 0.5;
         _loc3_.y = _loc3_.y + 0.5;
         if(_loc3_.x >= -cTexture.nPivotX / _loc4_ && _loc3_.x <= 1 - cTexture.nPivotX / _loc4_ && _loc3_.y >= -cTexture.nPivotY / _loc6_ && _loc3_.y <= 1 - cTexture.nPivotY / _loc6_)
         {
            if(mousePixelEnabled && cTexture.getAlphaAtUV(_loc3_.x + cTexture.pivotX / _loc4_,_loc3_.y + cTexture.nPivotY / _loc6_) == 0)
            {
               return false;
            }
            return true;
         }
         return false;
      }
      
      override public function processMouseEvent(param1:Boolean, param2:MouseEvent, param3:Vector3D) : Boolean {
         if(param1 && param2.type == "mouseUp")
         {
            cNode.cMouseDown = null;
         }
         if(param1 || cTexture == null)
         {
            if(cNode.cMouseOver == cNode)
            {
               cNode.handleMouseEvent(cNode,"mouseOut",NaN,NaN,param2.buttonDown,param2.ctrlKey);
            }
            return false;
         }
         var _loc4_:Number = cTexture.width;
         var _loc7_:Number = cTexture.height;
         var _loc5_:Matrix3D = cNode.cTransform.getTransformedWorldTransformMatrix(_loc4_,_loc7_,0,true);
         var _loc6_:* = _loc5_.transformVector(param3);
         _loc6_.x = _loc6_.x + 0.5;
         _loc6_.y = _loc6_.y + 0.5;
         if(_loc6_.x >= -cTexture.nPivotX / _loc4_ && _loc6_.x <= 1 - cTexture.nPivotX / _loc4_ && _loc6_.y >= -cTexture.nPivotY / _loc7_ && _loc6_.y <= 1 - cTexture.nPivotY / _loc7_)
         {
            if(mousePixelEnabled && cTexture.getAlphaAtUV(_loc6_.x + cTexture.pivotX / _loc4_,_loc6_.y + cTexture.nPivotY / _loc7_) == 0)
            {
               if(cNode.cMouseOver == cNode)
               {
                  cNode.handleMouseEvent(cNode,"mouseOut",_loc6_.x * _loc4_ + cTexture.nPivotX,_loc6_.y * _loc7_ + cTexture.nPivotY,param2.buttonDown,param2.ctrlKey);
               }
               return false;
            }
            cNode.handleMouseEvent(cNode,param2.type,_loc6_.x * _loc4_ + cTexture.nPivotX,_loc6_.y * _loc7_ + cTexture.nPivotY,param2.buttonDown,param2.ctrlKey);
            if(cNode.cMouseOver != cNode)
            {
               cNode.handleMouseEvent(cNode,"mouseOver",_loc6_.x * _loc4_ + cTexture.nPivotX,_loc6_.y * _loc7_ + cTexture.nPivotY,param2.buttonDown,param2.ctrlKey);
            }
            return true;
         }
         if(cNode.cMouseOver == cNode)
         {
            cNode.handleMouseEvent(cNode,"mouseOut",_loc6_.x * _loc4_ + cTexture.nPivotX,_loc6_.y * _loc7_ + cTexture.nPivotY,param2.buttonDown,param2.ctrlKey);
         }
         return false;
      }
      
      override public function dispose() : void {
         super.dispose();
         cTexture = null;
      }
   }
}
