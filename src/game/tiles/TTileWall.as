package game.tiles {
	import game.objects.TGameObject;

	/**
	 * ...
	 * @author
	 */
	public class TTileWall extends TTile {
		public function TTileWall(x:Number, y:Number, gfxX:uint, gfxY:uint) {
			super(x, y, gfxX, gfxY);

			drawMe();
		}

		override public function hitRight(o:TGameObject):Boolean {
			o.x = _x + _w;
			return true;
		}

		override public function hitLeft(o:TGameObject):Boolean {
			o.right = _x - 1;
			return true;
		}

		override public function hitTop(o:TGameObject):Boolean {
			o.bottom = _y - 1;
			return true;
		}

		override public function hitBottom(o:TGameObject):Boolean {
			o.y = _y + _h;
			return true;
		}

	}

}