package com.flengine.core
{
    import com.flengine.components.*;
    import com.flengine.error.*;
    import flash.utils.*;

    public class FNodeFactory extends Object
    {

        public function FNodeFactory()
        {
            return;
        }// end function

        public static function createNode(param1:String = "") : FNode
        {
            return new FNode(param1);
        }// end function

        public static function createNodeWithComponent(param1:Class, param2:String = "", param3:Class = null) : FComponent
        {
            var _loc_4:* = new FNode(param2);
            return _loc_4.addComponent(param1, param3);
        }// end function

        public static function createNodeWithComponentPrototype(param1:XML, param2:String = "") : FComponent
        {
            var _loc_3:* = new FNode(param2);
            return _loc_3.addComponentFromPrototype(param1);
        }// end function

        public static function createFromPrototype(param1:XML, param2:String = "") : FNode
        {
            var _loc_8:* = undefined;
            var _loc_6:* = undefined;
            var _loc_9:* = 0;
            var _loc_4:* = null;
            var _loc_7:* = null;
            if (param1 == null)
            {
                throw new FError("FError: Prototype cannot be null.");
            }
            var _loc_5:* = new FNode(param2);
            _loc_5.mouseEnabled = param1.@mouseEnabled == "true" ? (true) : (false);
            _loc_5.mouseChildren = param1.@mouseChildren == "true" ? (true) : (false);
            var _loc_3:* = param1.@tags.split(",");
            _loc_9 = 0;
            while (_loc_9 < _loc_3.length)
            {
                
                _loc_5.addTag(_loc_3[_loc_9]);
                _loc_9++;
            }
            _loc_9 = 0;
            while (_loc_9 < param1.components.children().length())
            {
                
                _loc_4 = param1.components.children()[_loc_9];
                _loc_8 = FNodeFactory.getDefinitionByName(_loc_4.@componentClass.split("-").join("::"));
                if (_loc_8 == FTransform)
                {
                    _loc_5.transform.bindFromPrototype(_loc_4);
                }
                else
                {
                    _loc_6 = FNodeFactory.getDefinitionByName(_loc_4.@componentLookupClass.split("-").join("::"));
                    _loc_7 = _loc_5.addComponent(_loc_8, _loc_6);
                    _loc_7.bindFromPrototype(_loc_4);
                }
                _loc_9++;
            }
            _loc_9 = 0;
            while (_loc_9 < param1.children.children().length())
            {
                
                _loc_4 = param1.children.children()[_loc_9];
                _loc_5.addChild(FNodeFactory.createFromPrototype(_loc_4));
                _loc_9++;
            }
            return _loc_5;
        }// end function

    }
}
