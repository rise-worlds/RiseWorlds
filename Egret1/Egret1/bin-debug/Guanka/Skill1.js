/**
 *
 * 技能-火球
 * @author
 *
 */
var Skill1 = (function (_super) {
    __extends(Skill1, _super);
    function Skill1() {
        _super.call(this);
    }
    var d = __define,c=Skill1,p=c.prototype;
    p.init = function (off, on, cdtime, layer) {
        this.off = off;
        this.on = on;
        this.cdtime = cdtime;
        this.contentLayer = layer;
        this.initbm();
        //技能图片
        this.skillbm.texture = RES.getRes(off);
    };
    /**技能释放*/
    p.setPoint = function (arr) {
        _super.prototype.setPoint.call(this, arr);
        //利用对象池创建火球并进行碰撞检测  火球有damage属性
        this.xpos = arr[0];
        this.ypos = arr[1] + 20;
        this.timer = new egret.Timer(100, 10);
        this.timer.addEventListener(egret.TimerEvent.TIMER, this.timerHandle, this);
        this.timer.start();
        //console.log("释放技能");
    };
    p.timerHandle = function (e) {
        var fb = ObjectPool.getInstance().createObject(FireBall);
        fb.damage = Math.sqrt(GuankaBase.instance.hardxs) * 20;
        if (this.timer.currentCount <= 4) {
            var xnum = 25 - Math.random() * 50 + this.xpos;
            var ynum = 25 - Math.random() * 50 + this.ypos;
        }
        else {
            var xnum = 50 + Math.random() * (GameSetting.swid - 100);
            var ynum = 50 + Math.random() * (GameSetting.shei - 100);
        }
        fb.init(xnum, ynum);
        fb.targets = GuankaBase.instance.enemyArr;
        GuankaBase.instance.weaponLayer.addChild(fb);
    };
    return Skill1;
})(SkillBase);
egret.registerClass(Skill1,'Skill1');
//# sourceMappingURL=Skill1.js.map