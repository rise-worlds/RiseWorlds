package com.genome2d.components.renderables.jointanim;
import flash.geom.Matrix3D;
import flash.Vector;

/**
 * ...
 * @author Rise
 */
class JAMatrix3
{
	private static var _helpMatrixArg1:JAMatrix3 = new JAMatrix3();
	private static var _helpMatrixArg2:JAMatrix3 = new JAMatrix3();
	private static var _helpMatrix3DVector1:Array<Float> = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1];
	private static var _helpMatrix3DVector2:Array<Float> = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1];
	private static var _helpMatrix3DArg1:Matrix3D = new Matrix3D();
	private static var _helpMatrix3DArg2:Matrix3D = new Matrix3D();

	public var m00:Float;
	public var m01:Float;
	public var m02:Float;
	public var m10:Float;
	public var m11:Float;
	public var m12:Float;

	public function new() 
	{
		LoadIdentity();
	}
	
	public static function MulJAMatrix3(d:JAMatrix3, c:JAMatrix3, out:JAMatrix3):JAMatrix3
	{
		_helpMatrixArg1.m00 = d.m00;
		_helpMatrixArg1.m01 = d.m01;
		_helpMatrixArg1.m02 = d.m02;
		_helpMatrixArg1.m10 = d.m10;
		_helpMatrixArg1.m11 = d.m11;
		_helpMatrixArg1.m12 = d.m12;
		_helpMatrixArg2.m00 = c.m00;
		_helpMatrixArg2.m01 = c.m01;
		_helpMatrixArg2.m02 = c.m02;
		_helpMatrixArg2.m10 = c.m10;
		_helpMatrixArg2.m11 = c.m11;
		_helpMatrixArg2.m12 = c.m12;
		out.m00 = ((_helpMatrixArg1.m00 * _helpMatrixArg2.m00) + (_helpMatrixArg1.m01 * _helpMatrixArg2.m10));
		out.m10 = ((_helpMatrixArg1.m10 * _helpMatrixArg2.m00) + (_helpMatrixArg1.m11 * _helpMatrixArg2.m10));
		out.m01 = ((_helpMatrixArg1.m00 * _helpMatrixArg2.m01) + (_helpMatrixArg1.m01 * _helpMatrixArg2.m11));
		out.m11 = ((_helpMatrixArg1.m10 * _helpMatrixArg2.m01) + (_helpMatrixArg1.m11 * _helpMatrixArg2.m11));
		out.m02 = (((_helpMatrixArg1.m00 * _helpMatrixArg2.m02) + (_helpMatrixArg1.m01 * _helpMatrixArg2.m12)) + _helpMatrixArg1.m02);
		out.m12 = (((_helpMatrixArg1.m10 * _helpMatrixArg2.m02) + (_helpMatrixArg1.m11 * _helpMatrixArg2.m12)) + _helpMatrixArg1.m12);
		return (out);
	}

	public static function MulJAMatrix3_M3D(c:Matrix3D, d:JATransform2D, out:JATransform2D):JATransform2D
	{
		_helpMatrix3DVector1[0] = d.m00;
		_helpMatrix3DVector1[1] = d.m10;
		_helpMatrix3DVector1[4] = d.m01;
		_helpMatrix3DVector1[5] = d.m11;
		_helpMatrix3DVector1[12] = d.m02;
		_helpMatrix3DVector1[13] = d.m12;
		_helpMatrix3DArg1.copyRawDataFrom(Vector.ofArray(_helpMatrix3DVector1));
		_helpMatrix3DArg1.prepend(c);
		_helpMatrix3DArg1.copyRawDataTo(Vector.ofArray(_helpMatrix3DVector1));
		out.m00 = _helpMatrix3DVector1[0];
		out.m10 = _helpMatrix3DVector1[1];
		out.m01 = _helpMatrix3DVector1[4];
		out.m11 = _helpMatrix3DVector1[5];
		out.m02 = _helpMatrix3DVector1[12];
		out.m12 = _helpMatrix3DVector1[13];
		return (out);
	}

	public static function MulJAMatrix3_2D(d:JAMatrix3, c:JATransform2D, out:JATransform2D):JATransform2D
	{
		_helpMatrixArg1.m00 = d.m00;
		_helpMatrixArg1.m01 = d.m01;
		_helpMatrixArg1.m02 = d.m02;
		_helpMatrixArg1.m10 = d.m10;
		_helpMatrixArg1.m11 = d.m11;
		_helpMatrixArg1.m12 = d.m12;
		_helpMatrixArg2.m00 = c.m00;
		_helpMatrixArg2.m01 = c.m01;
		_helpMatrixArg2.m02 = c.m02;
		_helpMatrixArg2.m10 = c.m10;
		_helpMatrixArg2.m11 = c.m11;
		_helpMatrixArg2.m12 = c.m12;
		out.m00 = ((_helpMatrixArg1.m00 * _helpMatrixArg2.m00) + (_helpMatrixArg1.m01 * _helpMatrixArg2.m10));
		out.m10 = ((_helpMatrixArg1.m10 * _helpMatrixArg2.m00) + (_helpMatrixArg1.m11 * _helpMatrixArg2.m10));
		out.m01 = ((_helpMatrixArg1.m00 * _helpMatrixArg2.m01) + (_helpMatrixArg1.m01 * _helpMatrixArg2.m11));
		out.m11 = ((_helpMatrixArg1.m10 * _helpMatrixArg2.m01) + (_helpMatrixArg1.m11 * _helpMatrixArg2.m11));
		out.m02 = (((_helpMatrixArg1.m00 * _helpMatrixArg2.m02) + (_helpMatrixArg1.m01 * _helpMatrixArg2.m12)) + _helpMatrixArg1.m02);
		out.m12 = (((_helpMatrixArg1.m10 * _helpMatrixArg2.m02) + (_helpMatrixArg1.m11 * _helpMatrixArg2.m12)) + _helpMatrixArg1.m12);
		return (out);
	}

	public static function MulJAVec2X(m:JAMatrix3, x:Float, y:Float):Float
	{
		return ((((m.m00 * x) + (m.m01 * y)) + m.m02));
	}

	public static function MulJAVec2Y(m:JAMatrix3, x:Float, y:Float):Float
	{
		return ((((m.m10 * x) + (m.m11 * y)) + m.m12));
	}

	public static function cloneTo(sourceMatrix:JAMatrix3, newMatrix:JAMatrix3):Void
	{
		sourceMatrix.m00 = newMatrix.m00;
		sourceMatrix.m01 = newMatrix.m01;
		sourceMatrix.m02 = newMatrix.m02;
		sourceMatrix.m10 = newMatrix.m10;
		sourceMatrix.m11 = newMatrix.m11;
		sourceMatrix.m12 = newMatrix.m12;
	}


	public function clone(from:JAMatrix3):Void
	{
		this.m00 = from.m00;
		this.m01 = from.m01;
		this.m02 = from.m02;
		this.m10 = from.m10;
		this.m11 = from.m11;
		this.m12 = from.m12;
	}

	public function ZeroMatrix():Void
	{
		m00 = 0;
		m01 = 0;
		m02 = 0;
		m10 = 0;
		m11 = 0;
		m12 = 0;
	}

	public function LoadIdentity():Void
	{
		m00 = 1;
		m01 = 0;
		m02 = 0;
		m10 = 0;
		m11 = 1;
		m12 = 0;
	}
}