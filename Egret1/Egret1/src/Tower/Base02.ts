/**
 *
 * 地基02
 * @author 
 *
 */
class Base02 extends Base{
    
	public constructor() {
        super();
        this.cacheAsBitmap = true;
        var bm: egret.Bitmap = Utils.createBitmapByName("Base02");
        this.anchorOffsetX = 0.5 * this.width;
        this.anchorOffsetY = 1 * this.height;
        this.addChild(bm);
	}
	
    public onEnterFrame(advancedTime:number){
        
    }
    
    
}
