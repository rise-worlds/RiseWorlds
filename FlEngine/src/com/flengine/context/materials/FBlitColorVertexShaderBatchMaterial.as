package com.flengine.context.materials
{
    import __AS3__.vec.*;
    import com.flengine.components.*;
    import com.flengine.context.materials.*;
    import com.flengine.core.*;
    import flash.display3D.*;
    import flash.utils.*;

    public class FBlitColorVertexShaderBatchMaterial extends Object implements IGMaterial
    {
        private const CONSTANTS_PER_BATCH:int = 2;
        private const BATCH_SIZE:int = 62;
        private const VertexShaderEmbed:Class;
        private const VertexShaderCode:ByteArray;
        private var _p3ShaderProgram:Program3D;
        private var __vb3VertexBuffer:VertexBuffer3D;
        private var __vb3UVBuffer:VertexBuffer3D;
        private var __vb3RegisterIndexBuffer:VertexBuffer3D;
        private var __ib3IndexBuffer:IndexBuffer3D;
        private var __bInitializedThisFrame:Boolean;
        private var __iQuadCount:int = 0;
        private var __cContext:Context3D;
        private static const NORMALIZED_VERTICES:Vector.<Number> = FBlitColorVertexShaderBatchMaterial.Vector.<Number>([-0.5, 0.5, -0.5, -0.5, 0.5, -0.5, 0.5, 0.5]);
        private static const NORMALIZED_UVS:Vector.<Number> = FBlitColorVertexShaderBatchMaterial.Vector.<Number>([0, 1, 0, 0, 1, 0, 1, 1]);

        public function FBlitColorVertexShaderBatchMaterial()
        {
            VertexShaderEmbed = FBlitColorVertexShaderBatchMaterialVertex_ash;
            VertexShaderCode = new VertexShaderEmbed() as ByteArray;
            return;
        }

        function initialize(param1:Context3D) : void
        {
            var _loc_7:* = 0;
            var _loc_3:* = 0;
            __cContext = param1;
            VertexShaderCode.endian = "littleEndian";
            _p3ShaderProgram = param1.createProgram();
            _p3ShaderProgram.upload(VertexShaderCode, FFragmentShadersCommon.getColorShaderCode());
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
            return;
        }

        public function bind(param1:Context3D, param2:Boolean = false, param3:FCamera = null) : void
        {
            if (_p3ShaderProgram == null || param2 && !__bInitializedThisFrame)
            {
                initialize(param1);
            }
            __bInitializedThisFrame = param2;
            __cContext.setProgram(_p3ShaderProgram);
            __cContext.setVertexBufferAt(0, __vb3VertexBuffer, 0, "float2");
            __cContext.setVertexBufferAt(1, __vb3UVBuffer, 0, "float2");
            __cContext.setVertexBufferAt(2, __vb3RegisterIndexBuffer, 0, "float2");
            __iQuadCount = 0;
            return;
        }

        public function draw(param1:Vector.<Number>) : void
        {
            __cContext.setProgramConstantsFromVector("vertex", 4 + __iQuadCount * 2, param1, 2);
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
            __cContext.drawTriangles(__ib3IndexBuffer, 0, __iQuadCount * 2);
            __iQuadCount = 0;
            return;
        }

        public function clear() : void
        {
            __cContext.setVertexBufferAt(0, null);
            __cContext.setVertexBufferAt(1, null);
            __cContext.setVertexBufferAt(2, null);
            return;
        }

    }
}
