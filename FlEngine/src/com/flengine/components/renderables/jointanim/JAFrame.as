package com.flengine.components.renderables.jointanim
{
    import __AS3__.vec.*;

    public class JAFrame extends Object
    {
        public var hasStop:Boolean;
        public var commandVector:Vector.<JACommand>;
        public var frameObjectPosVector:Vector.<JAObjectPos>;

        public function JAFrame()
        {
            commandVector = new Vector.<JACommand>;
            frameObjectPosVector = new Vector.<JAObjectPos>;
            return;
        }

    }
}
