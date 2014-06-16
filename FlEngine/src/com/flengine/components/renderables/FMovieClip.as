package com.flengine.components.renderables
{
   import com.flengine.textures.FTextureAtlas;
   import com.flengine.core.FNode;
   
   public class FMovieClip extends FTexturedQuad
   {
      
      public function FMovieClip(param1:FNode) {
         super(param1);
      }
      
      private static var __iCount:int = 0;
      
      protected var _nSpeed:Number = 33.333333333333336;
      
      protected var _nAccumulatedTime:Number = 0;
      
      protected var _iCurrentFrame:int = -1;
      
      public function get currentFrame() : int {
         return _iCurrentFrame;
      }
      
      protected var _iStartIndex:int = -1;
      
      protected var _iEndIndex:int = -1;
      
      protected var _bPlaying:Boolean = true;
      
      protected var _cTextureAtlas:FTextureAtlas;
      
      public function get textureAtlasId() : String {
         return _cTextureAtlas?_cTextureAtlas.id:"";
      }
      
      public function set textureAtlasId(param1:String) : void {
         _cTextureAtlas = param1 != ""?FTextureAtlas.getTextureAtlasById(param1):null;
         if(_aFrameIds)
         {
            cTexture = _cTextureAtlas.getTexture(_aFrameIds[0]);
         }
      }
      
      protected var _aFrameIds:Array;
      
      protected var _iFrameIdsLength:int = 0;
      
      public function get frames() : Array {
         return _aFrameIds;
      }
      
      public function set frames(param1:Array) : void {
         _aFrameIds = param1;
         _iFrameIdsLength = _aFrameIds.length;
         _iCurrentFrame = 0;
         if(_cTextureAtlas)
         {
            cTexture = _cTextureAtlas.getTexture(_aFrameIds[0]);
         }
      }
      
      public var repeatable:Boolean = true;
      
      public function setTextureAtlas(param1:FTextureAtlas) : void {
         _cTextureAtlas = param1;
         if(_aFrameIds)
         {
            cTexture = _cTextureAtlas.getTexture(_aFrameIds[0]);
         }
      }
      
      public function get frameRate() : int {
         return 1000 / _nSpeed;
      }
      
      public function set frameRate(param1:int) : void {
         _nSpeed = 1000 / param1;
      }
      
      public function get numFrames() : int {
         return _iFrameIdsLength;
      }
      
      public function gotoFrame(param1:int) : void {
         if(_aFrameIds == null)
         {
            return;
         }
         _iCurrentFrame = param1;
         _iCurrentFrame = _iCurrentFrame % _aFrameIds.length;
         cTexture = _cTextureAtlas.getTexture(_aFrameIds[_iCurrentFrame]);
      }
      
      public function gotoAndPlay(param1:int) : void {
         gotoFrame(param1);
         play();
      }
      
      public function gotoAndStop(param1:int) : void {
         gotoFrame(param1);
         stop();
      }
      
      public function stop() : void {
         _bPlaying = false;
      }
      
      public function play() : void {
         _bPlaying = true;
      }
      
      override public function update(param1:Number, param2:Boolean, param3:Boolean) : void {
         if(cTexture == null)
         {
            return;
         }
         if(_bPlaying)
         {
            _nAccumulatedTime = _nAccumulatedTime + param1;
            if(_nAccumulatedTime >= _nSpeed)
            {
               _iCurrentFrame = _iCurrentFrame + _nAccumulatedTime / _nSpeed;
               if(_iCurrentFrame < _iFrameIdsLength || repeatable)
               {
                  _iCurrentFrame = _iCurrentFrame % _aFrameIds.length;
               }
               else
               {
                  _iCurrentFrame = _iFrameIdsLength - 1;
               }
               cTexture = _cTextureAtlas.getTexture(_aFrameIds[_iCurrentFrame]);
            }
            _nAccumulatedTime = _nAccumulatedTime % _nSpeed;
         }
      }
   }
}
