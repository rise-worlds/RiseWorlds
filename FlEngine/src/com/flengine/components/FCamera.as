package com.flengine.components
{
   import flash.geom.Rectangle;
   import com.flengine.context.FContext;
   import flash.events.MouseEvent;
   import flash.geom.Vector3D;
   import com.flengine.core.FNode;
   
   public class FCamera extends FComponent
   {
      
      public function FCamera(param1:FNode) {
         aCameraVector = new <Number>[0,0,0,0,0,0,0,0];
         super(param1);
         rViewRectangle = new Rectangle();
         if(!(cNode == cNode.cCore.root) && cNode.isOnStage())
         {
            cNode.cCore.addCamera(this);
         }
         cNode.onAddedToStage.add(onAddedToStage);
         cNode.onRemovedFromStage.add(onRemovedFromStage);
      }
      
      override public function getPrototype() : XML {
         _xPrototype = super.getPrototype();
         return _xPrototype;
      }
      
      public var mask:int = 16777215;
      
      public var normalizedViewX:Number = 0;
      
      public var normalizedViewY:Number = 0;
      
      public var normalizedViewWidth:Number = 1;
      
      public var normalizedViewHeight:Number = 1;
      
      public var backgroundRed:Number = 0;
      
      public var backgroundGreen:Number = 0;
      
      public var backgroundBlue:Number = 0;
      
      public var backgroundAlpha:Number = 0;
      
      public function get backgroundColor() : uint {
         var _loc4_:uint = (backgroundAlpha * 255) << 24;
         var _loc1_:uint = (backgroundRed * 255) << 16;
         var _loc3_:uint = (backgroundGreen * 255) << 8;
         var _loc2_:uint = backgroundBlue * 255;
         return _loc4_ + _loc1_ + _loc3_ + _loc2_;
      }
      
      fl2d var rViewRectangle:Rectangle;
      
      fl2d var rendererData:Object;
      
      fl2d var bCapturedThisFrame:Boolean = false;
      
      fl2d var nViewX:Number = 0;
      
      fl2d var nViewY:Number = 0;
      
      fl2d var nScaleX:Number = 1;
      
      fl2d var nScaleY:Number = 1;
      
      fl2d var aCameraVector:Vector.<Number>;
      
      fl2d var iRenderedNodesCount:int;
      
      public function get zoom() : Number {
         return nScaleX;
      }
      
      public function set zoom(param1:Number) : void {
         nScaleY = param1;
         nScaleX = param1;
      }
      
      override public function update(param1:Number, param2:Boolean, param3:Boolean) : void {
      }
      
      fl2d function invalidate() : void {
         rViewRectangle.x = normalizedViewX * cNode.cCore.cConfig.viewRect.width;
         rViewRectangle.y = normalizedViewY * cNode.cCore.cConfig.viewRect.height;
         var _loc2_:Number = normalizedViewWidth + normalizedViewX > 1?1 - normalizedViewX:normalizedViewWidth;
         var _loc1_:Number = normalizedViewHeight + normalizedViewY > 1?1 - normalizedViewY:normalizedViewHeight;
         rViewRectangle.width = _loc2_ * cNode.cCore.cConfig.viewRect.width;
         rViewRectangle.height = _loc1_ * cNode.cCore.cConfig.viewRect.height;
         aCameraVector[0] = cNode.cTransform.nWorldRotation;
         aCameraVector[1] = rViewRectangle.x + rViewRectangle.width / 2;
         aCameraVector[2] = rViewRectangle.y + rViewRectangle.height / 2;
         aCameraVector[4] = cNode.cTransform.nWorldX;
         aCameraVector[5] = cNode.cTransform.nWorldY;
         aCameraVector[6] = nScaleX;
         aCameraVector[7] = nScaleY;
      }
      
      override public function render(param1:FContext, param2:FCamera, param3:Rectangle) : void {
         if(!(param2 == null) || !cNode.active)
         {
            return;
         }
         iRenderedNodesCount = 0;
         if(backgroundAlpha != 0)
         {
            param1.blitColor(rViewRectangle.x + rViewRectangle.width / 2,rViewRectangle.y + rViewRectangle.height / 2,rViewRectangle.width,rViewRectangle.height,backgroundRed,backgroundGreen,backgroundBlue,backgroundAlpha,1,rViewRectangle);
         }
         param1.setCamera(this);
         cNode.cCore.root.render(param1,this,rViewRectangle,false);
      }
      
      fl2d function captureMouseEvent(param1:Boolean, param2:MouseEvent, param3:Vector3D) : Boolean {
         if(bCapturedThisFrame || !cNode.active)
         {
            return false;
         }
         bCapturedThisFrame = true;
         if(!rViewRectangle.contains(param3.x,param3.y))
         {
            return false;
         }
         param3.x = param3.x - (rViewRectangle.x + rViewRectangle.width / 2);
         param3.y = param3.y - (rViewRectangle.y + rViewRectangle.height / 2);
         var _loc6_:Number = Math.cos(-cNode.cTransform.nWorldRotation);
         var _loc7_:Number = Math.sin(-cNode.cTransform.nWorldRotation);
         var _loc5_:Number = param3.x * _loc6_ - param3.y * _loc7_;
         var _loc4_:Number = param3.y * _loc6_ + param3.x * _loc7_;
         _loc5_ = _loc5_ / nScaleY;
         _loc4_ = _loc4_ / nScaleX;
         param3.x = _loc5_ + cNode.cTransform.nWorldX;
         param3.y = _loc4_ + cNode.cTransform.nWorldY;
         return cNode.cCore.root.processMouseEvent(param1,param2,param3,this);
      }
      
      override public function dispose() : void {
         cNode.cCore.removeCamera(this);
         cNode.onAddedToStage.remove(onAddedToStage);
         cNode.onRemovedFromStage.remove(onRemovedFromStage);
         super.dispose();
      }
      
      private function onAddedToStage(param1:Object) : void {
         cNode.cCore.addCamera(this);
      }
      
      private function onRemovedFromStage(param1:Object) : void {
         cNode.cCore.removeCamera(this);
      }
   }
}
