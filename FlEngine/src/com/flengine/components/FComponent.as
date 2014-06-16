package com.flengine.components
{
   import flash.utils.getQualifiedClassName;
   import flash.utils.describeType;
   import com.flengine.core.FNode;
   import com.flengine.context.FContext;
   import flash.geom.Rectangle;
   import flash.events.MouseEvent;
   import flash.geom.Vector3D;
   import flash.events.TouchEvent;
   
   public class FComponent extends Object
   {
      
      public function FComponent(param1:FNode) {
         super();
         cNode = param1;
      }
      
      protected var _xPrototype:XML;
      
      public function getPrototype() : XML {
         var _loc5_:* = 0;
         var _loc4_:* = null;
         var _loc1_:* = null;
         _xPrototype = <component/>;
         _xPrototype.@id = _sId;
         _xPrototype.@componentClass = getQualifiedClassName(this).split("::").join("-");
         _xPrototype.@componentLookupClass = getQualifiedClassName(this.cLookupClass).split("::").join("-");
         _xPrototype.properties = <properties/>;
         var _loc2_:XML = describeType(this);
         var _loc6_:XMLList = _loc2_.variable;
         _loc5_ = 0;
         while(_loc5_ < _loc6_.length())
         {
            _loc4_ = _loc6_[_loc5_];
            addPrototypeProperty(_loc4_.@name,this[_loc4_.@name],_loc4_.@type);
            _loc5_++;
         }
         var _loc3_:XMLList = _loc2_.accessor;
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length())
         {
            _loc1_ = _loc3_[_loc5_];
            if(_loc1_.@access == "readwrite")
            {
               addPrototypeProperty(_loc1_.@name,this[_loc1_.@name],_loc1_.@type);
            }
            _loc5_++;
         }
         return _xPrototype;
      }
      
      protected function addPrototypeProperty(param1:String, param2:*, param3:String, param4:XML = null) : void {
         var _loc5_:* = null;
         var param3:String = param3.toLowerCase();
         var _loc7_:String = typeof param2;
         if(_loc7_ == "object" && !(param3 == "array") && !(param3 == "object"))
         {
            return;
         }
         if(_loc7_ != "object")
         {
            _loc5_ = new XML("<" + (param1 + " ") + " value=" + ("\"" + ({param2}) + "\"") + " type=" + ("\"" + ({param3}) + "\"") + "/>");
         }
         else
         {
            _loc5_ = new XML("<" + (param1 + " ") + " type=" + ("\"" + ({param3}) + "\"") + "/>");
            _loc9_ = 0;
            _loc8_ = param2;
            for(_loc6_ in param2)
            {
               addPrototypeProperty(_loc6_,param2[_loc6_],typeof param2[_loc6_],_loc5_);
            }
         }
         if(param4 == null)
         {
            _xPrototype.properties.appendChild(_loc5_);
         }
         else
         {
            param4.appendChild(_loc5_);
         }
      }
      
      public function bindFromPrototype(param1:XML) : void {
         var _loc4_:* = 0;
         _sId = param1.@id;
         var _loc3_:XMLList = param1.properties;
         var _loc2_:int = _loc3_.children().length();
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            bindPrototypeProperty(_loc3_.children()[_loc4_],this);
            _loc4_++;
         }
      }
      
      public function bindPrototypeProperty(param1:XML, param2:Object) : void {
         var _loc3_:* = 0;
         var _loc5_:* = 0;
         var _loc4_:* = null;
         if(param1.@type == "object")
         {
         }
         if(param1.@type == "array")
         {
            _loc4_ = [];
            _loc3_ = param1.children().length();
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               bindPrototypeProperty(param1.children()[_loc5_],_loc4_);
               _loc5_++;
            }
         }
         if(param1.@type == "boolean")
         {
            _loc4_ = param1.@value == "false"?false:true;
         }
         try
         {
            param2[param1.name()] = _loc4_ == null?param1.@value:_loc4_;
         }
         catch(e:Error)
         {
            trace("bindPrototypeProperty",e,param2,param1.name(),_loc4_);
         }
      }
      
      protected var _bActive:Boolean = true;
      
      public function set active(param1:Boolean) : void {
         _bActive = param1;
      }
      
      public function get active() : Boolean {
         return _bActive;
      }
      
      protected var _sId:String = "";
      
      public function get id() : String {
         return _sId;
      }
      
      fl2d var cLookupClass:Object;
      
      fl2d var cPrevious:FComponent;
      
      fl2d var cNext:FComponent;
      
      fl2d var cNode:FNode;
      
      fl2d var cRenderData:Object;
      
      public function get node() : FNode {
         return cNode;
      }
      
      public function update(param1:Number, param2:Boolean, param3:Boolean) : void {
      }
      
      public function render(param1:FContext, param2:FCamera, param3:Rectangle) : void {
      }
      
      public function processMouseEvent(param1:Boolean, param2:MouseEvent, param3:Vector3D) : Boolean {
         return false;
      }
      
      public function processTouchEvent(param1:Boolean, param2:TouchEvent, param3:Vector3D) : Boolean {
         return false;
      }
      
      private function internaldispose() : void {
         _bActive = false;
         cNode = null;
         cNext = null;
         cPrevious = null;
         dispose();
      }
      
      public function dispose() : void {
      }
   }
}
