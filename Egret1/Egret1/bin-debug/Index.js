/**
 *
 * 主界面
 * @author
 *
 */
var Index = (function (_super) {
    __extends(Index, _super);
    function Index() {
        _super.call(this);
        this.stageWidth = GameSetting.swid;
        this.stageHeight = GameSetting.shei;
        this.addEventListener(egret.Event.ADDED_TO_STAGE, this.onAddToStage, this);
        //播放bgsound
        SoundManager.playBgSound("gamebgsound");
    }
    var d = __define,c=Index,p=c.prototype;
    p.init = function () {
    };
    p.onAddToStage = function (event) {
        //图片背景
        this.bg = new egret.Bitmap();
        this.bg.texture = RES.getRes("welbg");
        this.bg.alpha = 0;
        this.addChild(this.bg);
        egret.Tween.get(this.bg).wait(500).to({ alpha: 1 }, 800);
        //logo
        this.logo = new egret.Bitmap();
        this.logo.texture = RES.getRes("wellogo");
        this.logo.anchorOffsetX = 0.5;
        this.logo.anchorOffsetY = 1;
        this.logo.x = this.stageWidth / 2;
        this.logo.y = -this.logo.height;
        this.addChild(this.logo);
        TweenMax.fromTo(this.logo, 0.2, { y: -this.logo.height, scaleX: 0.1, rotation: 40 }, { delay: 1.3, y: this.stageHeight / 2 + 70, scaleX: 1, rotation: 0, ease: Circ.easeOut });
        //TweenMax.to(this.logo,0.1,{scaleX:0.9,yoyo:true,repeat:1,delay:1.45});
        //TweenMax.to(this.logo,0.1,{scaleY:1.1,yoyo:true,repeat:1,delay:1.46,onComplete:this.showLiantiao,onCompleteParams:[this]});
        //this.logo.scaleX = 0.1;
        //this.logo.rotation = 40;
        //egret.Tween.get(this.logo).wait(1300).to({ y: this.stageHeight / 2 + 70 },500,egret.Ease.bounceOut);
        egret.Tween.get(this.logo).wait(1450).to({ scaleX: 0.9 }, 100).to({ scaleX: 1 }, 100);
        egret.Tween.get(this.logo).wait(1460).to({ scaleY: 1.1 }, 100).to({ scaleY: 1 }, 100).call(this.showLiantiao, this);
        //链条
    };
    p.showLiantiao = function () {
        this.dropsp = new egret.Sprite();
        this.dropsp.x = this.stageWidth / 2;
        this.dropsp.y = this.logo.y - 30;
        this.addChildAt(this.dropsp, 1);
        //liantiao
        this.liantiao = new egret.Bitmap();
        this.liantiao.texture = RES.getRes("liantiao");
        this.liantiao.anchorOffsetX = 0.5;
        this.liantiao.anchorOffsetY = 1;
        this.dropsp.addChild(this.liantiao);
        //btn
        this.btn = new egret.Bitmap();
        this.btn.texture = RES.getRes("welbtn");
        this.btn.anchorOffsetX = 0.5;
        this.btn.anchorOffsetY = 1;
        this.dropsp.addChild(this.btn);
        //move  改成TweenMax
        egret.Tween.get(this.dropsp).to({ y: this.logo.y + 110 }, 600, egret.Ease.bounceOut).call(this.addLis, this);
    };
    p.addLis = function () {
        this.btn.touchEnabled = true;
        this.btn.addEventListener(egret.TouchEvent.TOUCH_TAP, this.btnCkH, this);
    };
    p.btnCkH = function (e) {
        this.btn.removeEventListener(egret.TouchEvent.TOUCH_TAP, this.btnCkH, this);
        //打开加载进度界面 加载资源下一场景
        Main.instance.dispatchEvent(new MainEvent(MainEvent.OPENLOADBAR, "maps"));
        //停止音效
        SoundManager.stopBgSound();
    };
    /*
    * 清除
    */
    p.destroy = function () {
        RES.destroyRes("welbg");
        RES.destroyRes("wellogo");
        RES.destroyRes("liantiao");
        RES.destroyRes("welbtn");
    };
    return Index;
})(egret.DisplayObjectContainer);
egret.registerClass(Index,'Index');
//# sourceMappingURL=Index.js.map