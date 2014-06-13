package com.flengine.context.materials
{
    import __AS3__.vec.*;
    import com.flengine.context.materials.*;
    import com.flengine.core.*;
    import com.flengine.textures.*;
    import flash.display3D.*;
    import flash.display3D.textures.*;
    import flash.system.*;
    import flash.utils.*;

    final public class FBlitTexturedVertexShaderBatchMaterial extends Object implements IGMaterial
    {
        private const BATCH_CONSTANTS:int = 124;
        private const CONSTANTS_PER_BATCH:int = 2;
        private const BATCH_SIZE:int = 62;
        private const VertexShaderEmbed:Class;
        private const VertexShaderCode:ByteArray;
        private var __vb3VertexBuffer:VertexBuffer3D;
        private var __vb3UVBuffer:VertexBuffer3D;
        private var __vb3RegisterIndexBuffer:VertexBuffer3D;
        private var __ib3IndexBuffer:IndexBuffer3D;
        private var __bInitializedThisFrame:Boolean;
        private var __iQuadCount:int = 0;
        private var __cActiveContextTexture:Texture;
        private var __aVertexConstants:Vector.<Number>;
        private var __baVertexArray:ByteArray;
        private var __iConstantsOffset:int = 0;
        private var __iActiveAtf:int = 0;
        private var __bUseFastMem:Boolean = false;
        private var __cContext:Context3D;
        private var __aCachedPrograms:Dictionary;
        private static const NORMALIZED_VERTICES:Vector.<Number> = FBlitTexturedVertexShaderBatchMaterial.Vector.<Number>([-0.5, 0.5, -0.5, -0.5, 0.5, -0.5, 0.5, 0.5]);
        private static const NORMALIZED_UVS:Vector.<Number> = FBlitTexturedVertexShaderBatchMaterial.Vector.<Number>([0, 1, 0, 0, 1, 0, 1, 1]);
        private static var _helpBindFloat2:String = "float2";

        public function FBlitTexturedVertexShaderBatchMaterial()
        {
            VertexShaderEmbed = FBlitTexturedVertexShaderBatchMaterialVertex_ash;
            VertexShaderCode = new VertexShaderEmbed() as ByteArray;
            __aVertexConstants = new Vector.<Number>(496);
            return;
        }

        private function getCachedProgram(param1:Boolean, param2:int, param3:int) : Program3D
        {
            var _loc_4:* = (param1 ? (1) : (0)) << 31 | (param2 & 1) << 29 | (param3 & 3) << 27;
            if (__aCachedPrograms[_loc_4] != null)
            {
                return __aCachedPrograms[_loc_4];
            }
            var _loc_5:* = __cContext.createProgram();
            _loc_5.upload(VertexShaderCode, FFragmentShadersCommon.getTexturedShaderCode(param1, param2, false, param3));
            __aCachedPrograms[_loc_4] = _loc_5;
            return _loc_5;
        }

        function initialize(param1:Context3D) : void
        {
            var _loc_7:* = 0;
            var _loc_3:* = 0;
            __cContext = param1;
            __bUseFastMem = FlEngine.getInstance().cConfig.useFastMem;
            VertexShaderCode.endian = "littleEndian";
            __aCachedPrograms = new Dictionary();
            var _loc_4:* = new Vector.<Number>;
            var _loc_6:* = new Vector.<Number>;
            var _loc_2:* = new Vector.<Number>;
            _loc_7 = 0;
            while (_loc_7 < 62)
            {
                
                _loc_4 = _loc_4.concat(NORMALIZED_VERTICES);
                _loc_6 = _loc_6.concat(NORMALIZED_UVS);
                _loc_3 = 4 + _loc_7 * 2;
                _loc_2.push(_loc_3, (_loc_3 + 1));
                _loc_2.push(_loc_3, (_loc_3 + 1));
                _loc_2.push(_loc_3, (_loc_3 + 1));
                _loc_2.push(_loc_3, (_loc_3 + 1));
                _loc_7++;
            }
            __vb3VertexBuffer = param1.createVertexBuffer(248, 2);
            __vb3VertexBuffer.uploadFromVector(_loc_4, 0, 248);
            __vb3UVBuffer = param1.createVertexBuffer(248, 2);
            __vb3UVBuffer.uploadFromVector(_loc_6, 0, 248);
            __vb3RegisterIndexBuffer = param1.createVertexBuffer(248, 2);
            __vb3RegisterIndexBuffer.uploadFromVector(_loc_2, 0, 248);
            var _loc_5:* = new Vector.<uint>;
            _loc_7 = 0;
            while (_loc_7 < 62)
            {
                
                _loc_5 = _loc_5.concat(this.Vector.<uint>([4 * _loc_7, 4 * _loc_7 + 1, 4 * _loc_7 + 2, 4 * _loc_7, 4 * _loc_7 + 2, 4 * _loc_7 + 3]));
                _loc_7++;
            }
            __ib3IndexBuffer = param1.createIndexBuffer(372);
            __ib3IndexBuffer.uploadFromVector(_loc_5, 0, 372);
            __baVertexArray = new ByteArray();
            __baVertexArray.endian = "littleEndian";
            __baVertexArray.length = 2048;
            return;
        }

        public function bind(param1:Context3D, param2:Boolean) : void
        {
            if (__aCachedPrograms == null || param2 && !__bInitializedThisFrame)
            {
                initialize(param1);
            }
            __bInitializedThisFrame = param2;
            __cContext.setProgram(getCachedProgram(true, 0, __iActiveAtf));
            __cContext.setVertexBufferAt(0, __vb3VertexBuffer, 0, _helpBindFloat2);
            __cContext.setVertexBufferAt(1, __vb3UVBuffer, 0, _helpBindFloat2);
            __cContext.setVertexBufferAt(2, __vb3RegisterIndexBuffer, 0, _helpBindFloat2);
            __iQuadCount = 0;
            __iConstantsOffset = 0;
            __cActiveContextTexture = null;
            if (__bUseFastMem)
            {
                ApplicationDomain.currentDomain.domainMemory = __baVertexArray;
            }
            return;
        }

        public function draw(param1:Number, param2:Number, param3:Number, param4:Number, param5:FTexture) : void
        {
            var _loc_7:* = param5.cContextTexture.tTexture;
            var _loc_8:* = __cActiveContextTexture != _loc_7;
            var _loc_6:* = __iActiveAtf != param5.iAtfType;
            if (_loc_8)
            {
                if (__cActiveContextTexture != null)
                {
                    push();
                }
                if (_loc_8)
                {
                    __cActiveContextTexture = _loc_7;
                    __cContext.setTextureAt(0, __cActiveContextTexture);
                }
                if (_loc_6)
                {
                    __iActiveAtf = param5.iAtfType;
                    __cContext.setProgram(getCachedProgram(true, 0, __iActiveAtf));
                }
            }
            __iConstantsOffset = __iQuadCount << 3;
            __aVertexConstants[__iConstantsOffset] = param1;
            __aVertexConstants[(__iConstantsOffset + 1)] = param2;
            __aVertexConstants[__iConstantsOffset + 2] = param5.iWidth * param3;
            __aVertexConstants[__iConstantsOffset + 3] = param5.iHeight * param4;
            __aVertexConstants[__iConstantsOffset + 4] = param5.uvX;
            __aVertexConstants[__iConstantsOffset + 5] = param5.uvY;
            __aVertexConstants[__iConstantsOffset + 6] = param5.uvScaleX;
            __aVertexConstants[__iConstantsOffset + 7] = param5.uvScaleY;
            (__iQuadCount + 1);
            if (__iQuadCount == 62)
            {
                push();
            }
            return;
        }

        public function push() : void
        {
            (FStats.iDrawCalls + 1);
            if (__bUseFastMem)
            {
                __cContext.setProgramConstantsFromByteArray("vertex", 4, 124, __baVertexArray, 0);
            }
            else
            {
                __cContext.setProgramConstantsFromVector("vertex", 4, __aVertexConstants, 124);
            }
            __cContext.drawTriangles(__ib3IndexBuffer, 0, __iQuadCount * 2);
            __iQuadCount = 0;
            __iConstantsOffset = 0;
            return;
        }

        public function clear() : void
        {
            __cContext.setTextureAt(0, null);
            __cContext.setVertexBufferAt(0, null);
            __cContext.setVertexBufferAt(1, null);
            __cContext.setVertexBufferAt(2, null);
            __cActiveContextTexture = null;
            return;
        }

    }
}
