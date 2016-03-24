/**
 *
 * 士兵事件
 * @author
 *
 */
var SoldEvent = (function (_super) {
    __extends(SoldEvent, _super);
    function SoldEvent(type, obj, arr, bubbles, cancelable) {
        if (obj === void 0) { obj = null; }
        if (arr === void 0) { arr = null; }
        if (bubbles === void 0) { bubbles = false; }
        if (cancelable === void 0) { cancelable = false; }
        _super.call(this, type, bubbles, cancelable);
        this._obj = obj;
        this._arr = arr;
    }
    var d = __define,c=SoldEvent,p=c.prototype;
    d(p, "obj"
        ,function () {
            return this._obj;
        }
    );
    d(p, "arr"
        ,function () {
            return this._arr;
        }
    );
    SoldEvent.SELECT = "select";
    SoldEvent.DESELECT = "deselect";
    SoldEvent.MOVE = "move";
    return SoldEvent;
})(egret.Event);
egret.registerClass(SoldEvent,'SoldEvent');
//# sourceMappingURL=SoldEvent.js.map