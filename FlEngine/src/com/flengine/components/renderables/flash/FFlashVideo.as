package com.flengine.components.renderables.flash
{
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import flash.media.Video;
   import flash.events.IOErrorEvent;
   import flash.events.NetStatusEvent;
   import com.flengine.core.FNode;
   
   public class FFlashVideo extends FFlashObject
   {
      
      public function FFlashVideo(param1:FNode) {
         super(param1);
         _iResampleType = 1;
         __iCount = __iCount + 1;
         __sTextureId = "G2DVideo#" + (__iCount);
         __ncConnection = new NetConnection();
         __ncConnection.addEventListener("ioError",onIOError);
         __ncConnection.addEventListener("netStatus",onNetStatus);
         __ncConnection.connect(null);
         __nsStream = new NetStream(__ncConnection);
         __nsStream.addEventListener("ioError",onIOError);
         __nsStream.addEventListener("netStatus",onNetStatus);
         __nsStream.client = this;
         __vNativeVideo = new Video();
         __vNativeVideo.attachNetStream(__nsStream);
         _doNative = __vNativeVideo;
      }
      
      private static var __iCount:int = 0;
      
      private var __ncConnection:NetConnection;
      
      private var __nsStream:NetStream;
      
      public function get netStream() : NetStream {
         return __nsStream;
      }
      
      private var __vNativeVideo:Video;
      
      public function get nativeVideo() : Video {
         return __vNativeVideo;
      }
      
      private var __nAccumulatedTime:int;
      
      private var __bPlaying:Boolean = false;
      
      private var __sTextureId:String;
      
      public function onMetaData(param1:Object, ... rest) : void {
         __vNativeVideo.width = param1.width != undefined?param1.width:320;
         __vNativeVideo.height = param1.height != undefined?param1.height:240;
         if(!(updateFrameRate == 0) && !(param1.framerate == undefined))
         {
            updateFrameRate = param1.framerate;
         }
      }
      
      public function onPlayStatus(param1:Object) : void {
         if(param1.code == "Netstream.Play.Complete")
         {
            __bPlaying = false;
         }
      }
      
      public function onTransition(... rest) : void {
      }
      
      public function playVideo(param1:String) : void {
         __nsStream.play(param1);
      }
      
      private function onIOError(param1:IOErrorEvent) : void {
      }
      
      private function onNetStatus(param1:NetStatusEvent) : void {
         var _loc2_:* = param1.info.code;
         if("NetStream.Play.Stop" === _loc2_)
         {
            __nsStream.seek(0);
         }
      }
      
      override public function dispose() : void {
         __vNativeVideo = null;
         __nsStream.close();
         __nsStream = null;
         __ncConnection.close();
         __ncConnection = null;
      }
   }
}
