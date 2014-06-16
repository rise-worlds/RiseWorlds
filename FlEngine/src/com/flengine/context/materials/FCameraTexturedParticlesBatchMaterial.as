package com.flengine.context.materials
{
   import flash.utils.Dictionary;
   import flash.utils.ByteArray;
   import flash.display3D.Program3D;
   import flash.display3D.VertexBuffer3D;
   import flash.display3D.IndexBuffer3D;
   import flash.display3D.textures.Texture;
   import flash.display3D.Context3D;
   import com.flengine.components.FCamera;
   import com.adobe.utils.AGALMiniAssembler;
   
   public class FCameraTexturedParticlesBatchMaterial extends Object implements IGMaterial
   {
      
      public function FCameraTexturedParticlesBatchMaterial() {
         VertexShaderEmbed = FCameraTexturedParticlesBatchMaterialVertex_ash;
         VertexShaderCode = new VertexShaderEmbed() as ByteArray;
         super();
      }
      
      private static const DATA_PER_VERTEX:int = 10;
      
      private static const NORMALIZED_VERTICES:Vector.<Number>;
      
      private static const NORMALIZED_UVS:Vector.<Number>;
      
      private static const VERTEX_SHADER_CODE:Array;
      
      private static var __aCached:Dictionary;
      
      public static function getByHash(param1:String) : FCameraTexturedParticlesBatchMaterial {
         var _loc2_:FCameraTexturedParticlesBatchMaterial = __aCached[param1];
         if(_loc2_ == null)
         {
            _loc2_ = new FCameraTexturedParticlesBatchMaterial();
            __aCached[param1] = _loc2_;
         }
         return _loc2_;
      }
      
      private const VertexShaderEmbed:Class;
      
      private const VertexShaderCode:ByteArray;
      
      private var _p3ShaderProgram:Program3D;
      
      private var __vb3VertexBuffer:VertexBuffer3D;
      
      private var __ib3IndexBuffer:IndexBuffer3D;
      
      private var __iActiveAtf:int = 0;
      
      private var __iActiveFiltering:int = 0;
      
      private var __cActiveTexture:Texture;
      
      private var __bReinitialized:Boolean = false;
      
      private var __bInitializedThisFrame:Boolean = false;
      
      private var __cContext:Context3D;
      
      public function bind(param1:Context3D, param2:Boolean, param3:FCamera, param4:Vector.<Number>) : void {
         var _loc7_:* = 0;
         var _loc10_:* = 0;
         var _loc8_:* = undefined;
         var _loc6_:* = 0;
         var _loc9_:* = undefined;
         var _loc5_:AGALMiniAssembler = null;
         __cContext = param1;
         if(!param2)
         {
            __bReinitialized = false;
         }
         if(__bReinitialized)
         {
            param2 = false;
         }
         if(param2)
         {
            __bReinitialized = true;
         }
         if(_p3ShaderProgram == null || param2 && !__bInitializedThisFrame)
         {
            VertexShaderCode.endian = "littleEndian";
            _loc5_ = new AGALMiniAssembler();
            _loc5_.assemble("vertex",VERTEX_SHADER_CODE.join("\n"));
            _p3ShaderProgram = __cContext.createProgram();
            _p3ShaderProgram.upload(_loc5_.agalcode,FFragmentShadersCommon.getTexturedShaderCode(true,1,true,__iActiveAtf));
            _loc7_ = param4.length / 10;
            _loc8_ = new Vector.<Number>();
            _loc10_ = 0;
            while(_loc10_ < _loc7_)
            {
               _loc6_ = _loc10_ * 10;
               _loc8_.push(NORMALIZED_VERTICES[0],NORMALIZED_VERTICES[1]);
               _loc8_.push(NORMALIZED_UVS[0],NORMALIZED_UVS[1]);
               _loc8_.push(param4[_loc6_],param4[_loc6_ + 1],param4[_loc6_ + 2],param4[_loc6_ + 3]);
               _loc8_.push(param4[_loc6_ + 4],param4[_loc6_ + 5],param4[_loc6_ + 6],param4[_loc6_ + 7]);
               _loc8_.push(param4[_loc6_ + 8],param4[_loc6_ + 9]);
               _loc8_.push(NORMALIZED_VERTICES[2],NORMALIZED_VERTICES[3]);
               _loc8_.push(NORMALIZED_UVS[2],NORMALIZED_UVS[3]);
               _loc8_.push(param4[_loc6_],param4[_loc6_ + 1],param4[_loc6_ + 2],param4[_loc6_ + 3]);
               _loc8_.push(param4[_loc6_ + 4],param4[_loc6_ + 5],param4[_loc6_ + 6],param4[_loc6_ + 7]);
               _loc8_.push(param4[_loc6_ + 8],param4[_loc6_ + 9]);
               _loc8_.push(NORMALIZED_VERTICES[4],NORMALIZED_VERTICES[5]);
               _loc8_.push(NORMALIZED_UVS[4],NORMALIZED_UVS[5]);
               _loc8_.push(param4[_loc6_],param4[_loc6_ + 1],param4[_loc6_ + 2],param4[_loc6_ + 3]);
               _loc8_.push(param4[_loc6_ + 4],param4[_loc6_ + 5],param4[_loc6_ + 6],param4[_loc6_ + 7]);
               _loc8_.push(param4[_loc6_ + 8],param4[_loc6_ + 9]);
               _loc8_.push(NORMALIZED_VERTICES[6],NORMALIZED_VERTICES[7]);
               _loc8_.push(NORMALIZED_UVS[6],NORMALIZED_UVS[7]);
               _loc8_.push(param4[_loc6_],param4[_loc6_ + 1],param4[_loc6_ + 2],param4[_loc6_ + 3]);
               _loc8_.push(param4[_loc6_ + 4],param4[_loc6_ + 5],param4[_loc6_ + 6],param4[_loc6_ + 7]);
               _loc8_.push(param4[_loc6_ + 8],param4[_loc6_ + 9]);
               _loc10_++;
            }
            __vb3VertexBuffer = __cContext.createVertexBuffer(4 * _loc7_,14);
            __vb3VertexBuffer.uploadFromVector(_loc8_,0,4 * _loc7_);
            _loc9_ = new Vector.<uint>();
            _loc10_ = 0;
            while(_loc10_ < _loc7_)
            {
               _loc9_ = _loc9_.concat(Vector.<uint>([4 * _loc10_,4 * _loc10_ + 1,4 * _loc10_ + 2,4 * _loc10_,4 * _loc10_ + 2,4 * _loc10_ + 3]));
               _loc10_++;
            }
            __ib3IndexBuffer = __cContext.createIndexBuffer(6 * _loc7_);
            __ib3IndexBuffer.uploadFromVector(_loc9_,0,6 * _loc7_);
         }
         __bInitializedThisFrame = param2;
         __cContext.setProgram(_p3ShaderProgram);
         __cContext.setProgramConstantsFromVector("vertex",4,param3.aCameraVector,2);
         __cContext.setProgramConstantsFromVector("fragment",1,Vector.<Number>([1,1,0,0.1]),1);
         __cContext.setVertexBufferAt(0,__vb3VertexBuffer,0,"float2");
         __cContext.setVertexBufferAt(1,__vb3VertexBuffer,2,"float2");
         __cContext.setVertexBufferAt(2,__vb3VertexBuffer,4,"float4");
         __cContext.setVertexBufferAt(3,__vb3VertexBuffer,8,"float4");
         __cContext.setVertexBufferAt(4,__vb3VertexBuffer,12,"float2");
      }
      
      public function draw(param1:Vector.<Number>, param2:Texture, param3:int, param4:int) : void {
         __cContext.setTextureAt(0,param2);
         __cContext.setProgramConstantsFromVector("vertex",6,param1,4);
         __cContext.drawTriangles(__ib3IndexBuffer,0,param4 * 2);
      }
      
      public function push() : void {
      }
      
      public function clear() : void {
         __cContext.setTextureAt(0,null);
         __cContext.setVertexBufferAt(0,null);
         __cContext.setVertexBufferAt(1,null);
         __cContext.setVertexBufferAt(2,null);
         __cContext.setVertexBufferAt(3,null);
         __cContext.setVertexBufferAt(4,null);
         __cActiveTexture = null;
         __iActiveFiltering = 0;
      }
   }
}
