package com.flengine.signals
{
    import com.flengine.core.*;
    import flash.events.*;

    public class FMouseSignal extends Event
    {
        private var __cTarget:FNode;
        private var __cDispatcher:FNode;
        private var __nLocalX:Number;
        private var __nLocalY:Number;
        private var __bButtonDown:Boolean;
        private var __bCtrlDown:Boolean;
        private var __sType:String;

        public function FMouseSignal(param1:FNode, param2:FNode, param3:Number, param4:Number, param5:Boolean, param6:Boolean, param7:String)
        {
            super("MouseSignal");
            __cTarget = param1;
            __cDispatcher = param2;
            __nLocalX = param3;
            __nLocalY = param4;
            __bButtonDown = param5;
            __bCtrlDown = param6;
            __sType = param7;
            return;
        }// end function

        override public function get target() : Object
        {
            return __cTarget;
        }// end function

        public function get dispatcher() : FNode
        {
            return __cDispatcher;
        }// end function

        public function get localX() : Number
        {
            return __nLocalX;
        }// end function

        public function get localY() : Number
        {
            return __nLocalY;
        }// end function

        public function get buttonDown() : Boolean
        {
            return __bButtonDown;
        }// end function

        public function get ctrlDown() : Boolean
        {
            return __bCtrlDown;
        }// end function

        override public function get type() : String
        {
            return __sType;
        }// end function

    }
}
