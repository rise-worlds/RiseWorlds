using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Audio;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.GamerServices;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework.Media;


namespace WindowsPhoneGame3
{
	/// <summary>
	/// 这是一个实现 IUpdateable 的游戏组件。
	/// </summary>
	public class FrameRateCounter : Microsoft.Xna.Framework.DrawableGameComponent
	{
		ContentManager content;
		SpriteBatch spriteBatch;
		SpriteFont spriteFont;

		int frameRate = 0;
		int frameCounter = 0;
		TimeSpan elapsedTime = TimeSpan.Zero;

		public FrameRateCounter(Game game, SpriteBatch spriteBatch)
			: base(game)
		{
			// TODO: 在此处构造任何子组件
			content = new ContentManager(game.Services);
			LoadGraphicsContent(true);
			this.spriteBatch = spriteBatch;
		}

		/// <summary>
		/// 允许游戏组件在开始运行之前执行其所需的任何初始化。
		/// 游戏组件能够在此时查询任何所需服务和加载内容。
		/// </summary>
		public override void Initialize()
		{
			// TODO: 在此处添加初始化代码

			base.Initialize();
		}

		protected void LoadGraphicsContent(bool loadAllContent)
		{
			if (loadAllContent)
			{
				spriteFont = content.Load<SpriteFont>(@"Content\HudFont");   // 指定SpriteFont
			}
		}

		/// <summary>
		/// 允许游戏组件进行自我更新。
		/// </summary>
		/// <param name="gameTime">提供计时值的快照。</param>
		public override void Update(GameTime gameTime)
		{
			// TODO: 在此处添加更新代码
			elapsedTime += gameTime.ElapsedGameTime;

			if (elapsedTime > TimeSpan.FromSeconds(1))
			{
				elapsedTime -= TimeSpan.FromSeconds(1);
				frameRate = frameCounter;
				frameCounter = 0;
			}

			//base.Update(gameTime);
		}

		/// <summary>
		/// 当游戏该进行自我绘制时调用此项。
		/// </summary>
		/// <param name="gameTime">提供计时值的快照。</param>
		public override void Draw(GameTime gameTime)
		{
			frameCounter++;

			string fps = string.Format("FPS: {0}", frameRate);

			spriteBatch.Begin();

			spriteBatch.DrawString(spriteFont, fps, new Vector2(20, 20), Color.White);    // 坐标根据需要自行修改

			spriteBatch.End();
		}
	}
}
