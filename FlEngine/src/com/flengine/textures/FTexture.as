package com.flengine.textures
{
    import flash.display.*;
    import flash.geom.*;

    public class FTexture extends FTextureBase
    {
        public var doNativeObject:DisplayObject;
        public var nUvX:Number = 0;
        public var nUvY:Number = 0;
        public var nUvScaleX:Number = 1;
        public var nUvScaleY:Number = 1;
        public var nFrameWidth:Number = 0;
        public var nFrameHeight:Number = 0;
        public var nPivotX:Number = 0;
        public var nPivotY:Number = 0;
        public var cParent:FTextureAtlas;
        public var sSubId:String = "";
        public var rRegion:Rectangle;

        public function FTexture(param1:String, param2:int, param3:*, param4:Rectangle, param5:Boolean, param6:Number, param7:Number, param8:Number = 0, param9:Number = 0, param10:Function = null, param11:FTextureAtlas = null)
        {
            super(param1, param2, param3, param5, param10);
            rRegion = param4;
            iWidth = rRegion.width;
            iHeight = rRegion.height;
            nPivotX = param8;
            nPivotY = param9;
            nFrameWidth = param6;
            nFrameHeight = param7;
            cParent = param11;
            if (cParent != null)
            {
                nUvX = param4.x / cParent.iWidth;
                nUvY = param4.y / cParent.iHeight;
                nUvScaleX = param4.width / cParent.iWidth;
                nUvScaleY = param4.height / cParent.iHeight;
            }
            else
            {
                invalidate();
            }
            return;
        }

        public function get nativeObject() : DisplayObject
        {
            return doNativeObject;
        }

        public function set bitmapData(param1:BitmapData) : void
        {
            if (cParent)
            {
                return;
            }
            bdBitmapData = param1;
            rRegion = bdBitmapData.rect;
            iWidth = rRegion.width;
            iHeight = rRegion.height;
            invalidateContextTexture(false);
            return;
        }

        public function get uvX() : Number
        {
            return nUvX;
        }

        public function get uvY() : Number
        {
            return nUvY;
        }

        public function set uvY(param1:Number) : void
        {
            nUvY = param1;
            return;
        }

        public function get uvScaleX() : Number
        {
            return nUvScaleX;
        }

        public function get uvScaleY() : Number
        {
            return nUvScaleY;
        }

        public function get frameWidth() : Number
        {
            return nFrameWidth;
        }

        public function set frameWidth(param1:Number) : void
        {
            nFrameWidth = param1;
            return;
        }

        public function get frameHeight() : Number
        {
            return nFrameHeight;
        }

        public function set frameHeight(param1:Number) : void
        {
            nFrameHeight = param1;
            return;
        }

        public function get pivotX() : Number
        {
            return nPivotX;
        }

        public function set pivotX(param1:Number) : void
        {
            nPivotX = param1;
            return;
        }

        public function get pivotY() : Number
        {
            return nPivotY;
        }

        public function set pivotY(param1:Number) : void
        {
            nPivotY = param1;
            return;
        }

        override public function get gpuWidth() : int
        {
            if (cParent)
            {
                return cParent.gpuWidth;
            }
            return FTextureUtils.getNextValidTextureSize(iWidth);
        }

        override public function get gpuHeight() : int
        {
            if (cParent)
            {
                return cParent.gpuHeight;
            }
            return FTextureUtils.getNextValidTextureSize(iHeight);
        }

        override public function hasParent() : Boolean
        {
            return cParent != null;
        }

        public function alignTexture(param1:int) : void
        {
            //switch((param1 - 1)) branch count is:<1>[11, 29] default offset is:<51>;
            //nPivotX = 0;
            //nPivotY = 0;
            //;
            //nPivotX = (-iWidth) / 2;
            //nPivotY = (-iHeight) / 2;
	    switch(param1)
            {
                case FTextureAlignType.CENTER:
                {
                    this.nPivotX = 0;
                    this.nPivotY = 0;
                    break;
                }
                case FTextureAlignType.TOP_LEFT:
                {
                    this.nPivotX = (-iWidth) / 2;
                    this.nPivotY = (-iHeight) / 2;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }

        override public function get resampleType() : int
        {
            if (cParent != null)
            {
                return cParent.resampleType;
            }
            return _iResampleType;
        }

        override public function set resampleType(param1:int) : void
        {
            if (cParent != null)
            {
                return;
            }
            resampleType = param1;
            return;
        }

        override public function get resampleScale() : int
        {
            if (cParent != null)
            {
                return cParent.resampleScale;
            }
            return _iResampleScale;
        }

        override public function set resampleScale(param1:int) : void
        {
            if (cParent != null)
            {
                return;
            }
            resampleScale = param1;
            return;
        }

        override public function set filteringType(param1:int) : void
        {
            if (cParent != null)
            {
                return;
            }
            filteringType = param1;
            return;
        }

        public function get parent() : FTextureAtlas
        {
            return cParent;
        }

        public function get region() : Rectangle
        {
            return rRegion;
        }

        public function set region(param1:Rectangle) : void
        {
            rRegion = param1;
            iWidth = rRegion.width;
            iHeight = rRegion.height;
            if (cParent)
            {
                nUvX = rRegion.x / cParent.iWidth;
                nUvY = rRegion.y / cParent.iHeight;
                nUvScaleX = iWidth / cParent.iWidth;
                nUvScaleY = iHeight / cParent.iHeight;
            }
            else
            {
                invalidateContextTexture(false);
            }
            return;
        }

        public function set width(param1:int) : void
        {
            iWidth = param1;
            rRegion.width = param1;
            nUvScaleX = iWidth / cParent.iWidth;
            return;
        }

        public function getAlphaAtUV(param1:Number, param2:Number) : uint
        {
            if (bdBitmapData == null)
            {
                return 255;
            }
            return bdBitmapData.getPixel32(rRegion.x + param1 * rRegion.width, rRegion.y + param2 * rRegion.height) >> 24 & 255;
        }

        protected function updateUVScale() : void
        {
            var _loc_4:* = 0;
            var _loc_3:* = 0;
            var _loc_1:* = NaN;
            var _loc_2:* = NaN;
            //switch((_iResampleType - 1)) branch count is:<1>[49, 11] default offset is:<125>;
            //nUvScaleX = rRegion.width / FTextureUtils.getNextValidTextureSize(iWidth);
            //nUvScaleY = rRegion.height / FTextureUtils.getNextValidTextureSize(iHeight);
            //;
            //_loc_4 = FTextureUtils.getNearestValidTextureSize(iWidth);
            //_loc_3 = FTextureUtils.getNearestValidTextureSize(iHeight);
            //_loc_1 = _loc_4 / rRegion.width;
            //_loc_2 = _loc_3 / rRegion.height;
            //nUvScaleX = _loc_1 > _loc_2 ? (_loc_2 / _loc_1) : (1);
            //nUvScaleY = _loc_2 > _loc_1 ? (_loc_1 / _loc_2) : (1);
			switch(_iResampleType) 
			{
				case FTextureResampleType.UP_CROP:
				nUvScaleX = rRegion.width / FTextureUtils.getNextValidTextureSize(iWidth);
				nUvScaleY = rRegion.height / FTextureUtils.getNextValidTextureSize(iHeight);
				break;
				case FTextureResampleType.NEAREST_DOWN_RESAMPLE_UP_CROP:
				_loc_4 = FTextureUtils.getNearestValidTextureSize(iWidth);
				_loc_3 = FTextureUtils.getNearestValidTextureSize(iHeight);
				_loc_1 = _loc_4 / rRegion.width;
				_loc_2 = _loc_3 / rRegion.height;
				nUvScaleX = _loc_1 > _loc_2 ? (_loc_2 / _loc_1) : (1);
				nUvScaleY = _loc_2 > _loc_1 ? (_loc_1 / _loc_2) : (1);
				break;
			}
            return;
        }

        override protected function invalidateContextTexture(param1:Boolean) : void
        {
            if (cParent != null)
            {
                return;
            }
            updateUVScale();
            super.invalidateContextTexture(param1);
            return;
        }

        public function setParent(param1:FTextureAtlas, param2:Rectangle) : void
        {
            cParent = param1;
            region = param2;
            return;
        }

        override public function dispose() : void
        {
            if (cParent == null)
            {
                if (doNativeObject)
                {
                    doNativeObject = null;
                }
                if (baByteArray)
                {
                    baByteArray = null;
                }
                if (bdBitmapData)
                {
                    bdBitmapData = null;
                }
                if (cContextTexture)
                {
                    cContextTexture.dispose();
                }
            }
            cParent = null;
            super.dispose();
            return;
        }

        public function toString() : String
        {
            return "[FTexture id:" + _sId + ", width:" + width + ", height:" + height + "]";
        }

        public static function getTextureById(param1:String) : FTexture
        {
            return FTextureBase.getTextureBaseById(param1) as FTexture;
        }

    }
}
