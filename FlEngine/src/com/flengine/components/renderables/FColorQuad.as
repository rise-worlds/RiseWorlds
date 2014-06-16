package com.flengine.components.renderables
{
   import com.flengine.context.materials.FDrawColorCameraVertexShaderBatchMaterial;
   import com.flengine.context.FContext;
   import com.flengine.components.FCamera;
   import flash.geom.Rectangle;
   import com.flengine.components.FTransform;
   import com.flengine.core.FNode;
   
   public class FColorQuad extends FRenderable
   {
      
      public function FColorQuad(param1:FNode) {
         super(param1);
         if(cMaterial == null)
         {
            cMaterial = new FDrawColorCameraVertexShaderBatchMaterial();
         }
      }
      
      private static var cMaterial:FDrawColorCameraVertexShaderBatchMaterial;
      
      private static var cTransformVector:Vector.<Number>;
      
      override public function render(param1:FContext, param2:FCamera, param3:Rectangle) : void {
         if(param1.checkAndSetupRender(cMaterial,iBlendMode,true,param3))
         {
            cMaterial.bind(param1.cContext,param1.bReinitialize,param2);
         }
         var _loc4_:FTransform = cNode.cTransform;
         cMaterial.draw(_loc4_.nWorldX,_loc4_.nWorldY,_loc4_.nWorldScaleX,_loc4_.nWorldScaleY,_loc4_.nWorldRotation,_loc4_.nWorldRed,_loc4_.nWorldGreen,_loc4_.nWorldBlue,_loc4_.nWorldAlpha);
      }
   }
}
