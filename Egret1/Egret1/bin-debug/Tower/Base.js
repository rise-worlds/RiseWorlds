/**
 *
 * @author
 *
 */
var Base = (function (_super) {
    __extends(Base, _super);
    function Base() {
        _super.call(this);
    }
    var d = __define,c=Base,p=c.prototype;
    //
    p.selectItem = function () {
        //console.log("地基选中");
        this.dispatchEvent(new TowerEvent(TowerEvent.SHOWTOOL, this));
    };
    p.deselectItem = function () {
        //console.log("地基取消");
        this.dispatchEvent(new TowerEvent(TowerEvent.HIDETOOL, this));
    };
    p.reselectItem = function () {
        //console.log("地基重选");
        this.dispatchEvent(new TowerEvent(TowerEvent.HIDETOOL, this));
        Group.dispose();
    };
    return Base;
})(egret.Sprite);
egret.registerClass(Base,'Base',["IGroupItem"]);
//# sourceMappingURL=Base.js.map