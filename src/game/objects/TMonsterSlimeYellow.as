package game.objects {
	import flash.display.BitmapData;

	import game.global.Game;
	import game.global.Level;
	import game.global.Score;

	import net.retrocade.collision.RetrocamelSimpleCollider;
	import net.retrocade.helpers.RetrocamelScrollAssist;
	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.core.RetrocamelSoundManager;

	public class TMonsterSlimeYellow extends TMonster {
		[Embed(source="/../src.assets/sprites/blobs.png")]
		public static var _gfx_:Class;

		private static var framesWalk:Array;
		private static var framesDamage:Array;

		private var animFrame:int = 0;

		private var state:uint = 0;
		private var waitDelay:uint = 0;

		private var damageEffect:uint = 0;

		private var jumpMode:Boolean = false;
		private var jumpModeTimer:int = 0;

		private var speed:Number;
		private var dir:int = 1;
		private var mY:Number = 0;

		private var jumpHold:uint = 0;

		private var isStanding:Boolean = false;

		public function TMonsterSlimeYellow(x:uint, y:uint, speed:Number) {
			if (!framesWalk) {
				framesWalk = [];
				framesWalk[0] = RetrocamelBitmapManager.getBDExt(_gfx_, 0, 32, 16, 16);
				framesWalk[1] = RetrocamelBitmapManager.getBDExt(_gfx_, 16, 32, 16, 16);
				framesWalk[2] = RetrocamelBitmapManager.getBDExt(_gfx_, 32, 32, 16, 16);
				framesWalk[3] = RetrocamelBitmapManager.getBDExt(_gfx_, 16, 32, 16, 16);

				framesDamage = [];
				framesDamage[0] = RetrocamelBitmapManager.getBDSpecial(_gfx_, 0, 32, 16, 16, false, 0xFFFFFF);
				framesDamage[1] = RetrocamelBitmapManager.getBDSpecial(_gfx_, 16, 32, 16, 16, false, 0xFFFFFF);
				framesDamage[2] = RetrocamelBitmapManager.getBDSpecial(_gfx_, 32, 32, 16, 16, false, 0xFFFFFF);
				framesDamage[3] = RetrocamelBitmapManager.getBDSpecial(_gfx_, 16, 32, 16, 16, false, 0xFFFFFF);
			}

			jumpModeTimer = Math.random() * 100 + 1;

			dir = Math.random() < 0.5 ? 1 : -1;

			this.x = x + 2;
			this.y = y + 8;
			this.speed = speed * Score.speedMultiplier.get();

			_width = 12;
			_height = 8;

			hp = 5 * Score.healthMultiplier.get();

			addDefault();

			Level.enemies.add(this);
		}

		override public function update():void {
			if (jumpModeTimer-- <= 0) {
				jumpModeTimer = Math.random() * 250 + 10;
				jumpMode = !jumpMode;
			}

			Level.enemies.remove(this);

			if (waitDelay) {
				waitDelay--;

			} else {

				if (isStanding)
					animFrame++;

				if (mY >= 0)
					x += dir * speed;

				if (jumpMode && isStanding && checkForJumpable(dir == 1 ? right + 1 : x - 1, y))
					jump();

				jumpModeTimer--;

				if (jumpModeTimer <= 0) {
					jumpMode = !jumpMode;
					jumpModeTimer = Math.random() * 250 + 1;
				}

				if (checkCollision(dir == 1 ? 0 : 180)) {
					if (isStanding) {
						if (checkForPit(dir == 1 ? right + 1 : x - 1, y)) {
							if (checkForJumpable(x + 16 * dir, y)) {
								jump();

							} else {
								dir = -dir;
								waitDelay = 10 + Math.random() * 50;
							}

						} else {
							if (checkForJumpable(x + 16 * dir, y)) {
								jump();
							} else {
								dir = -dir;
								waitDelay = 10 + Math.random() * 50;
							}
						}
					} else if (isStanding) {
						animFrame--;
					}

				} else {
					if (checkForPit(dir == 1 ? right + 1 : x - 1, y)) {
						if (isStanding) {
							if (checkForJumpable(x + 16 * dir, y))
								jump();

							else {
								dir = -dir;
								waitDelay = 10 + Math.random() * 50;
							}
						} else {
							x -= dir * speed;
							if (isStanding)
								animFrame--;
						}
					}
				}
			}

			var pla:TPlayer = player;
			if (RetrocamelSimpleCollider.rectRect(_x, _y, _width, _height, pla.x, pla.y, pla.width, pla.height))
				pla.damage(this);

			if (jumpHold) {
				jumpHold--;
				mY = -3;
			}

			mY += 0.15;
			y += mY;

			isStanding = false;

			if (mY > 0 && checkCollision(90)) {
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

		/**
		 * Returns true when pit found, otherwise false
		 */
		private function checkForPit(x:int, y:int):Boolean {
			x = (x / 16 | 0) * 16;
			y = (y / 16 | 0) * 16;

			var height:Number = RetrocamelScrollAssist.instance.edgeBottom;

			while (y < height) {
				if (getTile(x, y))
					return false;

				y += 16;
			}

			return true;
		}

		/**
		 * Returns true when jumping will let you land somewhere higher
		 */
		private function checkForJumpable(checkX:int, checkY:int):Boolean {
			checkX = (checkX / 16 | 0) * 16;
			checkY = (checkY / 16 | 0) * 16;

			var tempX:int = (x / 16 | 0) * 16;
			var tempY:int = (y / 16 | 0) * 16;

			var height:Number = checkY - 32;

			while (checkY >= height) {
				if (getTile(checkX, checkY) && !getTile(tempX, tempY)) {
					if (!getTile(checkX, checkY - 16) && !getTile(tempX, tempY - 16))
						return true;
				}

				checkY -= 16
				tempY -= 16;
			}

			return false;
		}

		private function jump():void {
			if (isStanding) {
				jumpHold = 10;
				isStanding = false;
			}
		}

		override public function damage(dmg:uint, hitter:*):void {
			hp -= dmg;

			damageEffect = 5;

			var dir:int = player.center > center ? 1 : -1;

			makeBullet(x + 3, y + 3, dir);

			if (Score.doubleChunks) {
				makeBullet(x + 3, y + 3, dir);
			}

			if (hp <= 0)
				kill();
			else
				RetrocamelSoundManager.playSound(Game._blob_hit_);
		}

		override protected function kill():void {
			super.update();

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
			Score.addScore(1800);
		}

		private function makeBullet(x:Number, y:Number, dir:int = 0):void {
			if (dir == 0)
				dir = Math.random() < 0.5 ? 1 : -1;

			new TSlimeBullet(x, y, Math.random() * 0.95 * dir, -Math.random() * 4 - 0.5, 2);
		}
	}
}