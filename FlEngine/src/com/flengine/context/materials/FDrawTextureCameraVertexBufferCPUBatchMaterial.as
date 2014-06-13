package com.flengine.context.materials
{
    import __AS3__.vec.*;
    import com.adobe.utils.*;
    import com.flengine.components.*;
    import com.flengine.context.filters.*;
    import com.flengine.context.materials.*;
    import com.flengine.core.*;
    import com.flengine.textures.*;
    import flash.display3D.*;
    import flash.display3D.textures.*;
    import flash.geom.*;
    import flash.utils.*;

    final public class FDrawTextureCameraVertexBufferCPUBatchMaterial extends Object implements IGMaterial
    {
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
        private static const BATCH_SIZE:int = 1000;
        private static const DATA_PER_VERTEX:int = 8;
        private static const VERTEX_SHADER_CODE:Array = ["mov vt0, va2", "mov vt0, va0", "sub vt1, vt0.xy, vc5.xy", "mul vt1, vt1.xy, vc5.zw", "mov vt4.x, vc4.x", "sin vt2.x, vt4.x", "cos vt2.y, vt4.x", "mul vt3.x, vt1.x, vt2.y", "mul vt3.y, vt1.y, vt2.x", "sub vt4.x, vt3.x, vt3.y", "mul vt3.y, vt1.y, vt2.y", "mul vt3.x, vt1.x, vt2.x", "add vt4.y, vt3.y, vt3.x", "add vt1, vt4.xy, vc4.yz", "mov vt1.zw, vt0.zw", "m44 op, vt1, vc0", "mov v0, va1"];
        private static const VERTEX_SHADER_ALPHA_CODE:Array = VERTEX_SHADER_CODE.concat(["mov v1, va2"]);
        private static var _helpBindVector:Vector.<Number> = FDrawTextureCameraVertexBufferCPUBatchMaterial.Vector.<Number>([1, 0, 0, 0.5]);

        public function FDrawTextureCameraVertexBufferCPUBatchMaterial()
        {
            return;
        }// end function

        private function getCachedProgram(param1:Boolean, param2:int, param3:Boolean, param4:int, param5:FFilter) : Program3D
        {
            var _loc_6:* = (param1 ? (1) : (0)) << 31 | (param3 ? (1) : (0)) << 30 | (param2 & 1) << 29 | (param4 & 3) << 27 | (param5 ? (param5.iId) : (0)) & 65535;
            if (__aCachedPrograms[_loc_6] != null)
            {
                return __aCachedPrograms[_loc_6];
            }
            var _loc_7:* = __cContext.createProgram();
            _loc_7.upload(param3 ? (vertexShaderAlpha.agalcode) : (vertexShader.agalcode), FFragmentShadersCommon.getTexturedShaderCode(param1, param2, param3, param4, param5));
            __aCachedPrograms[_loc_6] = _loc_7;
            return _loc_7;
        }// end function

        function initialize(param1:Context3D) : void
        {
            var _loc_3:* = 0;
            __cContext = param1;
            __bUseSeparatedAlphaShaders = FlEngine.getInstance().cConfig.useSeparatedAlphaShaders;
            __aCachedPrograms = new Dictionary();
            vertexShader = new AGALMiniAssembler();
            vertexShader.assemble("vertex", VERTEX_SHADER_CODE.join("\n"));
            vertexShaderAlpha = new AGALMiniAssembler();
            vertexShaderAlpha.assemble("vertex", VERTEX_SHADER_ALPHA_CODE.join("\n"));
            __aVertexVector = new Vector.<Number>(24000);
            __vb3VertexBuffer = __cContext.createVertexBuffer(3000, 8);
            var _loc_2:* = new Vector.<uint>;
            _loc_3 = 0;
            while (_loc_3 < 3000)
            {
                
                _loc_2.push(_loc_3);
                _loc_3++;
            }
            __ib3TriangleIndexBuffer = param1.createIndexBuffer(3000);
            __ib3TriangleIndexBuffer.uploadFromVector(_loc_2, 0, 3000);
            _loc_2.length = 0;
            _loc_3 = 0;
            while (_loc_3 < 500)
            {
                
                _loc_2 = _loc_2.concat(this.Vector.<uint>([4 * _loc_3, 4 * _loc_3 + 1, 4 * _loc_3 + 2, 4 * _loc_3, 4 * _loc_3 + 2, 4 * _loc_3 + 3]));
                _loc_3++;
            }
            __ib3QuadIndexBuffer = param1.createIndexBuffer(3000);
            __ib3QuadIndexBuffer.uploadFromVector(_loc_2, 0, 3000);
            __iTriangleCount = 0;
            return;
        }// end function

        function bind(param1:Context3D, param2:Boolean, param3:FCamera) : void
        {
            if (__aCachedPrograms == null || param2 && !__bInitializedThisFrame)
            {
                initialize(param1);
            }
            __bInitializedThisFrame = param2;
            __cContext.setProgram(getCachedProgram(true, FTextureBase.defaultFilteringType, __bActiveAlpha, __iActiveAtf, __cActiveFilter));
            __cContext.setProgramConstantsFromVector("vertex", 4, param3.aCameraVector, 2);
            __cContext.setProgramConstantsFromVector("fragment", 0, _helpBindVector, 1);
            __iTriangleCount = 0;
            __cActiveContextTexture = null;
            __iActiveFiltering = FTextureBase.defaultFilteringType;
            __cActiveFilter = null;
            return;
        }// end function

        public function draw(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:FTexture, param11:FFilter) : void
        {
            __bDrawQuads = true;
            var _loc_13:* = param10.cContextTexture.tTexture;
            var _loc_29:* = __cActiveContextTexture != _loc_13;
            var _loc_18:* = __iActiveFiltering != param10.iFilteringType;
            var _loc_31:* = !__bUseSeparatedAlphaShaders || param6 != 1 || param7 != 1 || param8 != 1 || param9 != 1;
            var _loc_15:* = __bActiveAlpha != _loc_31;
            var _loc_27:* = __iActiveAtf != param10.iAtfType;
            var _loc_30:* = __cActiveFilter != param11;
            if (_loc_29 || _loc_18 || _loc_15 || _loc_27)
            {
                if (__cActiveContextTexture != null)
                {
                    push();
                }
                if (_loc_29)
                {
                    __cActiveContextTexture = _loc_13;
                    __cContext.setTextureAt(0, __cActiveContextTexture);
                }
                if (_loc_18 || _loc_15 || _loc_27)
                {
                    __iActiveFiltering = param10.iFilteringType;
                    __bActiveAlpha = _loc_31;
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
            var _loc_21:* = param10.uvX;
            var _loc_16:* = param10.uvY;
            var _loc_22:* = param10.uvScaleX;
            var _loc_12:* = param10.uvScaleY;
            var _loc_14:* = Math.cos(param5);
            var _loc_28:* = Math.sin(param5);
            var _loc_23:* = 0.5 * param3 * param10.iWidth;
            var _loc_20:* = 0.5 * param4 * param10.iHeight;
            var _loc_25:* = _loc_14 * _loc_23;
            var _loc_26:* = _loc_14 * _loc_20;
            var _loc_17:* = _loc_28 * _loc_23;
            var _loc_19:* = _loc_28 * _loc_20;
            if (param10.premultiplied)
            {
                param6 = param6 * param9;
                param7 = param7 * param9;
                param8 = param8 * param9;
            }
            var _loc_24:* = 24 * __iTriangleCount;
            __aVertexVector[_loc_24] = -_loc_25 - _loc_19 + param1;
            __aVertexVector[(_loc_24 + 1)] = _loc_26 - _loc_17 + param2;
            __aVertexVector[_loc_24 + 2] = _loc_21;
            __aVertexVector[_loc_24 + 3] = _loc_12 + _loc_16;
            __aVertexVector[_loc_24 + 4] = param6;
            __aVertexVector[_loc_24 + 5] = param7;
            __aVertexVector[_loc_24 + 6] = param8;
            __aVertexVector[_loc_24 + 7] = param9;
            __aVertexVector[_loc_24 + 8] = -_loc_25 + _loc_19 + param1;
            __aVertexVector[_loc_24 + 9] = -_loc_26 - _loc_17 + param2;
            __aVertexVector[_loc_24 + 10] = _loc_21;
            __aVertexVector[_loc_24 + 11] = _loc_16;
            __aVertexVector[_loc_24 + 12] = param6;
            __aVertexVector[_loc_24 + 13] = param7;
            __aVertexVector[_loc_24 + 14] = param8;
            __aVertexVector[_loc_24 + 15] = param9;
            __aVertexVector[_loc_24 + 16] = _loc_25 + _loc_19 + param1;
            __aVertexVector[_loc_24 + 17] = -_loc_26 + _loc_17 + param2;
            __aVertexVector[_loc_24 + 18] = _loc_22 + _loc_21;
            __aVertexVector[_loc_24 + 19] = _loc_16;
            __aVertexVector[_loc_24 + 20] = param6;
            __aVertexVector[_loc_24 + 21] = param7;
            __aVertexVector[_loc_24 + 22] = param8;
            __aVertexVector[_loc_24 + 23] = param9;
            __aVertexVector[_loc_24 + 24] = _loc_25 - _loc_19 + param1;
            __aVertexVector[_loc_24 + 25] = _loc_26 + _loc_17 + param2;
            __aVertexVector[_loc_24 + 26] = _loc_22 + _loc_21;
            __aVertexVector[_loc_24 + 27] = _loc_12 + _loc_16;
            __aVertexVector[_loc_24 + 28] = param6;
            __aVertexVector[_loc_24 + 29] = param7;
            __aVertexVector[_loc_24 + 30] = param8;
            __aVertexVector[_loc_24 + 31] = param9;
            __iTriangleCount = __iTriangleCount + 2;
            if (__iTriangleCount == 1000)
            {
                push();
            }
            return;
        }// end function

        public function drawPoly(param1:Vector.<Number>, param2:Vector.<Number>, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:Number, param12:FTexture, param13:FFilter) : void
        {
            var _loc_25:* = 0;
            __bDrawQuads = false;
            var _loc_15:* = param12.cContextTexture.tTexture;
            var _loc_29:* = __cActiveContextTexture != _loc_15;
            var _loc_23:* = __iActiveFiltering != param12.iFilteringType;
            var _loc_31:* = !__bUseSeparatedAlphaShaders || param8 != 1 || param9 != 1 || param10 != 1 || param11 != 1;
            var _loc_17:* = __bActiveAlpha != _loc_31;
            var _loc_27:* = __iActiveAtf != param12.iAtfType;
            var _loc_30:* = __cActiveFilter != param13;
            if (_loc_29 || _loc_23 || _loc_17 || _loc_27)
            {
                if (__cActiveContextTexture != null)
                {
                    push();
                }
                if (_loc_29)
                {
                    __cActiveContextTexture = _loc_15;
                    __cContext.setTextureAt(0, __cActiveContextTexture);
                }
                if (_loc_23 || _loc_17 || _loc_27)
                {
                    __iActiveFiltering = param12.iFilteringType;
                    __bActiveAlpha = _loc_31;
                    __iActiveAtf = param12.iAtfType;
                    if (__cActiveFilter)
                    {
                        __cActiveFilter.clear(__cContext);
                    }
                    __cActiveFilter = param13;
                    if (__cActiveFilter)
                    {
                        __cActiveFilter.bind(__cContext, param12);
                    }
                    __cContext.setProgram(getCachedProgram(true, __iActiveFiltering, __bActiveAlpha, __iActiveAtf, __cActiveFilter));
                }
            }
            var _loc_16:* = Math.cos(param7);
            var _loc_28:* = Math.sin(param7);
            var _loc_20:* = param12.nUvX;
            var _loc_21:* = param12.nUvScaleX;
            var _loc_18:* = param12.nUvY;
            var _loc_19:* = param12.nUvScaleY;
            if (param12.premultiplied)
            {
                param8 = param8 * param11;
                param9 = param9 * param11;
                param10 = param10 * param11;
            }
            var _loc_14:* = param1.length;
            var _loc_26:* = param1.length >> 1;
            var _loc_22:* = (param1.length >> 1) / 3;
            if (__iTriangleCount + _loc_22 > 1000)
            {
                push();
            }
            var _loc_24:* = 24 * __iTriangleCount;
            _loc_25 = 0;
            while (_loc_25 < _loc_14)
            {
                
                __aVertexVector[_loc_24] = _loc_16 * param1[_loc_25] * param5 - _loc_28 * param1[(_loc_25 + 1)] * param6 + param3;
                __aVertexVector[(_loc_24 + 1)] = _loc_28 * param1[_loc_25] * param6 + _loc_16 * param1[(_loc_25 + 1)] * param5 + param4;
                __aVertexVector[_loc_24 + 2] = _loc_20 + param2[_loc_25] * _loc_21;
                __aVertexVector[_loc_24 + 3] = _loc_18 + param2[(_loc_25 + 1)] * _loc_19;
                __aVertexVector[_loc_24 + 4] = param8;
                __aVertexVector[_loc_24 + 5] = param9;
                __aVertexVector[_loc_24 + 6] = param10;
                __aVertexVector[_loc_24 + 7] = param11;
                _loc_24 = _loc_24 + 8;
                _loc_25 = _loc_25 + 2;
            }
            __iTriangleCount = __iTriangleCount + _loc_22;
            if (__iTriangleCount >= 1000)
            {
                push();
            }
            return;
        }// end function

        public function drawMatrix(param1:Matrix, param2:Number, param3:Number, param4:Number, param5:Number, param6:FTexture, param7:FFilter) : void
        {
            __bDrawQuads = true;
            var _loc_9:* = param6.cContextTexture.tTexture;
            var _loc_14:* = __cActiveContextTexture != _loc_9;
            var _loc_16:* = __iActiveFiltering != param6.iFilteringType;
            var _loc_17:* = !__bUseSeparatedAlphaShaders || !(param2 == 1 && param3 == 1 && param4 == 1 && param5 == 1);
            var _loc_10:* = __bActiveAlpha != _loc_17;
            var _loc_13:* = __iActiveAtf != param6.iAtfType;
            var _loc_15:* = __cActiveFilter != param7;
            if (_loc_14 || _loc_16 || _loc_10 || _loc_13)
            {
                if (__cActiveContextTexture != null)
                {
                    push();
                }
                if (_loc_14)
                {
                    __cActiveContextTexture = _loc_9;
                    __cContext.setTextureAt(0, __cActiveContextTexture);
                }
                if (_loc_16 || _loc_10 || _loc_13)
                {
                    __iActiveFiltering = param6.iFilteringType;
                    __bActiveAlpha = _loc_17;
                    __iActiveAtf = param6.iAtfType;
                    if (__cActiveFilter)
                    {
                        __cActiveFilter.clear(__cContext);
                    }
                    __cActiveFilter = param7;
                    if (__cActiveFilter)
                    {
                        __cActiveFilter.bind(__cContext, param6);
                    }
                    __cContext.setProgram(getCachedProgram(true, __iActiveFiltering, __bActiveAlpha, __iActiveAtf, __cActiveFilter));
                }
            }
            if (param6.premultiplied)
            {
                param2 = param2 * param5;
                param3 = param3 * param5;
                param4 = param4 * param5;
            }
            var _loc_8:* = 16 * __iTriangleCount;
            var _loc_12:* = 0.5 * param6.iWidth;
            var _loc_11:* = 0.5 * param6.iHeight;
            __aVertexVector[_loc_8] = param1.a * (-_loc_12) + param1.c * _loc_11 + param1.tx;
            __aVertexVector[(_loc_8 + 1)] = param1.d * _loc_11 + param1.b * (-_loc_12) + param1.ty;
            __aVertexVector[_loc_8 + 2] = param6.uvX;
            __aVertexVector[_loc_8 + 3] = param6.uvScaleY + param6.uvY;
            __aVertexVector[_loc_8 + 4] = param2;
            __aVertexVector[_loc_8 + 5] = param3;
            __aVertexVector[_loc_8 + 6] = param4;
            __aVertexVector[_loc_8 + 7] = param5;
            __aVertexVector[_loc_8 + 8] = param1.a * (-_loc_12) + param1.c * (-_loc_11) + param1.tx;
            __aVertexVector[_loc_8 + 9] = param1.d * (-_loc_11) + param1.b * (-_loc_12) + param1.ty;
            __aVertexVector[_loc_8 + 10] = param6.uvX;
            __aVertexVector[_loc_8 + 11] = param6.uvY;
            __aVertexVector[_loc_8 + 12] = param2;
            __aVertexVector[_loc_8 + 13] = param3;
            __aVertexVector[_loc_8 + 14] = param4;
            __aVertexVector[_loc_8 + 15] = param5;
            __aVertexVector[_loc_8 + 16] = param1.a * _loc_12 + param1.c * (-_loc_11) + param1.tx;
            __aVertexVector[_loc_8 + 17] = param1.d * (-_loc_11) + param1.b * _loc_12 + param1.ty;
            __aVertexVector[_loc_8 + 18] = param6.uvScaleX + param6.uvX;
            __aVertexVector[_loc_8 + 19] = param6.uvY;
            __aVertexVector[_loc_8 + 20] = param2;
            __aVertexVector[_loc_8 + 21] = param3;
            __aVertexVector[_loc_8 + 22] = param4;
            __aVertexVector[_loc_8 + 23] = param5;
            __aVertexVector[_loc_8 + 24] = param1.a * _loc_12 + param1.c * _loc_11 + param1.tx;
            __aVertexVector[_loc_8 + 25] = param1.d * _loc_11 + param1.b * _loc_12 + param1.ty;
            __aVertexVector[_loc_8 + 26] = param6.uvScaleX + param6.uvX;
            __aVertexVector[_loc_8 + 27] = param6.uvScaleY + param6.uvY;
            __aVertexVector[_loc_8 + 28] = param2;
            __aVertexVector[_loc_8 + 29] = param3;
            __aVertexVector[_loc_8 + 30] = param4;
            __aVertexVector[_loc_8 + 31] = param5;
            __iTriangleCount = __iTriangleCount + 2;
            if (__iTriangleCount == 1000)
            {
                push();
            }
            return;
        }// end function

        public function push() : void
        {
            (FStats.iDrawCalls + 1);
            __vb3VertexBuffer.uploadFromVector(__aVertexVector, 0, 3000);
            __cContext.setVertexBufferAt(0, __vb3VertexBuffer, 0, "float2");
            __cContext.setVertexBufferAt(1, __vb3VertexBuffer, 2, "float2");
            __cContext.setVertexBufferAt(2, __vb3VertexBuffer, 4, "float4");
            if (__bDrawQuads)
            {
                __cContext.drawTriangles(__ib3QuadIndexBuffer, 0, __iTriangleCount);
            }
            else
            {
                __cContext.drawTriangles(__ib3TriangleIndexBuffer, 0, __iTriangleCount);
            }
            __iTriangleCount = 0;
            return;
        }// end function

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
            __iActiveFiltering = FTextureBase.defaultFilteringType;
            return;
        }// end function

    }
}
