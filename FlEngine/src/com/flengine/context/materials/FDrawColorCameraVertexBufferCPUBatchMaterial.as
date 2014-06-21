package com.flengine.context.materials
{
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.Context3D;
	import com.adobe.utils.AGALMiniAssembler;
	import com.flengine.components.FCamera;
	import flash.geom.Matrix;
	import com.flengine.core.FStats;
	import com.flengine.fl2d;
	use namespace fl2d;
	
	public final class FDrawColorCameraVertexBufferCPUBatchMaterial extends Object implements IGMaterial
	{
		
		public function FDrawColorCameraVertexBufferCPUBatchMaterial()
		{
			super();
		}
		
		private static const BATCH_SIZE:int = 1000;
		private static const DATA_PER_VERTEX:int = 6;
		private static const VERTEX_SHADER_CODE:Array = [
				"mov vt0, va0", 
				"sub vt1, vt0.xy, vc5.xy", 
				"mul vt1, vt1.xy, vc5.zw", 
				"mov vt4.x, vc4.x", 
				"sin vt2.x, vt4.x", 
				"cos vt2.y, vt4.x", 
				"mul vt3.x, vt1.x, vt2.y", 
				"mul vt3.y, vt1.y, vt2.x", 
				"sub vt4.x, vt3.x, vt3.y", 
				"mul vt3.y, vt1.y, vt2.y", 
				"mul vt3.x, vt1.x, vt2.x", 
				"add vt4.y, vt3.y, vt3.x", 
				"add vt1, vt4.xy, vc4.yz", 
				"mov vt1.zw, vt0.zw", 
				"m44 op, vt1, vc0", 
				"mov v1, va1"];
		
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
		
		fl2d function initialize(param1:Context3D):void
		{
			var _loc3_:* = 0;
			__cContext = param1;
			vertexShader = new AGALMiniAssembler();
			vertexShader.assemble("vertex", VERTEX_SHADER_CODE.join("\n"));
			__p3ShaderProgram = param1.createProgram();
			__p3ShaderProgram.upload(vertexShader.agalcode, FFragmentShadersCommon.getColorShaderCode());
			__aVertexVector = new Vector.<Number>(3 * 1000 * 6);
			__vb3VertexBuffer = __cContext.createVertexBuffer(3 * 1000, 6);
			var _loc2_:Vector.<uint> = new Vector.<uint>();
			_loc3_ = 0;
			while (_loc3_ < 3 * 1000)
			{
				_loc2_.push(_loc3_);
				_loc3_++;
			}
			__ib3TriangleIndexBuffer = param1.createIndexBuffer(3 * 1000);
			__ib3TriangleIndexBuffer.uploadFromVector(_loc2_, 0, 3 * 1000);
			_loc2_.length = 0;
			_loc3_ = 0;
			while (_loc3_ < 1000 / 2)
			{
				_loc2_ = _loc2_.concat(Vector.<uint>([4 * _loc3_, 4 * _loc3_ + 1, 4 * _loc3_ + 2, 4 * _loc3_, 4 * _loc3_ + 2, 4 * _loc3_ + 3]));
				_loc3_++;
			}
			__ib3QuadIndexBuffer = param1.createIndexBuffer(3 * 1000);
			__ib3QuadIndexBuffer.uploadFromVector(_loc2_, 0, 3 * 1000);
			__iTriangleCount = 0;
		}
		
		fl2d function bind(param1:Context3D, param2:Boolean, param3:FCamera):void
		{
			if (__p3ShaderProgram == null || param2 && !__bInitializedThisFrame)
			{
				initialize(param1);
			}
			__bInitializedThisFrame = param2;
			__cContext.setProgram(__p3ShaderProgram);
			__cContext.setProgramConstantsFromVector("vertex", 4, param3.aCameraVector, 2);
			__cContext.setProgramConstantsFromVector("fragment", 0, Vector.<Number>([1, 0, 0, 0.5]), 1);
			__iTriangleCount = 0;
		}
		
		public function draw(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number):void
		{
			__bDrawQuads = true;
			var _loc11_:Number = Math.cos(param5);
			var _loc14_:Number = Math.sin(param5);
			var _loc18_:Number = 0.5 * param3;
			var _loc17_:Number = 0.5 * param4;
			var _loc12_:Number = _loc11_ * _loc18_;
			var _loc13_:Number = _loc11_ * _loc17_;
			var _loc15_:Number = _loc14_ * _loc18_;
			var _loc16_:Number = _loc14_ * _loc17_;
			var _loc10_:int = 6 * 3 * __iTriangleCount;
			__aVertexVector[_loc10_] = -_loc12_ - _loc16_ + param1;
			__aVertexVector[_loc10_ + 1] = _loc13_ - _loc15_ + param2;
			__aVertexVector[_loc10_ + 2] = param6;
			__aVertexVector[_loc10_ + 3] = param7;
			__aVertexVector[_loc10_ + 4] = param8;
			__aVertexVector[_loc10_ + 5] = param9;
			__aVertexVector[_loc10_ + 6] = -_loc12_ + _loc16_ + param1;
			__aVertexVector[_loc10_ + 7] = -_loc13_ - _loc15_ + param2;
			__aVertexVector[_loc10_ + 8] = param6;
			__aVertexVector[_loc10_ + 9] = param7;
			__aVertexVector[_loc10_ + 10] = param8;
			__aVertexVector[_loc10_ + 11] = param9;
			__aVertexVector[_loc10_ + 12] = _loc12_ + _loc16_ + param1;
			__aVertexVector[_loc10_ + 13] = -_loc13_ + _loc15_ + param2;
			__aVertexVector[_loc10_ + 14] = param6;
			__aVertexVector[_loc10_ + 15] = param7;
			__aVertexVector[_loc10_ + 16] = param8;
			__aVertexVector[_loc10_ + 17] = param9;
			__aVertexVector[_loc10_ + 18] = _loc12_ - _loc16_ + param1;
			__aVertexVector[_loc10_ + 19] = _loc13_ + _loc15_ + param2;
			__aVertexVector[_loc10_ + 20] = param6;
			__aVertexVector[_loc10_ + 21] = param7;
			__aVertexVector[_loc10_ + 22] = param8;
			__aVertexVector[_loc10_ + 23] = param9;
			__iTriangleCount = __iTriangleCount + 2;
			if (__iTriangleCount == 1000)
			{
				push();
			}
		}
		
		public function drawPoly(param1:Vector.<Number>, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number):void
		{
			var _loc14_:* = 0;
			__bDrawQuads = false;
			var _loc13_:Number = Math.cos(param6);
			var _loc16_:Number = Math.sin(param6);
			var _loc12_:int = param1.length;
			var _loc15_:* = _loc12_ >> 1;
			var _loc17_:int = _loc15_ / 3;
			if (__iTriangleCount + _loc17_ > 1000)
			{
				push();
			}
			var _loc11_:int = 6 * 3 * __iTriangleCount;
			_loc14_ = 0;
			while (_loc14_ < _loc12_)
			{
				__aVertexVector[_loc11_] = _loc13_ * param1[_loc14_] * param4 - _loc16_ * param1[_loc14_ + 1] * param5 + param2;
				__aVertexVector[_loc11_ + 1] = _loc16_ * param1[_loc14_] * param4 + _loc13_ * param1[_loc14_ + 1] * param5 + param3;
				__aVertexVector[_loc11_ + 2] = param7;
				__aVertexVector[_loc11_ + 3] = param8;
				__aVertexVector[_loc11_ + 4] = param9;
				__aVertexVector[_loc11_ + 5] = param10;
				_loc11_ = _loc11_ + 6;
				_loc14_ = _loc14_ + 2;
			}
			__iTriangleCount = __iTriangleCount + _loc17_;
			if (__iTriangleCount >= 1000)
			{
				push();
			}
		}
		
		public function drawMatrix(param1:Matrix, param2:Number, param3:Number, param4:Number, param5:Number):void
		{
			__bDrawQuads = true;
			var _loc7_:int = 6 * 2 * __iTriangleCount;
			var _loc6_:* = 0.5;
			var _loc8_:* = 0.5;
			__aVertexVector[_loc7_] = param1.a * -_loc6_ + param1.c * _loc8_ + param1.tx;
			__aVertexVector[_loc7_ + 1] = param1.d * _loc8_ + param1.b * -_loc6_ + param1.ty;
			__aVertexVector[_loc7_ + 2] = param2;
			__aVertexVector[_loc7_ + 3] = param3;
			__aVertexVector[_loc7_ + 4] = param4;
			__aVertexVector[_loc7_ + 5] = param5;
			__aVertexVector[_loc7_ + 6] = param1.a * -_loc6_ + param1.c * -_loc8_ + param1.tx;
			__aVertexVector[_loc7_ + 7] = param1.d * -_loc8_ + param1.b * -_loc6_ + param1.ty;
			__aVertexVector[_loc7_ + 8] = param2;
			__aVertexVector[_loc7_ + 9] = param3;
			__aVertexVector[_loc7_ + 10] = param4;
			__aVertexVector[_loc7_ + 11] = param5;
			__aVertexVector[_loc7_ + 12] = param1.a * _loc6_ + param1.c * -_loc8_ + param1.tx;
			__aVertexVector[_loc7_ + 13] = param1.d * -_loc8_ + param1.b * _loc6_ + param1.ty;
			__aVertexVector[_loc7_ + 14] = param2;
			__aVertexVector[_loc7_ + 15] = param3;
			__aVertexVector[_loc7_ + 16] = param4;
			__aVertexVector[_loc7_ + 17] = param5;
			__aVertexVector[_loc7_ + 18] = param1.a * _loc6_ + param1.c * _loc8_ + param1.tx;
			__aVertexVector[_loc7_ + 19] = param1.d * _loc8_ + param1.b * _loc6_ + param1.ty;
			__aVertexVector[_loc7_ + 20] = param2;
			__aVertexVector[_loc7_ + 21] = param3;
			__aVertexVector[_loc7_ + 22] = param4;
			__aVertexVector[_loc7_ + 23] = param5;
			__iTriangleCount = __iTriangleCount + 2;
			if (__iTriangleCount == 1000)
			{
				push();
			}
		}
		
		public function push():void
		{
			FStats.iDrawCalls++;
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
		}
		
		public function clear():void
		{
			__cContext.setVertexBufferAt(0, null);
			__cContext.setVertexBufferAt(1, null);
		}
	}
}
