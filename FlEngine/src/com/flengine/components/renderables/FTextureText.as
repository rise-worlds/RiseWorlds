package com.flengine.components.renderables
{
    import com.flengine.core.*;
    import com.flengine.error.*;
    import com.flengine.textures.*;
    import flash.events.*;
    import flash.geom.*;

    public class FTextureText extends FRenderable
    {
        protected var _cTextureAtlas:FTextureAtlas;
        protected var _bInvalidate:Boolean = false;
        protected var _nTracking:Number = 0;
        protected var _nLineSpace:Number = 0;
        protected var _iAlign:int;
        public var maxWidth:Number = 0;
        protected var _sText:String = "";
        protected var _nWidth:Number = 0;
        protected var _nHeight:Number = 0;

        public function FTextureText(param1:FNode)
        {
            _iAlign = FTextureTextAlignType.TOP_LEFT;
            super(param1);
            return;
        }

        public function get tracking() : Number
        {
            return _nTracking;
        }

        public function set tracking(param1:Number) : void
        {
            _nTracking = param1;
            _bInvalidate = true;
            return;
        }

        public function get lineSpace() : Number
        {
            return _nLineSpace;
        }

        public function set lineSpace(param1:Number) : void
        {
            _nLineSpace = param1;
            _bInvalidate = true;
            return;
        }

        public function get align() : int
        {
            return _iAlign;
        }

        public function set align(param1:int) : void
        {
            _iAlign = param1;
            _bInvalidate = true;
            return;
        }

        public function get textureAtlasId() : String
        {
            if (_cTextureAtlas)
            {
                return _cTextureAtlas.id;
            }
            return "";
        }

        public function set textureAtlasId(param1:String) : void
        {
            setTextureAtlas(FTextureAtlas.getTextureAtlasById(param1));
            return;
        }

        public function setTextureAtlas(param1:FTextureAtlas) : void
        {
            _cTextureAtlas = param1;
            _bInvalidate = true;
            return;
        }

        public function get text() : String
        {
            return _sText;
        }

        public function set text(param1:String) : void
        {
            _sText = param1;
            _bInvalidate = true;
            return;
        }

        public function get width() : Number
        {
            if (_bInvalidate)
            {
                invalidateText();
            }
            return _nWidth * cNode.cTransform.nWorldScaleX;
        }

        public function get height() : Number
        {
            if (_bInvalidate)
            {
                invalidateText();
            }
            return _nHeight * cNode.cTransform.nWorldScaleY;
        }

        override public function update(param1:Number, param2:Boolean, param3:Boolean) : void
        {
            if (!_bInvalidate)
            {
                return;
            }
            invalidateText();
            return;
        }

        protected function invalidateText() : void
        {
            var _loc_6:* = null;
            var _loc_3:* = null;
            var _loc_7:* = 0;
            var _loc_5:* = null;
            if (_cTextureAtlas == null)
            {
                return;
            }
            _nWidth = 0;
            var _loc_4:* = 0;
            var _loc_2:* = 0;
            var _loc_1:* = cNode.firstChild;
            _loc_7 = 0;
            while (_loc_7 < _sText.length)
            {
                
                if (_sText.charCodeAt(_loc_7) == 10)
                {
                    _nWidth = _loc_4 > _nWidth ? (_loc_4) : (_nWidth);
                    _loc_4 = 0;
                    _loc_2 = _loc_2 + (_loc_3.height + _nLineSpace);
                }
                else
                {
                    _loc_3 = _cTextureAtlas.getTexture(_sText.charCodeAt(_loc_7));
                    if (_loc_3 == null)
                    {
                        throw new FError("Texture for character " + _sText.charAt(_loc_7) + " with code " + _sText.charCodeAt(_loc_7) + " not found!");
                    }
                    if (_loc_1 == null)
                    {
                        _loc_6 = FNodeFactory.createNodeWithComponent(FSprite) as FSprite;
                        _loc_1 = _loc_6.cNode;
                        cNode.addChild(_loc_1);
                    }
                    else
                    {
                        _loc_6 = _loc_1.getComponent(FSprite) as FSprite;
                    }
                    _loc_6.node.cameraGroup = node.cameraGroup;
                    _loc_6.setTexture(_loc_3);
                    if (maxWidth > 0 && _loc_4 + _loc_3.width > maxWidth)
                    {
                        _nWidth = _loc_4 > _nWidth ? (_loc_4) : (_nWidth);
                        _loc_4 = 0;
                        _loc_2 = _loc_2 + (_loc_3.height + _nLineSpace);
                    }
                    _loc_4 = _loc_4 + _loc_3.width / 2;
                    _loc_1.cTransform.x = _loc_4;
                    _loc_1.cTransform.y = _loc_2 + _loc_3.height / 2;
                    _loc_4 = _loc_4 + (_loc_3.width / 2 + _nTracking);
                    _loc_1 = _loc_1.next;
                }
                _loc_7++;
            }
            _nWidth = _loc_4 > _nWidth ? (_loc_4) : (_nWidth);
            _nHeight = _loc_2 + (_loc_3 != null ? (_loc_3.height) : (0));
            while (_loc_1)
            {
                
                _loc_5 = _loc_1.next;
                cNode.removeChild(_loc_1);
                _loc_1 = _loc_5;
            }
            invalidateAlign();
            _bInvalidate = false;
            return;
        }

        private function invalidateAlign() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = _iAlign;
            while (FTextureTextAlignType.MIDDLE_CENTER === _loc_2)
            {
                
                _loc_1 = cNode.firstChild;
                while (_loc_1)
                {
                    
                    _loc_1.transform.x = _loc_1.transform.x - _nWidth / 2;
                    _loc_1.transform.y = _loc_1.transform.y - _nHeight / 2;
                    _loc_1 = _loc_1.next;
                }
                do
                {
                    
                    _loc_1 = cNode.firstChild;
                    while (_loc_1)
                    {
                        
                        _loc_1.transform.x = _loc_1.transform.x - _nWidth;
                        _loc_1 = _loc_1.next;
                    }
                    do
                    {
                        
                        do
                        {
                            
                            _loc_1 = cNode.firstChild;
                            while (_loc_1)
                            {
                                
                                _loc_1.transform.x = _loc_1.transform.x - _nWidth;
                                _loc_1.transform.y = _loc_1.transform.y - _nHeight / 2;
                                _loc_1 = _loc_1.next;
                            }
                            do
                            {
                                
                                _loc_1 = cNode.firstChild;
                                while (_loc_1)
                                {
                                    
                                    _loc_1.transform.y = _loc_1.transform.y - _nHeight / 2;
                                    _loc_1 = _loc_1.next;
                                }
                                break;
                            }
                        }while (FTextureTextAlignType.TOP_RIGHT === _loc_2)
                    }while (FTextureTextAlignType.TOP_LEFT === _loc_2)
                }while (FTextureTextAlignType.MIDDLE_RIGHT === _loc_2)
            }while (FTextureTextAlignType.MIDDLE_LEFT === _loc_2)
            return;
        }

        override public function processMouseEvent(param1:Boolean, param2:MouseEvent, param3:Vector3D) : Boolean
        {
            if (_nWidth == 0 || _nHeight == 0)
            {
                return false;
            }
            if (param1)
            {
                if (cNode.cMouseOver == cNode)
                {
                    cNode.handleMouseEvent(cNode, "mouseOut", NaN, NaN, param2.buttonDown, param2.ctrlKey);
                }
                return false;
            }
            var _loc_6:* = cNode.cTransform.getTransformedWorldTransformMatrix(_nWidth, _nHeight, 0, true);
            var _loc_7:* = _loc_6.transformVector(param3);
            _loc_6.prependScale(1 / _nWidth, 1 / _nHeight, 1);
            var _loc_5:* = 0;
            var _loc_4:* = 0;
            var _loc_8:* = _iAlign;
            while (FTextureTextAlignType.MIDDLE_CENTER === _loc_8)
            {
                
                _loc_5 = -0.5;
                _loc_4 = -0.5;
                break;
            }
            if (_loc_7.x >= _loc_5 && _loc_7.x <= 1 + _loc_5 && _loc_7.y >= _loc_4 && _loc_7.y <= 1 + _loc_4)
            {
                cNode.handleMouseEvent(cNode, param2.type, _loc_7.x * _nWidth, _loc_7.y * _nHeight, param2.buttonDown, param2.ctrlKey);
                if (cNode.cMouseOver != cNode)
                {
                    cNode.handleMouseEvent(cNode, "mouseOver", _loc_7.x * _nWidth, _loc_7.y * _nHeight, param2.buttonDown, param2.ctrlKey);
                }
                return true;
            }
            if (cNode.cMouseOver == cNode)
            {
                cNode.handleMouseEvent(cNode, "mouseOut", _loc_7.x * _nWidth, _loc_7.y * _nHeight, param2.buttonDown, param2.ctrlKey);
            }
            return false;
        }

    }
}
