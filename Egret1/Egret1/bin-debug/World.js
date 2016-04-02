/**
 *
 * 世界地图类
 * @author
 *
 */
var World = (function (_super) {
    __extends(World, _super);
    function World() {
        _super.call(this);
        //播放bgsound
        SoundManager.playBgSound("mapbgsound");
        this.init();
    }
    var d = __define,c=World,p=c.prototype;
    /**初始化*/
    p.init = function () {
        //背景
        this.bg = Utils.createBitmapByName("map");
        this.addChild(this.bg);
        //返回
        this.back = Utils.createBitmapByName("backToIndex");
        this.addChild(this.back);
        this.back.x = 80;
        this.back.y = GameSetting.shei;
        //英雄大厅
        this.hero = Utils.createBitmapByName("heroIcon");
        this.addChild(this.hero);
        this.hero.x = 620;
        this.hero.y = GameSetting.shei;
        //icon出现动画
        TweenMax.to(this.back, 0.5, { delay: 1, y: GameSetting.shei - 80, ease: Circ.easeInOut });
        TweenMax.to(this.hero, 0.5, { delay: 1, y: GameSetting.shei - 100, ease: Circ.easeInOut });
        //icon侦听
        this.back.touchEnabled = true;
        this.back.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.backH, this);
        this.hero.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.openHeroH, this);
        //获取关卡数据 生成旗帜
        this.flagArr = [];
        var arr = GuanKaConfig.getData();
        var len = arr.length;
        var flag;
        for (var i = 0; i < len; i++) {
            var ispass = arr[i]["ispass"];
            var texturename = ispass ? "flag0" : "flag1";
            flag = Utils.createBitmapByName(texturename);
            flag.x = arr[i]["xpos"];
            flag.y = arr[i]["ypos"];
            flag.alpha = 0;
            flag.touchEnabled = true;
            flag.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.choseGuanka, this);
            this.addChild(flag);
            this.flagArr.push(flag);
            if (!ispass) {
                break;
            }
        }
        //旗帜动画
        for (var i = 0; i < this.flagArr.length; i++) {
            TweenMax.fromTo(this.flagArr[i], 0.3, { alpha: 0, y: this.flagArr[i].y - 30 }, { alpha: 1, y: this.flagArr[i].y, delay: i * 0.1 + 1 });
        }
    };
    /**取消旗帜侦听*/
    p.removeLis = function () {
        var i;
        var flag;
        for (var i = 0; i < this.flagArr.length; i++) {
            flag = this.flagArr[i];
            flag.removeEventListener(egret.TouchEvent.TOUCH_BEGIN, this.choseGuanka, this);
        }
    };
    /**恢复旗帜侦听*/
    p.addLis = function () {
        var i;
        var flag;
        for (var i = 0; i < this.flagArr.length; i++) {
            flag = this.flagArr[i];
            flag.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.choseGuanka, this);
        }
    };
    /**创建选择面板*/
    p.showXZ = function () {
        this.xzmb = new egret.Sprite();
        this.xzmb.anchorOffsetX = this.xzmb.anchorOffsetY = 0.5 * 100;
        this.xzmb.x = GameSetting.swid / 2;
        this.xzmb.y = GameSetting.shei / 2;
        this.addChild(this.xzmb);
        this.xzmb.scaleX = this.xzmb.scaleY = 0.1;
        this.gkxz = Utils.createBitmapByName("gkxz");
        this.xzmb.addChild(this.gkxz);
        this.gushi = Utils.createBitmapByName("gushimoshi");
        this.gushi.x = 75;
        this.gushi.y = 125;
        this.xzmb.addChild(this.gushi);
        //判断故事模式是否通关ispass
        if (GuanKaConfig.data[Main.curIdx]["ispass"])
            this.wujin = Utils.createBitmapByName("wujinmoshi");
        else
            this.wujin = Utils.createBitmapByName("wujinmoshi2");
        this.wujin.x = 75;
        this.wujin.y = 187;
        this.xzmb.addChild(this.wujin);
        this.xx = Utils.createBitmapByName("xx");
        this.xx.x = 280;
        this.xx.y = 16;
        this.xzmb.addChild(this.xx);
        //gktxt
        this.gktxt = new egret.BitmapText();
        var bf = RES.getRes("NumFontda");
        this.gktxt.font = bf;
        this.gktxt.letterSpacing = -1;
        this.gktxt.text = (Main.curIdx + 1).toString();
        this.gktxt.x = 163 - this.gktxt.width / 2;
        this.gktxt.y = 18;
        this.xzmb.addChild(this.gktxt);
        //txt
        this.txt = new egret.BitmapText();
        var bf = RES.getRes("NumFont0");
        this.txt.font = bf;
        this.txt.letterSpacing = -1;
        this.txt.text = GuanKaConfig.data[Main.curIdx]["wujin"].toString();
        this.txt.x = 215;
        this.txt.y = 58;
        this.xzmb.addChild(this.txt);
        //侦听
        this.gushi.touchEnabled = true;
        this.xx.touchEnabled = true;
        this.gushi.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.gushiHandle, this);
        this.xx.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.closeHandle, this);
        if (GuanKaConfig.data[Main.curIdx]["ispass"]) {
            this.wujin.touchEnabled = true;
            this.wujin.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.wujinHandle, this);
        }
        //动效
        TweenMax.to(this.xzmb, 0.3, { scaleX: 1, scaleY: 1, ease: Back.easeOut });
    };
    /**故事模式*/
    p.gushiHandle = function (e) {
        Main.wujin = false;
        this.loadGuanka();
    };
    /**无尽模式*/
    p.wujinHandle = function (e) {
        Main.wujin = true;
        this.loadGuanka();
    };
    /**关闭选择面板*/
    p.closeHandle = function (e) {
        this.xx.removeEventListener(egret.TouchEvent.TOUCH_BEGIN, this.closeHandle, this);
        this.gushi.removeEventListener(egret.TouchEvent.TOUCH_BEGIN, this.gushiHandle, this);
        if (this.wujin.hasEventListener(egret.TouchEvent.TOUCH_BEGIN))
            this.wujin.removeEventListener(egret.TouchEvent.TOUCH_BEGIN, this.wujinHandle, this);
        var that = this;
        //动效
        TweenMax.to(this.xzmb, 0.3, { scaleX: 0.1, scaleY: 0.1, ease: Back.easeIn, onComplete: function () {
                that.removeChild(that.xzmb);
                that.xzmb = null;
                that.addLis();
            } });
    };
    /**选择面板*/
    p.choseGuanka = function (e) {
        Main.curIdx = this.flagArr.indexOf(e.currentTarget);
        //取消旗帜侦听
        this.removeLis();
        //出现选择面板
        this.showXZ();
    };
    /**选择模式*/
    p.loadGuanka = function () {
        //加载资源
        if (Main.loadCommis1st) {
            console.log("加载UI资源");
            Main.instance.dispatchEvent(new MainEvent(MainEvent.OPENLOADBAR, "uiLoad"));
            Main.loadCommis1st = false;
        }
        else {
            console.log("加载关卡资源");
            Main.instance.dispatchEvent(new MainEvent(MainEvent.OPENLOADBAR, GuanKaConfig.guankaData[Main.curIdx]));
        }
        SoundManager.stopBgSound();
    };
    /**返回主界面*/
    p.backH = function (e) {
        this.back.removeEventListener(egret.TouchEvent.TOUCH_BEGIN, this.backH, this);
        //打开加载进度界面 加载资源下一场景
        Main.instance.dispatchEvent(new MainEvent(MainEvent.OPENLOADBAR, "welcomeload"));
        SoundManager.stopBgSound();
    };
    /**打开英雄大厅UI面板*/
    p.openHeroH = function (e) {
    };
    /*
    * 清除
    */
    p.destroy = function () {
        RES.destroyRes("map");
        TweenMax.killChildTweensOf(this);
        for (var i = 0; i < this.flagArr.length; i++) {
            this.flagArr[i].removeEventListener(egret.TouchEvent.TOUCH_BEGIN, this.choseGuanka, this);
        }
    };
    return World;
})(egret.Sprite);
egret.registerClass(World,'World');
//# sourceMappingURL=World.js.map