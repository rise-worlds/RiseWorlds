package com.flengine.textures
{
	import flash.geom.Point;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	public class FTextureUtils extends Object
	{
		
		public function FTextureUtils()
		{
			super();
		}
		
		private static const ZERO_POINT:Point = new Point;
		
		public static function isBitmapDataTransparent(param1:BitmapData):Boolean
		{
			return !(param1.getColorBoundsRect(4.27819008E9, 4.27819008E9, false).width == 0);
		}
		
		public static function isValidTextureSize(param1:int):Boolean
		{
			var _loc2_:* = 1;
			while (_loc2_ < param1)
			{
				_loc2_ = _loc2_ * 2;
			}
			return _loc2_ == param1;
		}
		
		public static function getNextValidTextureSize(param1:int):int
		{
			var _loc2_:* = 1;
			while (param1 > _loc2_)
			{
				_loc2_ = _loc2_ * 2;
			}
			return _loc2_;
		}
		
		public static function getPreviousValidTextureSize(param1:int):int
		{
			var _loc2_:* = 1;
			while (param1 > _loc2_)
			{
				_loc2_ = _loc2_ * 2;
			}
			_loc2_ = _loc2_ / 2;
			return _loc2_;
		}
		
		public static function getNearestValidTextureSize(param1:int):int
		{
			var _loc2_:int = getPreviousValidTextureSize(param1);
			var _loc3_:int = getNextValidTextureSize(param1);
			return param1 - _loc2_ < _loc3_ - param1 ? _loc2_ : _loc3_;
		}
	
		//public static function resampleBitmapData(param1:BitmapData, param2:int, param3:int) : BitmapData {
		//   var _loc11_:* = 0;
		//   var _loc10_:* = 0;
		//   var _loc7_:* = null;
		//   var _loc9_:* = null;
		//   var _loc4_:* = NaN;
		//   var _loc6_:* = NaN;
		//   var _loc5_:* = NaN;
		//   var _loc8_:int = param1.width;
		//   var _loc12_:int = param1.height;
		//}
	}
}
