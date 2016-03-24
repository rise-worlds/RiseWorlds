/**
 *
 * 场景中所有可被摧毁的对象的基类 塔除外
 * @author
 *
 */
var Elements = (function (_super) {
    __extends(Elements, _super);
    function Elements() {
        _super.call(this);
        /**敌人*/
        this.targets = [];
        /**是否可清除*/
        this.canClear = false;
    }
    var d = __define,c=Elements,p=c.prototype;
    /**创建*/
    p.onCreate = function () { };
    /**销毁*/
    p.onDestroy = function () {
        if (this && this.parent) {
            this.parent.removeChild(this);
        }
    };
    /**移动*/
    p.move = function () { };
    /**打击效果*/
    p.onHit = function () { };
    /**帧事件*/
    p.onEnterFrame = function (advancedTime) {
    };
    return Elements;
})(egret.Sprite);
egret.registerClass(Elements,'Elements');
//# sourceMappingURL=Elements.js.map