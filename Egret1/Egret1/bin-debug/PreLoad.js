/**
 *
 * 游戏开始介绍页面
 * @author
 *
 */
var PreLoad = (function (_super) {
    __extends(PreLoad, _super);
    function PreLoad() {
        _super.call(this);
        this.stageWidth = GameSetting.swid;
        this.stageHeight = GameSetting.shei;
        this.addEventListener(egret.Event.ADDED_TO_STAGE, this.onAddToStage, this);
    }
    var d = __define,c=PreLoad,p=c.prototype;
    p.onAddToStage = function (event) {
        //图片背景
        this.bg = new egret.Bitmap();
        this.bg.texture = RES.getRes("0ui_bg");
        this.addChild(this.bg);
        //进度条背景
        this.barbg = new egret.Bitmap();
        this.barbg.texture = RES.getRes("probarbg");
        this.barbg.anchorOffsetX = 0.5 * 100;
        this.barbg.x = this.stageWidth / 2;
        this.barbg.y = this.stageHeight - 138;
        this.addChild(this.barbg);
        //进度条容器
        this.sp = new egret.DisplayObjectContainer();
        this.sp.x = this.stageWidth / 2 - 91;
        this.sp.y = this.stageHeight - 129;
        this.addChild(this.sp);
        //进度条
        this.bartop = new egret.Bitmap();
        this.bartop.texture = RES.getRes("probartop");
        this.bartop.width = 1;
        this.sp.addChild(this.bartop);
        //加载资源
        Loader.instance.load("welcomeload");
    };
    /*
     * 设置进度条
     */
    p.setProgress = function (current, total) {
        this.bartop.width = current / total * 182;
    };
    /*
     * 加载完成
     */
    p.loadComp = function () {
        this.removeChild(this.barbg);
        this.removeChild(this.sp);
        this.barbg = null;
        this.bartop = null;
        this.sp = null;
        this.btn = new egret.Bitmap();
        this.btn.texture = RES.getRes("0ui_btn");
        this.btn.anchorOffsetX = 0.5 * 100;
        this.btn.x = this.stageWidth / 2;
        this.btn.y = this.stageHeight - 156;
        this.addChild(this.btn);
        this.btn.touchEnabled = true;
        this.btn.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.touchH, this);
    };
    /*
     * 清除
     */
    p.destroy = function () {
        RES.destroyRes("0ui_bg");
        RES.destroyRes("0ui_btn");
    };
    /*
     * 点击开始
     */
    p.touchH = function (e) {
        this.btn.removeEventListener(egret.TouchEvent.TOUCH_BEGIN, this.touchH, this);
        Main.instance.init();
        this.destroy();
    };
    return PreLoad;
})(egret.DisplayObjectContainer);
egret.registerClass(PreLoad,'PreLoad');
//# sourceMappingURL=PreLoad.js.map