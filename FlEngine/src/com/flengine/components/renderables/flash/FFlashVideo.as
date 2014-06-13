package com.flengine.components.renderables.flash
{
    import com.flengine.core.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;

    public class FFlashVideo extends FFlashObject
    {
        private var __ncConnection:NetConnection;
        private var __nsStream:NetStream;
        private var __vNativeVideo:Video;
        private var __nAccumulatedTime:int;
        private var __bPlaying:Boolean = false;
        private var __sTextureId:String;
        private static var __iCount:int = 0;

        public function FFlashVideo(param1:FNode)
        {
            super(param1);
            _iResampleType = 1;
            (__iCount + 1);
            __sTextureId = "G2DVideo#" + __iCount;
            __ncConnection = new NetConnection();
            __ncConnection.addEventListener("ioError", onIOError);
            __ncConnection.addEventListener("netStatus", onNetStatus);
            __ncConnection.connect(null);
            __nsStream = new NetStream(__ncConnection);
            __nsStream.addEventListener("ioError", onIOError);
            __nsStream.addEventListener("netStatus", onNetStatus);
            __nsStream.client = this;
            __vNativeVideo = new Video();
            __vNativeVideo.attachNetStream(__nsStream);
            _doNative = __vNativeVideo;
            return;
        }// end function

        public function get netStream() : NetStream
        {
            return __nsStream;
        }// end function

        public function get nativeVideo() : Video
        {
            return __vNativeVideo;
        }// end function

        public function onMetaData(param1:Object, ... args) : void
        {
            __vNativeVideo.width = param1.width != undefined ? (param1.width) : (320);
            __vNativeVideo.height = param1.height != undefined ? (param1.height) : (240);
            if (updateFrameRate != 0 && param1.framerate != undefined)
            {
                updateFrameRate = param1.framerate;
            }
            return;
        }// end function

        public function onPlayStatus(param1:Object) : void
        {
            if (param1.code == "Netstream.Play.Complete")
            {
                __bPlaying = false;
            }
            return;
        }// end function

        public function onTransition(... args) : void
        {
            return;
        }// end function

        public function playVideo(param1:String) : void
        {
            __nsStream.play(param1);
            return;
        }// end function

        private function onIOError(event:IOErrorEvent) : void
        {
            return;
        }// end function

        private function onNetStatus(event:NetStatusEvent) : void
        {
            var _loc_2:* = event.info.code;
            while (_loc_2 === "NetStream.Play.Stop")
            {
                
                __nsStream.seek(0);
                break;
            }
            return;
        }// end function

        override public function dispose() : void
        {
            __vNativeVideo = null;
            __nsStream.close();
            __nsStream = null;
            __ncConnection.close();
            __ncConnection = null;
            return;
        }// end function

    }
}
