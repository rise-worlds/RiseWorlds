/**
 *
 * 建造工具
 * @author
 *
 */
var BuildTool = (function (_super) {
    __extends(BuildTool, _super);
    //根据当前选中对象类型生成建造工具
    function BuildTool(obj, gold) {
        _super.call(this);
        this.cacheAsBitmap = true;
        this.anchorOffsetX = this.anchorOffsetY = 0.5 * this.width;
        this.scaleX = this.scaleY = 0.5;
        this.alpha = 0;
        //工具圆圈
        this.bm = Utils.createBitmapByName("yuan");
        this.addChild(this.bm);
        //当前关卡拥有金钱
        this.gold = gold;
        //生成建造工具ICON
        this.createTools(obj);
        //展开动画
        TweenMax.to(this, 0.1, { alpha: 1, scaleX: 1, scaleY: 1 });
    }
    var d = __define,c=BuildTool,p=c.prototype;
    /**根据当前选中对象类型生成建造工具*/
    p.createTools = function (obj) {
        if (obj instanceof Base01 || obj instanceof Base02 || obj instanceof Base03) {
            this.addIcon("ArrowTower01", -4, -4);
            this.addIcon("ShieldTower01", 75, -4);
            this.addIcon("MagicTower01", -4, 70);
            this.addIcon("ExploTower01", 75, 70);
        }
        else if (obj instanceof ArrowTower01) {
            if (TowerLevel.ArrowTower["lv01-lv02"])
                this.addIcon("ArrowTower02", 36, -14);
            else
                this.addIcon("LockTower", 36, -14);
            this.addIcon("SellTower", 43, 98);
        }
        else if (obj instanceof ShieldTower01) {
            if (TowerLevel.ShieldTower["lv01-lv02"])
                this.addIcon("ShieldTower02", 36, -14);
            else
                this.addIcon("LockTower", 36, -14);
            this.addIcon("SellTower", 43, 98);
        }
        else if (obj instanceof MagicTower01) {
            if (TowerLevel.MagicTower["lv01-lv02"])
                this.addIcon("MagicTower02", 36, -14);
            else
                this.addIcon("LockTower", 36, -14);
            this.addIcon("SellTower", 43, 98);
        }
        else if (obj instanceof ExploTower01) {
            if (TowerLevel.ExploTower["lv01-lv02"])
                this.addIcon("ExploTower02", 36, -14);
            else
                this.addIcon("LockTower", 36, -14);
            this.addIcon("SellTower", 43, 98);
        }
        else if (obj instanceof ArrowTower02) {
            if (TowerLevel.ArrowTower["lv02-lv03_1"])
                this.addIcon("ArrowTower03_1", 0, -14);
            else
                this.addIcon("LockTower", 0, -14);
            if (TowerLevel.ArrowTower["lv02-lv03_2"])
                this.addIcon("ArrowTower03_2", 72, -14);
            else
                this.addIcon("LockTower", 72, -14);
            this.addIcon("SellTower", 43, 98);
        }
        else if (obj instanceof ShieldTower02) {
            if (TowerLevel.ShieldTower["lv02-lv03_1"])
                this.addIcon("ShieldTower03_1", 0, -14);
            else
                this.addIcon("LockTower", 0, -14);
            if (TowerLevel.ShieldTower["lv02-lv03_2"])
                this.addIcon("ShieldTower03_2", 72, -14);
            else
                this.addIcon("LockTower", 72, -14);
            this.addIcon("SellTower", 43, 98);
        }
        else if (obj instanceof MagicTower02) {
            if (TowerLevel.MagicTower["lv02-lv03_1"])
                this.addIcon("MagicTower03_1", 0, -14);
            else
                this.addIcon("LockTower", 0, -14);
            if (TowerLevel.MagicTower["lv02-lv03_2"])
                this.addIcon("MagicTower03_2", 72, -14);
            else
                this.addIcon("LockTower", 72, -14);
            this.addIcon("SellTower", 43, 98);
        }
        else if (obj instanceof ExploTower02) {
            if (TowerLevel.ExploTower["lv02-lv03_1"])
                this.addIcon("ExploTower03_1", 0, -14);
            else
                this.addIcon("LockTower", 0, -14);
            if (TowerLevel.ExploTower["lv02-lv03_2"])
                this.addIcon("ExploTower03_2", 72, -14);
            else
                this.addIcon("LockTower", 72, -14);
            this.addIcon("SellTower", 43, 98);
        }
        else {
            this.addIcon("SellTower", 43, 98);
        }
    };
    /**建造一个icon*/
    p.addIcon = function (type, x, y) {
        this.icon = new BuildIcon(type, this.gold);
        this.icon.x = x;
        this.icon.y = y;
        this.icon.touchEnabled = true;
        this.icon.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.iconClickHandle, this);
        this.addChild(this.icon);
    };
    /**建造icon点击事件*/
    p.iconClickHandle = function (e) {
        var className = e.currentTarget.className;
        var price = e.currentTarget.price;
        if (this.gold >= price)
            this.dispatchEvent(new ToolEvent(ToolEvent.BUILD_START, className, price));
    };
    /**隐藏工具*/
    p.hide = function () {
        var that = this;
        TweenMax.to(that, 0.1, { alpha: 0, scaleX: 0.5, scaleY: 0.5, onComplete: function () {
                if (that.parent != null) {
                    that.parent.removeChild(that);
                }
            } });
    };
    return BuildTool;
})(egret.Sprite);
egret.registerClass(BuildTool,'BuildTool');
//# sourceMappingURL=BuildTool.js.map