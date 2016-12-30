package game.objects {
	import game.global.Game;

	import net.retrocade.collision.RetrocamelSimpleCollider;
	import net.retrocade.helpers.RetrocamelScrollAssist;
	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;

	public class TSlimeBullet extends TGameObject {
		[Embed("/../src.assets/sprites/blobBullet.png")]
		public static var _gfx_:Class;

		public function get dir():int {
			return mX > 0 ? 1 : -1;
		}

		private var mX:Number;
		private var mY:Number;

		private var color:uint = 0;
		private var timer:uint = 35;

		private var dead:Boolean = false;

		public function TSlimeBullet(x:uint, y:uint, mX:Number, mY:Number, color:uint) {
			this.x = x;
			this.y = y;
			this.mX = mX;
			this.mY = mY;
			this.color = color;

			addAtDefault(0);

			setGfx(Math.random() * 4 | 0);
		}

		override public function update():void {
			if (!dead) {
				x += mX;
				if (checkCollision(mX > 0 ? 0 : 180))
					mX = 0;

				y += mY += 0.1;
				if (mY > 0 && checkCollision(90))
					dead = true;
				else if (mY < 0 && checkCollision(-90))
					mY = -mY;

				var p:TPlayer = player;
				if (p && RetrocamelSimpleCollider.rectRect(_x, _y, _width, _height, p.x, p.y, p.width, p.height)) {
					p.damage(this);
					kill();
				}

				if (y > 2000)
					kill();
			} else {
				var scroller:RetrocamelScrollAssist = RetrocamelScrollAssist.instance;
				if (!RetrocamelSimpleCollider.rectRect(_x, _y, _width, _height, scroller.x, scroller.y, S().SIZE_LEVEL_WIDTH, S().SIZE_LEVEL_HEIGHT))
					kill();
			}

			Game.lGame.draw(_gfx, x + scrollX, y + scrollY);
		}

		override public function draw():void {
			Game.lGame.draw(_gfx, x + scrollX, y + scrollY);
		}

		private function kill():void {
			nullifyDefault();
		}

		private function setGfx(id:uint):void {
			switch (id) {
				case(0):
					_gfx = RetrocamelBitmapManager.getBDExt(_gfx_, 0, color * 5, 3, 3);
					_width = 3;
					_height = 3;
					break;

				case(1):
					_gfx = RetrocamelBitmapManager.getBDExt(_gfx_, 4, color * 5, 4, 3);
					_width = 4;
					_height = 3;
					break;

				case(2):
					_gfx = RetrocamelBitmapManager.getBDExt(_gfx_, 9, color * 5, 3, 4);
					_width = 3;
					_height = 4;
					break;

				case(3):
					_gfx = RetrocamelBitmapManager.getBDExt(_gfx_, 13, color * 5, 4, 4);
					_width = 4;
					_height = 4;
					break;
			}
		}
	}
}