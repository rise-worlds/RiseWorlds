/**
*
* 弓箭塔02
* @author
*
*/
var ArrowTower02 = (function (_super) {
    __extends(ArrowTower02, _super);
    function ArrowTower02() {
        _super.call(this);
        this.minRadius = 100;
        this.maxRadius = 140;
        this.ratioY = this.minRadius / this.maxRadius;
        this.anchorOffsetX = 0.5;
        this.anchorOffsetY = 1;
        this.bm = Utils.createBitmapByName("ArrowTower02");
        this.addChild(this.bm);
        ////创建左右ArrowShooter01
        this.st1 = new ArrowShooter02();
        this.st1.x = 36;
        this.st1.y = 10;
        this.addChild(this.st1);
        this.st2 = new ArrowShooter02();
        this.st2.x = 50;
        this.st2.y = 10;
        this.addChild(this.st2);
        //初始化数据
        this.fireDelay = 1000;
    }
    var d = __define,c=ArrowTower02,p=c.prototype;
    /**实时刷新*/
    p.onEnterFrame = function (advancedTime) {
        _super.prototype.onEnterFrame.call(this, advancedTime);
        //实时刷新射手动作
        this.st1.onEnterFrame(advancedTime);
        this.st2.onEnterFrame(advancedTime);
        //进入范围敌人数组为空则直接返回
        if (this.atargets.length == 0) {
            this.timesum = this.fireDelay;
            return;
        }
        //发射间隔
        this.timesum += advancedTime;
        if (this.timesum < this.fireDelay) {
            return;
        }
        this.timesum = 0;
        //取进入范围数组第一个
        this.target = this.atargets[0];
        //确定敌人方向
        if (this.target.x >= this.sx && this.target.y <= this.sy - 22) {
            this.direct = "upR";
        }
        if (this.target.x >= this.sx && this.target.y > this.sy - 22) {
            this.direct = "downR";
        }
        if (this.target.x < this.sx && this.target.y <= this.sy - 22) {
            this.direct = "upL";
        }
        if (this.target.x < this.sx && this.target.y > this.sy - 22) {
            this.direct = "downL";
        }
        //射击音效播放
        this.playFireVoice();
        //轮流射击
        var p1;
        if (this.firstst == "L") {
            this.st1.fire(this.direct);
            this.firstst = "R";
            //弓箭产生坐标点
            p1 = new egret.Point(this.sx - 5, this.sy - 47);
        }
        else if (this.firstst == "R") {
            this.st2.fire(this.direct);
            this.firstst = "L";
            //弓箭产生坐标点
            p1 = new egret.Point(this.sx + 5, this.sy - 47);
        }
        //利用对象池产生弓箭对象并进行碰撞检测
        this.weapon = ObjectPool.getInstance().createObject(Arrow01);
        this.weapon.damage = 8;
        this.weapon.init(p1, this.target, this.target.offy);
        this.contentLayer.addChild(this.weapon);
    };
    return ArrowTower02;
})(ArrowTowerBase);
egret.registerClass(ArrowTower02,'ArrowTower02');
//# sourceMappingURL=ArrowTower02.js.map