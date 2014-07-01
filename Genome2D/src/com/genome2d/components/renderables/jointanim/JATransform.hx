package com.genome2d.components.renderables.jointanim;

/**
 * ...
 * @author Rise
 */
class JATransform
{
	private static var _m00:Float;
	private static var _m01:Float;
	private static var _m10:Float;
	private static var _m11:Float;
	private static var _m02:Float;
	private static var _m12:Float;
	private static var __m00:Float;
	private static var __m01:Float;
	private static var __m10:Float;
	private static var __m11:Float;
	private static var __m02:Float;
	private static var __m12:Float;
	public var matrix:JAMatrix3;

	public function new() 
	{
		matrix = new JAMatrix3();
	}
	
	public function clone(from:JATransform):Void
	{
		this.matrix.clone(from.matrix);
	}

	public function TransformSrc(theSrcTransform:JATransform, outTransform:JATransform):JATransform
	{
		__m00 = theSrcTransform.matrix.m00;
		__m01 = theSrcTransform.matrix.m01;
		__m10 = theSrcTransform.matrix.m10;
		__m11 = theSrcTransform.matrix.m11;
		__m02 = theSrcTransform.matrix.m02;
		__m12 = theSrcTransform.matrix.m12;
		_m00 = matrix.m00;
		_m01 = matrix.m01;
		_m10 = matrix.m10;
		_m11 = matrix.m11;
		_m02 = matrix.m02;
		_m12 = matrix.m12;
		outTransform.matrix.m00 = ((_m00 * __m00) + (_m01 * __m10));
		outTransform.matrix.m01 = ((_m00 * __m01) + (_m01 * __m11));
		outTransform.matrix.m10 = ((_m10 * __m00) + (_m11 * __m10));
		outTransform.matrix.m11 = ((_m10 * __m01) + (_m11 * __m11));
		outTransform.matrix.m02 = ((_m02 + (_m00 * __m02)) + (_m01 * __m12));
		outTransform.matrix.m12 = ((_m12 + (_m10 * __m02)) + (_m11 * __m12));
		return (outTransform);
	}

	public function InterpolateTo(theNextTransform:JATransform, thePct:Float, outTransform:JATransform):JATransform
	{
		__m00 = theNextTransform.matrix.m00;
		__m01 = theNextTransform.matrix.m01;
		__m10 = theNextTransform.matrix.m10;
		__m11 = theNextTransform.matrix.m11;
		__m02 = theNextTransform.matrix.m02;
		__m12 = theNextTransform.matrix.m12;
		_m00 = matrix.m00;
		_m01 = matrix.m01;
		_m10 = matrix.m10;
		_m11 = matrix.m11;
		_m02 = matrix.m02;
		_m12 = matrix.m12;
		outTransform.matrix.m00 = ((_m00 * (1 - thePct)) + (__m00 * thePct));
		outTransform.matrix.m01 = ((_m01 * (1 - thePct)) + (__m01 * thePct));
		outTransform.matrix.m10 = ((_m10 * (1 - thePct)) + (__m10 * thePct));
		outTransform.matrix.m11 = ((_m11 * (1 - thePct)) + (__m11 * thePct));
		outTransform.matrix.m02 = ((_m02 * (1 - thePct)) + (__m02 * thePct));
		outTransform.matrix.m12 = ((_m12 * (1 - thePct)) + (__m12 * thePct));
		return (outTransform);
	}
	
}