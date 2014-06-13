package com.flengine.components.renderables.jointanim
{
    import flash.geom.*;

    public class JAObjectPos extends Object
    {
        public var name:String;
        public var objectNum:int;
        public var isSprite:Boolean;
        public var isAdditive:Boolean;
        public var resNum:int;
        public var hasSrcRect:Boolean;
        public var srcRect:Rectangle;
        public var color:JAColor;
        public var animFrameNum:int;
        public var timeScale:Number;
        public var preloadFrames:int;
        public var transform:JATransform;

        public function JAObjectPos()
        {
            transform = new JATransform();
            return;
        }

        public function clone(param1:JAObjectPos) : void
        {
            this.name = param1.name;
            this.objectNum = param1.objectNum;
            this.isSprite = param1.isSprite;
            this.isAdditive = param1.isAdditive;
            this.resNum = param1.resNum;
            this.hasSrcRect = param1.hasSrcRect;
            if (this.hasSrcRect)
            {
                if (param1.srcRect != null)
                {
                    this.srcRect = param1.srcRect.clone();
                }
            }
            if (param1.color != JAColor.White)
            {
                this.color = new JAColor();
                this.color.clone(param1.color);
            }
            else
            {
                this.color = param1.color;
            }
            this.animFrameNum = param1.animFrameNum;
            this.timeScale = param1.timeScale;
            this.preloadFrames = param1.preloadFrames;
            transform.clone(param1.transform);
            return;
        }

    }
}
