package com.flengine.context.materials
{
    import __AS3__.vec.*;
    import com.adobe.utils.*;
    import com.flengine.components.*;
    import com.flengine.context.materials.*;
    import com.flengine.core.*;
    import flash.display3D.*;

    public class FShadowMaterial extends Object implements IGMaterial
    {
        private const CONSTANTS_OFFSET:int = 7;
        private const BATCH_CONSTANTS:int = 121;
        private const CONSTANTS_PER_BATCH:int = 2;
        private const BATCH_SIZE:int = 60;
        private var __p3ShaderProgram:Program3D;
        private var __vb3VertexBuffer:VertexBuffer3D;
        private var __vb3RegisterIndexBuffer:VertexBuffer3D;
        private var __aTransformVector:Vector.<Number>;
        private var __vb3TransformBuffer:VertexBuffer3D;
        private var __ib3IndexBuffer:IndexBuffer3D;
        private var __bInitializedThisFrame:Boolean;
        private var __iQuadCount:int = 0;
        private var __iConstantsOffset:int = 0;
        private var __aVertexConstants:Vector.<Number>;
        private var __cContext:Context3D;
        private static const NORMALIZED_VERTICES:Vector.<Number> = FShadowMaterial.Vector.<Number>([-0.5, 0.5, 0, -0.5, -0.5, 0, -0.5, -0.5, 1, -0.5, 0.5, 1, 0.5, 0.5, 0, -0.5, 0.5, 0, -0.5, 0.5, 1, 0.5, 0.5, 1, 0.5, -0.5, 0, 0.5, 0.5, 0, 0.5, 0.5, 1, 0.5, -0.5, 1, -0.5, -0.5, 0, 0.5, -0.5, 0, 0.5, -0.5, 1, -0.5, -0.5, 1]);
        private static const VERTEX_SHADER_CODE2:Array = ["mov vt0, va0", "mul vt5, va0.xy, vc[va1.x].zw", "mov vt5.zw, vt0.zw", "m44 op, vt5, vc0"];
        private static const VERTEX_SHADER_CODE:Array = ["mov vt0, va0", "mul vt5, va0.xy, vc[va1.x].zw", "mov vt4.x, vc[va1.y].x", "sin vt1.x, vt4.x", "cos vt1.y, vt4.x", "mul vt2.x, vt5.x, vt1.y", "mul vt3.y, vt5.y, vt1.x", "sub vt4.x, vt2.x, vt3.y", "mul vt2.y, vt5.y, vt1.y", "mul vt3.x, vt5.x, vt1.x", "add vt4.y, vt2.y, vt3.x", "add vt1, vt4.xy, vc[va1.x].xy", "sub vt2, vt1.xy, vc[va1.y].zw", "mul vt2, vt2, va0.z", "mul vt2, vt2, vc[va1.y].y", "add vt1.xy, vt1.xy, vt2.xy", "sub vt1, vt1.xy, vc5.xy", "mul vt1, vt1.xy, vc5.zw", "mov vt4.x, vc4.x", "sin vt2.x, vt4.x", "cos vt2.y, vt4.x", "mul vt3.x, vt1.x, vt2.y", "mul vt3.y, vt1.y, vt2.x", "sub vt4.x, vt3.x, vt3.y", "mul vt3.y, vt1.y, vt2.y", "mul vt3.x, vt1.x, vt2.x", "add vt4.y, vt3.y, vt3.x", "add vt1, vt4.xy, vc4.yz", "mov vt1.zw, vt0.zw", "m44 op, vt1, vc0"];
        private static const FRAGMENT_SHADER_CODE:Array = ["mov oc, fc0"];

        public function FShadowMaterial()
        {
            __aVertexConstants = new Vector.<Number>(484);
            return;
        }// end function

        function initialize(param1:Context3D) : void
        {
            var _loc_8:* = 0;
            var _loc_4:* = 0;
            __cContext = param1;
            var _loc_3:* = new AGALMiniAssembler();
            _loc_3.assemble("vertex", VERTEX_SHADER_CODE.join("\n"));
            var _loc_7:* = new AGALMiniAssembler();
            _loc_3.assemble("fragment", FRAGMENT_SHADER_CODE.join("\n"));
            __p3ShaderProgram = param1.createProgram();
            __p3ShaderProgram.upload(_loc_3.agalcode, _loc_7.agalcode);
            var _loc_5:* = new Vector.<Number>;
            var _loc_2:* = new Vector.<Number>;
            _loc_8 = 0;
            while (_loc_8 < 60)
            {
                
                _loc_5 = _loc_5.concat(NORMALIZED_VERTICES);
                _loc_4 = 7 + _loc_8 * 2;
                _loc_2.push(_loc_4, (_loc_4 + 1));
                _loc_2.push(_loc_4, (_loc_4 + 1));
                _loc_2.push(_loc_4, (_loc_4 + 1));
                _loc_2.push(_loc_4, (_loc_4 + 1));
                _loc_2.push(_loc_4, (_loc_4 + 1));
                _loc_2.push(_loc_4, (_loc_4 + 1));
                _loc_2.push(_loc_4, (_loc_4 + 1));
                _loc_2.push(_loc_4, (_loc_4 + 1));
                _loc_2.push(_loc_4, (_loc_4 + 1));
                _loc_2.push(_loc_4, (_loc_4 + 1));
                _loc_2.push(_loc_4, (_loc_4 + 1));
                _loc_2.push(_loc_4, (_loc_4 + 1));
                _loc_2.push(_loc_4, (_loc_4 + 1));
                _loc_2.push(_loc_4, (_loc_4 + 1));
                _loc_2.push(_loc_4, (_loc_4 + 1));
                _loc_2.push(_loc_4, (_loc_4 + 1));
                _loc_8++;
            }
            __vb3VertexBuffer = param1.createVertexBuffer(960, 3);
            __vb3VertexBuffer.uploadFromVector(_loc_5, 0, 960);
            __vb3RegisterIndexBuffer = param1.createVertexBuffer(960, 2);
            __vb3RegisterIndexBuffer.uploadFromVector(_loc_2, 0, 960);
            var _loc_6:* = new Vector.<uint>;
            _loc_8 = 0;
            while (_loc_8 < 240)
            {
                
                _loc_6 = _loc_6.concat(this.Vector.<uint>([4 * _loc_8, 4 * _loc_8 + 1, 4 * _loc_8 + 2, 4 * _loc_8, 4 * _loc_8 + 2, 4 * _loc_8 + 3]));
                _loc_8++;
            }
            __ib3IndexBuffer = param1.createIndexBuffer(1440);
            __ib3IndexBuffer.uploadFromVector(_loc_6, 0, 1440);
            return;
        }// end function

        function bind(param1:Context3D, param2:Boolean, param3:FCamera) : void
        {
            if (__p3ShaderProgram == null || param2 && !__bInitializedThisFrame)
            {
                initialize(param1);
            }
            __bInitializedThisFrame = param2;
            __cContext.setProgramConstantsFromVector("vertex", 4, param3.aCameraVector, 2);
            __cContext.setProgramConstantsFromVector("vertex", 6, this.Vector.<Number>([0, -1, 0.5, 1]), 1);
            __cContext.setProgramConstantsFromVector("fragment", 0, this.Vector.<Number>([0, 0, 0, 1]), 1);
            __cContext.setProgram(__p3ShaderProgram);
            __cContext.setVertexBufferAt(0, __vb3VertexBuffer, 0, "float3");
            __cContext.setVertexBufferAt(1, __vb3RegisterIndexBuffer, 0, "float2");
            __iQuadCount = 0;
            __iConstantsOffset = 0;
            return;
        }// end function

        function draw(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number = 1) : void
        {
            __aVertexConstants[__iConstantsOffset] = param1;
            __aVertexConstants[(__iConstantsOffset + 1)] = param2;
            __aVertexConstants[__iConstantsOffset + 2] = param3;
            __aVertexConstants[__iConstantsOffset + 3] = param4;
            __aVertexConstants[__iConstantsOffset + 4] = param5;
            __aVertexConstants[__iConstantsOffset + 5] = param8;
            __aVertexConstants[__iConstantsOffset + 6] = param6;
            __aVertexConstants[__iConstantsOffset + 7] = param7;
            (__iQuadCount + 1);
            __iConstantsOffset = __iQuadCount * 8;
            if (__iQuadCount == 60)
            {
                push();
            }
            return;
        }// end function

        public function push() : void
        {
            (FStats.iDrawCalls + 1);
            __cContext.setProgramConstantsFromVector("vertex", 7, __aVertexConstants, 121);
            __cContext.drawTriangles(__ib3IndexBuffer, 0, __iQuadCount * 8);
            __iQuadCount = 0;
            return;
        }// end function

        public function clear() : void
        {
            __cContext.setTextureAt(0, null);
            __cContext.setVertexBufferAt(0, null);
            __cContext.setVertexBufferAt(1, null);
            return;
        }// end function

    }
}
