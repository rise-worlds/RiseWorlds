package com.flengine.signals
{
   import flash.utils.Dictionary;
   
   public class HelpSignal extends Object
   {
      
      public function HelpSignal() {
         super();
         funcList = new Dictionary();
      }
      
      private var funcList:Dictionary;
      
      public function dispose() : void {
         for(var _loc1_:Object in funcList)
         {
            delete funcList[_loc1_];
            _loc1_ = null;
         }
         funcList = null;
      }
      
      public function dispatch(param1:Object) : void {
         for(var _loc2_:Object in funcList)
         {
            _loc2_(param1);
            if(funcList[_loc2_])
            {
               delete funcList[_loc2_];
               _loc2_ = null;
            }
         }
      }
      
      public function add(param1:Function) : void {
         if(funcList[param1] == undefined)
         {
            funcList[param1] = false;
         }
      }
      
      public function addOnce(param1:Function) : void {
         if(funcList[param1] == undefined)
         {
            funcList[param1] = true;
         }
      }
      
      public function remove(param1:Function) : void {
         if(funcList[param1] != undefined)
         {
            delete funcList[param1];
         }
      }
   }
}
