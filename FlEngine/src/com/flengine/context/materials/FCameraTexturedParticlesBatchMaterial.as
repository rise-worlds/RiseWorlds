package com.flengine.context.materials
{
    import __AS3__.vec.*;
    import com.adobe.utils.*;
    import com.flengine.components.*;
    import com.flengine.context.materials.*;
    import flash.display3D.*;
    import flash.display3D.textures.*;
    import flash.utils.*;

    public class FCameraTexturedParticlesBatchMaterial extends Object implements IGMaterial
    {
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
        private static const DATA_PER_VERTEX:int = 10;
        private static const NORMALIZED_VERTICES:Vector.<Number> = FCameraTexturedParticlesBatchMaterial.Vector.<Number>([-0.5, 0.5, -0.5, -0.5, 0.5, -0.5, 0.5, 0.5]);
        private static const NORMALIZED_UVS:Vector.<Number> = FCameraTexturedParticlesBatchMaterial.Vector.<Number>([0, 1, 0, 0, 1, 0, 1, 1]);
        private static const VERTEX_SHADER_CODE:Array = ["mov vt0, va0", "mov vt1, va1", "mov vt2, va2", "mov vt3, va3", "mov vt4, va4", "sub vt6.x, vc8.y, va4.x", "div vt6.x, vt6.x, va4.y", "frc vt6.x, vt6.x", "sat vt6.x, vt6.x", "sub vt6.y, vc8.w, vt6.x", "mul vt1.x, vt6.y, va3.x", "mul vt1.y, vt6.x, va3.y", "add vt1.x, vt1.x, vt1.y", "mul vt2.xy, vt1.xx, vc6.zw", "mul vt5.xy, va0.xy, vt2.xy", "mul vt1.xy, va2.zw, vt6.xx", "add vt1.xy, vt5.xy, vt1.xy", "add vt5.xy, vt1.xy, va2.xy", "mov vt4.x, vc8.x", "sin vt2.x, vt4.x", "cos vt2.y, vt4.x", "mul vt3.x, vt5.x, vt2.y", "mul vt3.y, vt5.y, vt2.x", "sub vt4.x, vt3.x, vt3.y", "mul vt3.y, vt5.y, vt2.y", "mul vt3.x, vt5.x, vt2.x", "add vt4.y, vt3.y, vt3.x", "add vt1.xy, vt4.xy, vc6.xy", "sub vt1.xy, vt1.xy, vc5.xy", "mul vt1.xy, vt1.xy, vc5.zw", "mov vt4.x, vc4.x", "sin vt2.x, vt4.x", "cos vt2.y, vt4.x", "mul vt3.x, vt1.x, vt2.y", "mul vt3.y, vt1.y, vt2.x", "sub vt4.x, vt3.x, vt3.y", "mul vt3.y, vt1.y, vt2.y", "mul vt3.x, vt1.x, vt2.x", "add vt4.y, vt3.y, vt3.x", "add vt1, vt4.xy, vc4.yz", "mov vt1.zw, vt0.zw", "m44 op, vt1, vc0", "mul vt0.xy, va1.xy, vc7.zw", "add vt0.xy, vt0.xy, vc7.xy", "mov v0, vt0", "mul vt1.x, vt6.y, va3.z", "mul vt1.y, vt6.x, va3.w", "add vt1.x, vt1.x, vt1.y", "mov vt2, vc9", "mul vt2.w, vt2.w, vt1.x", "mov v1, vt2"];
        private static var __aCached:Dictionary = new Dictionary();

        public function FCameraTexturedParticlesBatchMaterial()
        {
            VertexShaderEmbed = FCameraTexturedParticlesBatchMaterialVertex_ash;
            VertexShaderCode = new VertexShaderEmbed() as ByteArray;
            return;
        }// end function

        public function bind(param1:Context3D, param2:Boolean, param3:FCamera, param4:Vector.<Number>) : void
        {
            var _loc_7:* = 0;
            var _loc_10:* = 0;
            var _loc_8:* = undefined;
            var _loc_6:* = 0;
            var _loc_9:* = undefined;
            var _loc_5:* = null;
            __cContext = param1;
            if (!param2)
            {
                __bReinitialized = false;
            }
            if (__bReinitialized)
            {
                param2 = false;
            }
            if (param2)
            {
                __bReinitialized = true;
            }
            if (_p3ShaderProgram == null || param2 && !__bInitializedThisFrame)
            {
                VertexShaderCode.endian = "littleEndian";
                _loc_5 = new AGALMiniAssembler();
                _loc_5.assemble("vertex", VERTEX_SHADER_CODE.join("\n"));
                _p3ShaderProgram = __cContext.createProgram();
                _p3ShaderProgram.upload(_loc_5.agalcode, FFragmentShadersCommon.getTexturedShaderCode(true, 1, true, __iActiveAtf));
                _loc_7 = param4.length / 10;
                _loc_8 = new Vector.<Number>;
                _loc_10 = 0;
                while (_loc_10 < _loc_7)
                {
                    
                    _loc_6 = _loc_10 * 10;
                    _loc_8.push(NORMALIZED_VERTICES[0], NORMALIZED_VERTICES[1]);
                    _loc_8.push(NORMALIZED_UVS[0], NORMALIZED_UVS[1]);
                    _loc_8.push(param4[_loc_6], param4[(_loc_6 + 1)], param4[_loc_6 + 2], param4[_loc_6 + 3]);
                    _loc_8.push(param4[_loc_6 + 4], param4[_loc_6 + 5], param4[_loc_6 + 6], param4[_loc_6 + 7]);
                    _loc_8.push(param4[_loc_6 + 8], param4[_loc_6 + 9]);
                    _loc_8.push(NORMALIZED_VERTICES[2], NORMALIZED_VERTICES[3]);
                    _loc_8.push(NORMALIZED_UVS[2], NORMALIZED_UVS[3]);
                    _loc_8.push(param4[_loc_6], param4[(_loc_6 + 1)], param4[_loc_6 + 2], param4[_loc_6 + 3]);
                    _loc_8.push(param4[_loc_6 + 4], param4[_loc_6 + 5], param4[_loc_6 + 6], param4[_loc_6 + 7]);
                    _loc_8.push(param4[_loc_6 + 8], param4[_loc_6 + 9]);
                    _loc_8.push(NORMALIZED_VERTICES[4], NORMALIZED_VERTICES[5]);
                    _loc_8.push(NORMALIZED_UVS[4], NORMALIZED_UVS[5]);
                    _loc_8.push(param4[_loc_6], param4[(_loc_6 + 1)], param4[_loc_6 + 2], param4[_loc_6 + 3]);
                    _loc_8.push(param4[_loc_6 + 4], param4[_loc_6 + 5], param4[_loc_6 + 6], param4[_loc_6 + 7]);
                    _loc_8.push(param4[_loc_6 + 8], param4[_loc_6 + 9]);
                    _loc_8.push(NORMALIZED_VERTICES[6], NORMALIZED_VERTICES[7]);
                    _loc_8.push(NORMALIZED_UVS[6], NORMALIZED_UVS[7]);
                    _loc_8.push(param4[_loc_6], param4[(_loc_6 + 1)], param4[_loc_6 + 2], param4[_loc_6 + 3]);
                    _loc_8.push(param4[_loc_6 + 4], param4[_loc_6 + 5], param4[_loc_6 + 6], param4[_loc_6 + 7]);
                    _loc_8.push(param4[_loc_6 + 8], param4[_loc_6 + 9]);
                    _loc_10++;
                }
                __vb3VertexBuffer = __cContext.createVertexBuffer(4 * _loc_7, 14);
                __vb3VertexBuffer.uploadFromVector(_loc_8, 0, 4 * _loc_7);
                _loc_9 = new Vector.<uint>;
                _loc_10 = 0;
                while (_loc_10 < _loc_7)
                {
                    
                    _loc_9 = _loc_9.concat(this.Vector.<uint>([4 * _loc_10, 4 * _loc_10 + 1, 4 * _loc_10 + 2, 4 * _loc_10, 4 * _loc_10 + 2, 4 * _loc_10 + 3]));
                    _loc_10++;
                }
                __ib3IndexBuffer = __cContext.createIndexBuffer(6 * _loc_7);
                __ib3IndexBuffer.uploadFromVector(_loc_9, 0, 6 * _loc_7);
            }
            __bInitializedThisFrame = param2;
            __cContext.setProgram(_p3ShaderProgram);
            __cContext.setProgramConstantsFromVector("vertex", 4, param3.aCameraVector, 2);
            __cContext.setProgramConstantsFromVector("fragment", 1, this.Vector.<Number>([1, 1, 0, 0.1]), 1);
            __cContext.setVertexBufferAt(0, __vb3VertexBuffer, 0, "float2");
            __cContext.setVertexBufferAt(1, __vb3VertexBuffer, 2, "float2");
            __cContext.setVertexBufferAt(2, __vb3VertexBuffer, 4, "float4");
            __cContext.setVertexBufferAt(3, __vb3VertexBuffer, 8, "float4");
            __cContext.setVertexBufferAt(4, __vb3VertexBuffer, 12, "float2");
            return;
        }// end function

        public function draw(param1:Vector.<Number>, param2:Texture, param3:int, param4:int) : void
        {
            __cContext.setTextureAt(0, param2);
            __cContext.setProgramConstantsFromVector("vertex", 6, param1, 4);
            __cContext.drawTriangles(__ib3IndexBuffer, 0, param4 * 2);
            return;
        }// end function

        public function push() : void
        {
            return;
        }// end function

        public function clear() : void
        {
            __cContext.setTextureAt(0, null);
            __cContext.setVertexBufferAt(0, null);
            __cContext.setVertexBufferAt(1, null);
            __cContext.setVertexBufferAt(2, null);
            __cContext.setVertexBufferAt(3, null);
            __cContext.setVertexBufferAt(4, null);
            __cActiveTexture = null;
            __iActiveFiltering = 0;
            return;
        }// end function

        public static function getByHash(param1:String) : FCameraTexturedParticlesBatchMaterial
        {
            var _loc_2:* = __aCached[param1];
            if (_loc_2 == null)
            {
                _loc_2 = new FCameraTexturedParticlesBatchMaterial;
                __aCached[param1] = _loc_2;
            }
            return _loc_2;
        }// end function

    }
}
