package com.flengine.context.materials
{
    import __AS3__.vec.*;
    import com.adobe.utils.*;
    import com.flengine.components.*;
    import com.flengine.context.materials.*;
    import com.flengine.core.*;
    import flash.display3D.*;
    import flash.geom.*;

    final public class FDrawColorCameraVertexBufferCPUBatchMaterial extends Object implements IGMaterial
    {
        private var __vb3VertexBuffer:VertexBuffer3D;
        private var __aVertexVector:Vector.<Number>;
        private var __ib3QuadIndexBuffer:IndexBuffer3D;
        private var __ib3TriangleIndexBuffer:IndexBuffer3D;
        private var __iTriangleCount:int = 0;
        private var __bInitializedThisFrame:Boolean = false;
        private var __bDrawQuads:Boolean = true;
        private var __p3ShaderProgram:Program3D;
        private var __cContext:Context3D;
        private var vertexShader:AGALMiniAssembler;
        private var vertexShaderAlpha:AGALMiniAssembler;
        private static const BATCH_SIZE:int = 1000;
        private static const DATA_PER_VERTEX:int = 6;
        private static const VERTEX_SHADER_CODE:Array = ["mov vt0, va0", "sub vt1, vt0.xy, vc5.xy", "mul vt1, vt1.xy, vc5.zw", "mov vt4.x, vc4.x", "sin vt2.x, vt4.x", "cos vt2.y, vt4.x", "mul vt3.x, vt1.x, vt2.y", "mul vt3.y, vt1.y, vt2.x", "sub vt4.x, vt3.x, vt3.y", "mul vt3.y, vt1.y, vt2.y", "mul vt3.x, vt1.x, vt2.x", "add vt4.y, vt3.y, vt3.x", "add vt1, vt4.xy, vc4.yz", "mov vt1.zw, vt0.zw", "m44 op, vt1, vc0", "mov v1, va1"];

        public function FDrawColorCameraVertexBufferCPUBatchMaterial()
        {
            return;
        }

        public function initialize(param1:Context3D) : void
        {
            var _loc_3:* = 0;
            __cContext = param1;
            vertexShader = new AGALMiniAssembler();
            vertexShader.assemble("vertex", VERTEX_SHADER_CODE.join("\n"));
            __p3ShaderProgram = param1.createProgram();
            __p3ShaderProgram.upload(vertexShader.agalcode, FFragmentShadersCommon.getColorShaderCode());
            __aVertexVector = new Vector.<Number>(3 * 1000 * 6);
            __vb3VertexBuffer = __cContext.createVertexBuffer(3 * 1000, 6);
            var _loc_2:* = new Vector.<uint>;
            _loc_3 = 0;
            while (_loc_3 < 3 * 1000)
            {
                
                _loc_2.push(_loc_3);
                _loc_3++;
            }
            __ib3TriangleIndexBuffer = param1.createIndexBuffer(3 * 1000);
            __ib3TriangleIndexBuffer.uploadFromVector(_loc_2, 0, 3 * 1000);
            _loc_2.length = 0;
            _loc_3 = 0;
            while (_loc_3 < 1000 / 2)
            {
                
                _loc_2 = _loc_2.concat(this.Vector.<uint>([4 * _loc_3, 4 * _loc_3 + 1, 4 * _loc_3 + 2, 4 * _loc_3, 4 * _loc_3 + 2, 4 * _loc_3 + 3]));
                _loc_3++;
            }
            __ib3QuadIndexBuffer = param1.createIndexBuffer(3 * 1000);
            __ib3QuadIndexBuffer.uploadFromVector(_loc_2, 0, 3 * 1000);
            __iTriangleCount = 0;
            return;
        }

        public function bind(param1:Context3D, param2:Boolean, param3:FCamera) : void
        {
            if (__p3ShaderProgram == null || param2 && !__bInitializedThisFrame)
            {
                initialize(param1);
            }
            __bInitializedThisFrame = param2;
            __cContext.setProgram(__p3ShaderProgram);
            __cContext.setProgramConstantsFromVector("vertex", 4, param3.aCameraVector, 2);
            __cContext.setProgramConstantsFromVector("fragment", 0, this.Vector.<Number>([1, 0, 0, 0.5]), 1);
            __iTriangleCount = 0;
            return;
        }

        public function draw(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number) : void
        {
            __bDrawQuads = true;
            var _loc_11:* = Math.cos(param5);
            var _loc_14:* = Math.sin(param5);
            var _loc_18:* = 0.5 * param3;
            var _loc_17:* = 0.5 * param4;
            var _loc_12:* = _loc_11 * _loc_18;
            var _loc_13:* = _loc_11 * _loc_17;
            var _loc_15:* = _loc_14 * _loc_18;
            var _loc_16:* = _loc_14 * _loc_17;
            var _loc_10:* = 6 * 3 * __iTriangleCount;
            __aVertexVector[_loc_10] = -_loc_12 - _loc_16 + param1;
            __aVertexVector[(_loc_10 + 1)] = _loc_13 - _loc_15 + param2;
            __aVertexVector[_loc_10 + 2] = param6;
            __aVertexVector[_loc_10 + 3] = param7;
            __aVertexVector[_loc_10 + 4] = param8;
            __aVertexVector[_loc_10 + 5] = param9;
            __aVertexVector[_loc_10 + 6] = -_loc_12 + _loc_16 + param1;
            __aVertexVector[_loc_10 + 7] = -_loc_13 - _loc_15 + param2;
            __aVertexVector[_loc_10 + 8] = param6;
            __aVertexVector[_loc_10 + 9] = param7;
            __aVertexVector[_loc_10 + 10] = param8;
            __aVertexVector[_loc_10 + 11] = param9;
            __aVertexVector[_loc_10 + 12] = _loc_12 + _loc_16 + param1;
            __aVertexVector[_loc_10 + 13] = -_loc_13 + _loc_15 + param2;
            __aVertexVector[_loc_10 + 14] = param6;
            __aVertexVector[_loc_10 + 15] = param7;
            __aVertexVector[_loc_10 + 16] = param8;
            __aVertexVector[_loc_10 + 17] = param9;
            __aVertexVector[_loc_10 + 18] = _loc_12 - _loc_16 + param1;
            __aVertexVector[_loc_10 + 19] = _loc_13 + _loc_15 + param2;
            __aVertexVector[_loc_10 + 20] = param6;
            __aVertexVector[_loc_10 + 21] = param7;
            __aVertexVector[_loc_10 + 22] = param8;
            __aVertexVector[_loc_10 + 23] = param9;
            __iTriangleCount = __iTriangleCount + 2;
            if (__iTriangleCount == 1000)
            {
                push();
            }
            return;
        }

        public function drawPoly(param1:Vector.<Number>, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number) : void
        {
            var _loc_14:* = 0;
            __bDrawQuads = false;
            var _loc_13:* = Math.cos(param6);
            var _loc_16:* = Math.sin(param6);
            var _loc_12:* = param1.length;
            var _loc_15:* = param1.length >> 1;
            var _loc_17:* = (param1.length >> 1) / 3;
            if (__iTriangleCount + _loc_17 > 1000)
            {
                push();
            }
            var _loc_11:* = 6 * 3 * __iTriangleCount;
            _loc_14 = 0;
            while (_loc_14 < _loc_12)
            {
                
                __aVertexVector[_loc_11] = _loc_13 * param1[_loc_14] * param4 - _loc_16 * param1[(_loc_14 + 1)] * param5 + param2;
                __aVertexVector[(_loc_11 + 1)] = _loc_16 * param1[_loc_14] * param4 + _loc_13 * param1[(_loc_14 + 1)] * param5 + param3;
                __aVertexVector[_loc_11 + 2] = param7;
                __aVertexVector[_loc_11 + 3] = param8;
                __aVertexVector[_loc_11 + 4] = param9;
                __aVertexVector[_loc_11 + 5] = param10;
                _loc_11 = _loc_11 + 6;
                _loc_14 = _loc_14 + 2;
            }
            __iTriangleCount = __iTriangleCount + _loc_17;
            if (__iTriangleCount >= 1000)
            {
                push();
            }
            return;
        }

        public function drawMatrix(param1:Matrix, param2:Number, param3:Number, param4:Number, param5:Number) : void
        {
            __bDrawQuads = true;
            var _loc_7:* = 6 * 2 * __iTriangleCount;
            var _loc_6:* = 0.5;
            var _loc_8:* = 0.5;
            __aVertexVector[_loc_7] = param1.a * (-_loc_6) + param1.c * _loc_8 + param1.tx;
            __aVertexVector[(_loc_7 + 1)] = param1.d * _loc_8 + param1.b * (-_loc_6) + param1.ty;
            __aVertexVector[_loc_7 + 2] = param2;
            __aVertexVector[_loc_7 + 3] = param3;
            __aVertexVector[_loc_7 + 4] = param4;
            __aVertexVector[_loc_7 + 5] = param5;
            __aVertexVector[_loc_7 + 6] = param1.a * (-_loc_6) + param1.c * (-_loc_8) + param1.tx;
            __aVertexVector[_loc_7 + 7] = param1.d * (-_loc_8) + param1.b * (-_loc_6) + param1.ty;
            __aVertexVector[_loc_7 + 8] = param2;
            __aVertexVector[_loc_7 + 9] = param3;
            __aVertexVector[_loc_7 + 10] = param4;
            __aVertexVector[_loc_7 + 11] = param5;
            __aVertexVector[_loc_7 + 12] = param1.a * _loc_6 + param1.c * (-_loc_8) + param1.tx;
            __aVertexVector[_loc_7 + 13] = param1.d * (-_loc_8) + param1.b * _loc_6 + param1.ty;
            __aVertexVector[_loc_7 + 14] = param2;
            __aVertexVector[_loc_7 + 15] = param3;
            __aVertexVector[_loc_7 + 16] = param4;
            __aVertexVector[_loc_7 + 17] = param5;
            __aVertexVector[_loc_7 + 18] = param1.a * _loc_6 + param1.c * _loc_8 + param1.tx;
            __aVertexVector[_loc_7 + 19] = param1.d * _loc_8 + param1.b * _loc_6 + param1.ty;
            __aVertexVector[_loc_7 + 20] = param2;
            __aVertexVector[_loc_7 + 21] = param3;
            __aVertexVector[_loc_7 + 22] = param4;
            __aVertexVector[_loc_7 + 23] = param5;
            __iTriangleCount = __iTriangleCount + 2;
            if (__iTriangleCount == 1000)
            {
                push();
            }
            return;
        }

        public function push() : void
        {
            (FStats.iDrawCalls + 1);
            __vb3VertexBuffer.uploadFromVector(__aVertexVector, 0, 3 * 1000);
            __cContext.setVertexBufferAt(0, __vb3VertexBuffer, 0, "float2");
            __cContext.setVertexBufferAt(1, __vb3VertexBuffer, 2, "float4");
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
        }

        public function clear() : void
        {
            __cContext.setVertexBufferAt(0, null);
            __cContext.setVertexBufferAt(1, null);
            return;
        }

    }
}
