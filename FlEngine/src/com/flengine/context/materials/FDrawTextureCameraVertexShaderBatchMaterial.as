package com.flengine.context.materials
{
    import __AS3__.vec.*;
    import com.flengine.components.*;
    import com.flengine.context.filters.*;
    import com.flengine.context.materials.*;
    import com.flengine.core.*;
    import com.flengine.textures.*;
    import flash.display3D.*;
    import flash.display3D.textures.*;
    import flash.utils.*;

    final public class FDrawTextureCameraVertexShaderBatchMaterial extends Object implements IGMaterial
    {
        private const CONSTANTS_OFFSET:int = 6;
        private const BATCH_CONSTANTS:int = 122;
        private const CONSTANTS_PER_BATCH:int = 4;
        private const BATCH_SIZE:int = 30;
        private const VertexShaderEmbed:Class = FCameraTexturedQuadVertexShaderBatchMaterialVertex_ash;
        private const VertexShaderCode:ByteArray;
        private const VertexShaderNoAlphaEmbed:Class = FCameraTexturedQuadVertexShaderBatchMaterialVertexNoAlpha_ash;
        private const VertexShaderNoAlphaCode:ByteArray;
        private var __vb3VertexBuffer:VertexBuffer3D;
        private var __vb3UVBuffer:VertexBuffer3D;
        private var __vb3RegisterIndexBuffer:VertexBuffer3D;
        private var __ib3IndexBuffer:IndexBuffer3D;
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
        private static const NORMALIZED_VERTICES:Vector.<Number> = FDrawTextureCameraVertexShaderBatchMaterial.Vector.<Number>([-0.5, 0.5, -0.5, -0.5, 0.5, -0.5, 0.5, 0.5]);
        private static const NORMALIZED_UVS:Vector.<Number> = FDrawTextureCameraVertexShaderBatchMaterial.Vector.<Number>([0, 1, 0, 0, 1, 0, 1, 1]);
        private static var _helpBindVector:Vector.<Number> = FDrawTextureCameraVertexShaderBatchMaterial.Vector.<Number>([1, 0, 0, 0.5]);

        public function FDrawTextureCameraVertexShaderBatchMaterial()
        {
            VertexShaderCode = (new VertexShaderEmbed()) as ByteArray;
            VertexShaderNoAlphaCode = (new VertexShaderNoAlphaEmbed()) as ByteArray;
            return;
        }

        private function getCachedProgram(param1:Boolean, param2:int, param3:Boolean, param4:int, param5:FFilter) : Program3D
        {
            var _loc_6:* = (param1 ? (1) : (0)) << 31 | (param3 ? (1) : (0)) << 30 | (param2 & 1) << 29 | (param4 & 3) << 27 | (param5 ? (param5.iId) : (0)) & 65535;
            if (__aCachedPrograms[_loc_6] != null)
            {
                return __aCachedPrograms[_loc_6];
            }
            var _loc_7:* = __cContext.createProgram();
            _loc_7.upload(param3 ? (VertexShaderCode) : (VertexShaderNoAlphaCode), FFragmentShadersCommon.getTexturedShaderCode(param1, param2, param3, param4, param5));
            __aCachedPrograms[_loc_6] = _loc_7;
            return _loc_7;
        }

        public function initialize(param1:Context3D) : void
        {
            var _loc_7:* = 0;
            var _loc_3:* = 0;
            __cContext = param1;
            __bUseSeparatedAlphaShaders = FlEngine.getInstance().cConfig.useSeparatedAlphaShaders;
            __bUseFastMem = FlEngine.getInstance().cConfig.useFastMem;
            VertexShaderCode.endian = "littleEndian";
            VertexShaderNoAlphaCode.endian = "littleEndian";
            __aCachedPrograms = new Dictionary();
            var _loc_4:* = new Vector.<Number>;
            var _loc_6:* = new Vector.<Number>;
            var _loc_2:* = new Vector.<Number>;
            _loc_7 = 0;
            while (_loc_7 < 30)
            {
                
                _loc_4 = _loc_4.concat(NORMALIZED_VERTICES);
                _loc_6 = _loc_6.concat(NORMALIZED_UVS);
                _loc_3 = 6 + _loc_7 * 4;
                _loc_2.push(_loc_3, (_loc_3 + 1), _loc_3 + 2, _loc_3 + 3);
                _loc_2.push(_loc_3, (_loc_3 + 1), _loc_3 + 2, _loc_3 + 3);
                _loc_2.push(_loc_3, (_loc_3 + 1), _loc_3 + 2, _loc_3 + 3);
                _loc_2.push(_loc_3, (_loc_3 + 1), _loc_3 + 2, _loc_3 + 3);
                _loc_7++;
            }
            __vb3VertexBuffer = __cContext.createVertexBuffer(120, 2);
            __vb3VertexBuffer.uploadFromVector(_loc_4, 0, 120);
            __vb3UVBuffer = __cContext.createVertexBuffer(120, 2);
            __vb3UVBuffer.uploadFromVector(_loc_6, 0, 120);
            __vb3RegisterIndexBuffer = __cContext.createVertexBuffer(120, 4);
            __vb3RegisterIndexBuffer.uploadFromVector(_loc_2, 0, 120);
            var _loc_5:* = new Vector.<uint>;
            _loc_7 = 0;
            while (_loc_7 < 30)
            {
                
                _loc_5 = _loc_5.concat(this.Vector.<uint>([4 * _loc_7, 4 * _loc_7 + 1, 4 * _loc_7 + 2, 4 * _loc_7, 4 * _loc_7 + 2, 4 * _loc_7 + 3]));
                _loc_7++;
            }
            __ib3IndexBuffer = __cContext.createIndexBuffer(180);
            __ib3IndexBuffer.uploadFromVector(_loc_5, 0, 180);
            __aVertexConstants = new Vector.<Number>(488);
            __baVertexArray = new ByteArray();
            __baVertexArray.endian = "littleEndian";
            __baVertexArray.length = 2048;
            return;
        }

        public function bind(param1:Context3D, param2:Boolean, param3:FCamera) : void
        {
            if (__aCachedPrograms == null || param2 && !__bInitializedThisFrame)
            {
                initialize(param1);
            }
            __bInitializedThisFrame = param2;
            __cContext.setProgram(getCachedProgram(true, FTextureBase.defaultFilteringType, __bActiveAlpha, __iActiveAtf, __cActiveFilter));
            __cContext.setProgramConstantsFromVector("vertex", 4, param3.aCameraVector, 2);
            __cContext.setProgramConstantsFromVector("fragment", 0, _helpBindVector, 1);
            __cContext.setVertexBufferAt(0, __vb3VertexBuffer, 0, "float2");
            __cContext.setVertexBufferAt(1, __vb3UVBuffer, 0, "float2");
            __cContext.setVertexBufferAt(2, __vb3RegisterIndexBuffer, 0, "float4");
            __iQuadCount = 0;
            __cActiveContextTexture = null;
            __iActiveFiltering = FTextureBase.defaultFilteringType;
            __cActiveFilter = null;
            return;
        }

        public function draw(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:FTexture, param11:FFilter) : void
        {
            var _loc_12:* = param10.cContextTexture.tTexture;
            var _loc_14:* = __cActiveContextTexture != _loc_12;
            var _loc_16:* = __iActiveFiltering != param10.iFilteringType;
            var _loc_17:* = !__bUseSeparatedAlphaShaders || param6 != 1 || param7 != 1 || param8 != 1 || param9 != 1;
            var _loc_18:* = __bActiveAlpha != _loc_17;
            var _loc_13:* = __iActiveAtf != param10.iAtfType;
            var _loc_15:* = __cActiveFilter != param11;
            if (_loc_14 || _loc_16 || _loc_18 || _loc_13 || _loc_15)
            {
                if (__cActiveContextTexture != null)
                {
                    push();
                }
                if (_loc_14)
                {
                    __cActiveContextTexture = _loc_12;
                    __cContext.setTextureAt(0, _loc_12);
                }
                if (_loc_16 || _loc_18 || _loc_13 || _loc_15)
                {
                    __iActiveFiltering = param10.iFilteringType;
                    __bActiveAlpha = _loc_17;
                    __iActiveAtf = param10.iAtfType;
                    if (__cActiveFilter)
                    {
                        __cActiveFilter.clear(__cContext);
                    }
                    __cActiveFilter = param11;
                    if (__cActiveFilter)
                    {
                        __cActiveFilter.bind(__cContext, param10);
                    }
                    __cContext.setProgram(getCachedProgram(true, __iActiveFiltering, __bActiveAlpha, __iActiveAtf, __cActiveFilter));
                }
            }
            if (param10.premultiplied)
            {
                param6 = param6 * param9;
                param7 = param7 * param9;
                param8 = param8 * param9;
            }
            __iConstantsOffset = __iQuadCount << 4;
            __aVertexConstants[__iConstantsOffset] = param1;
            __aVertexConstants[(__iConstantsOffset + 1)] = param2;
            __aVertexConstants[__iConstantsOffset + 2] = param10.iWidth * param3;
            __aVertexConstants[__iConstantsOffset + 3] = param10.iHeight * param4;
            __aVertexConstants[__iConstantsOffset + 4] = param10.nUvX;
            __aVertexConstants[__iConstantsOffset + 5] = param10.nUvY;
            __aVertexConstants[__iConstantsOffset + 6] = param10.nUvScaleX;
            __aVertexConstants[__iConstantsOffset + 7] = param10.nUvScaleY;
            __aVertexConstants[__iConstantsOffset + 8] = param5;
            __aVertexConstants[__iConstantsOffset + 10] = param10.nPivotX * param3;
            __aVertexConstants[__iConstantsOffset + 11] = param10.nPivotY * param4;
            __aVertexConstants[__iConstantsOffset + 12] = param6;
            __aVertexConstants[__iConstantsOffset + 13] = param7;
            __aVertexConstants[__iConstantsOffset + 14] = param8;
            __aVertexConstants[__iConstantsOffset + 15] = param9;
            (__iQuadCount + 1);
            if (__iQuadCount == 30)
            {
                push();
            }
            return;
        }

        public function push() : void
        {
            if (__iQuadCount == 0)
            {
                return;
            }
            if (__bUseFastMem)
            {
                __cContext.setProgramConstantsFromByteArray("vertex", 6, 122, __baVertexArray, 0);
            }
            else
            {
                __cContext.setProgramConstantsFromVector("vertex", 6, __aVertexConstants, 122);
            }
            (FStats.iDrawCalls + 1);
            __cContext.drawTriangles(__ib3IndexBuffer, 0, __iQuadCount * 2);
            __iQuadCount = 0;
            return;
        }

        public function clear() : void
        {
            __cContext.setTextureAt(0, null);
            __cContext.setVertexBufferAt(0, null);
            __cContext.setVertexBufferAt(1, null);
            __cContext.setVertexBufferAt(2, null);
            __cActiveContextTexture = null;
            if (__cActiveFilter)
            {
                __cActiveFilter.clear(__cContext);
            }
            __cActiveFilter = null;
            return;
        }

    }
}
