package com.flengine.components.renderables
{
    import com.flengine.core.*;
    import com.flengine.textures.*;

    public class FMovieClip extends FTexturedQuad
    {
        protected var _nSpeed:Number = 33.3333;
        protected var _nAccumulatedTime:Number = 0;
        protected var _iCurrentFrame:int = -1;
        protected var _iStartIndex:int = -1;
        protected var _iEndIndex:int = -1;
        protected var _bPlaying:Boolean = true;
        protected var _cTextureAtlas:FTextureAtlas;
        protected var _aFrameIds:Array;
        protected var _iFrameIdsLength:int = 0;
        public var repeatable:Boolean = true;
        private static var __iCount:int = 0;

        public function FMovieClip(param1:FNode)
        {
            super(param1);
            return;
        }// end function

        public function get currentFrame() : int
        {
            return _iCurrentFrame;
        }// end function

        public function get textureAtlasId() : String
        {
            return _cTextureAtlas ? (_cTextureAtlas.id) : ("");
        }// end function

        public function set textureAtlasId(param1:String) : void
        {
            _cTextureAtlas = param1 != "" ? (FTextureAtlas.getTextureAtlasById(param1)) : (null);
            if (_aFrameIds)
            {
                cTexture = _cTextureAtlas.getTexture(_aFrameIds[0]);
            }
            return;
        }// end function

        public function get frames() : Array
        {
            return _aFrameIds;
        }// end function

        public function set frames(param1:Array) : void
        {
            _aFrameIds = param1;
            _iFrameIdsLength = _aFrameIds.length;
            _iCurrentFrame = 0;
            if (_cTextureAtlas)
            {
                cTexture = _cTextureAtlas.getTexture(_aFrameIds[0]);
            }
            return;
        }// end function

        public function setTextureAtlas(param1:FTextureAtlas) : void
        {
            _cTextureAtlas = param1;
            if (_aFrameIds)
            {
                cTexture = _cTextureAtlas.getTexture(_aFrameIds[0]);
            }
            return;
        }// end function

        public function get frameRate() : int
        {
            return 1000 / _nSpeed;
        }// end function

        public function set frameRate(param1:int) : void
        {
            _nSpeed = 1000 / param1;
            return;
        }// end function

        public function get numFrames() : int
        {
            return _iFrameIdsLength;
        }// end function

        public function gotoFrame(param1:int) : void
        {
            if (_aFrameIds == null)
            {
                return;
            }
            _iCurrentFrame = param1;
            _iCurrentFrame = _iCurrentFrame % _aFrameIds.length;
            cTexture = _cTextureAtlas.getTexture(_aFrameIds[_iCurrentFrame]);
            return;
        }// end function

        public function gotoAndPlay(param1:int) : void
        {
            gotoFrame(param1);
            play();
            return;
        }// end function

        public function gotoAndStop(param1:int) : void
        {
            gotoFrame(param1);
            stop();
            return;
        }// end function

        public function stop() : void
        {
            _bPlaying = false;
            return;
        }// end function

        public function play() : void
        {
            _bPlaying = true;
            return;
        }// end function

        override public function update(param1:Number, param2:Boolean, param3:Boolean) : void
        {
            if (cTexture == null)
            {
                return;
            }
            if (_bPlaying)
            {
                _nAccumulatedTime = _nAccumulatedTime + param1;
                if (_nAccumulatedTime >= _nSpeed)
                {
                    _iCurrentFrame = _iCurrentFrame + _nAccumulatedTime / _nSpeed;
                    if (_iCurrentFrame < _iFrameIdsLength || repeatable)
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
            return;
        }// end function

    }
}
