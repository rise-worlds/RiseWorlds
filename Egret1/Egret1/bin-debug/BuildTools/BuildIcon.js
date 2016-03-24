/**
 *
 * 建造工具icon
 * @author
 *
 */
var BuildIcon = (function (_super) {
    __extends(BuildIcon, _super);
    function BuildIcon(towerName, gold) {
        _super.call(this);
        this.gold = gold;
        this.className = TowerLevel.dic[towerName].className; //获取类名
        var res = TowerLevel.dic[towerName].res; //获取资源名
        this.price = TowerLevel.dic[towerName].price; //获取价格
        //icon
        this.bm = Utils.createBitmapByName(res);
        this.addChild(this.bm);
        //condition
        if (towerName == "SellTower" || towerName == "LockTower")
            return;
        //textbg
        this.bm = Utils.createBitmapByName("cashbg");
        this.bm.x = 8;
        this.bm.y = 32;
        this.addChild(this.bm);
        //text
        this.txt = new egret.BitmapText();
        var bf;
        if (this.gold >= this.price)
            bf = RES.getRes("NumFont");
        else
            bf = RES.getRes("NumFont2");
        this.txt.font = bf;
        this.txt.letterSpacing = -1;
        this.txt.text = this.price.toString();
        this.txt.x = (30 - this.txt.width) / 2 + 8;
        this.txt.y = 32;
        this.addChild(this.txt);
    }
    var d = __define,c=BuildIcon,p=c.prototype;
    return BuildIcon;
})(egret.Sprite);
egret.registerClass(BuildIcon,'BuildIcon');
//# sourceMappingURL=BuildIcon.js.map