package com.flengine.components.renderables.jointanim
{
    import __AS3__.vec.*;
    import com.flengine.components.renderables.*;

    public class JAImage extends Object
    {
        public var drawMode:int;
        public var cols:int;
        public var rows:int;
        public var origWidth:int;
        public var origHeight:int;
        public var _transform:JATransform;
        public var imageName:String;
        public var images:Vector.<JAMemoryImage>;

        public function JAImage()
        {
            imageName = "";
            _transform = new JATransform();
            images = new Vector.<JAMemoryImage>;
            return;
        }// end function

        public function get transform() : JATransform
        {
            return _transform;
        }// end function

        public function OnMemoryImageLoadCompleted(param1:JAMemoryImage) : void
        {
            if (this.images.length == 1 && this.images[0] == param1)
            {
                if (this.origWidth != -1 && this.origHeight != -1)
                {
                    this._transform.matrix.m02 = this._transform.matrix.m02 + (-(param1.width - this.origWidth * 1)) / (param1.numCols + 1);
                    this._transform.matrix.m12 = this._transform.matrix.m12 + (-(param1.height - this.origHeight * 1)) / (param1.numRows + 1);
                }
            }
            return;
        }// end function

    }
}
