package com.flengine.components
{
	import com.flengine.fl2d;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   import com.flengine.core.FNode;
   import flash.geom.Rectangle;
   
   use namespace fl2d;
   public class FTransform extends FComponent
   {
      
      public function FTransform(param1:FNode) {
         __mWorldTransformMatrix = new Matrix3D();
         __mLocalTransformMatrix = new Matrix3D();
         super(param1);
      }
      
      public var visible:Boolean = true;
      
      private var __bWorldTransformMatrixDirty:Boolean = true;
      
      private var __mWorldTransformMatrix:Matrix3D;
      
      public function get worldTransformMatrix() : Matrix3D {
         var _loc2_:* = NaN;
         var _loc1_:* = NaN;
         if(__bWorldTransformMatrixDirty)
         {
            _loc2_ = nWorldScaleX == 0?1.0E-6:nWorldScaleX;
            _loc1_ = nWorldScaleY == 0?1.0E-6:nWorldScaleY;
            __mWorldTransformMatrix.identity();
            __mWorldTransformMatrix.prependScale(_loc2_,_loc1_,1);
            __mWorldTransformMatrix.prependRotation(nWorldRotation * 180 / 3.141592653589793,Vector3D.Z_AXIS);
            __mWorldTransformMatrix.appendTranslation(nWorldX,nWorldY,0);
            __bWorldTransformMatrixDirty = false;
         }
         return __mWorldTransformMatrix;
      }
      
      private var __mLocalTransformMatrix:Matrix3D;
      
      public function get localTransformMatrix() : Matrix3D {
         __mLocalTransformMatrix.identity();
         __mLocalTransformMatrix.prependScale(__nLocalScaleX,__nLocalScaleY,1);
         __mLocalTransformMatrix.prependRotation(__nLocalRotation * 180 / 3.141592653589793,Vector3D.Z_AXIS);
         __mLocalTransformMatrix.appendTranslation(nLocalX,nLocalY,0);
         return __mLocalTransformMatrix;
      }
      
      override public function set active(param1:Boolean) : void {
         super.active = param1;
         bTransformDirty = _bActive;
      }
      
      public function getTransformedWorldTransformMatrix(param1:Number, param2:Number, param3:Number, param4:Boolean) : Matrix3D {
         var _loc5_:Matrix3D = worldTransformMatrix.clone();
         if(!(param1 == 1) && !(param2 == 1))
         {
            _loc5_.prependScale(param1,param2,1);
         }
         if(param3 != 0)
         {
            _loc5_.prependRotation(param3,Vector3D.Z_AXIS);
         }
         if(param4)
         {
            _loc5_.invert();
         }
         return _loc5_;
      }
      
      fl2d var bTransformDirty:Boolean = true;
      
      fl2d var nWorldX:Number = 0;
      
      fl2d var nLocalX:Number = 0;
      
      public function get x() : Number {
         return nLocalX;
      }
      
      public function set x(param1:Number) : void {
         nLocalX = param1;
         nWorldX = param1;
         bTransformDirty = true;
         if(cNode.cBody)
         {
            cNode.cBody.x = param1;
         }
         if(rMaskRect)
         {
            rAbsoluteMaskRect.x = rMaskRect.x + nWorldX;
         }
      }
      
      fl2d var nWorldY:Number = 0;
      
      fl2d var nLocalY:Number = 0;
      
      public function get y() : Number {
         return nLocalY;
      }
      
      public function set y(param1:Number) : void {
         nLocalY = param1;
         nWorldY = param1;
         bTransformDirty = true;
         if(cNode.cBody)
         {
            cNode.cBody.y = param1;
         }
         if(rMaskRect)
         {
            rAbsoluteMaskRect.y = rMaskRect.y + nWorldY;
         }
      }
      
      public function setPosition(param1:Number, param2:Number) : void {
         nLocalX = param1;
         nWorldX = param1;
         nLocalY = param2;
         nWorldY = param2;
         bTransformDirty = true;
         if(cNode.cBody)
         {
            cNode.cBody.x = param1;
            cNode.cBody.y = param2;
         }
         if(rMaskRect)
         {
            rAbsoluteMaskRect.x = rMaskRect.x + nWorldX;
            rAbsoluteMaskRect.y = rMaskRect.y + nWorldY;
         }
      }
      
      public function setScale(param1:Number, param2:Number) : void {
         __nLocalScaleX = param1;
         nWorldScaleX = param1;
         __nLocalScaleY = param2;
         nWorldScaleY = param2;
         bTransformDirty = true;
         if(cNode.cBody)
         {
            cNode.cBody.scaleX = param1;
            cNode.cBody.scaleY = param2;
         }
      }
      
      fl2d var nWorldScaleX:Number = 1;
      
      private var __nLocalScaleX:Number = 1;
      
      public function get scaleX() : Number {
         return __nLocalScaleX;
      }
      
      public function set scaleX(param1:Number) : void {
         __nLocalScaleX = param1;
         nWorldScaleX = param1;
         bTransformDirty = true;
         if(cNode.cBody)
         {
            cNode.cBody.scaleX = param1;
         }
      }
      
      fl2d var nWorldScaleY:Number = 1;
      
      private var __nLocalScaleY:Number = 1;
      
      public function get scaleY() : Number {
         return __nLocalScaleY;
      }
      
      public function set scaleY(param1:Number) : void {
         __nLocalScaleY = param1;
         nWorldScaleY = param1;
         bTransformDirty = true;
         if(cNode.cBody)
         {
            cNode.cBody.scaleY = param1;
         }
      }
      
      fl2d var nWorldRotation:Number = 0;
      
      private var __nLocalRotation:Number = 0;
      
      public function get rotation() : Number {
         return __nLocalRotation;
      }
      
      public function set rotation(param1:Number) : void {
         __nLocalRotation = param1;
         nWorldRotation = param1;
         bTransformDirty = true;
         if(cNode.cBody)
         {
            cNode.cBody.rotation = param1;
         }
      }
      
      fl2d var bColorDirty:Boolean = true;
      
      public function set color(param1:int) : void {
         red = (param1 >> 16 & 255) / 255;
         green = (param1 >> 8 & 255) / 255;
         blue = (param1 & 255) / 255;
      }
      
      fl2d var nWorldRed:Number = 1;
      
      private var _red:Number = 1;
      
      public function get red() : Number {
         return _red;
      }
      
      public function set red(param1:Number) : void {
         _red = param1;
         nWorldRed = param1;
         bColorDirty = true;
      }
      
      fl2d var nWorldGreen:Number = 1;
      
      private var _green:Number = 1;
      
      public function get green() : Number {
         return _green;
      }
      
      public function set green(param1:Number) : void {
         _green = param1;
         nWorldGreen = param1;
         bColorDirty = true;
      }
      
      fl2d var nWorldBlue:Number = 1;
      
      private var _blue:Number = 1;
      
      public function get blue() : Number {
         return _blue;
      }
      
      public function set blue(param1:Number) : void {
         _blue = param1;
         nWorldBlue = param1;
         bColorDirty = true;
      }
      
      fl2d var nWorldAlpha:Number = 1;
      
      private var _alpha:Number = 1;
      
      public function get alpha() : Number {
         return _alpha;
      }
      
      public function set alpha(param1:Number) : void {
         _alpha = param1;
         nWorldAlpha = param1;
         bColorDirty = true;
      }
      
      public var useWorldSpace:Boolean = false;
      
      public var useWorldColor:Boolean = false;
      
      fl2d var cMask:FNode;
      
      public function get mask() : FNode {
         return cMask;
      }
      
      public function set mask(param1:FNode) : void {
         if(cMask)
         {
            cMask.iUsedAsMask--;
         }
         cMask = param1;
         cMask.iUsedAsMask++;
      }
      
      fl2d var rMaskRect:Rectangle;
      
      public function get maskRect() : Rectangle {
         return rMaskRect;
      }
      
      public function set maskRect(param1:Rectangle) : void {
         rMaskRect = param1;
         rAbsoluteMaskRect = param1.clone();
         rAbsoluteMaskRect.x = rAbsoluteMaskRect.x + nWorldX;
         rAbsoluteMaskRect.y = rAbsoluteMaskRect.y + nWorldY;
      }
      
      fl2d var rAbsoluteMaskRect:Rectangle;
      
      fl2d function invalidate(param1:Boolean, param2:Boolean) : void {
         var _loc3_:* = NaN;
         var _loc5_:* = NaN;
         if(cNode.cParent == null)
         {
            bTransformDirty = false;
            bColorDirty = false;
            return;
         }
         var _loc4_:FTransform = cNode.cParent.cTransform;
         if(!(cNode.cBody == null) && cNode.cBody.isDynamic())
         {
            nWorldX = cNode.cBody.x;
            nLocalX = cNode.cBody.x;
            nWorldY = cNode.cBody.y;
            nLocalY = cNode.cBody.y;
            nWorldRotation = cNode.cBody.rotation;
            __nLocalRotation = cNode.cBody.rotation;
            __bWorldTransformMatrixDirty = true;
         }
         else if(param1)
         {
            if(!useWorldSpace)
            {
               if(_loc4_.nWorldRotation != 0)
               {
                  _loc3_ = Math.cos(_loc4_.nWorldRotation);
                  _loc5_ = Math.sin(_loc4_.nWorldRotation);
                  nWorldX = nLocalX * _loc4_.nWorldScaleX * _loc3_ - nLocalY * _loc4_.nWorldScaleY * _loc5_ + _loc4_.nWorldX;
                  nWorldY = nLocalY * _loc4_.nWorldScaleY * _loc3_ + nLocalX * _loc4_.nWorldScaleX * _loc5_ + _loc4_.nWorldY;
               }
               else
               {
                  nWorldX = nLocalX * _loc4_.nWorldScaleX + _loc4_.nWorldX;
                  nWorldY = nLocalY * _loc4_.nWorldScaleY + _loc4_.nWorldY;
               }
               nWorldScaleX = __nLocalScaleX * _loc4_.nWorldScaleX;
               nWorldScaleY = __nLocalScaleY * _loc4_.nWorldScaleY;
               nWorldRotation = __nLocalRotation + _loc4_.nWorldRotation;
               if(rMaskRect)
               {
                  rAbsoluteMaskRect.x = rMaskRect.x + nWorldX;
                  rAbsoluteMaskRect.y = rMaskRect.y + nWorldY;
               }
               if(!(cNode.cBody == null) && cNode.cBody.isKinematic())
               {
                  cNode.cBody.x = nWorldX;
                  cNode.cBody.y = nWorldY;
                  cNode.cBody.rotation = nWorldRotation;
               }
               bTransformDirty = false;
               __bWorldTransformMatrixDirty = true;
            }
         }
         
         if(param2 && !useWorldColor)
         {
            nWorldRed = _red * _loc4_.nWorldRed;
            nWorldGreen = _green * _loc4_.nWorldGreen;
            nWorldBlue = _blue * _loc4_.nWorldBlue;
            nWorldAlpha = _alpha * _loc4_.nWorldAlpha;
            bColorDirty = false;
         }
      }
      
      public function setColor(param1:Number = 1, param2:Number = 1, param3:Number = 1, param4:Number = 1) : void {
         red = param1;
         green = param2;
         blue = param3;
         alpha = param4;
      }
      
      public function worldToLocal(param1:Vector3D) : Vector3D {
         if(cNode.cParent == null)
         {
            return param1;
         }
         var _loc2_:Matrix3D = getTransformedWorldTransformMatrix(1,1,0,true);
         return _loc2_.transformVector(param1);
      }
      
      public function localToWorld(param1:Vector3D) : Vector3D {
         if(cNode.cParent == null)
         {
            return param1;
         }
		 param1 = localTransformMatrix.transformVector(param1);
         return cNode.cParent.cTransform.localToWorld(param1);
      }
      
      public function toString() : String {
         return "[" + x + "," + y + "," + scaleX + "," + scaleY + "]\n[" + nWorldX + "," + nWorldY + "]";
      }
   }
}
