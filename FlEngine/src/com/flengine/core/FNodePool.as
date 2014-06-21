package com.flengine.core
{
	import com.flengine.fl2d;
	use namespace fl2d;
   public class FNodePool extends Object
   {
      
      public function FNodePool(param1:XML, param2:int = 0, param3:int = 0) {
         var _loc4_:* = 0;
         super();
         __xPrototype = param1;
         __iMaxCount = param2;
         _loc4_ = 0;
         while(_loc4_ < param3)
         {
            createNew(true);
            _loc4_++;
         }
      }
      
      private var __cFirst:FNode;
      
      private var __cLast:FNode;
      
      private var __xPrototype:XML;
      
      private var __iMaxCount:int;
      
      private var __iCachedCount:int = 0;
      
      private var __bDisposing:Boolean = false;
      
      public function get cachedCount() : int {
         return __iCachedCount;
      }
      
      public function getNext() : FNode {
         var _loc1_:FNode = null;
         if(__cFirst == null || __cFirst.active)
         {
            _loc1_ = createNew();
         }
         else
         {
            _loc1_ = __cFirst;
            _loc1_.active = true;
         }
         return _loc1_;
      }
      
      fl2d function putToFront(param1:FNode) : void {
         if(param1 == __cFirst)
         {
            return;
         }
         if(param1.cPoolNext)
         {
            param1.cPoolNext.cPoolPrevious = param1.cPoolPrevious;
         }
         if(param1.cPoolPrevious)
         {
            param1.cPoolPrevious.cPoolNext = param1.cPoolNext;
         }
         if(param1 == __cLast)
         {
            __cLast = __cLast.cPoolPrevious;
         }
         if(__cFirst != null)
         {
            __cFirst.cPoolPrevious = param1;
         }
         param1.cPoolPrevious = null;
         param1.cPoolNext = __cFirst;
         __cFirst = param1;
      }
      
      fl2d function putToBack(param1:FNode) : void {
         if(param1 == __cLast)
         {
            return;
         }
         if(param1.cPoolNext)
         {
            param1.cPoolNext.cPoolPrevious = param1.cPoolPrevious;
         }
         if(param1.cPoolPrevious)
         {
            param1.cPoolPrevious.cPoolNext = param1.cPoolNext;
         }
         if(param1 == __cFirst)
         {
            __cFirst = __cFirst.cPoolNext;
         }
         if(__cLast != null)
         {
            __cLast.cPoolNext = param1;
         }
         param1.cPoolPrevious = __cLast;
         param1.cPoolNext = null;
         __cLast = param1;
      }
      
      private function createNew(param1:Boolean = false) : FNode {
         var _loc2_:FNode = null;
         if(__iMaxCount == 0 || __iCachedCount < __iMaxCount)
         {
            __iCachedCount = __iCachedCount + 1;
            _loc2_ = FNodeFactory.createFromPrototype(__xPrototype);
            _loc2_.active = !param1;
            _loc2_.cPool = this;
            if(__cFirst == null)
            {
               __cFirst = _loc2_;
               __cLast = _loc2_;
            }
            else
            {
               _loc2_.cPoolPrevious = __cLast;
               __cLast.cPoolNext = _loc2_;
               __cLast = _loc2_;
            }
         }
         return _loc2_;
      }
      
      private function createNode() : FNode {
         return FNodeFactory.createFromPrototype(__xPrototype);
      }
      
      public function dispose() : void {
         var _loc1_:FNode = null;
         while(__cFirst)
         {
            _loc1_ = __cFirst.cPoolNext;
            __cFirst.dispose();
            __cFirst = _loc1_;
         }
      }
      
      public function deactivate() : void {
         if(__cLast == null)
         {
            return;
         }
         while(__cLast.active)
         {
            __cLast.active = false;
         }
      }
   }
}
