/**
 *
 * 关卡UI
 * @author
 *
 */
var GuanKaUI = (function (_super) {
    __extends(GuanKaUI, _super);
    function GuanKaUI(weaponLayer, objLayer) {
        _super.call(this);
        /**canClick*/
        this.canClick = false;
        var bm;
        //位图字体
        this.bf1 = RES.getRes("NumFont");
        this.bf3 = RES.getRes("NumFont3");
        //顶部容器
        this.topSp = new egret.Sprite();
        this.topSp.x = 0;
        this.topSp.y = -100;
        this.addChild(this.topSp);
        //左上角bg
        bm = Utils.createBitmapByName("uiinfo");
        bm.x = bm.y = 10;
        this.topSp.addChild(bm);
        //生命
        this.lifeLeftTxt = new egret.BitmapText();
        this.lifeLeftTxt.font = this.bf1;
        this.lifeLeftTxt.letterSpacing = -1;
        this.lifeLeftTxt.text = "0";
        this.lifeLeftTxt.x = 55;
        this.lifeLeftTxt.y = 16;
        this.topSp.addChild(this.lifeLeftTxt);
        //金币
        this.goldTxt = new egret.BitmapText();
        this.goldTxt.font = this.bf1;
        this.goldTxt.letterSpacing = -1;
        this.goldTxt.text = "0";
        this.goldTxt.x = 108;
        this.goldTxt.y = 16;
        this.topSp.addChild(this.goldTxt);
        //波数
        this.bos = new egret.BitmapText();
        this.bos.font = this.bf3;
        this.bos.letterSpacing = -1;
        this.bos.text = "0/0";
        this.bos.x = 100;
        this.bos.y = 39;
        this.topSp.addChild(this.bos);
        //返回地图按钮
        bm = Utils.createBitmapByName("backToMaps");
        bm.x = 740;
        bm.y = 10;
        this.topSp.addChild(bm);
        bm.touchEnabled = true;
        bm.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.backToMapsHandle, this);
        //底部容器
        this.bottomSp = new egret.Sprite();
        this.bottomSp.x = 0;
        this.bottomSp.y = GameSetting.shei + 50;
        this.addChild(this.bottomSp);
        //左下角bg
        bm = Utils.createBitmapByName("uiskillbg");
        this.bottomSp.addChild(bm);
        //技能1、2     引用关卡的武器层（放火球） 和 对象层（放增援）
        this.skill1 = new Skill1();
        this.skill1.onCreate();
        this.skill1.init("uiskill1off", "uiskill1", 25000, weaponLayer);
        this.skill1.x = 46;
        this.skill1.y = -14;
        this.bottomSp.addChild(this.skill1);
        this.skill2 = new Skill2();
        this.skill2.onCreate();
        this.skill2.init("uiskill2off", "uiskill2", 20000, objLayer);
        this.skill2.x = 120;
        this.skill2.y = -14;
        this.bottomSp.addChild(this.skill2);
    }
    var d = __define,c=GuanKaUI,p=c.prototype;
    /**返回按钮*/
    p.backToMapsHandle = function (e) {
        TweenMax.killAll();
        GuankaBase.instance.clear();
        this.dispatchEvent(new MainEvent(MainEvent.QUITGUANKA, null, true));
    };
    p.onEnterFrame = function (advancedtime) {
        if (this.skill1)
            this.skill1.onEnterFrame(advancedtime);
        if (this.skill2)
            this.skill2.onEnterFrame(advancedtime);
    };
    /**UI出现动效*/
    p.showUI = function () {
        TweenLite.to(this.topSp, 0.3, { y: 0, ease: Circ.easeOut });
        TweenLite.to(this.bottomSp, 0.3, { delay: 0.1, y: GameSetting.shei - 60, ease: Circ.easeOut });
    };
    /**设置金币数量*/
    p.setGold = function (num) {
        this.goldTxt.text = num.toString();
    };
    /**设置生命*/
    p.setLife = function (num) {
        this.lifeLeftTxt.text = num.toString();
    };
    /**设置波数*/
    p.setBos = function (cur, total) {
        this.bos.text = cur.toString() + "/" + total.toString();
    };
    /**胜利*/
    p.showVictory = function () {
        //画一个黑色蒙板
        var sp = new egret.Shape();
        sp.graphics.beginFill(0x000000, 0.6);
        sp.graphics.drawRect(0, 0, GameSetting.swid, GameSetting.shei);
        this.addChild(sp);
        sp.touchEnabled = true;
        sp.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.spTouch1, this);
        //胜利位图
        this.victoryBm = Utils.createBitmapByName("victory");
        this.victoryBm.anchorOffsetX = this.victoryBm.anchorOffsetY = 0.5;
        this.victoryBm.x = GameSetting.swid / 2;
        this.victoryBm.y = 180;
        this.victoryBm.scaleX = this.victoryBm.scaleY = 0.1;
        this.addChild(this.victoryBm);
        TweenMax.to(this.victoryBm, 0.5, { scaleX: 1, scaleY: 1, ease: Back.easeOut });
        var that = this;
        TweenMax.delayedCall(15, function () {
            that.dispatchEvent(new MainEvent(MainEvent.QUITGUANKA, null, true));
        });
        //播放胜利音效
        SoundManager.playBgSound("victorysd", false);
    };
    /**失败*/
    p.showLose = function () {
        //画一个黑色蒙板
        this.mbBm = new egret.Shape();
        this.mbBm.graphics.beginFill(0x000000, 0.6);
        this.mbBm.graphics.drawRect(0, 0, GameSetting.swid, GameSetting.shei);
        this.addChild(this.mbBm);
        this.mbBm.touchEnabled = true;
        this.mbBm.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.spTouch2, this);
        //失败位图
        this.loseBm = Utils.createBitmapByName("lose");
        this.loseBm.anchorOffsetX = this.loseBm.anchorOffsetY = 0.5;
        this.loseBm.x = GameSetting.swid / 2;
        this.loseBm.y = -180;
        this.addChild(this.loseBm);
        //重新尝试按钮
        this.tryAgainBm = Utils.createBitmapByName("tryagain");
        this.tryAgainBm.anchorOffsetX = this.tryAgainBm.anchorOffsetY = 0.5;
        this.tryAgainBm.x = GameSetting.swid / 2;
        this.tryAgainBm.y = 550;
        this.addChild(this.tryAgainBm);
        //退出按钮
        this.quitBm = Utils.createBitmapByName("quitgame");
        this.quitBm.anchorOffsetX = this.quitBm.anchorOffsetY = 0.5;
        this.quitBm.x = GameSetting.swid / 2;
        this.quitBm.y = 550;
        this.addChild(this.quitBm);
        //lis
        this.tryAgainBm.touchEnabled = true;
        this.quitBm.touchEnabled = true;
        this.tryAgainBm.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.tryAgainHandle, this);
        this.quitBm.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.spTouch1, this);
        //UI动效
        TweenMax.to(this.loseBm, 0.5, { y: 150, ease: Cubic.easeOut });
        TweenMax.to(this.tryAgainBm, 0.3, { delay: 0.3, y: 240, ease: Cubic.easeOut });
        TweenMax.to(this.quitBm, 0.3, { delay: 0.4, y: 300, ease: Cubic.easeOut });
        //播放失败音效
    };
    /**返回地图界面*/
    p.spTouch1 = function (e) {
        TweenMax.killAll();
        SoundManager.stopBgSound();
        this.dispatchEvent(new MainEvent(MainEvent.QUITGUANKA, null, true));
        e.stopPropagation();
    };
    /**再次尝试*/
    p.tryAgainHandle = function (e) {
        TweenMax.killAll();
        SoundManager.stopBgSound();
        this.dispatchEvent(new MainEvent(MainEvent.TRYAGAIN, null, true));
        this.removeChild(this.mbBm);
        this.removeChild(this.loseBm);
        this.removeChild(this.tryAgainBm);
        this.removeChild(this.quitBm);
        e.stopPropagation();
    };
    /**阻止事件*/
    p.spTouch2 = function (e) {
        e.stopPropagation();
    };
    return GuanKaUI;
})(egret.Sprite);
egret.registerClass(GuanKaUI,'GuanKaUI');
//# sourceMappingURL=GuanKaUI.js.map