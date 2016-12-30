package game.objects {
	import flash.display.BitmapData;

	import game.global.Game;
	import game.global.Level;
	import game.global.Score;

	import net.retrocade.collision.RetrocamelSimpleCollider;
	import net.retrocade.helpers.RetrocamelScrollAssist;
	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.core.RetrocamelSoundManager;

	public class TMonsterSlimePink extends TMonster {
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

		private var dir:int = 1;
		private var speed:Number;
		private var mY:Number = 0;

		private var jumpHold:uint = 0;

		private var isStanding:Boolean = false;

		private var blindJump:Boolean = false;

		private var randomJump:uint = 0;

		public function TMonsterSlimePink(x:uint, y:uint, speed:Number) {
			if (!framesWalk) {
				framesWalk = [];
				framesWalk[0] = RetrocamelBitmapManager.getBDExt(_gfx_, 0, 64, 16, 16);
				framesWalk[1] = RetrocamelBitmapManager.getBDExt(_gfx_, 16, 64, 16, 16);
				framesWalk[2] = RetrocamelBitmapManager.getBDExt(_gfx_, 32, 64, 16, 16);
				framesWalk[3] = RetrocamelBitmapManager.getBDExt(_gfx_, 16, 64, 16, 16);

				framesDamage = [];
				framesDamage[0] = RetrocamelBitmapManager.getBDSpecial(_gfx_, 0, 64, 16, 16, false, 0xFFFFFF);
				framesDamage[1] = RetrocamelBitmapManager.getBDSpecial(_gfx_, 16, 64, 16, 16, false, 0xFFFFFF);
				framesDamage[2] = RetrocamelBitmapManager.getBDSpecial(_gfx_, 32, 64, 16, 16, false, 0xFFFFFF);
				framesDamage[3] = RetrocamelBitmapManager.getBDSpecial(_gfx_, 16, 64, 16, 16, false, 0xFFFFFF);
			}

			jumpModeTimer = Math.random() * 100 + 1;

			dir = Math.random() < 0.5 ? 1 : -1;

			this.x = x + 2;
			this.y = y + 8;
			this.speed = speed * Score.speedMultiplier.get();

			_width = 12;
			_height = 8;

			randomJump = Math.random() * 250 + 10;

			hp = 4 * Score.healthMultiplier.get();

			addDefault();

			Level.enemies.add(this);
		}

		override public function update():void {
			super.update();

			if (jumpModeTimer-- <= 0) {
				jumpModeTimer = Math.random() * 250 + 10;
				jumpMode = !jumpMode;
			}
			jumpMode = true;

			Level.enemies.remove(this);

			if (waitDelay) {
				waitDelay--;

			} else {

				if (isStanding)
					animFrame++;

				if (mY >= 0 || blindJump)
					x += dir * speed;

				if (jumpMode && isStanding && checkForJumpable(dir == 1 ? right + 1 : x - 1, y))
					jump();

				jumpModeTimer--;

				if (jumpModeTimer <= 0) {
					jumpMode = !jumpMode;
					jumpModeTimer = Math.random() * 250 + 1;
				}

				var jumpHeight:uint = 0;

				if (!blindJump) {
					if (checkCollision(dir == 1 ? 0 : 180)) {
						if (isStanding) {
							if (checkForPit(dir == 1 ? right + 1 : x - 1, y)) {
								if ((jumpHeight = checkForJumpable(center + 16 * dir, y))) {
									jump(jumpHeight * jumpHeight);

								} else {
									dir = -dir;
									waitDelay = 10 + Math.random() * 50;
								}

							} else {
								if ((jumpHeight = checkForJumpable(center + 16 * dir, y))) {
									jump(jumpHeight * jumpHeight);

								} else {
									dir = -dir;
									waitDelay = 10 + Math.random() * 50;
								}
							}
						} else if (isStanding) {
							animFrame--;
						}

					} else {
						if (checkForPit(dir == 1 ? right + 2 : x - 2, y)) {
							if (isStanding) {
								if ((jumpHeight = checkForJumpable(center + 16 * dir, y)))
									jump(jumpHeight * jumpHeight);

								else {
									dir = -dir;
									waitDelay = 10 + Math.random() * 50;
								}
							} else {
								x -= dir * speed;
								if (isStanding)
									animFrame--;
							}
						} else if (isStanding) {
							var chasm:uint = calculateChasm(dir == 1 ? right + 1 : x - 1, y + 16);
							if (chasm > 0 && chasm < 5 && willJumpLand(chasm)) {
								blindJump = true;
								jump(chasm);
							}
						}
					}
				} else if (dir > 0)
					checkCollision(0);
				else
					checkCollision(180);
			}

			if (isStanding) {
				var bullets:Array = Level.enemies.getOverlappingRect(x - 40, y, 80 + width, height);
				for each(var b:Object in bullets) {
					if (b is TPlayerBullet) {
						jump(1);
						if (willJumpLand(1))
							blindJump = true;
						break;
					}
				}

				if (isStanding) {
					if (randomJump == 0) {
						randomJump = Math.random() * 250 + 10;
						var jumpDistance:uint = Math.random() * 9 + 1;
						if (willJumpLand(jumpDistance)) {
							jump(jumpDistance);
							blindJump = true;
						}
					} else {
						randomJump--;
					}
				}
			}


			if (jumpHold) {
				jumpHold--;
				mY = -3;
			}

			mY += 0.15;
			y += mY;

			isStanding = false;

			var pla:TPlayer = player;
			if (RetrocamelSimpleCollider.rectRect(_x, _y, _width, _height, pla.x, pla.y, pla.width, pla.height))
				pla.damage(this);

			if (mY > 0 && checkCollision(90)) {
				mY = 0;
				isStanding = true;
				blindJump = false;

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
		private function checkForJumpable(checkX:int, checkY:int):uint {
			checkX = (checkX / 16 | 0) * 16;
			checkY = (checkY / 16 | 0) * 16;

			var tempX:int = (x / 16 | 0) * 16;
			var tempY:int = (y / 16 | 0) * 16;

			var height:Number = checkY - 32;

			var jumpHeight:uint = 1;

			while (checkY >= height) {
				if (getTile(checkX, checkY) && !getTile(tempX, tempY)) {
					if (!getTile(checkX, checkY - 16) && !getTile(tempX, tempY - 16))
						return jumpHeight;
				}

				checkY -= 16;
				tempY -= 16;

				jumpHeight++
			}

			return 0;
		}

		private function willJumpLand(jumpTime:uint, forceDistance:Boolean = true):Boolean {
			const START_X:Number = x;
			const START_Y:Number = y;

			const BOTTOM:Number = RetrocamelScrollAssist.instance.edgeBottom;

			var mY:Number = 0;
			var isStanding:Boolean = false;

			while (y < BOTTOM) {
				x += dir * speed;

				if (dir > 0)
					checkCollision(0);
				else
					checkCollision(180);

				if (jumpTime) {
					jumpTime--;
					mY = -3;
				}

				mY += 0.15;
				y += mY;

				isStanding = false;

				if (mY > 0 && checkCollision(90)) {
					mY = 0;
					isStanding = true;
					break;

				} else if (mY < 0 && checkCollision(-90)) {
					mY = 0;
				}
			}

			if (forceDistance && Math.abs(START_Y - y) < 4 && Math.abs(START_X - x) < 16)
				isStanding = false;

			x = START_X;
			y = START_Y;

			return isStanding;
		}

		private function calculateChasm(x:int, y:int):uint {
			var chasm:uint = 0;

			while (!getTile(x, y) && chasm < 10) {
				chasm++;
				x += dir * 16;
			}

			return chasm;
		}

		private function jump(hold:uint = 10):void {
			if (isStanding) {
				jumpHold = hold;
				isStanding = false;
			}
		}

		override public function damage(dmg:uint, hitter:*):void {
			hp -= dmg;

			damageEffect = 5;

			makeBullet(x + 3, y + 3);
			makeBullet(x + 3, y + 3);
			if (Score.doubleChunks) {
				makeBullet(x + 3, y + 3);
				makeBullet(x + 3, y + 3);
			}

			if (hp <= 0)
				kill();
			else
				RetrocamelSoundManager.playSound(Game._blob_hit_);
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

			Score.addScore(2500);
		}

		private function makeBullet(x:Number, y:Number, dir:int = 0):void {
			if (dir == 0)
				dir = Math.random() < 0.5 ? 1 : -1;

			new TSlimeBullet(x, y, Math.random() * 1.5 * dir, -Math.random() * 2 - 0.5, 4);
		}
	}
}