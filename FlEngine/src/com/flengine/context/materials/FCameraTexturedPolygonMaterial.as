package com.flengine.context.materials
{
    import __AS3__.vec.*;
    import com.flengine.components.*;
    import com.flengine.context.materials.*;
    import com.flengine.core.*;
    import com.flengine.textures.*;
    import flash.display3D.*;
    import flash.display3D.textures.*;
    import flash.utils.*;

    public class FCameraTexturedPolygonMaterial extends Object implements IGMaterial
    {
        private const VertexShaderEmbed:Class;
        private const VertexShaderCode:ByteArray;
        private var _p3ShaderProgramLinear:Program3D;
        private var _p3ShaderProgramNearest:Program3D;
        private var __vb3VertexBuffer:VertexBuffer3D;
        private var __vb3UVBuffer:VertexBuffer3D;
        private var __ib3IndexBuffer:IndexBuffer3D;
        private var __bInitializedThisFrame:Boolean = false;
        private var __cActiveTexture:Texture;
        private var __iActiveFiltering:int;
        private var __aPrograms:Vector.<Program3D>;
        private var __p3dColorProgram:Program3D;
        private var __cContext:Context3D;
        private var __iMaxVertices:int;
        private var __aVertices:Vector.<Number>;
        private var __aUVs:Vector.<Number>;
        private var __aIndices:Vector.<uint>;

        public function FCameraTexturedPolygonMaterial()
        {
            VertexShaderEmbed = FCameraTexturedPolygonMaterialVertex_ash;
            VertexShaderCode = new VertexShaderEmbed() as ByteArray;
            __aPrograms = new Vector.<Program3D>;
            return;
        }

        function initialize(param1:Context3D, param2:int) : void
        {
            var _loc_4:* = 0;
            __cContext = param1;
            __iMaxVertices = param2;
            VertexShaderCode.endian = "littleEndian";
            __p3dColorProgram = __cContext.createProgram();
            __p3dColorProgram.upload(VertexShaderCode, FFragmentShadersCommon.getColorShaderCode());
            __aPrograms = new Vector.<Program3D>;
            _p3ShaderProgramNearest = __cContext.createProgram();
            _p3ShaderProgramNearest.upload(VertexShaderCode, FFragmentShadersCommon.getTexturedShaderCode(true, 0, true));
            __aPrograms.push(_p3ShaderProgramNearest);
            _p3ShaderProgramLinear = __cContext.createProgram();
            _p3ShaderProgramLinear.upload(VertexShaderCode, FFragmentShadersCommon.getTexturedShaderCode(true, 1, true));
            __aPrograms.push(_p3ShaderProgramLinear);
            __vb3VertexBuffer = __cContext.createVertexBuffer(__iMaxVertices, 2);
            __vb3UVBuffer = __cContext.createVertexBuffer(__iMaxVertices, 2);
            __ib3IndexBuffer = __cContext.createIndexBuffer(__iMaxVertices);
            var _loc_3:* = new Vector.<uint>;
            _loc_4 = 0;
            while (_loc_4 < __iMaxVertices)
            {
                
                _loc_3.push(_loc_4);
                _loc_4++;
            }
            __ib3IndexBuffer.uploadFromVector(_loc_3, 0, __iMaxVertices);
            return;
        }

        public function bind(param1:Context3D, param2:Boolean, param3:FCamera, param4:int) : void
        {
            if (_p3ShaderProgramLinear == null || param2 && !__bInitializedThisFrame || param4 != __iMaxVertices)
            {
                initialize(param1, param4);
            }
            __bInitializedThisFrame = param2;
            __cContext.setProgramConstantsFromVector("vertex", 4, param3.aCameraVector, 2);
            __cActiveTexture = null;
            __iActiveFiltering = FTextureBase.defaultFilteringType;
            __cContext.setProgram(__aPrograms[__iActiveFiltering]);
            return;
        }

        public function draw(param1:Vector.<Number>, param2:Texture, param3:int, param4:Vector.<Number>, param5:Vector.<Number>, param6:int, param7:Boolean) : void
        {
            if (__cActiveTexture != param2)
            {
                __cActiveTexture = param2;
                __cContext.setTextureAt(0, __cActiveTexture);
                if (__cActiveTexture == null)
                {
                    param3 = -1;
                }
            }
            if (__iActiveFiltering != param3)
            {
                __iActiveFiltering = param3;
                if (__cActiveTexture)
                {
                    __cContext.setProgram(__aPrograms[__iActiveFiltering]);
                }
                else
                {
                    __cContext.setProgram(__p3dColorProgram);
                }
            }
            if (param7)
            {
                __aVertices = param4;
                __vb3VertexBuffer.uploadFromVector(__aVertices, 0, __aVertices.length / 2);
            }
            if (param5 != __aUVs)
            {
                __aUVs = param5;
                __vb3UVBuffer.uploadFromVector(__aUVs, 0, __aUVs.length / 2);
            }
            __cContext.setVertexBufferAt(0, __vb3VertexBuffer, 0, "float2");
            __cContext.setVertexBufferAt(1, __vb3UVBuffer, 0, "float2");
            __cContext.setProgramConstantsFromVector("vertex", 6, param1, 4);
            (FStats.iDrawCalls + 1);
            __cContext.drawTriangles(__ib3IndexBuffer, 0, param6 / 3);
            return;
        }

        public function push() : void
        {
            return;
        }

        public function clear() : void
        {
            __cContext.setTextureAt(0, null);
            __cContext.setVertexBufferAt(0, null);
            __cContext.setVertexBufferAt(1, null);
            __cActiveTexture = null;
            __iActiveFiltering = 0;
            return;
        }

    }
}
