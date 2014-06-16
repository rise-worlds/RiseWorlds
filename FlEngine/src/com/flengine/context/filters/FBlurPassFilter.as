package com.flengine.context.filters
{
   import flash.display3D.Context3D;
   import com.flengine.textures.FTexture;
   import com.flengine.core.FlEngine;
   import com.flengine.error.FError;
   
   public class FBlurPassFilter extends FFilter
   {
      
      public function FBlurPassFilter(param1:int, param2:int) {
         super();
         iId = 3;
         if(FlEngine.getInstance().cConfig.profile != "baseline")
         {
            throw new FError("FError: Cannot run in constrained mode.",FBlurPassFilter);
         }
         else
         {
            bOverrideFragmentShader = true;
            fragmentCode = "tex ft0, v0, fs0 <2d,linear,mipnone,clamp>     \nmul ft0.xyzw, ft0.xyzw, fc2.y                  \nsub ft1.xy, v0.xy, fc1.xy                      \ntex ft2, ft1.xy, fs0 <2d,linear,mipnone,clamp> \nmul ft2.xyzw, ft2.xyzw, fc2.z                  \nadd ft0, ft0, ft2                              \nadd ft1.xy, v0.xy, fc1.xy                      \ntex ft2, ft1.xy, fs0 <2d,linear,mipnone,clamp> \nmul ft2.xyzw, ft2.xyzw, fc2.z                  \nadd ft0, ft0, ft2                              \nsub ft1.xy, v0.xy, fc1.zw                      \ntex ft2, ft1.xy, fs0 <2d,linear,mipnone,clamp> \nmul ft2.xyzw, ft2.xyzw, fc2.w                  \nadd ft0, ft0, ft2                              \nadd ft1.xy, v0.xy, fc1.zw                      \ntex ft2, ft1.xy, fs0 <2d,linear,mipnone,clamp> \nmul ft2.xyzw, ft2.xyzw, fc2.w                  \nadd ft0, ft0, ft2                              \nmul ft0.xyz, ft0.xyz, fc2.xxx\t\t\t\t\t\nmul ft1.xyz, ft0.www, fc3.xyz\t\t\t\t\t\nadd ft0.xyz, ft0.xyz, ft1.xyz\t\t\t\t\t\nmul oc, ft0, fc3.wwww\t\t\t\t\t\t\t\n";
            _aFragmentConstants = new <Number>[0,0,0,0,1,0.227027027,0.3162162162,0.0702702703,0,0,0,1];
            blur = param1;
            direction = param2;
            return;
         }
      }
      
      public static const VERTICAL:int = 0;
      
      public static const HORIZONTAL:int = 1;
      
      public var blur:Number = 0;
      
      public var direction:int = 0;
      
      public var colorize:Boolean = false;
      
      public var red:Number = 0;
      
      public var green:Number = 0;
      
      public var blue:Number = 0;
      
      public var alpha:Number = 1;
      
      override public function bind(param1:Context3D, param2:FTexture) : void {
         if(direction == 1)
         {
            _aFragmentConstants[0] = 1 / param2.gpuWidth * 1.3846153846 * blur * 0.5;
            _aFragmentConstants[1] = 0;
            _aFragmentConstants[2] = 1 / param2.gpuWidth * 3.2307692308 * blur * 0.5;
            _aFragmentConstants[3] = 0;
         }
         else
         {
            _aFragmentConstants[0] = 0;
            _aFragmentConstants[1] = 1 / param2.gpuHeight * 1.3846153846 * blur * 0.5;
            _aFragmentConstants[2] = 0;
            _aFragmentConstants[3] = 1 / param2.gpuHeight * 3.2307692308 * blur * 0.5;
         }
         _aFragmentConstants[4] = colorize?0:1;
         _aFragmentConstants[8] = red;
         _aFragmentConstants[9] = green;
         _aFragmentConstants[10] = blue;
         _aFragmentConstants[11] = alpha;
         super.bind(param1,param2);
      }
   }
}
