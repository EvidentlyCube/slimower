package game.objects {
	import flash.display.BitmapData;

	import game.global.Game;
	import game.global.Level;
	import game.global.Score;

	import net.retrocade.helpers.RetrocamelScrollAssist;
	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.core.RetrocamelInputManager;
	import net.retrocade.retrocamel.core.RetrocamelSoundManager;
	import net.retrocade.utils.UtilsNumber;

	public class TPlayer extends TGameObject {
		[Embed(source='/../src.assets/sprites/player.png')]
		public static var _gfx_player_:Class;

		public static const X_SPEED:Number = 1;
		public static const X_MAX:Number = 1;
		public static const JUMP:Number = -3;
		public static const JUMP_HOLD:Number = 12;
		public static const GRAVITY:Number = 0.15;

		private var _gfxCurrent:BitmapData;

		private var _movX:Number = 0;
		private var _movY:Number = 0;

		private var _jumpHold:Number = 0;
		private var _canDoubleJump:Boolean = false;
		private var _preDoubleJumpRelease:Boolean = false;

		private var _shieldTime:uint = 0;

		/**
		 * If > 0 player can't move, sets to 0 on land, plus timer of white color
		 */
		private var _damaged:uint = 0;


		/**
		 * Movement animation frame counter
		 */
		private var _walkFrame:uint = 0;

		/**
		 * Whether the player is standing on the floor at the moment (or moving)
		 */
		private var _isStanding:Boolean = true;

		/**
		 * Movement direction, used for animation and shooting
		 */
		private var _walkDirection:int = 1;

		/**
		 * Delay used when firing, so it looks better
		 */
		private var _fireAnimDelay:uint = 0;

		private var _jumpSoundHelper:uint = 0;

		private var autoFireDelay:uint = 0;

		public var completing:Boolean = false;

		public function TPlayer(x:int, y:int) {
			Level.player = this;

			_width = 4;
			_height = 10;

			_x = x + 6;
			_y = y + 6;

			setGfx();

			Score.multiplier.set(1);

			RetrocamelScrollAssist.instance.setCorners(-1000, -1000, 65000, 65000);
		}

		override public function update():void {
			// X Movement calculations

			if (!_damaged && !Score.playerStop) {
				if (RetrocamelInputManager.isKeyDown(Game.keyLeft))       _movX -= X_SPEED;
				else if (RetrocamelInputManager.isKeyDown(Game.keyRight)) _movX += X_SPEED;
				else _movX = 0
			}

			if (_movX < -X_MAX) _movX = -X_MAX;
			if (_movX > X_MAX) _movX = X_MAX;

			if (Score.playerStop)
				_movX = 0;

			if (!_damaged) {
				if (_movX < 0)
					_walkDirection = -1;
				else if (_movX > 0)
					_walkDirection = 1;
			}


			// Y Movement calculations

			if (!RetrocamelInputManager.isKeyDown(Game.keyJump)) {
				_preDoubleJumpRelease = true;
				_jumpSoundHelper = 0;
			}

			if (RetrocamelInputManager.isKeyDown(Game.keyJump) && _jumpHold > 0 && !Score.playerStop) {
				_movY = JUMP;
				_jumpHold--;
				_preDoubleJumpRelease = false;
				if (_jumpSoundHelper == 0) {
					RetrocamelSoundManager.playSound(Game._jump_);
					_jumpSoundHelper = 1;
				}

			} else if (RetrocamelInputManager.isKeyDown(Game.keyJump) && _canDoubleJump && _preDoubleJumpRelease && !Score.playerStop) {
				_movY = JUMP;
				_jumpHold = JUMP_HOLD / 2;
				_canDoubleJump = false;
				_preDoubleJumpRelease = true;
				if (_jumpSoundHelper < 2) {
					RetrocamelSoundManager.playSound(Game._jump_);
					_jumpSoundHelper = 2;
				}

				var i:uint = 180;
				var colors:Array = [0xFFFF0000, 0xFFFFFF00, 0xFFDDDD00, 0xFFBBBB00, 0xFF999900, 0xFFFF88, 0xFFFF44, 0xFFCC66];
				while (i -= 6) {

					Game.partFirework.add(center, bottom, colors[Math.random() * 8 | 0], 5 + Math.random() * 15, Math.cos(i * Math.PI / 180) * Math.random() * 200, Math.sin(i * Math.PI / 180) * Math.random() * 200);
				}

			} else {
				_jumpHold = 0;
			}

			if (_movY < 0 && _jumpHold == 0)
				_movY = UtilsNumber.approach(_movY, 0, 0.25);
			else
				_movY += GRAVITY;

			if (_movY > 6)
				_movY = 6;


			if (autoFireDelay)
				autoFireDelay--;

			// Misc calculations
			var isScorePlayerStop:Boolean = Score.playerStop;
			var isMouseHit:* = (!_damaged && RetrocamelInputManager.isMouseHit());
			var isAutoFireMouseDown:* = (RetrocamelInputManager.isMouseDown() && autoFireDelay == 0);
			if (!isScorePlayerStop && (isMouseHit || isAutoFireMouseDown)) {
				autoFireDelay = 10;
				_fireAnimDelay = 16;

				new TPlayerBullet(x + (_walkDirection == 1 ? 3 : -2), y + 3, Math.atan2(RetrocamelInputManager.mouseY / 2 - y - scrollY, RetrocamelInputManager.mouseX / 2 - x - scrollX));
				RetrocamelSoundManager.playSound(Game._blaster_);
			}


			// Actual movement

			_x += _movX;
			if (checkCollision(_movX > 0 ? 0 : 180))
				_movX = 0;

			_y += _movY;

			_isStanding = false;

			if (_movY > 0 && checkCollision(90)) {
				if (_movY > 1)
					RetrocamelSoundManager.playSound(Game._footstep_);
				_movY = 0;
				_jumpHold = JUMP_HOLD;
				_canDoubleJump = true;
				_preDoubleJumpRelease = false;
				_isStanding = true;


				if (_damaged) {
					_movX = 0;
					_damaged = 0;
					_shieldTime = 60;
				}

			} else if (_movY < 0 && checkCollision(-90)) {
				_movY = 0;
				_jumpHold = 0;
			}


			// Final operations

			setGfx();

			RetrocamelScrollAssist.instance.scrollTo(x, y);
			RetrocamelScrollAssist.instance.update();

			if (_shieldTime)
				_shieldTime--;

			if (y > RetrocamelScrollAssist.instance.edgeBottom && !completing && !Score.playerStop)
				Score.playerDamaged(10);

			if (_shieldTime % 2 == 0)
				Game.lGame.draw(_gfxCurrent, x + scrollX - 6, y + scrollY - 6);
		}

		override public function draw():void {
			RetrocamelScrollAssist.instance.scrollTo(x, y);
			RetrocamelScrollAssist.instance.update();

			Game.lGame.draw(_gfxCurrent, x + scrollX - 6, y + scrollY - 6);
		}

		public function damage(object:*):void {
			if (Score.noChunkDamage && object is TSlimeBullet)
				return;

			if (completing || Score.playerStop)
				return;

			if (!_damaged && !_shieldTime) {
				RetrocamelSoundManager.playSound(Game._groan_);
				if (!Score.noPushback || object is TMonster) {
					_walkDirection = center > object.center ? -1 : 1;
					_isStanding = false;
					_canDoubleJump = false;
					_movX = -_walkDirection;
					_movY = -1;
					_fireAnimDelay = 0;

					_damaged = 8;

					_shieldTime = 500;
				} else {
					_damaged = 0;

					_shieldTime = 60;
				}

				Score.playerDamaged(1);
			}
		}


		/* INTERNALS */

		private function setGfx():void {
			var animX:uint = 0;
			var animY:uint = 0;

			if (_fireAnimDelay > 0) {
				_fireAnimDelay--;
				animY = 16;
			}

			if (_isStanding) {
				if (_movX == 0) {
					animX = 0;
					_walkFrame = 0;

				} else {
					_walkFrame = (_walkFrame + 1) % 30;
					animX = 16 * (_walkFrame / 3 | 0) + 32;
				}

			} else {
				animX = 16;
				_walkFrame = 0;
			}

			if (_damaged > 1)
				_damaged--;

			_gfxCurrent = RetrocamelBitmapManager.getBDSpecial(_gfx_player_, animX, animY, 16, 16, _walkDirection == -1, _damaged > 1 ? 0xFFFFFF : 0);
		}

		override public function get center():Number {
			return _x + _width / 2 | 0;
		}

		override public function get middle():Number {
			return _y + _height / 2 | 0;
		}
	}
}