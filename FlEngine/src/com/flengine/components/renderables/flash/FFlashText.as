package com.flengine.components.renderables.flash
{
   import flash.text.TextFormat;
   import flash.text.TextField;
   import com.flengine.core.FNode;
   
   public class FFlashText extends FFlashObject
   {
      
      public function FFlashText(param1:FNode) {
         super(param1);
         updateFrameRate = 0;
         __tfTextField = new TextField();
         _doNative = __tfTextField;
      }
      
      private static var __iCount:int = 0;
      
      private var __tfoTextFormat:TextFormat;
      
      private var __tfTextField:TextField;
      
      public function set textFormat(param1:TextFormat) : void {
         __tfTextField.defaultTextFormat = param1;
         if(__tfTextField.text.length > 0)
         {
            __tfTextField.setTextFormat(param1,0,__tfTextField.text.length - 1);
         }
         _bInvalidate = true;
      }
      
      public function set embedFonts(param1:Boolean) : void {
         __tfTextField.embedFonts = param1;
      }
      
      public function set background(param1:Boolean) : void {
         __tfTextField.background = param1;
         _bInvalidate = true;
      }
      
      public function set wordWrap(param1:Boolean) : void {
         __tfTextField.wordWrap = param1;
         _bInvalidate = true;
      }
      
      public function set backgroundColor(param1:int) : void {
         __tfTextField.backgroundColor = param1;
         _bInvalidate = true;
      }
      
      public function set htmlText(param1:String) : void {
         __tfTextField.htmlText = param1;
         _bInvalidate = true;
      }
      
      public function set text(param1:String) : void {
         __tfTextField.text = param1;
         _bInvalidate = true;
      }
      
      public function set multiLine(param1:Boolean) : void {
         __tfTextField.multiline = param1;
         _bInvalidate = true;
      }
      
      public function set textColor(param1:int) : void {
         __tfTextField.textColor = param1;
         _bInvalidate = true;
      }
      
      public function set autoSize(param1:String) : void {
         __tfTextField.autoSize = param1;
         _bInvalidate = true;
      }
      
      public function get width() : Number {
         return __tfTextField.width;
      }
      
      public function set width(param1:Number) : void {
         __tfTextField.width = param1;
         _bInvalidate = true;
      }
      
      public function get height() : Number {
         return __tfTextField.height;
      }
      
      public function set height(param1:Number) : void {
         __tfTextField.height = param1;
         _bInvalidate = true;
      }
   }
}
