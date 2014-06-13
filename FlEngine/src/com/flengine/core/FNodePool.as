package com.flengine.core
{

    public class FNodePool extends Object
    {
        private var __cFirst:FNode;
        private var __cLast:FNode;
        private var __xPrototype:XML;
        private var __iMaxCount:int;
        private var __iCachedCount:int = 0;
        private var __bDisposing:Boolean = false;

        public function FNodePool(param1:XML, param2:int = 0, param3:int = 0)
        {
            var _loc_4:* = 0;
            __xPrototype = param1;
            __iMaxCount = param2;
            _loc_4 = 0;
            while (_loc_4 < param3)
            {
                
                createNew(true);
                _loc_4++;
            }
            return;
        }// end function

        public function get cachedCount() : int
        {
            return __iCachedCount;
        }// end function

        public function getNext() : FNode
        {
            var _loc_1:* = null;
            if (__cFirst == null || __cFirst.active)
            {
                _loc_1 = createNew();
            }
            else
            {
                _loc_1 = __cFirst;
                _loc_1.active = true;
            }
            return _loc_1;
        }// end function

        function putToFront(param1:FNode) : void
        {
            if (param1 == __cFirst)
            {
                return;
            }
            if (param1.cPoolNext)
            {
                param1.cPoolNext.cPoolPrevious = param1.cPoolPrevious;
            }
            if (param1.cPoolPrevious)
            {
                param1.cPoolPrevious.cPoolNext = param1.cPoolNext;
            }
            if (param1 == __cLast)
            {
                __cLast = __cLast.cPoolPrevious;
            }
            if (__cFirst != null)
            {
                __cFirst.cPoolPrevious = param1;
            }
            param1.cPoolPrevious = null;
            param1.cPoolNext = __cFirst;
            __cFirst = param1;
            return;
        }// end function

        function putToBack(param1:FNode) : void
        {
            if (param1 == __cLast)
            {
                return;
            }
            if (param1.cPoolNext)
            {
                param1.cPoolNext.cPoolPrevious = param1.cPoolPrevious;
            }
            if (param1.cPoolPrevious)
            {
                param1.cPoolPrevious.cPoolNext = param1.cPoolNext;
            }
            if (param1 == __cFirst)
            {
                __cFirst = __cFirst.cPoolNext;
            }
            if (__cLast != null)
            {
                __cLast.cPoolNext = param1;
            }
            param1.cPoolPrevious = __cLast;
            param1.cPoolNext = null;
            __cLast = param1;
            return;
        }// end function

        private function createNew(param1:Boolean = false) : FNode
        {
            var _loc_2:* = null;
            if (__iMaxCount == 0 || __iCachedCount < __iMaxCount)
            {
                (__iCachedCount + 1);
                _loc_2 = FNodeFactory.createFromPrototype(__xPrototype);
                _loc_2.active = !param1;
                _loc_2.cPool = this;
                if (__cFirst == null)
                {
                    __cFirst = _loc_2;
                    __cLast = _loc_2;
                }
                else
                {
                    _loc_2.cPoolPrevious = __cLast;
                    __cLast.cPoolNext = _loc_2;
                    __cLast = _loc_2;
                }
            }
            return _loc_2;
        }// end function

        private function createNode() : FNode
        {
            return FNodeFactory.createFromPrototype(__xPrototype);
        }// end function

        public function dispose() : void
        {
            var _loc_1:* = null;
            while (__cFirst)
            {
                
                _loc_1 = __cFirst.cPoolNext;
                __cFirst.dispose();
                __cFirst = _loc_1;
            }
            return;
        }// end function

        public function deactivate() : void
        {
            if (__cLast == null)
            {
                return;
            }
            while (__cLast.active)
            {
                
                __cLast.active = false;
            }
            return;
        }// end function

    }
}
