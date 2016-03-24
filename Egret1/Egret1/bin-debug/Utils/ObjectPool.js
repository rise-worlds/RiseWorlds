/**
*
* 对象池
* @author
*
*/
var ObjectPool = (function () {
    function ObjectPool() {
        this._isPause = false;
        /**对象池*/
        this._pool = {};
        /**所有显示在舞台上的显示对象数组*/
        this._list = [];
        egret.Ticker.getInstance().register(this.onEnterFrame, this);
    }
    var d = __define,c=ObjectPool,p=c.prototype;
    /**事实刷新对象池中对象*/
    p.onEnterFrame = function (advancedTime) {
        //if (Main.isPause)return;
        var list = this._list.concat();
        for (var i = 0, length = list.length; i < length; i++) {
            var obj = list[i];
            obj.onEnterFrame(advancedTime);
        }
    };
    p.pauseEnterFrame = function () {
        this._isPause = true;
    };
    p.resumeEnterFrame = function () {
        this._isPause = false;
    };
    /**取出*/
    p.createObject = function (classFactory) {
        var result;
        var key = egret.getQualifiedClassName(classFactory);
        //console.log(key);
        var arr = this._pool[key];
        if (arr != null && arr.length) {
            result = arr.shift();
        }
        else {
            result = new classFactory();
        }
        result.onCreate(); //创建
        this._list.push(result);
        return result;
    };
    /**放回*/
    p.destroyObject = function (obj) {
        var key = egret.getQualifiedClassName(obj);
        //console.log(key);
        if (this._pool[key] == null) {
            this._pool[key] = [];
        }
        if (this._pool[key].indexOf(obj) == -1) {
            this._pool[key].push(obj);
        }
        obj.onDestroy(); //销毁
        var index = this._list.indexOf(obj);
        if (index != -1) {
            this._list.splice(index, 1);
        }
    };
    /***/
    p.destroyObjectByKey = function (key) {
        for (var i = 0; i < this._list.length; i++) {
            if (this._list[i].key == key) {
                this._list[i].onDestroy();
                i--;
            }
        }
    };
    /**放回所有舞台上的对象*/
    p.destroyAllObject = function () {
        while (this._list.length) {
            this.destroyObject(this._list[0]);
        }
    };
    ObjectPool.getInstance = function () {
        if (ObjectPool.instance == null) {
            ObjectPool.instance = new ObjectPool();
        }
        return ObjectPool.instance;
    };
    return ObjectPool;
})();
egret.registerClass(ObjectPool,'ObjectPool');
//# sourceMappingURL=ObjectPool.js.map