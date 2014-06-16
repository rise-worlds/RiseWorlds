package com.flengine.components.renderables
{
   import com.flengine.context.materials.FCameraTexturedPolygonMaterial;
   import com.flengine.textures.FTexture;
   import com.flengine.context.FContext;
   import com.flengine.components.FCamera;
   import flash.geom.Rectangle;
   import com.flengine.components.FTransform;
   import com.flengine.core.FNode;
   
   public class FShape extends FRenderable
   {
      
      public function FShape(param1:FNode) {
         super(param1);
         _cMaterial = new FCameraTexturedPolygonMaterial();
      }
      
      private static var cTransformVector:Vector.<Number>;
      
      protected var _cMaterial:FCameraTexturedPolygonMaterial;
      
      fl2d var cTexture:FTexture;
      
      protected var _iMaxVertices:int = 0;
      
      protected var _iCurrentVertices:int = 0;
      
      protected var _aVertices:Vector.<Number>;
      
      protected var _aUVs:Vector.<Number>;
      
      protected var _bDirty:Boolean = false;
      
      public function setTexture(param1:FTexture) : void {
         cTexture = param1;
      }
      
      override public function render(param1:FContext, param2:FCamera, param3:Rectangle) : void {
         if(cTexture == null || _iMaxVertices == 0)
         {
            return;
         }
         param1.checkAndSetupRender(_cMaterial,iBlendMode,cTexture.premultiplied,param3);
         _cMaterial.bind(param1.cContext,param1.bReinitialize,param2,_iMaxVertices);
         var _loc4_:FTransform = cNode.cTransform;
         cTransformVector[0] = _loc4_.nWorldX;
         cTransformVector[1] = _loc4_.nWorldY;
         cTransformVector[2] = _loc4_.nWorldScaleX;
         cTransformVector[3] = _loc4_.nWorldScaleY;
         cTransformVector[4] = cTexture.nUvX;
         cTransformVector[5] = cTexture.nUvY;
         cTransformVector[6] = cTexture.nUvScaleX;
         cTransformVector[7] = cTexture.nUvScaleY;
         cTransformVector[8] = _loc4_.nWorldRotation;
         cTransformVector[10] = cTexture.nPivotX * _loc4_.nWorldScaleX;
         cTransformVector[11] = cTexture.nPivotY * _loc4_.nWorldScaleY;
         cTransformVector[12] = _loc4_.nWorldRed * _loc4_.nWorldAlpha;
         cTransformVector[13] = _loc4_.nWorldGreen * _loc4_.nWorldAlpha;
         cTransformVector[14] = _loc4_.nWorldBlue * _loc4_.nWorldAlpha;
         cTransformVector[15] = _loc4_.nWorldAlpha;
         _cMaterial.draw(cTransformVector,cTexture.cContextTexture.tTexture,cTexture.iFilteringType,_aVertices,_aUVs,_iCurrentVertices,_bDirty);
         _bDirty = false;
      }
      
      public function init(param1:Vector.<Number>, param2:Vector.<Number>) : void {
         var _loc3_:* = 0;
         _bDirty = true;
         _iCurrentVertices = param1.length / 2;
         if(param1.length / 2 > _iMaxVertices)
         {
            _iMaxVertices = param1.length / 2;
            _aVertices = param1;
            _aUVs = param2;
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < _iCurrentVertices * 2)
            {
               _aVertices[_loc3_] = param1[_loc3_];
               _aUVs[_loc3_] = param2[_loc3_];
               _loc3_++;
            }
         }
      }
   }
}
