/**
 *
 * 防御塔基类
 * @author
 *
 */
var ShieldTowerBase = (function (_super) {
    __extends(ShieldTowerBase, _super);
    function ShieldTowerBase() {
        _super.call(this);
        /**集结点偏移量数组*/
        this.offArr = [[10, 0], [0, -10], [-10, 0]];
        /**集结点偏移量数组索引*/
        this.offIdx = -1;
        /**士兵恢复总时间*/
        this.createTime = 10000;
        /**时间累计*/
        this.timesum = 0;
        /**音效资源*/
        this.voiceArr = ["shield_ready1", "shield_ready2", "shield_ready3"];
        //播放音效
        var idx = Math.floor(Math.random() * 3);
        SoundManager.playEffect(this.voiceArr[idx]);
    }
    var d = __define,c=ShieldTowerBase,p=c.prototype;
    return ShieldTowerBase;
})(TowerBase);
egret.registerClass(ShieldTowerBase,'ShieldTowerBase');
//# sourceMappingURL=ShieldTowerBase.js.map