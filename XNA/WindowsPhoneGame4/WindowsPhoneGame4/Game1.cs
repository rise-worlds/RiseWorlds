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
using Microsoft.Devices.Sensors;

namespace WindowsPhoneGame4
{
    /// <summary>
    /// 这是游戏的主类型
    /// </summary>
    public class Game1 : Microsoft.Xna.Framework.Game
    {
        GraphicsDeviceManager graphics;
        SpriteBatch spriteBatch;

        Texture2D skullTexture;
        Point skullFrameSize = new Point(75, 75);
        Point skullCurrentFrame = new Point(0, 0);
        Point skullSheetSize = new Point(6, 8);
        int skullTimeSinceLastFrame = 0;
        const int skullMillisecondsPerFrame = 50;

        Texture2D ringsTexture;
        Point ringsFrameSize = new Point(75, 75);
        Point ringsCurrentFrame = new Point(0, 0);
        Point ringsSheetSize = new Point(6, 8);
        int ringsTimeSinceLastFrame = 0;
        const int ringsMillisecondsPerFrame = 50;
        Vector2 ringsPosition = Vector2.Zero;

        Accelerometer accelerometer;
        Vector2 accelerometerData = new Vector2();

        public Game1()
        {
            graphics = new GraphicsDeviceManager(this);
            Content.RootDirectory = "Content";

            graphics.PreferredBackBufferWidth = 480;
            graphics.PreferredBackBufferHeight = 800;

            // Windows Phone 的默认帧速率为 30 fps。
            TargetElapsedTime = TimeSpan.FromTicks(333333);

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
            accelerometer = new Accelerometer();
            accelerometer.CurrentValueChanged += accelerometer_CurrentValueChanged;
            accelerometer.Start();

            Viewport viewport = graphics.GraphicsDevice.Viewport;
            ringsPosition = new Vector2((viewport.Width - ringsFrameSize.X) / 2, (viewport.Height - ringsFrameSize.Y) / 2);

            base.Initialize();
        }

        private void accelerometer_CurrentValueChanged(object sender, SensorReadingEventArgs<AccelerometerReading> e)
        {
            accelerometerData.X += (float)e.SensorReading.Acceleration.X;
            accelerometerData.Y += -(float)e.SensorReading.Acceleration.Y;
            ringsPosition += accelerometerData;
        }

        /// <summary>
        /// 对于每个游戏会调用一次 LoadContent，
        /// 用于加载所有内容。
        /// </summary>
        protected override void LoadContent()
        {
            // 创建新的 SpriteBatch，可将其用于绘制纹理。
            spriteBatch = new SpriteBatch(GraphicsDevice);
            // 帧率计数器
            Components.Add(new FrameRateCounter(this, spriteBatch));

            // TODO: 在此处使用 this.Content 加载游戏内容
            skullTexture = Content.Load<Texture2D>(@"images\skullball");
            ringsTexture = Content.Load<Texture2D>(@"images\threerings");
        }

        /// <summary>
        /// 对于每个游戏会调用一次 UnloadContent，
        /// 用于取消加载所有内容。
        /// </summary>
        protected override void UnloadContent()
        {
            // TODO: 在此处取消加载任何非 ContentManager 内容
            accelerometer.Stop();
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
            Viewport viewport = graphics.GraphicsDevice.Viewport;

            skullTimeSinceLastFrame += gameTime.ElapsedGameTime.Milliseconds;
            if (skullTimeSinceLastFrame > skullMillisecondsPerFrame)
            {
                ++skullCurrentFrame.X;
                if (skullCurrentFrame.X >= skullSheetSize.X)
                {
                    skullCurrentFrame.X = 0;
                    ++skullCurrentFrame.Y;
                    if (skullCurrentFrame.Y >= skullSheetSize.Y)
                    {
                        skullCurrentFrame.Y = 0;
                    }
                }
                skullTimeSinceLastFrame = 0;
            }

            ringsTimeSinceLastFrame += gameTime.ElapsedGameTime.Milliseconds;
            if (ringsTimeSinceLastFrame > ringsMillisecondsPerFrame)
            {
                ++ringsCurrentFrame.X;
                if (ringsCurrentFrame.X >= ringsSheetSize.X)
                {
                    ringsCurrentFrame.X = 0;
                    ++ringsCurrentFrame.Y;
                    if (ringsCurrentFrame.Y >= ringsSheetSize.Y)
                    {
                        ringsCurrentFrame.Y = 0;
                    }
                }
                ringsTimeSinceLastFrame = 0;
            }
            if (ringsPosition.X < 0)
            {
                ringsPosition.X = 0;
                accelerometerData.X = 0;
            }
            else if (ringsPosition.X > viewport.Width - ringsFrameSize.X)
            {
                ringsPosition.X = viewport.Width - ringsFrameSize.X;
                accelerometerData.X = 0;
            }
            if (ringsPosition.Y < 0)
            {
                ringsPosition.Y = 0;
                accelerometerData.Y = 0;
            }
            else if (ringsPosition.Y > viewport.Height - ringsFrameSize.Y)
            {
                ringsPosition.Y = viewport.Height - ringsFrameSize.Y;
                accelerometerData.Y = 0;
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

            spriteBatch.Draw(skullTexture,
                new Vector2(0, 100),
                new Rectangle(skullCurrentFrame.X * skullFrameSize.X, skullCurrentFrame.Y * skullFrameSize.Y, skullFrameSize.X, skullFrameSize.Y)
                , Color.White, 0, Vector2.Zero, 1, SpriteEffects.None, 0);

            spriteBatch.Draw(ringsTexture,
                ringsPosition,
                new Rectangle(ringsCurrentFrame.X * ringsFrameSize.X, ringsCurrentFrame.Y * ringsFrameSize.Y, ringsFrameSize.X, ringsFrameSize.Y)
                , Color.White, 0, Vector2.Zero, 1, SpriteEffects.None, 0);

            spriteBatch.End();

            base.Draw(gameTime);
        }
    }
}
