/**
 *
 * 弓箭基类
 * @author
 *
 */
var ArrowBase = (function (_super) {
    __extends(ArrowBase, _super);
    function ArrowBase() {
        _super.call(this);
        /**是否击中目标*/
        this.isHit = false;
        /**是否失去目标*/
        this.isMiss = false;
        /**是否跟踪目标*/
        this.follow = false;
        this.t0 = 0;
        this.t1 = 20;
        this.g = 1; //重力
    }
    var d = __define,c=ArrowBase,p=c.prototype;
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
        this.angel = Math.atan2(dy, dx);
        this.rotation = this.angel * 180 / Math.PI + 180;
        //根据弓箭的角度来允许碰撞
        this.angle = this.rotation;
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
        //失去目标(插地)
        if (this.isMiss) {
            this.view.gotoAndPlay("miss");
            this.isMiss = false;
        }
        //播放完成
        if (this.view.currentLabel == "hitEnd" || this.view.currentLabel == "missEnd") {
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
            //if(HitTest.hitTestRect(this,this.target)) {
            this.target.hp -= this.damage;
            //console.log(this.target.hp);
            //在上一次攻击时已经死亡则插地
            if (this.target.hp <= -this.damage) {
                this.isMiss = true; //插地效果
                this.rotation = 270;
                //x,y坐标随机偏移几像素
                var dx = 2 - Math.random() * 4;
                var dy = Math.random() * 6 + 4;
                this.x += dx;
                this.y += dy;
            }
            else {
                this.isHit = true; //击中敌人效果
                //播放音效
                if (Math.random() > 0.4)
                    SoundManager.playEffect("arrow_hit2");
                else
                    SoundManager.playEffect("arrow_hit1");
            }
            this.follow = false;
        }
    };
    return ArrowBase;
})(Elements);
egret.registerClass(ArrowBase,'ArrowBase');
//# sourceMappingURL=ArrowBase.js.map