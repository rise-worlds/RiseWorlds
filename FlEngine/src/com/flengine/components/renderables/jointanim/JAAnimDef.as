package com.flengine.components.renderables.jointanim
{
    import __AS3__.vec.*;

    public class JAAnimDef extends Object
    {
        public var mainSpriteDef:JASpriteDef;
        public var spriteDefVector:Vector.<JASpriteDef>;
        public var objectNamePool:Array;

        public function JAAnimDef()
        {
            mainSpriteDef = null;
            spriteDefVector = new Vector.<JASpriteDef>;
            objectNamePool = [];
            return;
        }

    }
}
