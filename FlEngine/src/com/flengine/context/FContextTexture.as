package com.flengine.context
{
    import flash.display.*;
    import flash.display3D.*;
    import flash.display3D.textures.*;
    import flash.utils.*;

    public class FContextTexture extends Object
    {
        private var __cContext:Context3D;
        var iWidth:int;
        var iHeight:int;
        var tTexture:Texture;

        public function FContextTexture(param1:Context3D, param2:int, param3:int, param4:String, param5:Boolean)
        {
            __cContext = param1;
            if (__cContext.driverInfo == "Disposed")
            {
                return;
            }
            iWidth = param2;
            iHeight = param3;
            tTexture = param1.createTexture(iWidth, iHeight, param4, param5);
            return;
        }// end function

        function getTexture() : Texture
        {
            return tTexture;
        }// end function

        function dispose() : void
        {
            if (tTexture != null)
            {
                tTexture.dispose();
            }
            return;
        }// end function

        function uploadFromBitmapData(param1:BitmapData) : void
        {
            if (tTexture == null || __cContext.driverInfo == "Disposed")
            {
                return;
            }
            tTexture.uploadFromBitmapData(param1, 0);
            return;
        }// end function

        function uploadFromCompressedByteArray(param1:ByteArray, param2:uint, param3:Boolean) : void
        {
            if (tTexture == null || __cContext.driverInfo == "Disposed")
            {
                return;
            }
            tTexture.uploadCompressedTextureFromByteArray(param1, param2, param3);
            return;
        }// end function

        function uploadFromByteArray(param1:ByteArray, param2:uint) : void
        {
            if (tTexture == null || __cContext.driverInfo == "Disposed")
            {
                return;
            }
            tTexture.uploadFromByteArray(param1, param2, 0);
            return;
        }// end function

    }
}
