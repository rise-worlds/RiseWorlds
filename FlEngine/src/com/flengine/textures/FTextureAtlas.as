package com.flengine.textures
{
    import com.flengine.error.*;
    import flash.geom.*;
    import flash.utils.*;

    public class FTextureAtlas extends FTextureBase
    {
        private var __dTextures:Dictionary;

        public function FTextureAtlas(param1:String, param2:int, param3:int, param4:int, param5, param6:Boolean, param7:Function)
        {
            super(param1, param2, param5, param6, param7);
            if (!FTextureUtils.isValidTextureSize(param3) || !FTextureUtils.isValidTextureSize(param4))
            {
                throw new FError("FError: Invalid atlas size, it needs to be power of 2.");
            }
            iWidth = param3;
            iHeight = param4;
            __dTextures = new Dictionary();
            return;
        }// end function

        public function get textures() : Dictionary
        {
            return __dTextures;
        }// end function

        override public function set filteringType(param1:int) : void
        {
            filteringType = param1;
            for each (_loc_2 in __dTextures)
            {
                
                _loc_2.iFilteringType = param1;
            }
            return;
        }// end function

        public function getTexture(param1:String) : FTexture
        {
            return __dTextures[param1];
        }// end function

        override protected function invalidateContextTexture(param1:Boolean) : void
        {
            super.invalidateContextTexture(param1);
            for each (_loc_2 in __dTextures)
            {
                
                _loc_2.cContextTexture = cContextTexture;
                _loc_2.iAtfType = iAtfType;
            }
            return;
        }// end function

        public function addSubTexture(param1:String, param2:Rectangle, param3:Number, param4:Number, param5:Number = 0, param6:Number = 0, param7:Boolean = false) : FTexture
        {
            var _loc_8:* = new FTexture(_sId + "_" + param1, iSourceType, getSource(), param2, bTransparent, param3, param4, param5, param6, null, this);
            _loc_8.sSubId = param1;
            _loc_8.filteringType = filteringType;
            _loc_8.cContextTexture = cContextTexture;
            __dTextures[param1] = _loc_8;
            if (param7)
            {
                invalidate();
            }
            return _loc_8;
        }// end function

        public function removeSubTexture(param1:String) : void
        {
            __dTextures[param1] = null;
            return;
        }// end function

        private function disposeSubTextures() : void
        {
            var _loc_2:* = null;
            for (_loc_1 in __dTextures)
            {
                
                _loc_2 = _loc_3[_loc_1];
                _loc_2.dispose();
                delete _loc_3[_loc_1];
            }
            __dTextures = new Dictionary();
            return;
        }// end function

        override public function dispose() : void
        {
            disposeSubTextures();
            if (baByteArray)
            {
                baByteArray = null;
            }
            if (bdBitmapData)
            {
                bdBitmapData.dispose();
                bdBitmapData = null;
            }
            if (cContextTexture)
            {
                cContextTexture.dispose();
            }
            super.dispose();
            return;
        }// end function

        public static function getTextureAtlasById(param1:String) : FTextureAtlas
        {
            return FTextureBase.getTextureBaseById(param1) as FTextureAtlas;
        }// end function

    }
}
