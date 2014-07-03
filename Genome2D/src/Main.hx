package ;

import com.genome2d.assets.GAssetManager;
import com.genome2d.components.renderables.GMovieClip;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.jointanim.JAnim;
import com.genome2d.components.renderables.jointanim.JointAnimate;
import com.genome2d.context.filters.GHDRPassFilter;
import com.genome2d.context.GContextConfig;
import com.genome2d.context.stats.GStats;
import com.genome2d.Genome2D;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.signals.GNodeMouseSignal;
import com.genome2d.textures.factories.GTextureAtlasFactory;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureAtlas;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;
import flash.net.URLRequest;
import flash.events.IOErrorEvent;
import flash.events.Event;
import flash.net.URLLoaderDataFormat;
import flash.net.URLLoader;
import flash.utils.ByteArray;
import flash.utils.Endian;

/**
 * ...
 * @author Rise
 */

class Main 
{
	static public function main() {
        var inst = new Main();
    }

    /**
        Genome2D singleton instance
     **/
    private var genome:Genome2D;

    /**
        Asset manager instance for loading assets
     **/
    private var assetManager:GAssetManager;

    public function new() {
        initGenome();
    }

    /**
        Initialize Genome2D
     **/
    private function initGenome():Void {
        genome = Genome2D.getInstance();
        genome.onInitialized.add(genomeInitializedHandler);
		genome.onUpdate.add(genomeUpdateHandler);
		genome.onPostRender.add(genomeRenderHandler);
        genome.init(new GContextConfig());
    }

    /**
        Genome2D initialized handler
     **/
    private function genomeInitializedHandler():Void {
		GStats.visible = true;
        initAssets();
    }

    /**
        Initialize assets
     **/
    private function initAssets():Void {
        assetManager = new GAssetManager();
        //assetManager.addUrl("atlas_gfx", "atlas.png");
        //assetManager.addUrl("atlas_xml", "atlas.xml");
        assetManager.addUrl("atlas_gfx", "cloud.png");
        assetManager.addUrl("atlas_xml", "cloud.xml");
        //assetManager.addUrl("atlas_dat", "atlas.pam");
        assetManager.onAllLoaded.add(assetsInitializedHandler);
        assetManager.load();
    }

    /**
        Assets initialization handler dispatched after all assets were initialized
     **/
    private function assetsInitializedHandler():Void {
        initExample();
    }

    /**
        Initialize Example code
     **/
    private function initExample():Void {
        //GTextureAtlasFactory.createFromAssets("atlas", cast assetManager.getAssetById("atlas_gfx"), cast assetManager.getAssetById("atlas_xml"));

        //var sprite:GSprite;
        //
        //sprite = createSprite(300, 200, "atlas_0");
        //
        //sprite = createSprite(500, 200, "atlas_0");
        //sprite.node.transform.setScale(2,2);
        //
        //sprite = createSprite(300, 400, "atlas_0");
        //sprite.node.transform.rotation = 0.753;
        //
        //sprite = createSprite(500, 400, "atlas_0");
        //sprite.node.transform.rotation = 0.753;
        //sprite.node.transform.setScale(2,2);
        //
        //sprite = createSprite(300, 300, "atlas_0");
        //sprite.node.transform.alpha = .5;
        //
        //sprite = createSprite(500, 300, "atlas_0");
        //sprite.node.transform.color = 0x00FF00;
		
		//var clip:GMovieClip;
        //clip = createMovieClip(300, 200, ["atlas_GENERAL101B_ATTACK_B0000",
		//								  "atlas_GENERAL101B_ATTACK_B0001",
		//								  "atlas_GENERAL101B_ATTACK_B0002",
		//								  "atlas_GENERAL101B_ATTACK_B0003",
		//								  "atlas_GENERAL101B_ATTACK_B0004",
		//								  "atlas_GENERAL101B_ATTACK_B0005",
		//								  "atlas_GENERAL101B_ATTACK_B0006",
		//								  "atlas_GENERAL101B_ATTACK_B0007",
		//								  "atlas_GENERAL101B_ATTACK_B0008",
		//								  "atlas_GENERAL101B_ATTACK_B0009"]);
		//									
		//clip = createMovieClip(500,200, ["atlas_GENERAL101B_ATTACK_D0000",
		//								 "atlas_GENERAL101B_ATTACK_D0001",
		//								 "atlas_GENERAL101B_ATTACK_D0002",
		//								 "atlas_GENERAL101B_ATTACK_D0003",
		//								 "atlas_GENERAL101B_ATTACK_D0004",
		//								 "atlas_GENERAL101B_ATTACK_D0005",
		//								 "atlas_GENERAL101B_ATTACK_D0006",
		//								 "atlas_GENERAL101B_ATTACK_D0007",
		//								 "atlas_GENERAL101B_ATTACK_D0008",
		//								 "atlas_GENERAL101B_ATTACK_D0009"]);
        ////clip.node.transform.setScale(2, 2);
		//
		//clip = createMovieClip(300,400, ["atlas_GENERAL101B_ATTACK_U0000",
		//								 "atlas_GENERAL101B_ATTACK_U0001",
		//								 "atlas_GENERAL101B_ATTACK_U0002",
		//								 "atlas_GENERAL101B_ATTACK_U0003",
		//								 "atlas_GENERAL101B_ATTACK_U0004",
		//								 "atlas_GENERAL101B_ATTACK_U0005",
		//								 "atlas_GENERAL101B_ATTACK_U0006",
		//								 "atlas_GENERAL101B_ATTACK_U0007",
		//								 "atlas_GENERAL101B_ATTACK_U0008",
		//								 "atlas_GENERAL101B_ATTACK_U0009"]);
        ////clip.node.transform.rotation = 0.753;
		//
		//clip = createMovieClip(500,400, ["atlas_GENERAL101B_ATTACK_F0000",
		//								 "atlas_GENERAL101B_ATTACK_F0001",
		//								 "atlas_GENERAL101B_ATTACK_F0002",
		//								 "atlas_GENERAL101B_ATTACK_F0003",
		//								 "atlas_GENERAL101B_ATTACK_F0004",
		//								 "atlas_GENERAL101B_ATTACK_F0005",
		//								 "atlas_GENERAL101B_ATTACK_F0006",
		//								 "atlas_GENERAL101B_ATTACK_F0007",
		//								 "atlas_GENERAL101B_ATTACK_F0008",
		//								 "atlas_GENERAL101B_ATTACK_F0009"]);
        ////clip.node.transform.rotation = 0.753;
        ////clip.node.transform.setScale(2, 2);
		//
		//clip = createMovieClip(300,300, ["atlas_GENERAL101B_ATTACK_S0000",
		//								 "atlas_GENERAL101B_ATTACK_S0001",
		//								 "atlas_GENERAL101B_ATTACK_S0002",
		//								 "atlas_GENERAL101B_ATTACK_S0003",
		//								 "atlas_GENERAL101B_ATTACK_S0004",
		//								 "atlas_GENERAL101B_ATTACK_S0005",
		//								 "atlas_GENERAL101B_ATTACK_S0006",
		//								 "atlas_GENERAL101B_ATTACK_S0007",
		//								 "atlas_GENERAL101B_ATTACK_S0008",
		//								 "atlas_GENERAL101B_ATTACK_S0009"]);
		////clip.node.transform.color = 0x00FF00;
		//clip.node.transform.red = 0.5;
		//clip.node.transform.green = 0.5;
		//clip.node.transform.blue = 1.5;
        //clip.node.transform.alpha = .5;
		

        //clip = createMovieClip(300,200, ["atlas_1","atlas_2","atlas_3","atlas_4","atlas_5","atlas_6","atlas_7"]);
        //
        //clip = createMovieClip(500,200, ["atlas_1","atlas_2","atlas_3","atlas_4","atlas_5","atlas_6","atlas_7"]);
        //clip.node.transform.setScale(2,2);
        //
        //clip = createMovieClip(300,400, ["atlas_1","atlas_2","atlas_3","atlas_4","atlas_5","atlas_6","atlas_7"]);
        //clip.node.transform.rotation = 0.753;
        //
        //clip = createMovieClip(500,400, ["atlas_1","atlas_2","atlas_3","atlas_4","atlas_5","atlas_6","atlas_7"]);
        //clip.node.transform.rotation = 0.753;
        //clip.node.transform.setScale(2,2);
        //
        //clip = createMovieClip(300,300, ["atlas_1","atlas_2","atlas_3","atlas_4","atlas_5","atlas_6","atlas_7"]);
        //clip.node.transform.alpha = .5;
        //
        //clip = createMovieClip(500,300, ["atlas_1","atlas_2","atlas_3","atlas_4","atlas_5","atlas_6","atlas_7"]);
        //clip.node.transform.color = 0x00FF00;
		
		//var sprite:GSprite = cast GNodeFactory.createNodeWithComponent(GSprite);
        //sprite.texture = GTexture.getTextureById("atlas_0");
        //sprite.node.transform.setPosition(400, 300);
        //
        //sprite.node.mouseEnabled = true;
        //sprite.node.onMouseClick.add(mouseClickHandler);
        //sprite.node.onMouseOver.add(mouseOverHandler);
        //sprite.node.onMouseOut.add(mouseOutHandler);
        //sprite.node.onMouseDown.add(mouseDownHandler);
        //sprite.node.onMouseUp.add(mouseUpHandler);
        //
        //genome.root.addChild(sprite.node);
		
		var urlLoader:URLLoader = new URLLoader();
		urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
		urlLoader.addEventListener(Event.COMPLETE, g2d_completeHandler);
		//urlLoader.addEventListener(IOErrorEvent.IO_ERROR, g2d_ioErrorHandler);
		//urlLoader.load(new URLRequest("atlas.pam"));
		urlLoader.load(new URLRequest("cloud.pam"));
		JAnim.HelpCallInitialize();
    }
	
	private var anim:JAnim;
	private function g2d_completeHandler(p_event:Event):Void
	{
		var g2d_bytes:ByteArray = cast(p_event.target.data, ByteArray);
		g2d_bytes.endian = Endian.LITTLE_ENDIAN;
		g2d_bytes.position = 0;
		var callback:AnimCallback = new AnimCallback();
		var textureAltas:GTextureAtlas = GTextureAtlasFactory.createFromAssets("atlas", cast assetManager.getAssetById("atlas_gfx"), cast assetManager.getAssetById("atlas_xml"));
		var joint:JointAnimate = new JointAnimate();
		joint.LoadPam(g2d_bytes, textureAltas);
		//var anim:JAnim = new JAnim(null, joint, 0);
		anim = cast GNodeFactory.createNodeWithComponent(JAnim);
		anim.setJointAnim(joint, 0, callback);
		//anim.Play("MOVE_F");
		anim.Play("CLOUD");
		//anim.mirror = true;
		//anim.color = cast 0xAABBCCDDEE;
		//anim.filter = new GHDRPassFilter();
		//anim.transform.LoadIdentity();
		//anim.transform.Translate(100, 100);
		genome.root.addChild(anim.node);
		
		
		//var clip:GMovieClip;
        //clip = createMovieClip(500, 400, ["atlas_GENERAL101B_MOVE_F0000",
		//								  "atlas_GENERAL101B_MOVE_F0001",
		//								  "atlas_GENERAL101B_MOVE_F0002",
		//								  "atlas_GENERAL101B_MOVE_F0003",
		//								  "atlas_GENERAL101B_MOVE_F0004",
		//								  "atlas_GENERAL101B_MOVE_F0005",
		//								  "atlas_GENERAL101B_MOVE_F0006",
		//								  "atlas_GENERAL101B_MOVE_F0007",
		//								  "atlas_GENERAL101B_MOVE_F0008",
		//								  "atlas_GENERAL101B_MOVE_F0009"]);
	}
	
	private function genomeUpdateHandler(time:Float):Void
	{
		if (anim != null)
		{
			anim.Update(time * 0.1);
		}
	}
	
	private function genomeRenderHandler():Void
	{
		if (anim != null)
		{
			//anim.Draw(genome.getContext());
		}
	}

    /**
        Create a sprite helper function
     **/
    private function createSprite(p_x:Int, p_y:Int, p_textureId:String):GSprite {
        var sprite:GSprite = cast GNodeFactory.createNodeWithComponent(GSprite);
        sprite.textureId = p_textureId;
        sprite.node.transform.setPosition(p_x, p_y);
        genome.root.addChild(sprite.node);

        return sprite;
    }
	
	private function createMovieClip(p_x:Float, p_y:Float, p_frames:Array<String>):GMovieClip {
        var clip:GMovieClip = cast GNodeFactory.createNodeWithComponent(GMovieClip);
        clip.frameRate = 10;
        clip.frameTextureIds = p_frames;
        clip.node.transform.setPosition(p_x, p_y);
        genome.root.addChild(clip.node);
        return clip;
    }
	
	/**
        Mouse click handler
     **/
    private function mouseClickHandler(signal:GNodeMouseSignal):Void {
        trace("CLICK", signal.dispatcher.name, signal.target.name);
    }

    /**
        Mouse over handler
     **/
    private function mouseOverHandler(signal:GNodeMouseSignal):Void {
        trace("OVER", signal.dispatcher.name, signal.target.name);
    }

    /**
        Mouse out handler
     **/
    private function mouseOutHandler(signal:GNodeMouseSignal):Void {
        trace("OUT", signal.dispatcher.name, signal.target.name);
    }

    /**
        Mouse down handler
     **/
    private function mouseDownHandler(signal:GNodeMouseSignal):Void {
        trace("DOWN", signal.dispatcher.name, signal.target.name);
    }

    /**
        Mouse up handler
     **/
    private function mouseUpHandler(signal:GNodeMouseSignal):Void {
        trace("UP", signal.dispatcher.name, signal.target.name);
    }
}