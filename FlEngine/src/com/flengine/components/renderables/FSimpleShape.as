package com.flengine.components.renderables
{
   import com.flengine.textures.FTexture;
   import com.flengine.context.FContext;
   import com.flengine.components.FCamera;
   import flash.geom.Rectangle;
   import com.flengine.components.FTransform;
   import com.flengine.core.FNode;
   
   public class FSimpleShape extends FRenderable
   {
      
      public function FSimpleShape(param1:FNode) {
         super(param1);
      }
      
      fl2d var cTexture:FTexture;
      
      protected var _aVertices:Vector.<Number>;
      
      protected var _aUvs:Vector.<Number>;
      
      public function setTexture(param1:FTexture) : void {
         cTexture = param1;
      }
      
      override public function render(param1:FContext, param2:FCamera, param3:Rectangle) : void {
         if(cTexture == null || _aVertices == null || _aUvs == null)
         {
            return;
         }
         var _loc4_:FTransform = cNode.cTransform;
         param1.drawPoly(cTexture,_aVertices,_aUvs,_loc4_.nWorldX,_loc4_.nWorldY,_loc4_.nWorldScaleX,_loc4_.nWorldScaleY,_loc4_.nWorldRotation,_loc4_.nWorldRed,_loc4_.nWorldGreen,_loc4_.nWorldBlue,_loc4_.nWorldAlpha,iBlendMode,param3);
      }
      
      public function init(param1:Vector.<Number>, param2:Vector.<Number>) : void {
         _aVertices = param1;
         _aUvs = param2;
      }
   }
}
