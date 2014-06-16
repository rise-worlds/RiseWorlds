package com.flengine.core
{
   import com.flengine.textures.FTexture;
   import flash.text.TextField;
   import flash.display.BitmapData;
   import com.flengine.textures.factories.FTextureFactory;
   import flash.text.TextFormat;
   import flash.utils.getTimer;
   import flash.system.System;
   import com.flengine.textures.FTextureBase;
   
   public class FStats extends Object
   {
      
      public function FStats() {
         super();
      }
      
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
      
      fl2d  static var iDrawCalls:int = 0;
      
      public static function get fps() : int {
         return __iLastFPS;
      }
      
      fl2d  static function init() : void {
         __bdBitmapData = new BitmapData(256,16,false,0);
         __cTexture = FTextureFactory.createFromBitmapData("stats_internal",__bdBitmapData);
         var _loc1_:TextFormat = new TextFormat("_sans",9,16777215);
         __tfStatsField = new TextField();
         __tfStatsField.defaultTextFormat = _loc1_;
         __tfStatsField.autoSize = "left";
         __tfStatsField.multiline = true;
         __tfStatsField.backgroundColor = 0;
         __tfStatsField.background = true;
         __bInitialized = true;
      }
      
      private static function invalidateTextureSize() : void {
         __bdBitmapData = new BitmapData(256,__tfStatsField.height,false,0);
      }
      
      fl2d  static function update() : void {
         var _loc1_:uint = getTimer();
         if(_loc1_ - 1000 > __iPreviousTime)
         {
            __iPreviousTime = _loc1_;
            __iLastFPS = __iFPS;
            __sFPSString = "<font color=\'#999999\'>FPS:</font> " + __iLastFPS + " / " + FlEngine.getInstance().stage.frameRate;
            __iFPS = 0;
            __iMem = System.totalMemory / 1048576;
            __iMemMax = __iMem > __iMemMax?__iMem:__iMemMax;
            __sMemString = "<font color=\'#999999\'>MEM:</font> " + __iMem.toFixed(2) + " / " + __iMemMax.toFixed(2) + "MB";
         }
         __iFPS = __iFPS + 1;
      }
      
      fl2d  static function clear() : void {
         if(!__bInitialized)
         {
            init();
         }
         iDrawCalls = 0;
      }
      
      fl2d  static function draw() : void {
         var _loc2_:* = 0;
         var _loc1_:* = 0;
         if(FlEngine.getInstance().cConfig.showExtendedStats)
         {
            __tfStatsField.htmlText = __sFPSString + " " + __sMemString + " <font color=\'#999999\'>DRAWS:</font> " + iDrawCalls + "\n";
            __tfStatsField.htmlText = __tfStatsField.htmlText + "<font color=\'#999999\'>TEXTURES:</font> " + (FTextureBase.getTextureCount() - 1) + " <font color=\'#999999\'>GPU TEXTURES:</font> " + (FTextureBase.getGPUTextureCount() - 1) + "\n";
            _loc2_ = FlEngine.getInstance().aCameras.length;
            if(_loc2_ > 0)
            {
               __tfStatsField.htmlText = __tfStatsField.htmlText + "<font color=\'#999999\'>CUSTOM CAMERAS:</font> " + _loc2_ + "\n";
               _loc1_ = 0;
               while(_loc1_ < _loc2_)
               {
                  __tfStatsField.htmlText = __tfStatsField.htmlText + "<font color=\'#999999\'>CAMERA #" + _loc1_ + ":</font> " + FlEngine.getInstance().aCameras[_loc1_].iRenderedNodesCount + "\n";
                  _loc1_++;
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
         if(__cTexture.height < __tfStatsField.height || !FlEngine.getInstance().cConfig.showExtendedStats && __cTexture.height > 16)
         {
            invalidateTextureSize();
         }
         else
         {
            __bdBitmapData.fillRect(__bdBitmapData.rect,0);
         }
         __bdBitmapData.draw(__tfStatsField);
         __cTexture.bitmapData = __bdBitmapData;
         __cTexture.invalidate();
         FlEngine.getInstance().context.blit(__cTexture,__cTexture.width * scaleX / 2 + x,__cTexture.height * scaleY / 2 + y,scaleX,scaleY,0);
      }
   }
}
