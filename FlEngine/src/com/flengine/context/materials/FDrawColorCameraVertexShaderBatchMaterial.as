package com.flengine.context.materials
{
	import flash.utils.ByteArray;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Context3D;
	
	import com.flengine.components.FCamera;
	import com.flengine.core.FStats;
	import com.flengine.fl2d;
	use namespace fl2d;
	
	public class FDrawColorCameraVertexShaderBatchMaterial extends Object implements IGMaterial
	{
		
		public function FDrawColorCameraVertexShaderBatchMaterial()
		{
//         VertexShaderEmbed = FCameraColorQuadVertexShaderBatchMaterialVertex_ash;
//         VertexShaderCode = new VertexShaderEmbed() as ByteArray;
			__aVertexConstants = new Vector.<Number>(122 * 4);
			super();
		}
		
		private static const NORMALIZED_VERTICES:Vector.<Number> = new <Number>[-0.5, 0.5, -0.5, -0.5, 0.5, -0.5, 0.5, 0.5];
		private static const NORMALIZED_UVS:Vector.<Number> = new <Number>[0, 1, 0, 0, 1, 0, 1, 1];
		private const CONSTANTS_OFFSET:int = 6;
		private const CONSTANTS_PER_BATCH:int = 3;
		private const BATCH_CONSTANTS:int = 122;
		private const BATCH_SIZE:int = 40;
		private const VertexShaderEmbed:Class = FCameraColorQuadVertexShaderBatchMaterialVertex_ash;
		private const VertexShaderCode:ByteArray = new VertexShaderEmbed() as ByteArray;
		private var __p3ShaderProgram:Program3D;
		private var __vb3VertexBuffer:VertexBuffer3D;
		private var __vb3RegisterIndexBuffer:VertexBuffer3D;
		private var __ib3IndexBuffer:IndexBuffer3D;
		private var __bInitializedThisFrame:Boolean;
		private var __iQuadCount:int = 0;
		private var __aVertexConstants:Vector.<Number>;
		private var __cContext:Context3D;
		
		fl2d function initialize(param1:Context3D):void
		{
			var _loc6_:* = 0;
			var _loc3_:* = 0;
			__cContext = param1;
			VertexShaderCode.endian = "littleEndian";
			__p3ShaderProgram = param1.createProgram();
			__p3ShaderProgram.upload(VertexShaderCode, FFragmentShadersCommon.getColorShaderCode());
			var _loc4_:Vector.<Number> = new Vector.<Number>();
			var _loc2_:Vector.<Number> = new Vector.<Number>();
			_loc6_ = 0;
			while (_loc6_ < 40)
			{
				_loc4_ = _loc4_.concat(NORMALIZED_VERTICES);
				_loc3_ = 6 + _loc6_ * 3;
				_loc2_.push(_loc3_, _loc3_ + 1, _loc3_ + 2);
				_loc2_.push(_loc3_, _loc3_ + 1, _loc3_ + 2);
				_loc2_.push(_loc3_, _loc3_ + 1, _loc3_ + 2);
				_loc2_.push(_loc3_, _loc3_ + 1, _loc3_ + 2);
				_loc6_++;
			}
			__vb3VertexBuffer = param1.createVertexBuffer(4 * 40, 2);
			__vb3VertexBuffer.uploadFromVector(_loc4_, 0, 4 * 40);
			__vb3RegisterIndexBuffer = param1.createVertexBuffer(4 * 40, 3);
			__vb3RegisterIndexBuffer.uploadFromVector(_loc2_, 0, 4 * 40);
			var _loc5_:Vector.<uint> = new Vector.<uint>();
			_loc6_ = 0;
			while (_loc6_ < 40)
			{
				_loc5_ = _loc5_.concat(Vector.<uint>([4 * _loc6_, 4 * _loc6_ + 1, 4 * _loc6_ + 2, 4 * _loc6_, 4 * _loc6_ + 2, 4 * _loc6_ + 3]));
				_loc6_++;
			}
			__ib3IndexBuffer = param1.createIndexBuffer(6 * 40);
			__ib3IndexBuffer.uploadFromVector(_loc5_, 0, 6 * 40);
		}
		
		public function bind(param1:Context3D, param2:Boolean, param3:FCamera):void
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
		}
		
		public function draw(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number):void
		{
			var _loc10_:int = __iQuadCount * 12;
			__aVertexConstants[_loc10_] = param1;
			__aVertexConstants[_loc10_ + 1] = param2;
			__aVertexConstants[_loc10_ + 2] = param3;
			__aVertexConstants[_loc10_ + 3] = param4;
			__aVertexConstants[_loc10_ + 4] = param5;
			__aVertexConstants[_loc10_ + 8] = param6 * param9;
			__aVertexConstants[_loc10_ + 9] = param7 * param9;
			__aVertexConstants[_loc10_ + 10] = param8 * param9;
			__aVertexConstants[_loc10_ + 11] = param9;
			__iQuadCount = __iQuadCount + 1;
			if (__iQuadCount == 40)
			{
				push();
			}
		}
		
		public function push():void
		{
			if (__iQuadCount == 0)
			{
				return;
			}
			__cContext.setProgramConstantsFromVector("vertex", 6, __aVertexConstants, 122);
			FStats.iDrawCalls++;
			__cContext.drawTriangles(__ib3IndexBuffer, 0, __iQuadCount * 2);
			__iQuadCount = 0;
		}
		
		public function clear():void
		{
			__cContext.setVertexBufferAt(0, null);
			__cContext.setVertexBufferAt(1, null);
		}
	}
}
