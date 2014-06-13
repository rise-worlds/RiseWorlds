package com.flengine.signals
{
    import flash.utils.*;

    public class HelpSignal extends Object
    {
        private var funcList:Dictionary;

        public function HelpSignal()
        {
            funcList = new Dictionary();
            return;
        }

        public function dispose() : void
        {
            for (var _loc_1:* in funcList)
            {
                
                delete funcList[_loc_1];
                _loc_1 = null;
            }
            funcList = null;
            return;
        }

        public function dispatch(param1:Object) : void
        {
            for (var _loc_2:* in funcList)
            {
                
                _loc_2(param1);
                if (funcList[_loc_2])
                {
                    delete funcList[_loc_2];
                    _loc_2 = null;
                }
            }
            return;
        }

        public function add(param1:Function) : void
        {
            if (funcList[param1] == undefined)
            {
                funcList[param1] = false;
            }
            return;
        }

        public function addOnce(param1:Function) : void
        {
            if (funcList[param1] == undefined)
            {
                funcList[param1] = true;
            }
            return;
        }

        public function remove(param1:Function) : void
        {
            if (funcList[param1] != undefined)
            {
                delete funcList[param1];
            }
            return;
        }

    }
}
