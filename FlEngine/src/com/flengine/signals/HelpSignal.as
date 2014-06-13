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
        }// end function

        public function dispose() : void
        {
            for (_loc_1 in funcList)
            {
                
                delete _loc_2[_loc_1];
                _loc_1 = null;
            }
            funcList = null;
            return;
        }// end function

        public function dispatch(param1:Object) : void
        {
            for (_loc_2 in funcList)
            {
                
                this._loc_2(param1);
                if (_loc_3[_loc_2])
                {
                    delete _loc_3[_loc_2];
                    _loc_2 = null;
                }
            }
            return;
        }// end function

        public function add(param1:Function) : void
        {
            if (funcList[param1] == undefined)
            {
                funcList[param1] = false;
            }
            return;
        }// end function

        public function addOnce(param1:Function) : void
        {
            if (funcList[param1] == undefined)
            {
                funcList[param1] = true;
            }
            return;
        }// end function

        public function remove(param1:Function) : void
        {
            if (funcList[param1] != undefined)
            {
                delete funcList[param1];
            }
            return;
        }// end function

    }
}
