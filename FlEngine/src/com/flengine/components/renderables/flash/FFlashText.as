package com.flengine.components.renderables.flash
{
    import com.flengine.core.*;
    import flash.text.*;

    public class FFlashText extends FFlashObject
    {
        private var __tfoTextFormat:TextFormat;
        private var __tfTextField:TextField;
        private static var __iCount:int = 0;

        public function FFlashText(param1:FNode)
        {
            super(param1);
            updateFrameRate = 0;
            __tfTextField = new TextField();
            _doNative = __tfTextField;
            return;
        }

        public function set textFormat(param1:TextFormat) : void
        {
            __tfTextField.defaultTextFormat = param1;
            if (__tfTextField.text.length > 0)
            {
                __tfTextField.setTextFormat(param1, 0, (__tfTextField.text.length - 1));
            }
            _bInvalidate = true;
            return;
        }

        public function set embedFonts(param1:Boolean) : void
        {
            __tfTextField.embedFonts = param1;
            return;
        }

        public function set background(param1:Boolean) : void
        {
            __tfTextField.background = param1;
            _bInvalidate = true;
            return;
        }

        public function set wordWrap(param1:Boolean) : void
        {
            __tfTextField.wordWrap = param1;
            _bInvalidate = true;
            return;
        }

        public function set backgroundColor(param1:int) : void
        {
            __tfTextField.backgroundColor = param1;
            _bInvalidate = true;
            return;
        }

        public function set htmlText(param1:String) : void
        {
            __tfTextField.htmlText = param1;
            _bInvalidate = true;
            return;
        }

        public function set text(param1:String) : void
        {
            __tfTextField.text = param1;
            _bInvalidate = true;
            return;
        }

        public function set multiLine(param1:Boolean) : void
        {
            __tfTextField.multiline = param1;
            _bInvalidate = true;
            return;
        }

        public function set textColor(param1:int) : void
        {
            __tfTextField.textColor = param1;
            _bInvalidate = true;
            return;
        }

        public function set autoSize(param1:String) : void
        {
            __tfTextField.autoSize = param1;
            _bInvalidate = true;
            return;
        }

        public function get width() : Number
        {
            return __tfTextField.width;
        }

        public function set width(param1:Number) : void
        {
            __tfTextField.width = param1;
            _bInvalidate = true;
            return;
        }

        public function get height() : Number
        {
            return __tfTextField.height;
        }

        public function set height(param1:Number) : void
        {
            __tfTextField.height = param1;
            _bInvalidate = true;
            return;
        }

    }
}
