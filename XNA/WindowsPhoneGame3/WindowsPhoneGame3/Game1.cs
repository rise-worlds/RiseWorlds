using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Audio;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.GamerServices;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework.Input.Touch;
using Microsoft.Xna.Framework.Media;
using System.ComponentModel;

namespace WindowsPhoneGame3
{
	/// <summary>
	/// 这是游戏的主类型
	/// </summary>
	public class Game1 : Microsoft.Xna.Framework.Game
	{
		GraphicsDeviceManager graphics;
		SpriteBatch spriteBatch;
		Texture2D texture;
		Point frameSize = new Point(75, 75);
		Point currentFrame = new Point(0, 0);
		Point sheetSize = new Point(6, 8);
		int timeSinceLastFrame = 0;
		int milliseocndsPerFrame = 30;
		Vector2 pos = Vector2.Zero;
		Vector2 speed = new Vector2(5, 3);

		public Game1()
		{
			graphics = new GraphicsDeviceManager(this);
			Content.RootDirectory = "Content";
			graphics.PreferredBackBufferHeight = 480;	//创建一个画面高度为480的屏幕
			graphics.PreferredBackBufferWidth = 800;	//创建一个画面宽度为800的屏幕

			// Windows Phone 的默认帧速率为 30 fps。
			//TargetElapsedTime = TimeSpan.FromTicks(333333);				// 30 fps
			TargetElapsedTime = TimeSpan.FromTicks(166666);				// 60 fps
			//TargetElapsedTime = new System.TimeSpan(0, 0, 0, 0, 33);	// 30 fps
			//TargetElapsedTime = TimeSpan.FromMilliseconds(16);			// 60 fps

			// 延长锁定时的电池寿命。
			InactiveSleepTime = TimeSpan.FromSeconds(1);
		}

		/// <summary>
		/// 允许游戏在开始运行之前执行其所需的任何初始化。
		/// 游戏能够在此时查询任何所需服务并加载任何非图形
		/// 相关的内容。调用 base.Initialize 将枚举所有组件
		/// 并对其进行初始化。 
		/// </summary>
		protected override void Initialize()
		{
			// TODO: 在此处添加初始化逻辑

			base.Initialize();
		}

		/// <summary>
		/// 对于每个游戏会调用一次 LoadContent，
		/// 用于加载所有内容。
		/// </summary>
		protected override void LoadContent()
		{
			// 创建新的 SpriteBatch，可将其用于绘制纹理。
			spriteBatch = new SpriteBatch(GraphicsDevice);
			
			// TODO: 在此处使用 this.Content 加载游戏内容
			Components.Add(new FrameRateCounter(this, spriteBatch));
			texture = Content.Load<Texture2D>(@"Images\threerings");
		}

		/// <summary>
		/// 对于每个游戏会调用一次 UnloadContent，
		/// 用于取消加载所有内容。
		/// </summary>
		protected override void UnloadContent()
		{
			// TODO: 在此处取消加载任何非 ContentManager 内容
		}

		/// <summary>
		/// 允许游戏运行逻辑，例如更新全部内容、
		/// 检查冲突、收集输入信息以及播放音频。
		/// </summary>
		/// <param name="gameTime">提供计时值的快照。</param>
		protected override void Update(GameTime gameTime)
		{
			// 允许游戏退出
			if (GamePad.GetState(PlayerIndex.One).Buttons.Back == ButtonState.Pressed)
				this.Exit();

			// TODO: 在此处添加更新逻辑
			timeSinceLastFrame += gameTime.ElapsedGameTime.Milliseconds;
			if (timeSinceLastFrame > milliseocndsPerFrame)
			{
				++currentFrame.X;
				if (currentFrame.X >= sheetSize.X)
				{
					currentFrame.X = 0;
					++currentFrame.Y;
					if (currentFrame.Y >= sheetSize.Y)
					{
						currentFrame.Y = 0;
					}
				}
				timeSinceLastFrame = 0;
			}

			pos.X += speed.X;
			if (pos.X > Window.ClientBounds.Height - 75 || pos.X < 0)
			{
				speed.X *= -1;
			}
			pos.Y += speed.Y;
			if (pos.Y > Window.ClientBounds.Width - 75 || pos.Y < 0)
			{
				speed.Y *= -1;
			}

			base.Update(gameTime);
		}

		/// <summary>
		/// 当游戏该进行自我绘制时调用此项。
		/// </summary>
		/// <param name="gameTime">提供计时值的快照。</param>
		protected override void Draw(GameTime gameTime)
		{
			GraphicsDevice.Clear(Color.CornflowerBlue);

			// TODO: 在此处添加绘图代码
			spriteBatch.Begin(SpriteSortMode.FrontToBack, BlendState.AlphaBlend);

			spriteBatch.Draw(texture,
				pos, //new Vector2((Window.ClientBounds.Height - 75) / 2, (Window.ClientBounds.Width - 75) / 2), //Vector2.Zero,
				new Rectangle(currentFrame.X * frameSize.X, currentFrame.Y * frameSize.Y, frameSize.X, frameSize.Y)
				, Color.White, 0, Vector2.Zero, 1, SpriteEffects.None, 0);

			spriteBatch.End();

			base.Draw(gameTime);
		}
	}
}
