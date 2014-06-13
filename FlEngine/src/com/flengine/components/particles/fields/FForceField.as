package com.flengine.components.particles.fields
{
    import com.flengine.components.particles.*;
    import com.flengine.core.*;

    public class FForceField extends FField
    {
        public var radius:Number = 0;
        public var forceX:Number = 0;
        public var forceXVariance:Number = 0;
        public var forceY:Number = 0;
        public var forceYVariance:Number = 0;

        public function FForceField(param1:FNode)
        {
            super(param1);
            return;
        }// end function

        override public function updateParticle(param1:FParticle, param2:Number) : void
        {
            if (!_bActive)
            {
                return;
            }
            var _loc_3:* = cNode.cTransform.nWorldX - param1.cNode.cTransform.nWorldX;
            var _loc_4:* = cNode.cTransform.nWorldY - param1.cNode.cTransform.nWorldY;
            var _loc_5:* = _loc_3 * _loc_3 + _loc_4 * _loc_4;
            if (_loc_3 * _loc_3 + _loc_4 * _loc_4 > radius * radius && radius > 0)
            {
                return;
            }
            param1.nVelocityX = param1.nVelocityX + forceX * 0.001 * param2;
            param1.nVelocityY = param1.nVelocityY + forceY * 0.001 * param2;
            return;
        }// end function

        override public function updateSimpleParticle(param1:FSimpleParticle, param2:Number) : void
        {
            if (!_bActive)
            {
                return;
            }
            var _loc_3:* = cNode.cTransform.nWorldX - param1.nX;
            var _loc_4:* = cNode.cTransform.nWorldY - param1.nY;
            var _loc_5:* = _loc_3 * _loc_3 + _loc_4 * _loc_4;
            if (_loc_3 * _loc_3 + _loc_4 * _loc_4 > radius * radius && radius > 0)
            {
                return;
            }
            param1.nVelocityX = param1.nVelocityX + forceX * 0.001 * param2;
            param1.nVelocityY = param1.nVelocityY + forceY * 0.001 * param2;
            return;
        }// end function

    }
}
