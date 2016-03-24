/**
*
* 塔类事件
* @author
*
*/
var TowerEvent = (function (_super) {
    __extends(TowerEvent, _super);
    function TowerEvent(type, obj, bubbles, cancelable) {
        if (obj === void 0) { obj = null; }
        if (bubbles === void 0) { bubbles = false; }
        if (cancelable === void 0) { cancelable = false; }
        _super.call(this, type, bubbles, cancelable);
        this._obj = obj;
    }
    var d = __define,c=TowerEvent,p=c.prototype;
    d(p, "obj"
        ,function () {
            return this._obj;
        }
    );
    TowerEvent.SHOWTOOL = "showtool";
    TowerEvent.HIDETOOL = "hidetool";
    return TowerEvent;
})(egret.Event);
egret.registerClass(TowerEvent,'TowerEvent');
//# sourceMappingURL=TowerEvent.js.map