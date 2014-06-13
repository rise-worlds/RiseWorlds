package com.flengine.core
{
    import com.flengine.textures.*;
    import com.flengine.textures.factories.*;
    import flash.display.*;
    import flash.system.*;
    import flash.text.*;
    import flash.utils.*;

    public class FStats extends Object
    {
        public static var x:Number = 10;
        public static var y:Number = 10;
        public static var scaleX:Number = 1;
        public static var scaleY:Number = 1;
        private static var __cTexture:FTexture;
        private static var __tfStatsField:TextField;
        private static var __bInitialized:Boolean = false;
        private static var __iPreviousTime:uint;
        private static var __sFPSString:String;
        private static var __sFPSSimpleString:String;
        private static var __iFPS:int = 0;
        private static var __iLastFPS:int = -1;
        private static var __sMemString:String;
        private static var __sMemSimpleString:String;
        private static var __iMem:int;
        private static var __iMemMax:int;
        private static var __bdBitmapData:BitmapData;
        static var iDrawCalls:int = 0;

        public function FStats()
        {
            return;
        }

        public static function get fps() : int
        {
            return __iLastFPS;
        }

        static function init() : void
        {
            __bdBitmapData = new BitmapData(256, 16, false, 0);
            __cTexture = FTextureFactory.createFromBitmapData("stats_internal", __bdBitmapData);
            var _loc_1:* = new TextFormat("_sans", 9, 16777215);
            __tfStatsField = new TextField();
            __tfStatsField.defaultTextFormat = _loc_1;
            __tfStatsField.autoSize = "left";
            __tfStatsField.multiline = true;
            __tfStatsField.backgroundColor = 0;
            __tfStatsField.background = true;
            __bInitialized = true;
            return;
        }

        private static function invalidateTextureSize() : void
        {
            __bdBitmapData = new BitmapData(256, __tfStatsField.height, false, 0);
            return;
        }

        static function update() : void
        {
            var _loc_1:* = FStats.getTimer();
            if (_loc_1 - 1000 > __iPreviousTime)
            {
                __iPreviousTime = _loc_1;
                __iLastFPS = __iFPS;
                __sFPSString = "<font color=\'#999999\'>FPS:</font> " + __iLastFPS + " / " + FlEngine.getInstance().stage.frameRate;
                __iFPS = 0;
                __iMem = System.totalMemory / 1048576;
                __iMemMax = __iMem > __iMemMax ? (__iMem) : (__iMemMax);
                __sMemString = "<font color=\'#999999\'>MEM:</font> " + __iMem.toFixed(2) + " / " + __iMemMax.toFixed(2) + "MB";
            }
            (__iFPS + 1);
            return;
        }

        static function clear() : void
        {
            if (!__bInitialized)
            {
                init();
            }
            iDrawCalls = 0;
            return;
        }

        static function draw() : void
        {
            var _loc_2:* = 0;
            var _loc_1:* = 0;
            if (FlEngine.getInstance().cConfig.showExtendedStats)
            {
                __tfStatsField.htmlText = __sFPSString + " " + __sMemString + " <font color=\'#999999\'>DRAWS:</font> " + iDrawCalls + "\n";
                __tfStatsField.htmlText = __tfStatsField.htmlText + "<font color=\'#999999\'>TEXTURES:</font> " + (FTextureBase.getTextureCount() - 1) + " <font color=\'#999999\'>GPU TEXTURES:</font> " + (FTextureBase.getGPUTextureCount() - 1) + "\n";
                _loc_2 = FlEngine.getInstance().aCameras.length;
                if (_loc_2 > 0)
                {
                    __tfStatsField.htmlText = __tfStatsField.htmlText + "<font color=\'#999999\'>CUSTOM CAMERAS:</font> " + _loc_2 + "\n";
                    _loc_1 = 0;
                    while (_loc_1 < _loc_2)
                    {
                        
                        __tfStatsField.htmlText = __tfStatsField.htmlText + "<font color=\'#999999\'>CAMERA #" + _loc_1 + ":</font> " + FlEngine.getInstance().aCameras[_loc_1].iRenderedNodesCount + "\n";
                        _loc_1++;
                    }
                }
                else
                {
                    __tfStatsField.htmlText = __tfStatsField.htmlText + "<font color=\'#999999\'>DEFAULT CAMERA:</font> " + FlEngine.getInstance().cDefaultCamera.iRenderedNodesCount + "\n";
                }
            }
            else
            {
                __tfStatsField.htmlText = __sFPSString + " " + __sMemString + " <font color=\'#999999\'>DRAWS:</font> " + iDrawCalls;
            }
            if (__cTexture.height < __tfStatsField.height || !FlEngine.getInstance().cConfig.showExtendedStats && __cTexture.height > 16)
            {
                invalidateTextureSize();
            }
            else
            {
                __bdBitmapData.fillRect(__bdBitmapData.rect, 0);
            }
            __bdBitmapData.draw(__tfStatsField);
            __cTexture.bitmapData = __bdBitmapData;
            __cTexture.invalidate();
            FlEngine.getInstance().context.blit(__cTexture, __cTexture.width * scaleX / 2 + x, __cTexture.height * scaleY / 2 + y, scaleX, scaleY, 0);
            return;
        }

    }
}
