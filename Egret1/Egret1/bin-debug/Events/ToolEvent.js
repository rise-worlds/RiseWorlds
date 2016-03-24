/**
 *
 * @author
 *
 */
var ToolEvent = (function (_super) {
    __extends(ToolEvent, _super);
    function ToolEvent(type, className, price, bubbles, cancelable) {
        if (className === void 0) { className = ""; }
        if (price === void 0) { price = 0; }
        if (bubbles === void 0) { bubbles = false; }
        if (cancelable === void 0) { cancelable = false; }
        _super.call(this, type, bubbles, cancelable);
        this._className = "";
        this._price = 0;
        this._className = className;
        this._price = price;
    }
    var d = __define,c=ToolEvent,p=c.prototype;
    d(p, "className"
        ,function () {
            return this._className;
        }
    );
    d(p, "price"
        ,function () {
            return this._price;
        }
    );
    ToolEvent.BUILD_START = "build_start";
    ToolEvent.BUILD_COMP = "build_comp";
    return ToolEvent;
})(egret.Event);
egret.registerClass(ToolEvent,'ToolEvent');
//# sourceMappingURL=ToolEvent.js.map