package com.flengine.core
{
   import com.flengine.components.FComponent;
   import com.flengine.error.FError;
   import flash.utils.getDefinitionByName;
   import com.flengine.components.FTransform;
   
   public class FNodeFactory extends Object
   {
      
      public function FNodeFactory() {
         super();
      }
      
      public static function createNode(param1:String = "") : FNode {
         return new FNode(param1);
      }
      
      public static function createNodeWithComponent(param1:Class, param2:String = "", param3:Class = null) : FComponent {
         var _loc4_:FNode = new FNode(param2);
         return _loc4_.addComponent(param1,param3);
      }
      
      public static function createNodeWithComponentPrototype(param1:XML, param2:String = "") : FComponent {
         var _loc3_:FNode = new FNode(param2);
         return _loc3_.addComponentFromPrototype(param1);
      }
      
      public static function createFromPrototype(param1:XML, param2:String = "") : FNode {
         var _loc8_:* = undefined;
         var _loc6_:* = undefined;
         var _loc9_:* = 0;
         var _loc4_:* = null;
         var _loc7_:* = null;
         if(param1 == null)
         {
            throw new FError("FError: Prototype cannot be null.");
         }
         else
         {
            var _loc5_:FNode = new FNode(param2);
            _loc5_.mouseEnabled = param1.@mouseEnabled == "true"?true:false;
            _loc5_.mouseChildren = param1.@mouseChildren == "true"?true:false;
            var _loc3_:Array = param1.@tags.split(",");
            _loc9_ = 0;
            while(_loc9_ < _loc3_.length)
            {
               _loc5_.addTag(_loc3_[_loc9_]);
               _loc9_++;
            }
            _loc9_ = 0;
            while(_loc9_ < param1.components.children().length())
            {
               _loc4_ = param1.components.children()[_loc9_];
               _loc8_ = getDefinitionByName(_loc4_.@componentClass.split("-").join("::"));
               if(_loc8_ == FTransform)
               {
                  _loc5_.transform.bindFromPrototype(_loc4_);
               }
               else
               {
                  _loc6_ = getDefinitionByName(_loc4_.@componentLookupClass.split("-").join("::"));
                  _loc7_ = _loc5_.addComponent(_loc8_,_loc6_);
                  _loc7_.bindFromPrototype(_loc4_);
               }
               _loc9_++;
            }
            _loc9_ = 0;
            while(_loc9_ < param1.children.children().length())
            {
               _loc4_ = param1.children.children()[_loc9_];
               _loc5_.addChild(FNodeFactory.createFromPrototype(_loc4_));
               _loc9_++;
            }
            return _loc5_;
         }
      }
   }
}
