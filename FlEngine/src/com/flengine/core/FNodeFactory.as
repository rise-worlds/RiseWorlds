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
        }

        public static function createNode(param1:String = "") : FNode
        {
            return new FNode(param1);
        }

        public static function createNodeWithComponent(param1:Class, param2:String = "", param3:Class = null) : FComponent
        {
            var _loc_4:* = new FNode(param2);
            return _loc_4.addComponent(param1, param3);
        }

        public static function createNodeWithComponentPrototype(param1:XML, param2:String = "") : FComponent
        {
            var _loc_3:* = new FNode(param2);
            return _loc_3.addComponentFromPrototype(param1);
        }

        public static function createFromPrototype(param1:XML, param2:String = "") : FNode
        {
            var _loc_8:Class = undefined;
            var _loc_6:Class = undefined;
            var _loc_9:int = 0;
            var _loc_4:* = null;
            var _loc_7:* = null;
            if (param1 == null)
            {
                throw new FError("FError: Prototype cannot be null.");
            }
            var _loc_5:FNode = new FNode(param2);
            _loc_5.mouseEnabled = param1.@mouseEnabled == "true" ? (true) : (false);
            _loc_5.mouseChildren = param1.@mouseChildren == "true" ? (true) : (false);
            var _loc_3:Array = param1.@tags.split(",");
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
                _loc_8 = getDefinitionByName(_loc_4.@componentClass.split("-").join("::")) as Class;
                if (_loc_8 == FTransform)
                {
                    _loc_5.transform.bindFromPrototype(_loc_4);
                }
                else
                {
                    _loc_6 = getDefinitionByName(_loc_4.@componentLookupClass.split("-").join("::")) as Class;
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
        }

    }
}
