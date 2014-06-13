package com.flengine.components.particles.fields
{
    import com.flengine.components.*;
    import com.flengine.components.particles.*;
    import com.flengine.core.*;

    public class FField extends FComponent
    {
        protected var _bUpdateParticles:Boolean = true;

        public function FField(param1:FNode)
        {
            super(param1);
            return;
        }

        public function updateParticle(param1:FParticle, param2:Number) : void
        {
            return;
        }

        public function updateSimpleParticle(param1:FSimpleParticle, param2:Number) : void
        {
            return;
        }

    }
}
