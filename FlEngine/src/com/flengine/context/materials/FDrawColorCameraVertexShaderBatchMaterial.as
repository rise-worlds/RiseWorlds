package com.flengine.context.materials
{
    import __AS3__.vec.*;
    import com.flengine.components.*;
    import com.flengine.context.materials.*;
    import com.flengine.core.*;
    import flash.display3D.*;
    import flash.utils.*;

    public class FDrawColorCameraVertexShaderBatchMaterial extends Object implements IGMaterial
    {
        private const CONSTANTS_OFFSET:int = 6;
        private const CONSTANTS_PER_BATCH:int = 3;
        private const BATCH_CONSTANTS:int = 122;
        private const BATCH_SIZE:int = 40;
        private const VertexShaderEmbed:Class = FCameraColorQuadVertexShaderBatchMaterialVertex_ash;
        private const VertexShaderCode:ByteArray;
        private var __p3ShaderProgram:Program3D;
        private var __vb3VertexBuffer:VertexBuffer3D;
        private var __vb3RegisterIndexBuffer:VertexBuffer3D;
        private var __ib3IndexBuffer:IndexBuffer3D;
        private var __bInitializedThisFrame:Boolean;
        private var __iQuadCount:int = 0;
        private var __aVertexConstants:Vector.<Number>;
        private var __cContext:Context3D;
        private static const NORMALIZED_VERTICES:Vector.<Number> = FDrawColorCameraVertexShaderBatchMaterial.Vector.<Number>([-0.5, 0.5, -0.5, -0.5, 0.5, -0.5, 0.5, 0.5]);
        private static const NORMALIZED_UVS:Vector.<Number> = FDrawColorCameraVertexShaderBatchMaterial.Vector.<Number>([0, 1, 0, 0, 1, 0, 1, 1]);

        public function FDrawColorCameraVertexShaderBatchMaterial()
        {
            VertexShaderCode = (new VertexShaderEmbed()) as ByteArray;
            __aVertexConstants = new Vector.<Number>(122 * 4);
            return;
        }

        function initialize(param1:Context3D) : void
        {
            var _loc_6:* = 0;
            var _loc_3:* = 0;
            __cContext = param1;
            VertexShaderCode.endian = "littleEndian";
            __p3ShaderProgram = param1.createProgram();
            __p3ShaderProgram.upload(VertexShaderCode, FFragmentShadersCommon.getColorShaderCode());
            var _loc_4:* = new Vector.<Number>;
            var _loc_2:* = new Vector.<Number>;
            _loc_6 = 0;
            while (_loc_6 < 40)
            {
                
                _loc_4 = _loc_4.concat(NORMALIZED_VERTICES);
                _loc_3 = 6 + _loc_6 * 3;
                _loc_2.push(_loc_3, (_loc_3 + 1), _loc_3 + 2);
                _loc_2.push(_loc_3, (_loc_3 + 1), _loc_3 + 2);
                _loc_2.push(_loc_3, (_loc_3 + 1), _loc_3 + 2);
                _loc_2.push(_loc_3, (_loc_3 + 1), _loc_3 + 2);
                _loc_6++;
            }
            __vb3VertexBuffer = param1.createVertexBuffer(4 * 40, 2);
            __vb3VertexBuffer.uploadFromVector(_loc_4, 0, 4 * 40);
            __vb3RegisterIndexBuffer = param1.createVertexBuffer(4 * 40, 3);
            __vb3RegisterIndexBuffer.uploadFromVector(_loc_2, 0, 4 * 40);
            var _loc_5:* = new Vector.<uint>;
            _loc_6 = 0;
            while (_loc_6 < 40)
            {
                
                _loc_5 = _loc_5.concat(this.Vector.<uint>([4 * _loc_6, 4 * _loc_6 + 1, 4 * _loc_6 + 2, 4 * _loc_6, 4 * _loc_6 + 2, 4 * _loc_6 + 3]));
                _loc_6++;
            }
            __ib3IndexBuffer = param1.createIndexBuffer(6 * 40);
            __ib3IndexBuffer.uploadFromVector(_loc_5, 0, 6 * 40);
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
            __cContext.setVertexBufferAt(0, __vb3VertexBuffer, 0, "float2");
            __cContext.setVertexBufferAt(1, __vb3RegisterIndexBuffer, 0, "float3");
            __iQuadCount = 0;
            return;
        }

        public function draw(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number) : void
        {
            var _loc_10:* = __iQuadCount * 12;
            __aVertexConstants[_loc_10] = param1;
            __aVertexConstants[(_loc_10 + 1)] = param2;
            __aVertexConstants[_loc_10 + 2] = param3;
            __aVertexConstants[_loc_10 + 3] = param4;
            __aVertexConstants[_loc_10 + 4] = param5;
            __aVertexConstants[_loc_10 + 8] = param6 * param9;
            __aVertexConstants[_loc_10 + 9] = param7 * param9;
            __aVertexConstants[_loc_10 + 10] = param8 * param9;
            __aVertexConstants[_loc_10 + 11] = param9;
            (__iQuadCount + 1);
            if (__iQuadCount == 40)
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
            __cContext.setProgramConstantsFromVector("vertex", 6, __aVertexConstants, 122);
            (FStats.iDrawCalls + 1);
            __cContext.drawTriangles(__ib3IndexBuffer, 0, __iQuadCount * 2);
            __iQuadCount = 0;
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
