package com.flengine.context.materials
{
   import flash.display3D.VertexBuffer3D;
   import flash.display3D.IndexBuffer3D;
   import flash.display3D.textures.Texture;
   import com.flengine.context.filters.FFilter;
   import flash.utils.Dictionary;
   import flash.display3D.Context3D;
   import com.adobe.utils.AGALMiniAssembler;
   import flash.display3D.Program3D;
   import com.flengine.core.FlEngine;
   import com.flengine.components.FCamera;
   import com.flengine.textures.FTextureBase;
   import com.flengine.textures.FTexture;
   import flash.geom.Matrix;
   import com.flengine.core.FStats;
   
   public final class FDrawTextureCameraVertexBufferCPUBatchMaterial extends Object implements IGMaterial
   {
      
      public function FDrawTextureCameraVertexBufferCPUBatchMaterial() {
         super();
      }
      
      private static const BATCH_SIZE:int = 1000;
      
      private static const DATA_PER_VERTEX:int = 8;
      
      private static const VERTEX_SHADER_CODE:Array;
      
      private static const VERTEX_SHADER_ALPHA_CODE:Array;
      
      private static var _helpBindVector:Vector.<Number>;
      
      private var __vb3VertexBuffer:VertexBuffer3D;
      
      private var __aVertexVector:Vector.<Number>;
      
      private var __ib3QuadIndexBuffer:IndexBuffer3D;
      
      private var __ib3TriangleIndexBuffer:IndexBuffer3D;
      
      private var __iTriangleCount:int = 0;
      
      private var __bInitializedThisFrame:Boolean = false;
      
      private var __cActiveContextTexture:Texture;
      
      private var __iActiveFiltering:int;
      
      private var __bActiveAlpha:Boolean = false;
      
      private var __bUseSeparatedAlphaShaders:Boolean;
      
      private var __iActiveAtf:int = 0;
      
      private var __cActiveFilter:FFilter;
      
      private var __bDrawQuads:Boolean = true;
      
      private var __aCachedPrograms:Dictionary;
      
      private var __cContext:Context3D;
      
      private var vertexShader:AGALMiniAssembler;
      
      private var vertexShaderAlpha:AGALMiniAssembler;
      
      private function getCachedProgram(param1:Boolean, param2:int, param3:Boolean, param4:int, param5:FFilter) : Program3D {
         var _loc6_:* = (param1?1:0) << 31 | (param3?1:0) << 30 | (param2 & 1) << 29 | (param4 & 3) << 27 | (param5?param5.iId:0) & 65535;
         if(__aCachedPrograms[_loc6_] != null)
         {
            return __aCachedPrograms[_loc6_];
         }
         var _loc7_:Program3D = __cContext.createProgram();
         _loc7_.upload(param3?vertexShaderAlpha.agalcode:vertexShader.agalcode,FFragmentShadersCommon.getTexturedShaderCode(param1,param2,param3,param4,param5));
         __aCachedPrograms[_loc6_] = _loc7_;
         return _loc7_;
      }
      
      fl2d function initialize(param1:Context3D) : void {
         var _loc3_:* = 0;
         __cContext = param1;
         __bUseSeparatedAlphaShaders = FlEngine.getInstance().cConfig.useSeparatedAlphaShaders;
         __aCachedPrograms = new Dictionary();
         vertexShader = new AGALMiniAssembler();
         vertexShader.assemble("vertex",VERTEX_SHADER_CODE.join("\n"));
         vertexShaderAlpha = new AGALMiniAssembler();
         vertexShaderAlpha.assemble("vertex",VERTEX_SHADER_ALPHA_CODE.join("\n"));
         __aVertexVector = new Vector.<Number>(24000);
         __vb3VertexBuffer = __cContext.createVertexBuffer(3000,8);
         var _loc2_:Vector.<uint> = new Vector.<uint>();
         _loc3_ = 0;
         while(_loc3_ < 3000)
         {
            _loc2_.push(_loc3_);
            _loc3_++;
         }
         __ib3TriangleIndexBuffer = param1.createIndexBuffer(3000);
         __ib3TriangleIndexBuffer.uploadFromVector(_loc2_,0,3000);
         _loc2_.length = 0;
         _loc3_ = 0;
         while(_loc3_ < 500)
         {
            _loc2_ = _loc2_.concat(Vector.<uint>([4 * _loc3_,4 * _loc3_ + 1,4 * _loc3_ + 2,4 * _loc3_,4 * _loc3_ + 2,4 * _loc3_ + 3]));
            _loc3_++;
         }
         __ib3QuadIndexBuffer = param1.createIndexBuffer(3000);
         __ib3QuadIndexBuffer.uploadFromVector(_loc2_,0,3000);
         __iTriangleCount = 0;
      }
      
      fl2d function bind(param1:Context3D, param2:Boolean, param3:FCamera) : void {
         if(__aCachedPrograms == null || param2 && !__bInitializedThisFrame)
         {
            initialize(param1);
         }
         __bInitializedThisFrame = param2;
         __cContext.setProgram(getCachedProgram(true,FTextureBase.defaultFilteringType,__bActiveAlpha,__iActiveAtf,__cActiveFilter));
         __cContext.setProgramConstantsFromVector("vertex",4,param3.aCameraVector,2);
         __cContext.setProgramConstantsFromVector("fragment",0,_helpBindVector,1);
         __iTriangleCount = 0;
         __cActiveContextTexture = null;
         __iActiveFiltering = FTextureBase.defaultFilteringType;
         __cActiveFilter = null;
      }
      
      public function draw(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:FTexture, param11:FFilter) : void {
         __bDrawQuads = true;
         var _loc13_:Texture = param10.cContextTexture.tTexture;
         var _loc29_:* = !(__cActiveContextTexture == _loc13_);
         var _loc18_:* = !(__iActiveFiltering == param10.iFilteringType);
         var _loc31_:Boolean = !__bUseSeparatedAlphaShaders || !(param6 == 1) || !(param7 == 1) || !(param8 == 1) || !(param9 == 1);
         var _loc15_:* = !(__bActiveAlpha == _loc31_);
         var _loc27_:* = !(__iActiveAtf == param10.iAtfType);
         var _loc30_:* = !(__cActiveFilter == param11);
         if(_loc29_ || _loc18_ || _loc15_ || _loc27_)
         {
            if(__cActiveContextTexture != null)
            {
               push();
            }
            if(_loc29_)
            {
               __cActiveContextTexture = _loc13_;
               __cContext.setTextureAt(0,__cActiveContextTexture);
            }
            if(_loc18_ || _loc15_ || _loc27_)
            {
               __iActiveFiltering = param10.iFilteringType;
               __bActiveAlpha = _loc31_;
               __iActiveAtf = param10.iAtfType;
               if(__cActiveFilter)
               {
                  __cActiveFilter.clear(__cContext);
               }
               __cActiveFilter = param11;
               if(__cActiveFilter)
               {
                  __cActiveFilter.bind(__cContext,param10);
               }
               __cContext.setProgram(getCachedProgram(true,__iActiveFiltering,__bActiveAlpha,__iActiveAtf,__cActiveFilter));
            }
         }
         var _loc21_:Number = param10.uvX;
         var _loc16_:Number = param10.uvY;
         var _loc22_:Number = param10.uvScaleX;
         var _loc12_:Number = param10.uvScaleY;
         var _loc14_:Number = Math.cos(param5);
         var _loc28_:Number = Math.sin(param5);
         var _loc23_:Number = 0.5 * param3 * param10.iWidth;
         var _loc20_:Number = 0.5 * param4 * param10.iHeight;
         var _loc25_:Number = _loc14_ * _loc23_;
         var _loc26_:Number = _loc14_ * _loc20_;
         var _loc17_:Number = _loc28_ * _loc23_;
         var _loc19_:Number = _loc28_ * _loc20_;
         if(param10.premultiplied)
         {
            param6 = param6 * param9;
            param7 = param7 * param9;
            param8 = param8 * param9;
         }
         var _loc24_:int = 24 * __iTriangleCount;
         __aVertexVector[_loc24_] = -_loc25_ - _loc19_ + param1;
         __aVertexVector[_loc24_ + 1] = _loc26_ - _loc17_ + param2;
         __aVertexVector[_loc24_ + 2] = _loc21_;
         __aVertexVector[_loc24_ + 3] = _loc12_ + _loc16_;
         __aVertexVector[_loc24_ + 4] = param6;
         __aVertexVector[_loc24_ + 5] = param7;
         __aVertexVector[_loc24_ + 6] = param8;
         __aVertexVector[_loc24_ + 7] = param9;
         __aVertexVector[_loc24_ + 8] = -_loc25_ + _loc19_ + param1;
         __aVertexVector[_loc24_ + 9] = -_loc26_ - _loc17_ + param2;
         __aVertexVector[_loc24_ + 10] = _loc21_;
         __aVertexVector[_loc24_ + 11] = _loc16_;
         __aVertexVector[_loc24_ + 12] = param6;
         __aVertexVector[_loc24_ + 13] = param7;
         __aVertexVector[_loc24_ + 14] = param8;
         __aVertexVector[_loc24_ + 15] = param9;
         __aVertexVector[_loc24_ + 16] = _loc25_ + _loc19_ + param1;
         __aVertexVector[_loc24_ + 17] = -_loc26_ + _loc17_ + param2;
         __aVertexVector[_loc24_ + 18] = _loc22_ + _loc21_;
         __aVertexVector[_loc24_ + 19] = _loc16_;
         __aVertexVector[_loc24_ + 20] = param6;
         __aVertexVector[_loc24_ + 21] = param7;
         __aVertexVector[_loc24_ + 22] = param8;
         __aVertexVector[_loc24_ + 23] = param9;
         __aVertexVector[_loc24_ + 24] = _loc25_ - _loc19_ + param1;
         __aVertexVector[_loc24_ + 25] = _loc26_ + _loc17_ + param2;
         __aVertexVector[_loc24_ + 26] = _loc22_ + _loc21_;
         __aVertexVector[_loc24_ + 27] = _loc12_ + _loc16_;
         __aVertexVector[_loc24_ + 28] = param6;
         __aVertexVector[_loc24_ + 29] = param7;
         __aVertexVector[_loc24_ + 30] = param8;
         __aVertexVector[_loc24_ + 31] = param9;
         __iTriangleCount = __iTriangleCount + 2;
         if(__iTriangleCount == 1000)
         {
            push();
         }
      }
      
      public function drawPoly(param1:Vector.<Number>, param2:Vector.<Number>, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:Number, param12:FTexture, param13:FFilter) : void {
         var _loc25_:* = 0;
         __bDrawQuads = false;
         var _loc15_:Texture = param12.cContextTexture.tTexture;
         var _loc29_:* = !(__cActiveContextTexture == _loc15_);
         var _loc23_:* = !(__iActiveFiltering == param12.iFilteringType);
         var _loc31_:Boolean = !__bUseSeparatedAlphaShaders || !(param8 == 1) || !(param9 == 1) || !(param10 == 1) || !(param11 == 1);
         var _loc17_:* = !(__bActiveAlpha == _loc31_);
         var _loc27_:* = !(__iActiveAtf == param12.iAtfType);
         var _loc30_:* = !(__cActiveFilter == param13);
         if(_loc29_ || _loc23_ || _loc17_ || _loc27_)
         {
            if(__cActiveContextTexture != null)
            {
               push();
            }
            if(_loc29_)
            {
               __cActiveContextTexture = _loc15_;
               __cContext.setTextureAt(0,__cActiveContextTexture);
            }
            if(_loc23_ || _loc17_ || _loc27_)
            {
               __iActiveFiltering = param12.iFilteringType;
               __bActiveAlpha = _loc31_;
               __iActiveAtf = param12.iAtfType;
               if(__cActiveFilter)
               {
                  __cActiveFilter.clear(__cContext);
               }
               __cActiveFilter = param13;
               if(__cActiveFilter)
               {
                  __cActiveFilter.bind(__cContext,param12);
               }
               __cContext.setProgram(getCachedProgram(true,__iActiveFiltering,__bActiveAlpha,__iActiveAtf,__cActiveFilter));
            }
         }
         var _loc16_:Number = Math.cos(param7);
         var _loc28_:Number = Math.sin(param7);
         var _loc20_:Number = param12.nUvX;
         var _loc21_:Number = param12.nUvScaleX;
         var _loc18_:Number = param12.nUvY;
         var _loc19_:Number = param12.nUvScaleY;
         if(param12.premultiplied)
         {
            param8 = param8 * param11;
            param9 = param9 * param11;
            param10 = param10 * param11;
         }
         var _loc14_:int = param1.length;
         var _loc26_:* = _loc14_ >> 1;
         var _loc22_:int = _loc26_ / 3;
         if(__iTriangleCount + _loc22_ > 1000)
         {
            push();
         }
         var _loc24_:int = 24 * __iTriangleCount;
         _loc25_ = 0;
         while(_loc25_ < _loc14_)
         {
            __aVertexVector[_loc24_] = _loc16_ * param1[_loc25_] * param5 - _loc28_ * param1[_loc25_ + 1] * param6 + param3;
            __aVertexVector[_loc24_ + 1] = _loc28_ * param1[_loc25_] * param6 + _loc16_ * param1[_loc25_ + 1] * param5 + param4;
            __aVertexVector[_loc24_ + 2] = _loc20_ + param2[_loc25_] * _loc21_;
            __aVertexVector[_loc24_ + 3] = _loc18_ + param2[_loc25_ + 1] * _loc19_;
            __aVertexVector[_loc24_ + 4] = param8;
            __aVertexVector[_loc24_ + 5] = param9;
            __aVertexVector[_loc24_ + 6] = param10;
            __aVertexVector[_loc24_ + 7] = param11;
            _loc24_ = _loc24_ + 8;
            _loc25_ = _loc25_ + 2;
         }
         __iTriangleCount = __iTriangleCount + _loc22_;
         if(__iTriangleCount >= 1000)
         {
            push();
         }
      }
      
      public function drawMatrix(param1:Matrix, param2:Number, param3:Number, param4:Number, param5:Number, param6:FTexture, param7:FFilter) : void {
         __bDrawQuads = true;
         var _loc9_:Texture = param6.cContextTexture.tTexture;
         var _loc14_:* = !(__cActiveContextTexture == _loc9_);
         var _loc16_:* = !(__iActiveFiltering == param6.iFilteringType);
         var _loc17_:Boolean = !__bUseSeparatedAlphaShaders || !(param2 == 1 && param3 == 1 && param4 == 1 && param5 == 1);
         var _loc10_:* = !(__bActiveAlpha == _loc17_);
         var _loc13_:* = !(__iActiveAtf == param6.iAtfType);
         var _loc15_:* = !(__cActiveFilter == param7);
         if(_loc14_ || _loc16_ || _loc10_ || _loc13_)
         {
            if(__cActiveContextTexture != null)
            {
               push();
            }
            if(_loc14_)
            {
               __cActiveContextTexture = _loc9_;
               __cContext.setTextureAt(0,__cActiveContextTexture);
            }
            if(_loc16_ || _loc10_ || _loc13_)
            {
               __iActiveFiltering = param6.iFilteringType;
               __bActiveAlpha = _loc17_;
               __iActiveAtf = param6.iAtfType;
               if(__cActiveFilter)
               {
                  __cActiveFilter.clear(__cContext);
               }
               __cActiveFilter = param7;
               if(__cActiveFilter)
               {
                  __cActiveFilter.bind(__cContext,param6);
               }
               __cContext.setProgram(getCachedProgram(true,__iActiveFiltering,__bActiveAlpha,__iActiveAtf,__cActiveFilter));
            }
         }
         if(param6.premultiplied)
         {
            param2 = param2 * param5;
            param3 = param3 * param5;
            param4 = param4 * param5;
         }
         var _loc8_:int = 16 * __iTriangleCount;
         var _loc12_:Number = 0.5 * param6.iWidth;
         var _loc11_:Number = 0.5 * param6.iHeight;
         __aVertexVector[_loc8_] = param1.a * -_loc12_ + param1.c * _loc11_ + param1.tx;
         __aVertexVector[_loc8_ + 1] = param1.d * _loc11_ + param1.b * -_loc12_ + param1.ty;
         __aVertexVector[_loc8_ + 2] = param6.uvX;
         __aVertexVector[_loc8_ + 3] = param6.uvScaleY + param6.uvY;
         __aVertexVector[_loc8_ + 4] = param2;
         __aVertexVector[_loc8_ + 5] = param3;
         __aVertexVector[_loc8_ + 6] = param4;
         __aVertexVector[_loc8_ + 7] = param5;
         __aVertexVector[_loc8_ + 8] = param1.a * -_loc12_ + param1.c * -_loc11_ + param1.tx;
         __aVertexVector[_loc8_ + 9] = param1.d * -_loc11_ + param1.b * -_loc12_ + param1.ty;
         __aVertexVector[_loc8_ + 10] = param6.uvX;
         __aVertexVector[_loc8_ + 11] = param6.uvY;
         __aVertexVector[_loc8_ + 12] = param2;
         __aVertexVector[_loc8_ + 13] = param3;
         __aVertexVector[_loc8_ + 14] = param4;
         __aVertexVector[_loc8_ + 15] = param5;
         __aVertexVector[_loc8_ + 16] = param1.a * _loc12_ + param1.c * -_loc11_ + param1.tx;
         __aVertexVector[_loc8_ + 17] = param1.d * -_loc11_ + param1.b * _loc12_ + param1.ty;
         __aVertexVector[_loc8_ + 18] = param6.uvScaleX + param6.uvX;
         __aVertexVector[_loc8_ + 19] = param6.uvY;
         __aVertexVector[_loc8_ + 20] = param2;
         __aVertexVector[_loc8_ + 21] = param3;
         __aVertexVector[_loc8_ + 22] = param4;
         __aVertexVector[_loc8_ + 23] = param5;
         __aVertexVector[_loc8_ + 24] = param1.a * _loc12_ + param1.c * _loc11_ + param1.tx;
         __aVertexVector[_loc8_ + 25] = param1.d * _loc11_ + param1.b * _loc12_ + param1.ty;
         __aVertexVector[_loc8_ + 26] = param6.uvScaleX + param6.uvX;
         __aVertexVector[_loc8_ + 27] = param6.uvScaleY + param6.uvY;
         __aVertexVector[_loc8_ + 28] = param2;
         __aVertexVector[_loc8_ + 29] = param3;
         __aVertexVector[_loc8_ + 30] = param4;
         __aVertexVector[_loc8_ + 31] = param5;
         __iTriangleCount = __iTriangleCount + 2;
         if(__iTriangleCount == 1000)
         {
            push();
         }
      }
      
      public function push() : void {
         FStats.iDrawCalls++;
         __vb3VertexBuffer.uploadFromVector(__aVertexVector,0,3000);
         __cContext.setVertexBufferAt(0,__vb3VertexBuffer,0,"float2");
         __cContext.setVertexBufferAt(1,__vb3VertexBuffer,2,"float2");
         __cContext.setVertexBufferAt(2,__vb3VertexBuffer,4,"float4");
         if(__bDrawQuads)
         {
            __cContext.drawTriangles(__ib3QuadIndexBuffer,0,__iTriangleCount);
         }
         else
         {
            __cContext.drawTriangles(__ib3TriangleIndexBuffer,0,__iTriangleCount);
         }
         __iTriangleCount = 0;
      }
      
      public function clear() : void {
         __cContext.setTextureAt(0,null);
         __cContext.setVertexBufferAt(0,null);
         __cContext.setVertexBufferAt(1,null);
         __cContext.setVertexBufferAt(2,null);
         __cActiveContextTexture = null;
         if(__cActiveFilter)
         {
            __cActiveFilter.clear(__cContext);
         }
         __cActiveFilter = null;
         __iActiveFiltering = FTextureBase.defaultFilteringType;
      }
   }
}
