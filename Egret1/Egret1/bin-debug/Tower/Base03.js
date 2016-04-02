/**
 *
 * 地基02
 * @author
 *
 */
var Base03 = (function (_super) {
    __extends(Base03, _super);
    function Base03() {
        _super.call(this);
        this.cacheAsBitmap = true;
        var bm = Utils.createBitmapByName("Base03");
        this.anchorOffsetX = 0.5 * this.width;
        this.anchorOffsetY = 1 * this.height;
        this.addChild(bm);
    }
    var d = __define,c=Base03,p=c.prototype;
    p.onEnterFrame = function (advancedTime) {
    };
    return Base03;
})(Base);
egret.registerClass(Base03,'Base03');
//# sourceMappingURL=Base03.js.map