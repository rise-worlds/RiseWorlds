package com.flengine.textures
{
    import com.flengine.context.*;
    import com.flengine.core.*;
    import com.flengine.error.*;
    import flash.display.*;
	import flash.display3D.Context3DTextureFormat;
    import flash.events.*;
    import flash.utils.*;

    public class FTextureBase extends Object
    {
        public var bdBitmapData:BitmapData;
        public var baByteArray:ByteArray;
        protected var _iResampleType:int;
        protected var _iResampleScale:int;
        public var iFilteringType:int;
        public var nSourceWidth:int;
        public var nSourceHeight:int;
        public var premultiplied:Boolean = true;
        public var iWidth:int;
        public var iHeight:int;
        protected var _sId:String;
        public var cContextTexture:FContextTexture;
        public var iSourceType:int;
        public var iAtfType:int;
        public var bTransparent:Boolean;
        protected var _fAsyncCallback:Function;
        public var resampled:BitmapData;
        public static var alwaysUseCompressed:Boolean = false;
        private static var __iDefaultResampleType:int = 2;
        public static var defaultResampleScale:int = 1;
        private static var __iDefaultFilteringType:int = 1;
        private static var __dReferences:Dictionary = new Dictionary();

        public function FTextureBase(param1:String, param2:int, param3:*, param4:Boolean, param5:Function)
        {
            _iResampleType = defaultResampleType;
            _iResampleScale = defaultResampleScale;
            iFilteringType = __iDefaultFilteringType;
            if (!FlEngine.getInstance().isInitialized())
            {
                throw new FError(FError.GENOME2D_NOT_INITIALIZED);
            }
            if (param1 == null || param1.length == 0)
            {
                throw new FError(FError.INVALID_TEXTURE_ID);
            }
            if (__dReferences[param1] != null)
            {
                throw new FError(FError.DUPLICATE_TEXTURE_ID, param1);
            }
            __dReferences[param1] = this;
            _sId = param1;
            iSourceType = param2;
            bTransparent = param4;
            _fAsyncCallback = param5;
            //switch(param2) branch count is:<3>[36, 55, 81, 17] default offset is:<122>;
            //bdBitmapData = param3 as BitmapData;
            //premultiplied = true;
            //;
            //baByteArray = param3 as ByteArray;
            //premultiplied = false;
            //;
            //baByteArray = param3 as ByteArray;
            //iAtfType = 1;
            //premultiplied = false;
            //;
            //baByteArray = param3 as ByteArray;
            //iAtfType = 2;
            //premultiplied = false;
            //;
            //baByteArray = param3 as ByteArray;
            //premultiplied = false;
			switch(param2)
			{
				case FTextureSourceType.BITMAPDATA:
				bdBitmapData = param3 as BitmapData;
				premultiplied = true;
				break;
				case FTextureSourceType.ATF_BGRA:
				baByteArray = param3 as ByteArray;
				premultiplied = false;
				break;
				case FTextureSourceType.ATF_COMPRESSED:
				baByteArray = param3 as ByteArray;
				iAtfType = FTextureAtfType.ATF_Type_Dxt1;
				premultiplied = false;
				break;
				case FTextureSourceType.ATF_COMPRESSEDALPHA:
				baByteArray = param3 as ByteArray;
				iAtfType = FTextureAtfType.ATF_Type_Dxt5;
				premultiplied = false;
				break;
				case FTextureSourceType.BYTEARRAY:
				baByteArray = param3 as ByteArray;
				premultiplied = false;
				break;
			}
            return;
        }

        public function invalidate() : void
        {
            invalidateContextTexture(false);
            return;
        }

        public function get bitmapData() : BitmapData
        {
            return bdBitmapData;
        }

        public function get resampleType() : int
        {
            return _iResampleType;
        }

        public function set resampleType(param1:int) : void
        {
            if (!FTextureResampleType.isValid(param1))
            {
                 throw new FError(FError.INVALID_RESAMPLE_TYPE);
            }
            _iResampleType = param1;
            return;
        }

        public function get resampleScale() : int
        {
            return _iResampleScale;
        }

        public function set resampleScale(param1:int) : void
        {
            _iResampleScale = param1 > 0 ? (param1) : (1);
            invalidateContextTexture(false);
            return;
        }

        public function get filteringType() : int
        {
            return iFilteringType;
        }

        public function set filteringType(param1:int) : void
        {
            if (!FTextureFilteringType.isValid(param1))
            {
               throw new FError(FError.INVALID_FILTERING_TYPE);
            }
            iFilteringType = param1;
            return;
        }

        public function get width() : int
        {
            return iWidth;
        }

        public function get gpuWidth() : int
        {
            return FTextureUtils.getNextValidTextureSize(iWidth);
        }

        public function get height() : int
        {
            return iHeight;
        }

        public function get gpuHeight() : int
        {
            return FTextureUtils.getNextValidTextureSize(iHeight);
        }

        public function hasParent() : Boolean
        {
            return false;
        }

        public function get id() : String
        {
            return _sId;
        }

        public function getSource():*
        {
            //switch((iSourceType - 1)) branch count is:<2>[21, 28, 14] default offset is:<31>;
            //return bdBitmapData;
            //;
            //return baByteArray;
            //;
            //return baByteArray;
			switch(iSourceType)
			{
				case FTextureSourceType.BITMAPDATA:
				return bdBitmapData;
				case FTextureSourceType.ATF_COMPRESSED:
				return baByteArray;
				case FTextureSourceType.BYTEARRAY:
				return baByteArray;
			}
			return null;
        }

        protected function invalidateContextTexture(param1:Boolean) : void
        {
            var _loc_4:* = null;
            var _loc_3:* = 0;
            var _loc_2:* = 0;
            //switch(iSourceType) branch count is:<4>[189, 301, 420, 20, 686] default offset is:<776>;
            //resampled = FTextureUtils.resampleBitmapData(bdBitmapData, _iResampleType, resampleScale);
            //if (cContextTexture == null || param1 || cContextTexture.iWidth != resampled.width || cContextTexture.iHeight != resampled.height)
            //{
            //    if (cContextTexture)
            //    {
            //        cContextTexture.dispose();
            //    }
            //    _loc_4 = "bgra";
            //    if (alwaysUseCompressed)
            //    {
            //        _loc_4 = bTransparent ? ("compressedAlpha") : ("compressed");
            //        iAtfType = bTransparent ? (2) : (1);
            //    }
            //    else
            //    {
            //        iAtfType = 0;
            //    }
            //    cContextTexture = FlEngine.getInstance().cContext.createTexture(resampled.width, resampled.height, _loc_4, false);
            //}
            //cContextTexture.uploadFromBitmapData(resampled);
            //;
            //if (cContextTexture == null || param1 || cContextTexture.iWidth != iWidth || cContextTexture.iHeight != iHeight)
            //{
            //    if (cContextTexture)
            //    {
            //        cContextTexture.dispose();
            //    }
            //    cContextTexture = FlEngine.getInstance().cContext.createTexture(iWidth, iHeight, "bgra", false);
            //    if (_fAsyncCallback != null)
            //    {
            //        cContextTexture.tTexture.addEventListener("textureReady", onATFUploaded);
            //    }
            //}
            //cContextTexture.uploadFromCompressedByteArray(baByteArray, 0, _fAsyncCallback != null);
            //;
            //if (cContextTexture == null || param1 || cContextTexture.iWidth != iWidth || cContextTexture.iHeight != iHeight)
            //{
            //    if (cContextTexture)
            //    {
            //        cContextTexture.dispose();
            //    }
            //    cContextTexture = FlEngine.getInstance().cContext.createTexture(iWidth, iHeight, "compressed", false);
            //    if (_fAsyncCallback != null)
            //    {
            //        cContextTexture.tTexture.addEventListener("textureReady", onATFUploaded);
            //    }
            //    iAtfType = 1;
            //}
            //cContextTexture.uploadFromCompressedByteArray(baByteArray, 0, _fAsyncCallback != null);
            //;
            //if (cContextTexture == null || param1 || cContextTexture.iWidth != iWidth || cContextTexture.iHeight != iHeight)
            //{
            //    if (cContextTexture)
            //    {
            //        cContextTexture.dispose();
            //    }
            //    cContextTexture = FlEngine.getInstance().cContext.createTexture(iWidth, iHeight, "compressedAlpha", false);
            //    if (_fAsyncCallback != null)
            //    {
            //        cContextTexture.tTexture.addEventListener("textureReady", onATFUploaded);
            //    }
            //    iAtfType = 2;
            //}
            //cContextTexture.uploadFromCompressedByteArray(baByteArray, 0, _fAsyncCallback != null);
            //;
            //if (cContextTexture == null || param1 || cContextTexture.iWidth != iWidth || cContextTexture.iHeight != iHeight)
            //{
            //    if (cContextTexture)
            //    {
            //        cContextTexture.dispose();
            //    }
            //    _loc_4 = "bgra";
            //    if (alwaysUseCompressed)
            //    {
            //        _loc_4 = bTransparent ? ("compressedAlpha") : ("compressed");
            //        iAtfType = bTransparent ? (2) : (1);
            //    }
            //    else
            //    {
            //        iAtfType = 0;
            //    }
            //    cContextTexture = FlEngine.getInstance().cContext.createTexture(iWidth, iHeight, _loc_4, false);
            //}
            //cContextTexture.uploadFromByteArray(baByteArray, 0);
            //;
            //_loc_3 = FTextureUtils.getNextValidTextureSize(iWidth);
            //_loc_2 = FTextureUtils.getNextValidTextureSize(iHeight);
            //if (cContextTexture == null || param1 || cContextTexture.iWidth != _loc_3 || cContextTexture.iHeight != _loc_2)
            //{
            //    if (cContextTexture)
            //    {
            //        cContextTexture.dispose();
            //    }
            //    cContextTexture = FlEngine.getInstance().cContext.createTexture(_loc_3, _loc_2, "bgra", true);
            //}
			switch(iSourceType)
			{
				case FTextureSourceType.BITMAPDATA:
				resampled = FTextureUtils.resampleBitmapData(bdBitmapData, _iResampleType, resampleScale);
				if (cContextTexture == null || param1 || cContextTexture.iWidth != resampled.width || cContextTexture.iHeight != resampled.height)
				{
					if (cContextTexture)
					{
						cContextTexture.dispose();
					}
					_loc_4 = Context3DTextureFormat.BGRA;
					if (alwaysUseCompressed)
					{
						_loc_4 = bTransparent ? (Context3DTextureFormat.COMPRESSED_ALPHA) : (Context3DTextureFormat.COMPRESSED);
						iAtfType = bTransparent ? (FTextureAtfType.ATF_Type_Dxt5) : (FTextureAtfType.ATF_Type_Dxt1);
					}
					else
					{
						iAtfType = FTextureAtfType.ATF_Type_None;
					}
					cContextTexture = FlEngine.getInstance().cContext.createTexture(resampled.width, resampled.height, _loc_4, false);
				}
				cContextTexture.uploadFromBitmapData(resampled);
				break;
				case FTextureSourceType.ATF_BGRA:
				if (cContextTexture == null || param1 || cContextTexture.iWidth != iWidth || cContextTexture.iHeight != iHeight)
				{
					if (cContextTexture)
					{
						cContextTexture.dispose();
					}
					cContextTexture = FlEngine.getInstance().cContext.createTexture(iWidth, iHeight, "bgra", false);
					if (_fAsyncCallback != null)
					{
						cContextTexture.tTexture.addEventListener("textureReady", onATFUploaded);
					}
				}
				cContextTexture.uploadFromCompressedByteArray(baByteArray, 0, _fAsyncCallback != null);
				break;
				case FTextureSourceType.ATF_COMPRESSED:
				if (cContextTexture == null || param1 || cContextTexture.iWidth != iWidth || cContextTexture.iHeight != iHeight)
				{
					if (cContextTexture)
					{
						cContextTexture.dispose();
					}
					cContextTexture = FlEngine.getInstance().cContext.createTexture(iWidth, iHeight, "compressed", false);
					if (_fAsyncCallback != null)
					{
						cContextTexture.tTexture.addEventListener("textureReady", onATFUploaded);
					}
					iAtfType = 1;
				}
				cContextTexture.uploadFromCompressedByteArray(baByteArray, 0, _fAsyncCallback != null);
				break;
				case FTextureSourceType.ATF_COMPRESSEDALPHA:
				if (cContextTexture == null || param1 || cContextTexture.iWidth != iWidth || cContextTexture.iHeight != iHeight)
				{
					if (cContextTexture)
					{
						cContextTexture.dispose();
					}
					cContextTexture = FlEngine.getInstance().cContext.createTexture(iWidth, iHeight, "compressedAlpha", false);
					if (_fAsyncCallback != null)
					{
						cContextTexture.tTexture.addEventListener("textureReady", onATFUploaded);
					}
					iAtfType = FTextureAtfType.ATF_Type_Dxt5;
				}
				cContextTexture.uploadFromCompressedByteArray(baByteArray, 0, _fAsyncCallback != null);
				break;
				case FTextureSourceType.BYTEARRAY:
				if (cContextTexture == null || param1 || cContextTexture.iWidth != iWidth || cContextTexture.iHeight != iHeight)
				{
					if (cContextTexture)
					{
						cContextTexture.dispose();
					}
					_loc_4 = Context3DTextureFormat.BGRA;
					if (alwaysUseCompressed)
					{
						_loc_4 = bTransparent ? (Context3DTextureFormat.COMPRESSED_ALPHA) : (Context3DTextureFormat.COMPRESSED);
						iAtfType = bTransparent ? (FTextureAtfType.ATF_Type_Dxt5) : (FTextureAtfType.ATF_Type_Dxt1);
					}
					else
					{
						iAtfType = FTextureAtfType.ATF_Type_None;
					}
					cContextTexture = FlEngine.getInstance().cContext.createTexture(iWidth, iHeight, _loc_4, false);
				}
				cContextTexture.uploadFromByteArray(baByteArray, 0);
				break;
			case FTextureSourceType.RENDER_TARGET:
				_loc_3 = FTextureUtils.getNextValidTextureSize(iWidth);
				_loc_2 = FTextureUtils.getNextValidTextureSize(iHeight);
				if (cContextTexture == null || param1 || cContextTexture.iWidth != _loc_3 || cContextTexture.iHeight != _loc_2)
				{
					if (cContextTexture)
					{
						cContextTexture.dispose();
					}
					cContextTexture = FlEngine.getInstance().cContext.createTexture(_loc_3, _loc_2, "bgra", true);
				}
			break;
			}
            return;
        }

        protected function onATFUploaded(event:Event) : void
        {
            cContextTexture.tTexture.removeEventListener("textureReady", onATFUploaded);
            this._fAsyncCallback(this);
            _fAsyncCallback = null;
            return;
        }

        public function dispose() : void
        {
            return;
        }

        public static function get defaultResampleType() : int
        {
            return __iDefaultResampleType;
        }

        public static function set defaultResampleType(param1:int) : void
        {
            if (!FTextureResampleType.isValid(param1))
            {
                throw new FError(FError.INVALID_RESAMPLE_TYPE);
            }
            __iDefaultResampleType = param1;
            return;
        }

        public static function get defaultFilteringType() : int
        {
            return __iDefaultFilteringType;
        }

        public static function set defaultFilteringType(param1:int) : void
        {
            if (!FTextureFilteringType.isValid(param1))
            {
                throw new FError(FError.INVALID_FILTERING_TYPE);
            }
            __iDefaultFilteringType = param1;
            return;
        }

        public static function getTextureBaseById(param1:String) : FTextureBase
        {
            return __dReferences[param1];
        }

        public static function getGPUTextureCount() : int
        {
            var _loc_2:* = 0;
            for each (var _loc_1:* in __dReferences)
            {
                if (_loc_1.cContextTexture && !_loc_1.hasParent())
                {
                    _loc_2++;
                }
            }
            return _loc_2;
        }

        public static function getTextureCount() : int
        {
            var _loc_2:* = 0;
            for each (var _loc_1:* in __dReferences)
            {
                
                if (_loc_1 is FTexture)
                {
                    _loc_2++;
                }
            }
            return _loc_2;
        }

        public static function invalidate() : void
        {
            for (var _loc_1:* in __dReferences)
            {
                (__dReferences[_loc_1] as FTextureBase).invalidateContextTexture(true);
            }
            return;
        }

    }
}
