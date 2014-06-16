package com.flengine.context.materials
{
   import flash.utils.ByteArray;
   import flash.display3D.VertexBuffer3D;
   import flash.display3D.IndexBuffer3D;
   import flash.display3D.textures.Texture;
   import com.flengine.context.filters.FFilter;
   import flash.utils.Dictionary;
   import flash.display3D.Context3D;
   import flash.display3D.Program3D;
   import com.flengine.core.FlEngine;
   import com.flengine.components.FCamera;
   import com.flengine.textures.FTextureBase;
   import flash.geom.Matrix;
   import com.flengine.textures.FTexture;
   import com.flengine.core.FStats;
   
   public class FDrawTextureCameraVertexShaderBatchMaterial2 extends Object implements IGMaterial
   {
      
      public function FDrawTextureCameraVertexShaderBatchMaterial2() {
         VertexShaderEmbed = FCameraTexturedQuadVertexShaderBatchMaterialVertex2_ash;
         VertexShaderCode = new VertexShaderEmbed() as ByteArray;
         VertexShaderNoAlphaEmbed = FCameraTexturedQuadVertexShaderBatchMaterialVertexNoAlpha2_ash;
         VertexShaderNoAlphaCode = new VertexShaderNoAlphaEmbed() as ByteArray;
         super();
      }
      
      private static const NORMALIZED_VERTICES:Vector.<Number>;
      
      private static const NORMALIZED_UVS:Vector.<Number>;
      
      private static var _helpBindVector:Vector.<Number>;
      
      private const CONSTANTS_OFFSET:int = 6;
      
      private const BATCH_CONSTANTS:int = 122;
      
      private const CONSTANTS_PER_BATCH:int = 4;
      
      private const BATCH_SIZE:int = 30;
      
      private const VertexShaderEmbed:Class;
      
      private const VertexShaderCode:ByteArray;
      
      private const VertexShaderNoAlphaEmbed:Class;
      
      private const VertexShaderNoAlphaCode:ByteArray;
      
      private var __vb3VertexBuffer:VertexBuffer3D;
      
      private var __vb3UVBuffer:VertexBuffer3D;
      
      private var __vb3RegisterIndexBuffer:VertexBuffer3D;
      
      private var __ib3Indexbuffer:IndexBuffer3D;
      
      private var __bInitializedThisFrame:Boolean = false;
      
      private var __iQuadCount:int = 0;
      
      private var __iConstantsOffset:int = 0;
      
      private var __cActiveContextTexture:Texture;
      
      private var __iActiveFiltering:int;
      
      private var __bActiveAlpha:Boolean = true;
      
      private var __iActiveAtf:int = 0;
      
      private var __cActiveFilter:FFilter;
      
      private var __bUseFastMem:Boolean = true;
      
      private var __bUseSeparatedAlphaShaders:Boolean;
      
      private var __aCachedPrograms:Dictionary;
      
      private var __cContext:Context3D;
      
      private var __aVertexConstants:Vector.<Number>;
      
      private var __baVertexArray:ByteArray;
      
      private function getCachedProgram(param1:Boolean, param2:int, param3:Boolean, param4:int, param5:FFilter) : Program3D {
         var _loc6_:* = (param1?1:0) << 31 | (param3?1:0) << 30 | (param2 & 1) << 29 | (param4 & 3) << 27 | (param5?param5.iId:0) & 65535;
         if(__aCachedPrograms[_loc6_] != null)
         {
            return __aCachedPrograms[_loc6_];
         }
         var _loc7_:Program3D = __cContext.createProgram();
         _loc7_.upload(param3?VertexShaderCode:VertexShaderNoAlphaCode,FFragmentShadersCommon.getTexturedShaderCode(true,param2,param3,param4,param5));
         __aCachedPrograms[_loc6_] = _loc7_;
         return _loc7_;
      }
      
      fl2d function initialize(param1:Context3D) : void {
         var _loc7_:* = 0;
         var _loc3_:* = 0;
         __cContext = param1;
         __bUseSeparatedAlphaShaders = FlEngine.getInstance().cConfig.useSeparatedAlphaShaders;
         __bUseFastMem = FlEngine.getInstance().cConfig.useFastMem;
         VertexShaderCode.endian = "littleEndian";
         VertexShaderNoAlphaCode.endian = "littleEndian";
         __aCachedPrograms = new Dictionary();
         var _loc4_:Vector.<Number> = new Vector.<Number>();
         var _loc6_:Vector.<Number> = new Vector.<Number>();
         var _loc2_:Vector.<Number> = new Vector.<Number>();
         _loc7_ = 0;
         while(_loc7_ < 30)
         {
            _loc4_ = _loc4_.concat(NORMALIZED_VERTICES);
            _loc6_ = _loc6_.concat(NORMALIZED_UVS);
            _loc3_ = 6 + _loc7_ * 4;
            _loc2_.push(_loc3_,_loc3_ + 1,_loc3_ + 2,_loc3_ + 3);
            _loc2_.push(_loc3_,_loc3_ + 1,_loc3_ + 2,_loc3_ + 3);
            _loc2_.push(_loc3_,_loc3_ + 1,_loc3_ + 2,_loc3_ + 3);
            _loc2_.push(_loc3_,_loc3_ + 1,_loc3_ + 2,_loc3_ + 3);
            _loc7_++;
         }
         __vb3VertexBuffer = __cContext.createVertexBuffer(4 * 30,2);
         __vb3VertexBuffer.uploadFromVector(_loc4_,0,4 * 30);
         __vb3UVBuffer = __cContext.createVertexBuffer(4 * 30,2);
         __vb3UVBuffer.uploadFromVector(_loc6_,0,4 * 30);
         __vb3RegisterIndexBuffer = __cContext.createVertexBuffer(4 * 30,4);
         __vb3RegisterIndexBuffer.uploadFromVector(_loc2_,0,4 * 30);
         var _loc5_:Vector.<uint> = new Vector.<uint>();
         _loc7_ = 0;
         while(_loc7_ < 30)
         {
            _loc5_ = _loc5_.concat(Vector.<uint>([4 * _loc7_,4 * _loc7_ + 1,4 * _loc7_ + 2,4 * _loc7_,4 * _loc7_ + 2,4 * _loc7_ + 3]));
            _loc7_++;
         }
         __ib3Indexbuffer = __cContext.createIndexBuffer(6 * 30);
         __ib3Indexbuffer.uploadFromVector(_loc5_,0,6 * 30);
         __aVertexConstants = new Vector.<Number>(122 * 4);
         __baVertexArray = new ByteArray();
         __baVertexArray.endian = "littleEndian";
         __baVertexArray.length = 2048;
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
         __cContext.setVertexBufferAt(0,__vb3VertexBuffer,0,"float2");
         __cContext.setVertexBufferAt(1,__vb3UVBuffer,0,"float2");
         __cContext.setVertexBufferAt(2,__vb3RegisterIndexBuffer,0,"float4");
         __iQuadCount = 0;
         __cActiveContextTexture = null;
         __iActiveFiltering = FTextureBase.defaultFilteringType;
         __cActiveFilter = null;
      }
      
      public function draw(param1:Matrix, param2:Number, param3:Number, param4:Number, param5:Number, param6:FTexture, param7:FFilter) : void {
         var _loc8_:Texture = param6.cContextTexture.tTexture;
         var _loc10_:* = !(__cActiveContextTexture == _loc8_);
         var _loc12_:* = !(__iActiveFiltering == param6.iFilteringType);
         var _loc13_:Boolean = !__bUseSeparatedAlphaShaders || !(param2 == 1) || !(param3 == 1) || !(param4 == 1) || !(param5 == 1);
         var _loc14_:* = !(__bActiveAlpha == _loc13_);
         var _loc9_:* = !(__iActiveAtf == param6.iAtfType);
         var _loc11_:* = !(__cActiveFilter == param7);
         if(_loc10_ || _loc12_ || _loc14_ || _loc9_ || _loc11_)
         {
            if(__cActiveContextTexture != null)
            {
               push();
            }
            if(_loc10_)
            {
               __cActiveContextTexture = _loc8_;
               __cContext.setTextureAt(0,_loc8_);
            }
            if(_loc12_ || _loc14_ || _loc9_ || _loc11_)
            {
               __iActiveFiltering = param6.iFilteringType;
               __bActiveAlpha = _loc13_;
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
         __iConstantsOffset = __iQuadCount << 4;
         __aVertexConstants[__iConstantsOffset] = param1.a;
         __aVertexConstants[__iConstantsOffset + 1] = param1.b;
         __aVertexConstants[__iConstantsOffset + 2] = param1.c;
         __aVertexConstants[__iConstantsOffset + 3] = param1.d;
         __aVertexConstants[__iConstantsOffset + 4] = param1.tx - (param1.a * param6.pivotX + param1.c * param6.pivotY);
         __aVertexConstants[__iConstantsOffset + 5] = param1.ty - (param1.d * param6.pivotY + param1.b * param6.pivotX);
         __aVertexConstants[__iConstantsOffset + 6] = param6.iWidth;
         __aVertexConstants[__iConstantsOffset + 7] = param6.iHeight;
         __aVertexConstants[__iConstantsOffset + 8] = param6.uvX;
         __aVertexConstants[__iConstantsOffset + 9] = param6.uvY;
         __aVertexConstants[__iConstantsOffset + 10] = param6.uvScaleX;
         __aVertexConstants[__iConstantsOffset + 11] = param6.uvScaleY;
         __aVertexConstants[__iConstantsOffset + 12] = param2;
         __aVertexConstants[__iConstantsOffset + 13] = param3;
         __aVertexConstants[__iConstantsOffset + 14] = param4;
         __aVertexConstants[__iConstantsOffset + 15] = param5;
         __iQuadCount = __iQuadCount + 1;
         if(__iQuadCount == 30)
         {
            push();
         }
      }
      
      public function push() : void {
         if(__iQuadCount == 0)
         {
            return;
         }
         if(__bUseFastMem)
         {
            __cContext.setProgramConstantsFromByteArray("vertex",6,122,__baVertexArray,0);
         }
         else
         {
            __cContext.setProgramConstantsFromVector("vertex",6,__aVertexConstants,122);
         }
         FStats.iDrawCalls++;
         __cContext.drawTriangles(__ib3Indexbuffer,0,__iQuadCount * 2);
         __iQuadCount = 0;
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
      }
   }
}
