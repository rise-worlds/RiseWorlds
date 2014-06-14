package com.flengine.components
{
    import com.flengine.context.*;
    import com.flengine.core.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    public class FComponent extends Object
    {
        protected var _xPrototype:XML;
        protected var _bActive:Boolean = true;
        protected var _sId:String = "";
        public var cLookupClass:Object;
        public var cPrevious:FComponent;
        public var cNext:FComponent;
        public var cNode:FNode;
        public var cRenderData:Object;

        public function FComponent(param1:FNode)
        {
            cNode = param1;
            return;
        }

        public function getPrototype() : XML
        {
            var _loc_5:* = 0;
            var _loc_4:* = null;
            var _loc_1:* = null;
            _xPrototype = <component/>;
            _xPrototype.@id = _sId;
            _xPrototype.@componentClass = getQualifiedClassName(this).split("::").join("-");
            _xPrototype.@componentLookupClass = getQualifiedClassName(this.cLookupClass).split("::").join("-");
            _xPrototype.properties = <properties/>;
            var _loc_2:* = describeType(this);
            var _loc_6:* = _loc_2.variable;
            _loc_5 = 0;
            while (_loc_5 < _loc_6.length())
            {
                
                _loc_4 = _loc_6[_loc_5];
                addPrototypeProperty(_loc_4.@name, this[_loc_4.@name], _loc_4.@type);
                _loc_5++;
            }
            var _loc_3:* = _loc_2.accessor;
            _loc_5 = 0;
            while (_loc_5 < _loc_3.length())
            {
                
                _loc_1 = _loc_3[_loc_5];
                if (_loc_1.@access == "readwrite")
                {
                    addPrototypeProperty(_loc_1.@name, this[_loc_1.@name], _loc_1.@type);
                }
                _loc_5++;
            }
            return _xPrototype;
        }

        protected function addPrototypeProperty(param1:String, param2:Object, param3:String, param4:XML = null) : void
        {
            var _loc_5:* = null;
			var _loc_6:* = null;
			var _loc_8:* = null;
            param3 = param3.toLowerCase();
            var _loc_7:* = typeof(param2);
            if (typeof(param2) == "object" && (param3 != "array" && param3 != "object"))
            {
                return;
            }
            if (_loc_7 != "object")
            {
                _loc_5 = new XML("<" + (param1 + " ") + " value=" + ("\"" + param2 + "\"") + " type=" + ("\"" + param3 + "\"") + "/>");
            }
            else
            {
                _loc_5 = new XML("<" + (param1 + " ") + " type=" + ("\"" + param3 + "\"") + "/>");
                for (_loc_6 in param2)
                {
                    
                    addPrototypeProperty(_loc_6, _loc_8[_loc_6], typeof(_loc_8[_loc_6]), _loc_5);
                }
            }
            if (param4 == null)
            {
                _xPrototype.properties.appendChild(_loc_5);
            }
            else
            {
                param4.appendChild(_loc_5);
            }
            return;
        }

        public function bindFromPrototype(param1:XML) : void
        {
            var _loc_4:* = 0;
            _sId = param1.@id;
            var _loc_3:* = param1.properties;
            var _loc_2:* = _loc_3.children().length();
            _loc_4 = 0;
            while (_loc_4 < _loc_2)
            {
                
                bindPrototypeProperty(_loc_3.children()[_loc_4], this);
                _loc_4++;
            }
            return;
        }

        public function bindPrototypeProperty(param1:XML, param2:Object) : void
        {
            var value:*;
            var count:int;
            var i:int;
            var p_property:* = param1;
            var p_object:* = param2;
            value;
            if (p_property.@type == "object")
            {
            }
            if (p_property.@type == "array")
            {
                value = new Array();
                count = p_property.children().length();
                i;
                while (i < count)
                {
                    
                    this.bindPrototypeProperty(p_property.children()[i], value);
                    i = (i + 1);
                }
            }
            if (p_property.@type == "boolean")
            {
                value = p_property.@value == "false" ? (false) : (true);
            }
            try
            {
                p_object[p_property.name()] = value == null ? (p_property.@value) : (value);
            }
            catch (e:Error)
            {
                trace("bindPrototypeProperty", e, p_object, p_property.name(), value);
            }
            return;
        }

        public function set active(param1:Boolean) : void
        {
            _bActive = param1;
            return;
        }

        public function get active() : Boolean
        {
            return _bActive;
        }

        public function get id() : String
        {
            return _sId;
        }

        public function get node() : FNode
        {
            return cNode;
        }

        public function update(param1:Number, param2:Boolean, param3:Boolean) : void
        {
            return;
        }

        public function render(param1:FContext, param2:FCamera, param3:Rectangle) : void
        {
            return;
        }

        public function processMouseEvent(param1:Boolean, param2:MouseEvent, param3:Vector3D) : Boolean
        {
            return false;
        }

        public function processTouchEvent(param1:Boolean, param2:TouchEvent, param3:Vector3D) : Boolean
        {
            return false;
        }

        private function internaldispose() : void
        {
            _bActive = false;
            cNode = null;
            cNext = null;
            cPrevious = null;
            dispose();
            return;
        }

        public function dispose() : void
        {
            return;
        }

    }
}
