package game.objects {
	import flash.display.BitmapData;

	import game.global.Game;
	import game.global.Level;
	import game.global.Score;

	import net.retrocade.collision.RetrocamelSimpleCollider;
	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.core.RetrocamelSoundManager;

	public class TMonsterSlimeRed extends TMonster {
		[Embed(source="/../src.assets/sprites/blobs.png")]
		public static var _gfx_:Class;

		private static var framesWalk:Array;
		private static var framesDamage:Array;

		private var animFrame:uint = 0;

		private var state:uint = 0;
		private var waitDelay:uint = 0;

		private var speed:Number;
		private var mY:Number = 0;
		private var isStanding:Boolean = false;

		private var damageEffect:uint = 0;

		public function TMonsterSlimeRed(x:uint, y:uint, speed:Number) {
			if (!framesWalk) {
				framesWalk = [];
				framesWalk[0] = RetrocamelBitmapManager.getBDExt(_gfx_, 0, 48, 16, 16);
				framesWalk[1] = RetrocamelBitmapManager.getBDExt(_gfx_, 16, 48, 16, 16);
				framesWalk[2] = RetrocamelBitmapManager.getBDExt(_gfx_, 32, 48, 16, 16);
				framesWalk[3] = RetrocamelBitmapManager.getBDExt(_gfx_, 16, 48, 16, 16);

				framesDamage = [];
				framesDamage[0] = RetrocamelBitmapManager.getBDSpecial(_gfx_, 0, 48, 16, 16, false, 0xFFFFFF);
				framesDamage[1] = RetrocamelBitmapManager.getBDSpecial(_gfx_, 16, 48, 16, 16, false, 0xFFFFFF);
				framesDamage[2] = RetrocamelBitmapManager.getBDSpecial(_gfx_, 32, 48, 16, 16, false, 0xFFFFFF);
				framesDamage[3] = RetrocamelBitmapManager.getBDSpecial(_gfx_, 16, 48, 16, 16, false, 0xFFFFFF);
			}

			this.x = x + 2;
			this.y = y + 8;
			this.speed = speed * Score.speedMultiplier.get();

			_width = 12;
			_height = 8;

			hp = 2 * Score.healthMultiplier.get();

			addDefault();

			Level.enemies.add(this);
		}

		override public function update():void {
			super.update();
			Level.enemies.remove(this);
			if (isStanding) {
				switch (state) {
					case(0): // Turn towards player
						if (Level.player) {
							if (Level.player.center > center)
								state = 1;
							else
								state = 2;
						}
						break;

					case(1): // Walk right
						x += speed;
						animFrame++;

						if (checkCollision(0) || Math.random() < 0.001)
							state = 3;
						else if (!getTile(right + 1, y + 16)) {
							state = 3;
							x -= speed;
							animFrame--;
						}
						break;

					case(2): // Walk left

						x -= speed;
						animFrame++;

						if (checkCollision(180) || Math.random() < 0.001)
							state = 3;
						else if (!getTile(x - 1, y + 16)) {
							state = 3;
							x += speed;
							animFrame--;
						}
						break;

					case(3): // Set wait time to a random number
						waitDelay = 5 + Math.random() * 45;
						state = 4;
						break;

					case(4): // AAAAAA I AM THINKING WHERE TO GOOOOO
						waitDelay--;
						if (waitDelay <= 0)
							state = Math.random() > 0.5 ? 2 : 1;
						break;
				}
			}

			var pla:TPlayer = player;
			if (RetrocamelSimpleCollider.rectRect(_x, _y, _width, _height, pla.x, pla.y, pla.width, pla.height))
				pla.damage(this);

			var bullets:Array = Level.enemies.getOverlappingRect(x - 40, y, 80 + width, height);
			for each(var b:Object in bullets) {
				if (b is TPlayerBullet) {
					jump();
					break;
				}
			}

			mY += 0.15;
			y += mY;

			isStanding = false;

			if (mY >= 0 && checkCollision(90)) {
				mY = 0;
				isStanding = true;

			} else if (mY < 0 && checkCollision(-90)) {
				mY = 0;
			}
			Level.enemies.add(this);

			if (animFrame >= 20) animFrame -= 20;

			if (damageEffect) {
				damageEffect--;
				Game.lGame.draw(framesDamage[animFrame / 5 | 0], x + scrollX - 2, y + scrollY - 8);
			} else {
				Game.lGame.draw(framesWalk[animFrame / 5 | 0], x + scrollX - 2, y + scrollY - 8);
			}
		}

		override public function draw():void {
			if (damageEffect) {
				Game.lGame.draw(framesDamage[animFrame / 5 | 0], x + scrollX - 2, y + scrollY - 8);
			} else {
				Game.lGame.draw(framesWalk[animFrame / 5 | 0], x + scrollX - 2, y + scrollY - 8);
			}
		}

		override public function damage(dmg:uint, hitter:*):void {
			hp -= dmg;

			damageEffect = 5;

			if (hp <= 0)
				kill();
			else
				RetrocamelSoundManager.playSound(Game._blob_hit_);
		}

		private function jump():void {
			if (isStanding) {
				mY = -3;
				var dir:int = Level.player.center > center ? 1 : -1;
				makeBullet(x + 3, y + 3, dir);
				if (Score.doubleChunks) {
					makeBullet(x + 3, y + 3, dir);
				}

				isStanding = false;
			}
		}

		override protected function kill():void {
			RetrocamelSoundManager.playSound(Game._blob_kill_);

			var gfx:BitmapData = framesWalk[animFrame / 5 | 0];
			var jump:int = Math.random() * -60;
			for (var i:uint = 0; i < 16; i++) {
				for (var j:uint = 0; j < 16; j++) {
					Game.partFirework.add(_x + i - 2, _y + j - 8, gfx.getPixel32(i, j), 200, 0, jump);
				}
			}

			makeBullet(x + 3, y + 3);
			makeBullet(x + 4, y + 3);
			makeBullet(x + 5, y + 3);
			makeBullet(x + 3, y + 4);
			if (Score.doubleChunks) {
				makeBullet(x + 4, y + 4);
				makeBullet(x + 5, y + 4);
				makeBullet(x + 3, y + 5);
				makeBullet(x + 4, y + 5);
			}

			nullifyDefault();
			Level.enemies.remove(this);

			super.kill();

			Score.addScore(2000);
		}

		private function makeBullet(x:Number, y:Number, dir:int = 0):void {
			if (dir == 0)
				dir = Math.random() < 0.5 ? 1 : -1;

			new TSlimeBullet(x, y, Math.random() * 1.5 * dir, -Math.random() * 1.5 - 0.5, 3);
		}
	}
}