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
	
	public class FBlitColorVertexShaderBatchMaterial extends Object implements IGMaterial
	{
		
		public function FBlitColorVertexShaderBatchMaterial()
		{
//			VertexShaderEmbed = FBlitColorVertexShaderBatchMaterialVertex_ash;
//			VertexShaderCode = new VertexShaderEmbed() as ByteArray;
			super();
		}
		
		private static const NORMALIZED_VERTICES:Vector.<Number> = new <Number>[-0.5, 0.5, -0.5, -0.5, 0.5, -0.5, 0.5, 0.5];
		private static const NORMALIZED_UVS:Vector.<Number> = new <Number>[0, 1, 0, 0, 1, 0, 1, 1];
		private const CONSTANTS_PER_BATCH:int = 2;
		private const BATCH_SIZE:int = 62;
		private const VertexShaderEmbed:Class = FBlitColorVertexShaderBatchMaterialVertex_ash;
		private const VertexShaderCode:ByteArray = new VertexShaderEmbed() as ByteArray;
		private var _p3ShaderProgram:Program3D;
		private var __vb3VertexBuffer:VertexBuffer3D;
		private var __vb3UVBuffer:VertexBuffer3D;
		private var __vb3RegisterIndexBuffer:VertexBuffer3D;
		private var __ib3IndexBuffer:IndexBuffer3D;
		private var __bInitializedThisFrame:Boolean;
		private var __iQuadCount:int = 0;
		private var __cContext:Context3D;
		
		fl2d function initialize(param1:Context3D):void
		{
			var _loc7_:* = 0;
			var _loc3_:* = 0;
			__cContext = param1;
			VertexShaderCode.endian = "littleEndian";
			_p3ShaderProgram = param1.createProgram();
			_p3ShaderProgram.upload(VertexShaderCode, FFragmentShadersCommon.getColorShaderCode());
			var _loc4_:Vector.<Number> = new Vector.<Number>();
			var _loc6_:Vector.<Number> = new Vector.<Number>();
			var _loc2_:Vector.<Number> = new Vector.<Number>();
			_loc7_ = 0;
			while (_loc7_ < 62)
			{
				_loc4_ = _loc4_.concat(NORMALIZED_VERTICES);
				_loc6_ = _loc6_.concat(NORMALIZED_UVS);
				_loc3_ = 4 + _loc7_ * 2;
				_loc2_.push(_loc3_, _loc3_ + 1);
				_loc2_.push(_loc3_, _loc3_ + 1);
				_loc2_.push(_loc3_, _loc3_ + 1);
				_loc2_.push(_loc3_, _loc3_ + 1);
				_loc7_++;
			}
			__vb3VertexBuffer = param1.createVertexBuffer(248, 2);
			__vb3VertexBuffer.uploadFromVector(_loc4_, 0, 248);
			__vb3UVBuffer = param1.createVertexBuffer(248, 2);
			__vb3UVBuffer.uploadFromVector(_loc6_, 0, 248);
			__vb3RegisterIndexBuffer = param1.createVertexBuffer(248, 2);
			__vb3RegisterIndexBuffer.uploadFromVector(_loc2_, 0, 248);
			var _loc5_:Vector.<uint> = new Vector.<uint>();
			_loc7_ = 0;
			while (_loc7_ < 62)
			{
				_loc5_ = _loc5_.concat(Vector.<uint>([4 * _loc7_, 4 * _loc7_ + 1, 4 * _loc7_ + 2, 4 * _loc7_, 4 * _loc7_ + 2, 4 * _loc7_ + 3]));
				_loc7_++;
			}
			__ib3IndexBuffer = param1.createIndexBuffer(372);
			__ib3IndexBuffer.uploadFromVector(_loc5_, 0, 372);
		}
		
		public function bind(param1:Context3D, param2:Boolean = false, param3:FCamera = null):void
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
		}
		
		public function draw(param1:Vector.<Number>):void
		{
			__cContext.setProgramConstantsFromVector("vertex", 4 + __iQuadCount * 2, param1, 2);
			__iQuadCount = __iQuadCount + 1;
			if (__iQuadCount == 62)
			{
				push();
			}
		}
		
		public function push():void
		{
			FStats.iDrawCalls = FStats.iDrawCalls + 1;
			__cContext.drawTriangles(__ib3IndexBuffer, 0, __iQuadCount * 2);
			__iQuadCount = 0;
		}
		
		public function clear():void
		{
			__cContext.setVertexBufferAt(0, null);
			__cContext.setVertexBufferAt(1, null);
			__cContext.setVertexBufferAt(2, null);
		}
	}
}
