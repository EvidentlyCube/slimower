package game.objects {
	import flash.display.BitmapData;

	import game.global.Game;
	import game.global.Score;

	import net.retrocade.collision.RetrocamelSimpleCollider;
	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.core.RetrocamelSoundManager;
	import net.retrocade.utils.UtilsNumber;

	public class TCoin extends TGameObject {
		[Embed(source="/../src.assets/sprites/coin.png")]
		public static var _gfx_:Class;

		private static var _frames:Array;

		private static const NEXT_FRAME_ON:uint = 6;

		private var _frame:uint = 0;
		private var _frameTimer:Number = 0;
		private var _animSpeed:Number = 0;

		public function TCoin(x:uint, y:uint) {
			if (!_frames) {
				_frames = [];
				_frames[0] = RetrocamelBitmapManager.getBDExt(_gfx_, 0, 0, 8, 8);
				_frames[1] = RetrocamelBitmapManager.getBDExt(_gfx_, 8, 0, 8, 8);
				_frames[2] = RetrocamelBitmapManager.getBDExt(_gfx_, 16, 0, 8, 8);
				_frames[3] = RetrocamelBitmapManager.getBDExt(_gfx_, 24, 0, 8, 8);
				_frames[4] = RetrocamelBitmapManager.getBDExt(_gfx_, 32, 0, 8, 8);
				_frames[5] = RetrocamelBitmapManager.getBDExt(_gfx_, 40, 0, 8, 8);
			}

			_x = x;
			_y = y;
			_width = 8;
			_height = 8;

			_frame = Math.random() * 6;
			_animSpeed = 1 + Math.random() * 0.2 - Math.random() * 0.2;
			_frameTimer = Math.random() * 10;

			addDefault();
		}

		override public function update():void {
			var pla:TPlayer = player;
			if (RetrocamelSimpleCollider.rectRect(_x, _y, _width, _height, pla.x, pla.y, pla.width, pla.height))
				collected();

			_frameTimer += _animSpeed;
			if (_frameTimer >= NEXT_FRAME_ON) {
				_frameTimer -= NEXT_FRAME_ON;
				_frame = (++_frame) % 6;
			}

			Game.lGame.draw(_frames[_frame], _x + scrollX, _y + scrollY);

		}

		override public function draw():void {
			Game.lGame.draw(_frames[_frame], _x + scrollX, _y + scrollY);
		}

		private function collected():void {
			RetrocamelSoundManager.playSound(Game._coin_);
			var gfx:BitmapData = _frames[_frame]
			var jump:int = Math.random() * -60 - 50;
			for (var i:uint = 0; i < 16; i++) {
				for (var j:uint = 0; j < 16; j++) {
					Game.partFirework.add(_x + i, _y + j, gfx.getPixel32(i, j), Math.random() * 30, UtilsNumber.randomWaved(0, 150), UtilsNumber.randomWaved(0, 150));
				}
			}

			Score.addScore(100);

			nullifyDefault();
		}
	}
}