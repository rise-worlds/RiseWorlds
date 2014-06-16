package com.flengine.components.renderables
{
   import flash.display.BitmapData;
   import com.flengine.textures.FTexture;
   import flash.geom.Rectangle;
   import flash.events.Event;
   
   public class JAMemoryImage extends Object
   {
      
      public function JAMemoryImage(param1:Function) {
         super();
         width = 0;
         height = 0;
         numRows = 1;
         numCols = 1;
         imageExist = true;
         loadFlag = 0;
         onImgLoadCompleted = param1;
      }
      
      public static const Image_Uninitialized:int = 0;
      
      public static const Image_Loading:int = 1;
      
      public static const Image_Loaded:int = 2;
      
      public var width:int;
      
      public var height:int;
      
      public var numRows:int;
      
      public var numCols:int;
      
      public var bd:BitmapData;
      
      public var loadFlag:int;
      
      public var name:String;
      
      public var texture:FTexture;
      
      public var imageExist:Boolean;
      
      private var onImgLoadCompleted:Function;
      
      public function GetCelRect(param1:int, param2:Rectangle) : void {
         param2.height = GetCelHeight();
         param2.width = GetCelWidth();
         param2.x = param1 % numCols * param2.width;
         param2.y = param1 / numCols * param2.height;
      }
      
      public function GetCelHeight() : Number {
         return height / numRows;
      }
      
      public function GetCelWidth() : Number {
         return width / numCols;
      }
      
      public function OnLoadedCompleted(param1:Event) : void {
         param1.target.removeEventListener("complete",OnLoadedCompleted);
         bd = BitmapData(param1.target.content.bitmapData);
         width = bd.width;
         height = bd.height;
         loadFlag = 2;
         if(onImgLoadCompleted != null)
         {
            onImgLoadCompleted(this);
            onImgLoadCompleted = null;
         }
      }
      
      public function onBeChanged() : void {
         if(bd)
         {
            width = bd.width;
            height = bd.height;
            loadFlag = 2;
         }
      }
      
      public function Dispose() : void {
         if(texture)
         {
            texture.dispose();
         }
         texture = null;
         if(bd)
         {
            bd.dispose();
         }
      }
   }
}
