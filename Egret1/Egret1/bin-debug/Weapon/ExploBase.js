/**
 *
 * 炮弹基类
 * @author
 *
 */
var ExploBase = (function (_super) {
    __extends(ExploBase, _super);
    function ExploBase() {
        _super.call(this);
        /**是否击中目标*/
        this.isHit = false;
        /**是否失去目标*/
        this.isMiss = false;
        /**是否跟踪目标*/
        this.follow = false;
        /**攻击范围最大半径*/
        this.maxSoldRadius = 40;
        /**攻击范围最小半径*/
        this.minSoldRadius = 40;
        this.t0 = 0;
        this.t1 = 25; //高度
        this.g = 1; //重力
    }
    var d = __define,c=ExploBase,p=c.prototype;
    /**刷新*/
    p.update = function () {
        if (this.follow) {
            this.move();
            this.hittest();
        }
    };
    /**计算双轴速度*/
    p.setTarget = function (x, y) {
        this.pos = new egret.Point(x, y);
        //根据终点计算双轴速度
        this.xSpeed = (this.pos.x - this.p1.x) / this.t1;
        this.ySpeed = (((this.pos.y - this.p1.y) - ((this.g * this.t1) * (this.t1 / 2))) / this.t1);
    };
    /**移动*/
    p.move = function () {
        this.setTarget(this.target.x, this.target.y - this.offy);
        this.t0 += 0.5;
        this.x = (this.p1.x + (this.t0 * this.xSpeed));
        this.y = ((this.p1.y + (this.t0 * this.ySpeed)) + (((this.g * this.t0) * this.t0) / 2));
        this.t0 += 0.5;
        var Sx = (this.p1.x + (this.t0 * this.xSpeed));
        var Sy = ((this.p1.y + (this.t0 * this.ySpeed)) + (((this.g * this.t0) * this.t0) / 2));
        this.t0 -= 0.5;
        var dx = Sx - this.x;
        var dy = Sy - this.y;
        //this.angel = Math.atan2(dy,dx);
        //this.rotation = this.angel * 180 / Math.PI + 180;
        //根据弓箭的角度来允许碰撞
        this.angle = Math.atan2(dy, dx) * 180 / Math.PI + 180;
    };
    /**帧事件*/
    p.onEnterFrame = function (advancedTime) {
        //刷新
        this.update();
        //击中
        if (this.isHit) {
            this.view.gotoAndPlay("hit");
            this.isHit = false;
        }
        //播放完成
        if (this.view.currentLabel == "hitEnd") {
            this.canClear = true;
        }
        //销毁
        if (this.canClear) {
            ObjectPool.getInstance().destroyObject(this);
        }
    };
    /**碰撞检测*/
    //根据坐标差值检测？
    //设置一个小的rectangle 优先尝试
    p.hittest = function () {
        //允许攻击角度
        if (this.angle >= 0 && this.angle <= 180)
            return;
        //
        var disx = this.x - this.target.x < 0 ? this.target.x - this.x : this.x - this.target.x;
        var disy = this.y - this.target.y - this.offy < 0 ? this.target.y - this.offy - this.y : this.y - this.target.y - this.offy;
        if (disx <= 1 && disy <= 1) {
            //在椭圆范围内的允许碰撞筛选数组(进入炮弹攻击的范围)
            var i;
            this.atargets = [];
            for (i = 0; i < this.targets.length; i++) {
                var obj = this.targets[i];
                var isin = Utils.containsXY(obj.x, obj.y, this.x, this.y, this.maxSoldRadius, this.ratioSoldY);
                var index = this.atargets.indexOf(obj);
                if (isin && obj.hp > 0) {
                    if (index == -1)
                        this.atargets.push(obj);
                }
                else {
                    if (index != -1)
                        this.atargets.splice(index, 1);
                }
            }
            //范围内敌人扣血
            for (i = 0; i < this.atargets.length; i++) {
                var obj = this.atargets[i];
                obj.hp -= this.damage;
            }
            //if(HitTest.hitTestRect(this,this.target)) {
            //this.target.hp -= this.damage;
            //击中敌人效果
            this.isHit = true;
            this.follow = false;
            //}
            //播放音效
            SoundManager.playEffect("explo_fireend1");
        }
    };
    return ExploBase;
})(Elements);
egret.registerClass(ExploBase,'ExploBase');
//# sourceMappingURL=ExploBase.js.map