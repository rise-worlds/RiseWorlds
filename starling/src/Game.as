package
{
	import starling.core.Starling;
    import starling.display.*;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
    import starling.utils.Color;
	import starling.text.TextField;
 
    public class Game extends Sprite
    {
		[Embed(source = "../assets/atlas.xml", mimeType="application/octet-stream")]
		public static const AtlasXml:Class;
		[Embed(source = "../assets/atlas.png")]
		public static const AtlasTexture:Class;
		
        public function Game()
        {
            var quad:Quad = new Quad(200, 200, Color.RED);
            quad.x = 100;
            quad.y = 50;
            addChild(quad);
			//var image:Image = new Image(texture);
			var textField:TextField = new TextField(200, 50, "Hello World");
			//sprite.addChild(image);
			addChild(textField);
			
			var texture:Texture = Texture.fromBitmap(new AtlasTexture);
			var xml:XML = XML(new AtlasXml);
			var atlas:TextureAtlas = new TextureAtlas(texture, xml);
			
			var movie:MovieClip = new MovieClip(atlas.getTextures("flight_"), 5);
			movie.loop = true;
			addChild(movie);
			
			movie.play();
			Starling.juggler.add(movie);
		}
    }
}