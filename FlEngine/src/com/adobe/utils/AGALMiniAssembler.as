package com.adobe.utils
{
    import flash.display3D.*;
    import flash.utils.*;

    public class AGALMiniAssembler extends Object
    {
        private var _agalcode:ByteArray = null;
        private var _error:String = "";
        private var debugEnabled:Boolean = false;
        public var verbose:Boolean = false;
        private static const REGEXP_OUTER_SPACES:RegExp = /^\s+|\s+$/g;
        private static var initialized:Boolean = false;
        private static const OPMAP:Dictionary = new Dictionary();
        private static const REGMAP:Dictionary = new Dictionary();
        private static const SAMPLEMAP:Dictionary = new Dictionary();
        private static const MAX_OPCODES:int = 2048;
        private static const FRAGMENT:String = "fragment";
        private static const VERTEX:String = "vertex";
        private static const SAMPLER_TYPE_SHIFT:uint = 8;
        private static const SAMPLER_DIM_SHIFT:uint = 12;
        private static const SAMPLER_SPECIAL_SHIFT:uint = 16;
        private static const SAMPLER_REPEAT_SHIFT:uint = 20;
        private static const SAMPLER_MIPMAP_SHIFT:uint = 24;
        private static const SAMPLER_FILTER_SHIFT:uint = 28;
        private static const REG_WRITE:uint = 1;
        private static const REG_READ:uint = 2;
        private static const REG_FRAG:uint = 32;
        private static const REG_VERT:uint = 64;
        private static const OP_SCALAR:uint = 1;
        private static const OP_SPECIAL_TEX:uint = 8;
        private static const OP_SPECIAL_MATRIX:uint = 16;
        private static const OP_FRAG_ONLY:uint = 32;
        private static const OP_VERT_ONLY:uint = 64;
        private static const OP_NO_DEST:uint = 128;
        private static const OP_VERSION2:uint = 256;
        private static const OP_INCNEST:uint = 512;
        private static const OP_DECNEST:uint = 1024;
        private static const MOV:String = "mov";
        private static const ADD:String = "add";
        private static const SUB:String = "sub";
        private static const MUL:String = "mul";
        private static const DIV:String = "div";
        private static const RCP:String = "rcp";
        private static const MIN:String = "min";
        private static const MAX:String = "max";
        private static const FRC:String = "frc";
        private static const SQT:String = "sqt";
        private static const RSQ:String = "rsq";
        private static const POW:String = "pow";
        private static const LOG:String = "log";
        private static const EXP:String = "exp";
        private static const NRM:String = "nrm";
        private static const SIN:String = "sin";
        private static const COS:String = "cos";
        private static const CRS:String = "crs";
        private static const DP3:String = "dp3";
        private static const DP4:String = "dp4";
        private static const ABS:String = "abs";
        private static const NEG:String = "neg";
        private static const SAT:String = "sat";
        private static const M33:String = "m33";
        private static const M44:String = "m44";
        private static const M34:String = "m34";
        private static const DDX:String = "ddx";
        private static const DDY:String = "ddy";
        private static const IFE:String = "ife";
        private static const INE:String = "ine";
        private static const IFG:String = "ifg";
        private static const IFL:String = "ifl";
        private static const ELS:String = "els";
        private static const EIF:String = "eif";
        private static const TED:String = "ted";
        private static const KIL:String = "kil";
        private static const TEX:String = "tex";
        private static const SGE:String = "sge";
        private static const SLT:String = "slt";
        private static const SGN:String = "sgn";
        private static const SEQ:String = "seq";
        private static const SNE:String = "sne";
        private static const VA:String = "va";
        private static const VC:String = "vc";
        private static const VT:String = "vt";
        private static const VO:String = "vo";
        private static const VI:String = "vi";
        private static const FC:String = "fc";
        private static const FT:String = "ft";
        private static const FS:String = "fs";
        private static const FO:String = "fo";
        private static const FD:String = "fd";
        private static const D2:String = "2d";
        private static const D3:String = "3d";
        private static const CUBE:String = "cube";
        private static const MIPNEAREST:String = "mipnearest";
        private static const MIPLINEAR:String = "miplinear";
        private static const MIPNONE:String = "mipnone";
        private static const NOMIP:String = "nomip";
        private static const NEAREST:String = "nearest";
        private static const LINEAR:String = "linear";
        private static const CENTROID:String = "centroid";
        private static const SINGLE:String = "single";
        private static const IGNORESAMPLER:String = "ignoresampler";
        private static const REPEAT:String = "repeat";
        private static const WRAP:String = "wrap";
        private static const CLAMP:String = "clamp";
        private static const RGBA:String = "rgba";
        private static const DXT1:String = "dxt1";
        private static const DXT5:String = "dxt5";
        private static const VIDEO:String = "video";

        public function AGALMiniAssembler(param1:Boolean = false) : void
        {
            debugEnabled = param1;
            if (!initialized)
            {
                init();
            }
            return;
        }

        public function get error() : String
        {
            return _error;
        }

        public function get agalcode() : ByteArray
        {
            return _agalcode;
        }

        public function assemble2(param1:Context3D, param2:uint, param3:String, param4:String) : Program3D
        {
            var _loc_6:* = assemble("vertex", param3, param2);
            var _loc_7:* = assemble("fragment", param4, param2);
            var _loc_5:* = param1.createProgram();
            _loc_5.upload(_loc_6, _loc_7);
            return _loc_5;
        }

        public function assemble(param1:String, param2:String, param3:uint = 1, param4:Boolean = false) : ByteArray
        {
            var _loc_42:* = 0;
            var _loc_30:* = null;
            var _loc_22:* = 0;
            var _loc_28:* = 0;
            var _loc_5:* = null;
            var _loc_34:* = null;
            var _loc_10:* = null;
            var _loc_17:* = null;
            var _loc_43:* = false;
            var _loc_39:* = 0;
            var _loc_29:* = 0;
            var _loc_40:* = 0;
            var _loc_35:* = false;
            var _loc_16:* = null;
            var _loc_27:* = null;
            var _loc_9:* = null;
            var _loc_15:* = null;
            var _loc_19:* = 0;
            var _loc_48:* = 0;
            var _loc_49:* = null;
            var _loc_33:* = false;
            var _loc_7:* = false;
            var _loc_24:* = 0;
            var _loc_20:* = 0;
            var _loc_8:* = 0;
            var _loc_18:* = 0;
            var _loc_31:* = 0;
            var _loc_41:* = 0;
            var _loc_11:* = null;
            var _loc_26:* = null;
            var _loc_6:* = null;
            var _loc_38:* = null;
            var _loc_45:* = 0;
            var _loc_13:* = 0;
            var _loc_12:* = NaN;
            var _loc_44:* = null;
            var _loc_36:* = null;
            var _loc_37:* = 0;
            var _loc_14:* = 0;
            var _loc_47:* = null;
            var _loc_23:* = getTimer();
            _agalcode = new ByteArray();
            _error = "";
            var _loc_46:* = false;
            if (param1 == "fragment")
            {
                _loc_46 = true;
            }
            else if (param1 != "vertex")
            {
                _error = "ERROR: mode needs to be \"fragment\" or \"vertex\" but is \"" + param1 + "\".";
            }
            agalcode.endian = "littleEndian";
            agalcode.writeByte(160);
            agalcode.writeUnsignedInt(param3);
            agalcode.writeByte(161);
            agalcode.writeByte(_loc_46 ? (1) : (0));
            initregmap(param3, param4);
            var _loc_25:* = param2.replace(/[\f\n\r\v]+/g, "\n").split("\n");
            var _loc_21:* = 0;
            var _loc_32:* = _loc_25.length;
            _loc_42 = 0;
            while (_loc_42 < _loc_32 && _error == "")
            {
                
                _loc_30 = new String(_loc_25[_loc_42]);
                _loc_30 = _loc_30.replace(REGEXP_OUTER_SPACES, "");
                _loc_22 = _loc_30.search("//");
                if (_loc_22 != -1)
                {
                    _loc_30 = _loc_30.slice(0, _loc_22);
                }
                _loc_28 = _loc_30.search(/<.*>/g);
                if (_loc_28 != -1)
                {
                    _loc_5 = _loc_30.slice(_loc_28).match(/([\w\.\-\+]+)/gi);
                    _loc_30 = _loc_30.slice(0, _loc_28);
                }
                _loc_34 = _loc_30.match(/^\w{3}/gi);
                if (!_loc_34)
                {
                    if (_loc_30.length >= 3)
                    {
                        trace("warning: bad line " + _loc_42 + ": " + _loc_25[_loc_42]);
                    }
                }
                else
                {
                    _loc_10 = OPMAP[_loc_34[0]];
                    if (debugEnabled)
                    {
                        trace(_loc_10);
                    }
                    if (_loc_10 == null)
                    {
                        if (_loc_30.length >= 3)
                        {
                            trace("warning: bad line " + _loc_42 + ": " + _loc_25[_loc_42]);
                        }
                    }
                    else
                    {
                        _loc_30 = _loc_30.slice(_loc_30.search(_loc_10.name) + _loc_10.name.length);
                        if (_loc_10.flags & 256 && param3 < 2)
                        {
                            _error = "error: opcode requires version 2.";
                            break;
                        }
                        if (_loc_10.flags & 64 && _loc_46)
                        {
                            _error = "error: opcode is only allowed in vertex programs.";
                            break;
                        }
                        if (_loc_10.flags & 32 && !_loc_46)
                        {
                            _error = "error: opcode is only allowed in fragment programs.";
                            break;
                        }
                        if (verbose)
                        {
                            trace("emit opcode=" + _loc_10);
                        }
                        agalcode.writeUnsignedInt(_loc_10.emitCode);
                        _loc_21++;
                        if (_loc_21 > 2048)
                        {
                            _error = "error: too many opcodes. maximum is 2048.";
                            break;
                        }
                        _loc_17 = _loc_30.match(/vc\[([vof][acostdip]?)(\d*)?(\.[xyzw](\+\d{1,3})?)?\](\.[xyzw]{1,4})?|([vof][acostdip]?)(\d*)?(\.[xyzw]{1,4})?/gi);
                        if (!_loc_17 || _loc_17.length != _loc_10.numRegister)
                        {
                            _error = "error: wrong number of operands. found " + _loc_17.length + " but expected " + _loc_10.numRegister + ".";
                            break;
                        }
                        _loc_43 = false;
                        _loc_39 = 160;
                        _loc_29 = _loc_17.length;
                        _loc_40 = 0;
                        while (_loc_40 < _loc_29)
                        {
                            
                            _loc_35 = false;
                            _loc_16 = _loc_17[_loc_40].match(/\[.*\]/gi);
                            if (_loc_16 && _loc_16.length > 0)
                            {
                                _loc_17[_loc_40] = _loc_17[_loc_40].replace(_loc_16[0], "0");
                                if (verbose)
                                {
                                    trace("IS REL");
                                }
                                _loc_35 = true;
                            }
                            _loc_27 = _loc_17[_loc_40].match(/^\b[A-Za-z]{1,2}/gi);
                            if (!_loc_27)
                            {
                                _error = "error: could not parse operand " + _loc_40 + " (" + _loc_17[_loc_40] + ").";
                                _loc_43 = true;
                                break;
                            }
                            _loc_9 = REGMAP[_loc_27[0]];
                            if (debugEnabled)
                            {
                                trace(_loc_9);
                            }
                            if (_loc_9 == null)
                            {
                                _error = "error: could not find register name for operand " + _loc_40 + " (" + _loc_17[_loc_40] + ").";
                                _loc_43 = true;
                                break;
                            }
                            if (_loc_46)
                            {
                                if (!(_loc_9.flags & 32))
                                {
                                    _error = "error: register operand " + _loc_40 + " (" + _loc_17[_loc_40] + ") only allowed in vertex programs.";
                                    _loc_43 = true;
                                    break;
                                }
                                if (_loc_35)
                                {
                                    _error = "error: register operand " + _loc_40 + " (" + _loc_17[_loc_40] + ") relative adressing not allowed in fragment programs.";
                                    _loc_43 = true;
                                    break;
                                }
                            }
                            else if (!(_loc_9.flags & 64))
                            {
                                _error = "error: register operand " + _loc_40 + " (" + _loc_17[_loc_40] + ") only allowed in fragment programs.";
                                _loc_43 = true;
                                break;
                            }
                            _loc_17[_loc_40] = _loc_17[_loc_40].slice(_loc_17[_loc_40].search(_loc_9.name) + _loc_9.name.length);
                            _loc_15 = _loc_35 ? (_loc_16[0].match(/\d+/)) : (_loc_17[_loc_40].match(/\d+/));
                            _loc_19 = 0;
                            if (_loc_15)
                            {
                                _loc_19 = _loc_15[0];
                            }
                            if (_loc_9.range < _loc_19)
                            {
                                _error = "error: register operand " + _loc_40 + " (" + _loc_17[_loc_40] + ") index exceeds limit of " + (_loc_9.range + 1) + ".";
                                _loc_43 = true;
                                break;
                            }
                            _loc_48 = 0;
                            _loc_49 = _loc_17[_loc_40].match(/(\.[xyzw]{1,4})/);
                            _loc_33 = _loc_40 == 0 && !(_loc_10.flags & 128);
                            _loc_7 = _loc_40 == 2 && _loc_10.flags & 8;
                            _loc_24 = 0;
                            _loc_20 = 0;
                            _loc_8 = 0;
                            if (_loc_33 && _loc_35)
                            {
                                _error = "error: relative can not be destination";
                                _loc_43 = true;
                                break;
                            }
                            if (_loc_49)
                            {
                                _loc_48 = 0;
                                _loc_31 = _loc_49[0].length;
                                _loc_41 = 1;
                                while (_loc_41 < _loc_31)
                                {
                                    
                                    _loc_18 = _loc_49[0].charCodeAt(_loc_41) - "x".charCodeAt(0);
                                    if (_loc_18 > 2)
                                    {
                                        _loc_18 = 3;
                                    }
                                    if (_loc_33)
                                    {
                                        _loc_48 = _loc_48 | 1 << _loc_18;
                                    }
                                    else
                                    {
                                        _loc_48 = _loc_48 | _loc_18 << ((_loc_41 - 1) << 1);
                                    }
                                    _loc_41++;
                                }
                                if (!_loc_33)
                                {
                                    while (_loc_41 <= 4)
                                    {
                                        
                                        _loc_48 = _loc_48 | _loc_18 << ((_loc_41 - 1) << 1);
                                        _loc_41++;
                                    }
                                }
                            }
                            else
                            {
                                _loc_48 = _loc_33 ? (15) : (228);
                            }
                            if (_loc_35)
                            {
                                _loc_11 = _loc_16[0].match(/[A-Za-z]{1,2}/gi);
                                _loc_26 = REGMAP[_loc_11[0]];
                                if (_loc_26 == null)
                                {
                                    _error = "error: bad index register";
                                    _loc_43 = true;
                                    break;
                                }
                                _loc_24 = _loc_26.emitCode;
                                _loc_6 = _loc_16[0].match(/(\.[xyzw]{1,1})/);
                                if (_loc_6.length == 0)
                                {
                                    _error = "error: bad index register select";
                                    _loc_43 = true;
                                    break;
                                }
                                _loc_20 = _loc_6[0].charCodeAt(1) - "x".charCodeAt(0);
                                if (_loc_20 > 2)
                                {
                                    _loc_20 = 3;
                                }
                                _loc_38 = _loc_16[0].match(/\+\d{1,3}/gi);
                                if (_loc_38.length > 0)
                                {
                                    _loc_8 = _loc_38[0];
                                }
                                if (_loc_8 < 0 || _loc_8 > 255)
                                {
                                    _error = "error: index offset " + _loc_8 + " out of bounds. [0..255]";
                                    _loc_43 = true;
                                    break;
                                }
                                if (verbose)
                                {
                                    trace("RELATIVE: type=" + _loc_24 + "==" + _loc_11[0] + " sel=" + _loc_20 + "==" + _loc_6[0] + " idx=" + _loc_19 + " offset=" + _loc_8);
                                }
                            }
                            if (verbose)
                            {
                                trace("  emit argcode=" + _loc_9 + "[" + _loc_19 + "][" + _loc_48 + "]");
                            }
                            if (_loc_33)
                            {
                                agalcode.writeShort(_loc_19);
                                agalcode.writeByte(_loc_48);
                                agalcode.writeByte(_loc_9.emitCode);
                                _loc_39 = _loc_39 - 32;
                            }
                            else if (_loc_7)
                            {
                                if (verbose)
                                {
                                    trace("  emit sampler");
                                }
                                _loc_45 = 5;
                                _loc_13 = _loc_5 == null ? (0) : (_loc_5.length);
                                _loc_12 = 0;
                                _loc_41 = 0;
                                while (_loc_41 < _loc_13)
                                {
                                    
                                    if (verbose)
                                    {
                                        trace("    opt: " + _loc_5[_loc_41]);
                                    }
                                    _loc_44 = SAMPLEMAP[_loc_5[_loc_41]];
                                    if (_loc_44 == null)
                                    {
                                        _loc_12 = _loc_5[_loc_41];
                                        if (verbose)
                                        {
                                            trace("    bias: " + _loc_12);
                                        }
                                    }
                                    else
                                    {
                                        if (_loc_44.flag != 16)
                                        {
                                            _loc_45 = _loc_45 & ~(15 << _loc_44.flag);
                                        }
                                        _loc_45 = _loc_45 | _loc_44.mask << _loc_44.flag;
                                    }
                                    _loc_41++;
                                }
                                agalcode.writeShort(_loc_19);
                                agalcode.writeByte(_loc_12 * 8);
                                agalcode.writeByte(0);
                                agalcode.writeUnsignedInt(_loc_45);
                                if (verbose)
                                {
                                    trace("    bits: " + (_loc_45 - 5));
                                }
                                _loc_39 = _loc_39 - 64;
                            }
                            else
                            {
                                if (_loc_40 == 0)
                                {
                                    agalcode.writeUnsignedInt(0);
                                    _loc_39 = _loc_39 - 32;
                                }
                                agalcode.writeShort(_loc_19);
                                agalcode.writeByte(_loc_8);
                                agalcode.writeByte(_loc_48);
                                agalcode.writeByte(_loc_9.emitCode);
                                agalcode.writeByte(_loc_24);
                                agalcode.writeShort(_loc_35 ? (_loc_20 | 32768) : (0));
                                _loc_39 = _loc_39 - 64;
                            }
                            _loc_40++;
                        }
                        _loc_40 = 0;
                        while (_loc_40 < _loc_39)
                        {
                            
                            agalcode.writeByte(0);
                            _loc_40 = _loc_40 + 8;
                        }
                    }
                }
                _loc_42++;
            }
            if (_error != "")
            {
                _error = _error + ("\n  at line " + _loc_42 + " " + _loc_25[_loc_42]);
                agalcode.length = 0;
                trace(_error);
            }
            if (debugEnabled)
            {
                _loc_36 = "generated bytecode:";
                _loc_37 = agalcode.length;
                _loc_14 = 0;
                while (_loc_14 < _loc_37)
                {
                    
                    if (!(_loc_14 % 16))
                    {
                        _loc_36 = _loc_36 + "\n";
                    }
                    if (!(_loc_14 % 4))
                    {
                        _loc_36 = _loc_36 + " ";
                    }
                    _loc_47 = agalcode[_loc_14].toString(16);
                    if (_loc_47.length < 2)
                    {
                        _loc_47 = "0" + _loc_47;
                    }
                    _loc_36 = _loc_36 + _loc_47;
                    _loc_14 = _loc_14 + 1;
                }
                trace(_loc_36);
            }
            if (verbose)
            {
                trace("AGALMiniAssembler.assemble time: " + (getTimer() - _loc_23) / 1000 + "s");
            }
            return agalcode;
        }

        private function initregmap(param1:uint, param2:Boolean) : void
        {
            REGMAP["va"] = new Register("va", "vertex attribute", 0, param2 ? (1024) : (7), 64 | 2);
            REGMAP["vc"] = new Register("vc", "vertex constant", 1, param2 ? (1024) : (param1 == 1 ? (127) : (250)), 64 | 2);
            REGMAP["vt"] = new Register("vt", "vertex temporary", 2, param2 ? (1024) : (param1 == 1 ? (7) : (27)), 64 | 1 | 2);
            REGMAP["vo"] = new Register("vo", "vertex output", 3, param2 ? (1024) : (0), 64 | 1);
            REGMAP["vi"] = new Register("vi", "varying", 4, param2 ? (1024) : (param1 == 1 ? (7) : (11)), 64 | 32 | 2 | 1);
            REGMAP["fc"] = new Register("fc", "fragment constant", 1, param2 ? (1024) : (param1 == 1 ? (27) : (63)), 32 | 2);
            REGMAP["ft"] = new Register("ft", "fragment temporary", 2, param2 ? (1024) : (param1 == 1 ? (7) : (27)), 32 | 1 | 2);
            REGMAP["fs"] = new Register("fs", "texture sampler", 5, param2 ? (1024) : (7), 32 | 2);
            REGMAP["fo"] = new Register("fo", "fragment output", 3, param2 ? (1024) : (param1 == 1 ? (0) : (3)), 32 | 1);
            REGMAP["fd"] = new Register("fd", "fragment depth output", 6, param2 ? (1024) : (param1 == 1 ? (-1) : (0)), 32 | 1);
            REGMAP["op"] = REGMAP["vo"];
            REGMAP["i"] = REGMAP["vi"];
            REGMAP["v"] = REGMAP["vi"];
            REGMAP["oc"] = REGMAP["fo"];
            REGMAP["od"] = REGMAP["fd"];
            REGMAP["fi"] = REGMAP["vi"];
            return;
        }

        private static function init() : void
        {
            initialized = true;
            OPMAP["mov"] = new OpCode("mov", 2, 0, 0);
            OPMAP["add"] = new OpCode("add", 3, 1, 0);
            OPMAP["sub"] = new OpCode("sub", 3, 2, 0);
            OPMAP["mul"] = new OpCode("mul", 3, 3, 0);
            OPMAP["div"] = new OpCode("div", 3, 4, 0);
            OPMAP["rcp"] = new OpCode("rcp", 2, 5, 0);
            OPMAP["min"] = new OpCode("min", 3, 6, 0);
            OPMAP["max"] = new OpCode("max", 3, 7, 0);
            OPMAP["frc"] = new OpCode("frc", 2, 8, 0);
            OPMAP["sqt"] = new OpCode("sqt", 2, 9, 0);
            OPMAP["rsq"] = new OpCode("rsq", 2, 10, 0);
            OPMAP["pow"] = new OpCode("pow", 3, 11, 0);
            OPMAP["log"] = new OpCode("log", 2, 12, 0);
            OPMAP["exp"] = new OpCode("exp", 2, 13, 0);
            OPMAP["nrm"] = new OpCode("nrm", 2, 14, 0);
            OPMAP["sin"] = new OpCode("sin", 2, 15, 0);
            OPMAP["cos"] = new OpCode("cos", 2, 16, 0);
            OPMAP["crs"] = new OpCode("crs", 3, 17, 0);
            OPMAP["dp3"] = new OpCode("dp3", 3, 18, 0);
            OPMAP["dp4"] = new OpCode("dp4", 3, 19, 0);
            OPMAP["abs"] = new OpCode("abs", 2, 20, 0);
            OPMAP["neg"] = new OpCode("neg", 2, 21, 0);
            OPMAP["sat"] = new OpCode("sat", 2, 22, 0);
            OPMAP["m33"] = new OpCode("m33", 3, 23, 16);
            OPMAP["m44"] = new OpCode("m44", 3, 24, 16);
            OPMAP["m34"] = new OpCode("m34", 3, 25, 16);
            OPMAP["ddx"] = new OpCode("ddx", 2, 26, 256 | 32);
            OPMAP["ddy"] = new OpCode("ddy", 2, 27, 256 | 32);
            OPMAP["ife"] = new OpCode("ife", 2, 28, 128 | 256 | 512 | 1);
            OPMAP["ine"] = new OpCode("ine", 2, 29, 128 | 256 | 512 | 1);
            OPMAP["ifg"] = new OpCode("ifg", 2, 30, 128 | 256 | 512 | 1);
            OPMAP["ifl"] = new OpCode("ifl", 2, 31, 128 | 256 | 512 | 1);
            OPMAP["els"] = new OpCode("els", 0, 32, 128 | 256 | 512 | 1024 | 1);
            OPMAP["eif"] = new OpCode("eif", 0, 33, 128 | 256 | 1024 | 1);
            OPMAP["ted"] = new OpCode("ted", 3, 38, 32 | 8 | 256);
            OPMAP["kil"] = new OpCode("kil", 1, 39, 128 | 32);
            OPMAP["tex"] = new OpCode("tex", 3, 40, 32 | 8);
            OPMAP["sge"] = new OpCode("sge", 3, 41, 0);
            OPMAP["slt"] = new OpCode("slt", 3, 42, 0);
            OPMAP["sgn"] = new OpCode("sgn", 2, 43, 0);
            OPMAP["seq"] = new OpCode("seq", 3, 44, 0);
            OPMAP["sne"] = new OpCode("sne", 3, 45, 0);
            SAMPLEMAP["rgba"] = new Sampler("rgba", 8, 0);
            SAMPLEMAP["dxt1"] = new Sampler("dxt1", 8, 1);
            SAMPLEMAP["dxt5"] = new Sampler("dxt5", 8, 2);
            SAMPLEMAP["video"] = new Sampler("video", 8, 3);
            SAMPLEMAP["2d"] = new Sampler("2d", 12, 0);
            SAMPLEMAP["3d"] = new Sampler("3d", 12, 2);
            SAMPLEMAP["cube"] = new Sampler("cube", 12, 1);
            SAMPLEMAP["mipnearest"] = new Sampler("mipnearest", 24, 1);
            SAMPLEMAP["miplinear"] = new Sampler("miplinear", 24, 2);
            SAMPLEMAP["mipnone"] = new Sampler("mipnone", 24, 0);
            SAMPLEMAP["nomip"] = new Sampler("nomip", 24, 0);
            SAMPLEMAP["nearest"] = new Sampler("nearest", 28, 0);
            SAMPLEMAP["linear"] = new Sampler("linear", 28, 1);
            SAMPLEMAP["centroid"] = new Sampler("centroid", 16, 1);
            SAMPLEMAP["single"] = new Sampler("single", 16, 2);
            SAMPLEMAP["ignoresampler"] = new Sampler("ignoresampler", 16, 4);
            SAMPLEMAP["repeat"] = new Sampler("repeat", 20, 1);
            SAMPLEMAP["wrap"] = new Sampler("wrap", 20, 1);
            SAMPLEMAP["clamp"] = new Sampler("clamp", 20, 0);
            return;
        }

    }
}

import flash.display3D.*;

import flash.utils.*;

class OpCode extends Object
{
    private var _emitCode:uint;
    private var _flags:uint;
    private var _name:String;
    private var _numRegister:uint;

    function OpCode(param1:String, param2:uint, param3:uint, param4:uint)
    {
        _name = param1;
        _numRegister = param2;
        _emitCode = param3;
        _flags = param4;
        return;
    }

    public function get emitCode() : uint
    {
        return _emitCode;
    }

    public function get flags() : uint
    {
        return _flags;
    }

    public function get name() : String
    {
        return _name;
    }

    public function get numRegister() : uint
    {
        return _numRegister;
    }

    public function toString() : String
    {
        return "[OpCode name=\"" + _name + "\", numRegister=" + _numRegister + ", emitCode=" + _emitCode + ", flags=" + _flags + "]";
    }

}


import flash.display3D.*;

import flash.utils.*;

class Register extends Object
{
    private var _emitCode:uint;
    private var _name:String;
    private var _longName:String;
    private var _flags:uint;
    private var _range:uint;

    function Register(param1:String, param2:String, param3:uint, param4:uint, param5:uint)
    {
        _name = param1;
        _longName = param2;
        _emitCode = param3;
        _range = param4;
        _flags = param5;
        return;
    }

    public function get emitCode() : uint
    {
        return _emitCode;
    }

    public function get longName() : String
    {
        return _longName;
    }

    public function get name() : String
    {
        return _name;
    }

    public function get flags() : uint
    {
        return _flags;
    }

    public function get range() : uint
    {
        return _range;
    }

    public function toString() : String
    {
        return "[Register name=\"" + _name + "\", longName=\"" + _longName + "\", emitCode=" + _emitCode + ", range=" + _range + ", flags=" + _flags + "]";
    }

}


import flash.display3D.*;

import flash.utils.*;

class Sampler extends Object
{
    private var _flag:uint;
    private var _mask:uint;
    private var _name:String;

    function Sampler(param1:String, param2:uint, param3:uint)
    {
        _name = param1;
        _flag = param2;
        _mask = param3;
        return;
    }

    public function get flag() : uint
    {
        return _flag;
    }

    public function get mask() : uint
    {
        return _mask;
    }

    public function get name() : String
    {
        return _name;
    }

    public function toString() : String
    {
        return "[Sampler name=\"" + _name + "\", flag=\"" + _flag + "\", mask=" + mask + "]";
    }

}

