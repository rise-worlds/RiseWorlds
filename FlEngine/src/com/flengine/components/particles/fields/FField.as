package com.flengine.components.particles.fields
{
   import com.flengine.components.FComponent;
   import com.flengine.components.particles.FParticle;
   import com.flengine.components.particles.FSimpleParticle;
   import com.flengine.core.FNode;
   
   public class FField extends FComponent
   {
      
      public function FField(param1:FNode) {
         super(param1);
      }
      
      protected var _bUpdateParticles:Boolean = true;
      
      public function updateParticle(param1:FParticle, param2:Number) : void {
      }
      
      public function updateSimpleParticle(param1:FSimpleParticle, param2:Number) : void {
      }
   }
}
