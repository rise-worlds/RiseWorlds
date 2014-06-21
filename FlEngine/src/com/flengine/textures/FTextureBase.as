package com.flengine.textures
{
	import com.flengine.fl2d;
	import com.flengine.context.FContextTexture;
	import com.flengine.core.FlEngine;
	import com.flengine.error.FError;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	use namespace fl2d;
	
	public class FTextureBase extends Object
	{
		
		public function FTextureBase(param1:String, param2:int, param3:*, param4:Boolean, param5:Function)
		{
			_iResampleType = defaultResampleType;
			_iResampleScale = defaultResampleScale;
			iFilteringType = __iDefaultFilteringType;
			super();
			if (!FlEngine.getInstance().isInitialized())
			{
				throw new FError("FError: FlEngine is not initialized.");
			}
			else if (param1 == null || param1.length == 0)
			{
				throw new FError("FError: Texture ID cannot be null or empty.");
			}
			else if (__dReferences[param1] != null)
			{
				throw new FError("FError: Texture with specified ID already exists.", param1);
			}
			else
			{
				__dReferences[param1] = this;
				_sId = param1;
				iSourceType = param2;
				bTransparent = param4;
				_fAsyncCallback = param5;
			}
		
		}
		
		public static var alwaysUseCompressed:Boolean = false;
		private static var __iDefaultResampleType:int = 2;
		
		public static function get defaultResampleType():int
		{
			return __iDefaultResampleType;
		}
		
		public static function set defaultResampleType(param1:int):void
		{
			if (!FTextureResampleType.isValid(param1))
			{
				throw new FError("FError: Invalid resample type.");
			}
			else
			{
				__iDefaultResampleType = param1;
				return;
			}
		}
		
		public static var defaultResampleScale:int = 1;
		private static var __iDefaultFilteringType:int = 1;
		
		public static function get defaultFilteringType():int
		{
			return __iDefaultFilteringType;
		}
		
		public static function set defaultFilteringType(param1:int):void
		{
			if (!FTextureFilteringType.isValid(param1))
			{
				throw new FError("FError: Invalid filtering type.");
			}
			else
			{
				__iDefaultFilteringType = param1;
				return;
			}
		}
		
		private static var __dReferences:Dictionary = new Dictionary;
		
		public static function getTextureBaseById(param1:String):FTextureBase
		{
			return __dReferences[param1];
		}
		
		public static function getGPUTextureCount():int
		{
			var _loc2_:int = 0;
			var _loc1_:FTextureBase;
			for each (_loc1_ in __dReferences)
			{
				if (_loc1_.cContextTexture && !_loc1_.hasParent())
				{
					_loc2_++;
				}
			}
			return _loc2_;
		}
		
		public static function getTextureCount():int
		{
			var _loc2_:int = 0;
			var _loc1_:FTextureBase;
			for each (_loc1_ in __dReferences)
			{
				if (_loc1_ is FTexture)
				{
					_loc2_++;
				}
			}
			return _loc2_;
		}
		
		fl2d static function invalidate():void
		{
			var _loc1_:String;
			for (_loc1_ in __dReferences)
			{
				(__dReferences[_loc1_] as FTextureBase).invalidateContextTexture(true);
			}
		}
		
		public function invalidate():void
		{
			invalidateContextTexture(false);
		}
		
		fl2d var bdBitmapData:BitmapData;
		
		public function get bitmapData():BitmapData
		{
			return bdBitmapData;
		}
		
		fl2d var baByteArray:ByteArray;
		
		protected var _iResampleType:int;
		
		public function get resampleType():int
		{
			return _iResampleType;
		}
		
		public function set resampleType(param1:int):void
		{
			if (!FTextureResampleType.isValid(param1))
			{
				throw new FError("FError: Invalid resample type.");
			}
			else
			{
				_iResampleType = param1;
				return;
			}
		}
		
		protected var _iResampleScale:int;
		
		public function get resampleScale():int
		{
			return _iResampleScale;
		}
		
		public function set resampleScale(param1:int):void
		{
			_iResampleScale = param1 > 0 ? param1 : 1;
			invalidateContextTexture(false);
		}
		
		fl2d var iFilteringType:int;
		
		public function get filteringType():int
		{
			return iFilteringType;
		}
		
		public function set filteringType(param1:int):void
		{
			if (!FTextureFilteringType.isValid(param1))
			{
				throw new FError("FError: Invalid filtering type.");
			}
			else
			{
				iFilteringType = param1;
				return;
			}
		}
		
		fl2d var nSourceWidth:int;
		
		fl2d var nSourceHeight:int;
		
		public var premultiplied:Boolean = true;
		
		fl2d var iWidth:int;
		
		public function get width():int
		{
			return iWidth;
		}
		
		public function get gpuWidth():int
		{
			return FTextureUtils.getNextValidTextureSize(iWidth);
		}
		
		fl2d var iHeight:int;
		
		public function get height():int
		{
			return iHeight;
		}
		
		public function get gpuHeight():int
		{
			return FTextureUtils.getNextValidTextureSize(iHeight);
		}
		
		public function hasParent():Boolean
		{
			return false;
		}
		
		protected var _sId:String;
		
		public function get id():String
		{
			return _sId;
		}
		
		fl2d var cContextTexture:FContextTexture;
		
		fl2d var iSourceType:int;
		
		fl2d var iAtfType:int;
		
		fl2d var bTransparent:Boolean;
		
		protected var _fAsyncCallback:Function;
		
		fl2d function getSource():*
		{
		}
		
		public var resampled:BitmapData;
		
		protected function invalidateContextTexture(param1:Boolean):void
		{
			var _loc4_:* = null;
			var _loc3_:* = 0;
			var _loc2_:* = 0;
		}
		
		protected function onATFUploaded(param1:Event):void
		{
			cContextTexture.tTexture.removeEventListener("textureReady", onATFUploaded);
			_fAsyncCallback(this);
			_fAsyncCallback = null;
		}
		
		public function dispose():void
		{
			delete __dReferences[_sId];
		}
	}
}
