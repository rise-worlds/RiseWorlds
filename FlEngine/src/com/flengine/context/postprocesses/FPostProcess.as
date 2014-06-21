package com.flengine.context.postprocesses
{
	import com.flengine.context.filters.FFilter;
	import com.flengine.textures.FTexture;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import com.flengine.context.FContext;
	import com.flengine.components.FCamera;
	import com.flengine.core.FNode;
	import com.flengine.core.FlEngine;
	import com.flengine.textures.factories.FTextureFactory;
	import com.flengine.error.FError;
	import com.flengine.fl2d;
	use namespace fl2d;
	
	public class FPostProcess extends Object
	{
		
		public function FPostProcess(param1:int = 1)
		{
			_cMatrix = new Matrix3D();
			super();
			__iCount = __iCount + 1;
			_sId = __iCount.toString();
			if (param1 < 1)
			{
				throw new FError("FError: Post process needs atleast one pass.");
			}
			else
			{
				_iPasses = param1;
				_aPassFilters = new Vector.<FFilter>(_iPasses);
				_aPassTextures = new Vector.<FTexture>(_iPasses);
				createPassTextures();
				return;
			}
		}
		
		private static var __iCount:int = 0;
		
		protected var _iPasses:int = 1;
		
		public function get passes():int
		{
			return _iPasses;
		}
		
		protected var _aPassFilters:Vector.<FFilter>;
		protected var _aPassTextures:Vector.<FTexture>;
		protected var _cMatrix:Matrix3D;
		protected var _rDefinedBounds:Rectangle;
		protected var _rActiveBounds:Rectangle;
		protected var _iLeftMargin:int = 0;
		protected var _iRightMargin:int = 0;
		protected var _iTopMargin:int = 0;
		protected var _iBottomMargin:int = 0;
		protected var _sId:String;
		
		public function setBounds(param1:Rectangle):void
		{
			_rDefinedBounds = param1;
		}
		
		public function setMargins(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0):void
		{
			_iLeftMargin = param1;
			_iRightMargin = param2;
			_iTopMargin = param3;
			_iBottomMargin = param4;
		}
		
		public function render(param1:FContext, param2:FCamera, param3:Rectangle, param4:FNode, param5:Rectangle = null, param6:FTexture = null, param7:FTexture = null):void
		{
			var _loc10_:* = 0;
			var _loc8_:* = param5;
			if (_loc8_ == null)
			{
				_loc8_ = _rDefinedBounds ? _rDefinedBounds : param4.getWorldBounds(_rActiveBounds);
			}
			if (_loc8_.x == 1.7976931348623157E308)
			{
				return;
			}
			updatePassTextures(_loc8_);
			if (param6 == null)
			{
				_cMatrix.identity();
				_cMatrix.prependTranslation(-_loc8_.x + _iLeftMargin, -_loc8_.y + _iTopMargin, 0);
				param1.setRenderTarget(_aPassTextures[0], _cMatrix);
				param1.setCamera(FlEngine.getInstance().defaultCamera);
				param4.render(param1, param2, _aPassTextures[0].region, false);
			}
			var _loc9_:FTexture = _aPassTextures[0];
			if (param6)
			{
				_aPassTextures[0] = param6;
			}
			_loc10_ = 1;
			while (_loc10_ < _iPasses)
			{
				param1.setRenderTarget(_aPassTextures[_loc10_]);
				param1.draw(_aPassTextures[_loc10_ - 1], 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, _aPassTextures[_loc10_].region, _aPassFilters[_loc10_ - 1]);
				_loc10_++;
			}
			param1.setRenderTarget(param7);
			if (param7 == null)
			{
				param1.setCamera(param2);
				param1.draw(_aPassTextures[_iPasses - 1], _loc8_.x - _iLeftMargin, _loc8_.y - _iTopMargin, 1, 1, 0, 1, 1, 1, 1, 1, param3, _aPassFilters[_iPasses - 1]);
			}
			else
			{
				param1.draw(_aPassTextures[_iPasses - 1], 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, param7.region, _aPassFilters[_iPasses - 1]);
			}
			_aPassTextures[0] = _loc9_;
		}
		
		public function getPassTexture(param1:int):FTexture
		{
			return _aPassTextures[param1];
		}
		
		public function getPassFilter(param1:int):FFilter
		{
			return _aPassFilters[param1];
		}
		
		protected function updatePassTextures(param1:Rectangle):void
		{
			var _loc5_:* = 0;
			var _loc3_:* = null;
			var _loc2_:Number = param1.width + _iLeftMargin + _iRightMargin;
			var _loc4_:Number = param1.height + _iTopMargin + _iBottomMargin;
			if (!(_aPassTextures[0].width == _loc2_) || !(_aPassTextures[0].height == _loc4_))
			{
				_loc5_ = _aPassTextures.length - 1;
				while (_loc5_ >= 0)
				{
					_loc3_ = _aPassTextures[_loc5_];
					_loc3_.region = new Rectangle(0, 0, _loc2_, _loc4_);
					_loc3_.pivotX = -_loc3_.iWidth / 2;
					_loc3_.pivotY = -_loc3_.iHeight / 2;
					_loc5_--;
				}
			}
		}
		
		protected function createPassTextures():void
		{
			var _loc2_:* = 0;
			var _loc1_:* = null;
			_loc2_ = 0;
			while (_loc2_ < _iPasses)
			{
				_loc1_ = FTextureFactory.createRenderTexture("g2d_pp_" + _sId + "_" + _loc2_, 2, 2, true);
				_loc1_.filteringType = 0;
				_loc1_.pivotX = -_loc1_.iWidth / 2;
				_loc1_.pivotY = -_loc1_.iHeight / 2;
				_aPassTextures[_loc2_] = _loc1_;
				_loc2_++;
			}
		}
		
		public function dispose():void
		{
			var _loc1_:* = 0;
			_loc1_ = _aPassTextures.length - 1;
			while (_loc1_ >= 0)
			{
				_aPassTextures[_loc1_].dispose();
				_loc1_--;
			}
		}
	}
}
