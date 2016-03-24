/**
 *
 *
 * 节点二维数组 节点操作方法
 * @author
 *
 */
var Grid = (function () {
    /**
    * 构造函数
    * @numCols 列
    * @numRows 行
    */
    function Grid(numCols, numRows) {
        this._numCols = numCols;
        this._numRows = numRows;
        this._nodes = new Array();
        ////以列数作为X坐标循环
        for (var i = 0; i < this._numCols; i++) {
            this._nodes[i] = [];
            for (var j = 0; j < this._numRows; j++) {
                this._nodes[i][j] = new NodePoint(i, j);
            }
        }
    }
    var d = __define,c=Grid,p=c.prototype;
    /**
    * 根据坐标获取节点
    * @param x 列
    * @param y 行
    */
    p.getNode = function (x, y) {
        return this._nodes[x][y];
    };
    /**
    * 设置节点是否可以通行
    * @param x 列
    * @param y 行
    */
    p.setWalkable = function (x, y, value) {
        this._nodes[x][y].walkable = value;
    };
    return Grid;
})();
egret.registerClass(Grid,'Grid');
//# sourceMappingURL=Grid.js.map