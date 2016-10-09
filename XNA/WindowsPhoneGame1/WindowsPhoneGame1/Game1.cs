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

namespace WindowsPhoneGame1
{
	/// <summary>
	/// 这是游戏的主类型
	/// </summary>
	public class Game1 : Microsoft.Xna.Framework.Game
	{
		GraphicsDeviceManager graphics;
		SpriteBatch spriteBatch;

        // Model stuff
        ModelManager modelManager;

        // Camera
        public Camera camera { get; protected set; }

        // Random number generator
        public Random random { get; protected set; }

        // Textures
        Texture2D attackTexture;

        // Audio
        SoundEffect shotSound;

		public Game1()
		{
            // Initialize random number generator
            random = new Random();

			graphics = new GraphicsDeviceManager(this);
			Content.RootDirectory = "Content";

			// Windows Phone 的默认帧速率为 30 fps。
			TargetElapsedTime = TimeSpan.FromTicks(333333);

			// 延长锁定时的电池寿命。
			InactiveSleepTime = TimeSpan.FromSeconds(1);

            // Force the game to stay at landscape left
            graphics.SupportedOrientations = DisplayOrientation.LandscapeLeft;
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
            // Initialize Camera
            camera = new Camera(this);
            Components.Add(camera);

            // Initialize model manager
            modelManager = new ModelManager(this);
            Components.Add(modelManager);

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
            // Load textures
            attackTexture = Content.Load<Texture2D>(@"textures\attack");

            // Load audio
            shotSound = Content.Load<SoundEffect>(@"audio\shot");
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
            // Did the user press the attack button on the touch panel?
            TouchCollection touchCollection = TouchPanel.GetState();
            foreach (TouchLocation touchLocation in touchCollection)
            {
                if (touchLocation.State == TouchLocationState.Pressed &&
                    GetAttackTextureRect().Contains(
                    new Point((int)touchLocation.Position.X, (int)touchLocation.Position.Y)))
                {
                    shotSound.Play();
                    modelManager.FireShot();
                }
            }

			base.Update(gameTime);
		}

        protected Rectangle GetAttackTextureRect()
        {
            return new Rectangle(
                graphics.PreferredBackBufferWidth - attackTexture.Width - 10,
                graphics.PreferredBackBufferHeight - attackTexture.Height - 10,
                attackTexture.Width,
                attackTexture.Height);
        }

		/// <summary>
		/// 当游戏该进行自我绘制时调用此项。
		/// </summary>
		/// <param name="gameTime">提供计时值的快照。</param>
		protected override void Draw(GameTime gameTime)
		{
			GraphicsDevice.Clear(Color.CornflowerBlue);

			// TODO: 在此处添加绘图代码
            spriteBatch.Begin();
			
			// Draw the attack texture on the screen
            spriteBatch.Draw(attackTexture,
                GetAttackTextureRect(),
                Color.White);

            spriteBatch.End();

            ResetGraphicsDevice();
			
			base.Draw(gameTime);
		}

        private void ResetGraphicsDevice()
        {
            GraphicsDevice.BlendState = BlendState.Opaque;
            GraphicsDevice.DepthStencilState = DepthStencilState.Default;
            GraphicsDevice.RasterizerState = RasterizerState.CullCounterClockwise;
            GraphicsDevice.SamplerStates[0] = SamplerState.LinearWrap;
        }
	}
}
