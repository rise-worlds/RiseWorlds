/**
 *
 * 技能基类
 * @author
 *
 */
var SkillBase = (function (_super) {
    __extends(SkillBase, _super);
    function SkillBase() {
        _super.call(this);
        /**时间差*/
        this.curtime = 0;
        /**CD*/
        this.cdtime = 0;
        /**是否cd中*/
        this.iscd = true;
    }
    var d = __define,c=SkillBase,p=c.prototype;
    p.initbm = function () {
        //技能图片
        this.skillbm = new egret.Bitmap();
        this.skillbm.x = 12;
        this.skillbm.y = 8;
        this.addChild(this.skillbm);
        //蒙板
        this.mb = Utils.createBitmapByName("mb");
        this.mb.anchorOffsetY = 1 * this.mb.width;
        this.mb.x = 12;
        this.mb.y = 8 + 38;
        this.addChild(this.mb);
        //框
        this.bkbm = Utils.createBitmapByName("uiskilloff");
        this.addChild(this.bkbm);
        this.touchEnabled = true;
    };
    /**创建*/
    p.onCreate = function () {
        this.iscd = true;
        this.curtime = 0;
    };
    /**销毁*/
    p.onDestroy = function () { };
    /**帧事件*/
    p.onEnterFrame = function (advancedTime) {
        if (this.iscd) {
            this.curtime += advancedTime;
            var per = this.curtime / this.cdtime;
            var left = 1 - per;
            this.setMbheight(left * 38);
            if (per >= 1) {
                this.iscd = false;
                this.skillbm.texture = RES.getRes(this.on);
                this.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.touchHandle, this);
            }
        }
    };
    /**设置蒙板高度*/
    p.setMbheight = function (num) {
        this.mb.height = num;
    };
    /**点击事件*/
    p.touchHandle = function (e) {
        Group.selectItem(this);
    };
    /**对象管理事件  选中 重选 取消*/
    p.selectItem = function () {
        this.bkbm.texture = RES.getRes("uiskillon");
        //console.log("取消");
        var i;
        var obj;
        var len = GuankaBase.instance.objArr.length;
        for (i = 0; i < len; i++) {
            obj = GuankaBase.instance.objArr[i];
            var soldorhero = egret.getQualifiedSuperclassName(obj);
            if (soldorhero == "ShieldSoldierBase" || soldorhero == "HeroBase") {
                obj.view.touchEnabled = false;
            }
        }
    };
    p.reselectItem = function () {
    };
    p.deselectItem = function () {
        this.bkbm.texture = RES.getRes("uiskilloff");
        //console.log("恢复");
        var i;
        var obj;
        var len = GuankaBase.instance.objArr.length;
        for (i = 0; i < len; i++) {
            obj = GuankaBase.instance.objArr[i];
            var soldorhero = egret.getQualifiedSuperclassName(obj);
            if (soldorhero == "ShieldSoldierBase" || soldorhero == "HeroBase") {
                obj.view.touchEnabled = true;
            }
        }
    };
    /**技能释放*/
    p.setPoint = function (arr) {
        //还原cd状态
        this.skillbm.texture = RES.getRes(this.off);
        this.setMbheight(38);
        this.curtime = 0;
        this.iscd = true;
        this.removeEventListener(egret.TouchEvent.TOUCH_BEGIN, this.touchHandle, this);
        //console.log("释放技能");
    };
    return SkillBase;
})(egret.Sprite);
egret.registerClass(SkillBase,'SkillBase');
//# sourceMappingURL=SkillBase.js.map