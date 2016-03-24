/**
 *
 * 所有塔基类
 * @author
 *
 */
var TowerBase = (function (_super) {
    __extends(TowerBase, _super);
    function TowerBase() {
        _super.call(this);
        /**敌人数组*/
        this.targets = [];
        /**射程范围最大半径*/
        this.maxRadius = 140;
        /**射程范围最小半径*/
        this.minRadius = 100;
    }
    var d = __define,c=TowerBase,p=c.prototype;
    /**销毁自身*/
    p.destory = function () {
    };
    /**塔初始化*/
    p.init = function () {
    };
    /**实时刷新*/
    p.onEnterFrame = function (advancedTime) {
    };
    return TowerBase;
})(Base);
egret.registerClass(TowerBase,'TowerBase');
//# sourceMappingURL=TowerBase.js.map