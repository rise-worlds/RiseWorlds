/**
 *
 * 主类事件
 * @author
 *
 */
var MainEvent = (function (_super) {
    __extends(MainEvent, _super);
    function MainEvent(type, resName, bubbles, cancelable) {
        if (resName === void 0) { resName = ""; }
        if (bubbles === void 0) { bubbles = false; }
        if (cancelable === void 0) { cancelable = false; }
        _super.call(this, type, bubbles, cancelable);
        this._resName = "";
        this._resName = resName;
    }
    var d = __define,c=MainEvent,p=c.prototype;
    d(p, "resName"
        ,function () {
            return this._resName;
        }
    );
    MainEvent.OPENLOADBAR = "openloadbar";
    MainEvent.REMOVE = "remove";
    MainEvent.LOADCOMP = "loadcomp";
    MainEvent.PAUSE = "pause";
    MainEvent.QUITGUANKA = "quitguanka"; //退出关卡
    MainEvent.TRYAGAIN = "tryagain"; //再次尝试
    return MainEvent;
})(egret.Event);
egret.registerClass(MainEvent,'MainEvent');
//# sourceMappingURL=MainEvent.js.map