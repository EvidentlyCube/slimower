package game.tiles {
	import flash.display.BitmapData;

	import game.global.Game;
	import game.global.Level;
	import game.objects.TGameObject;

	import net.retrocade.helpers.RetrocamelScrollAssist;

	import net.retrocade.retrocamel.components.RetrocamelUpdatableObject;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;

	public class TTile extends RetrocamelUpdatableObject {
		[Embed(source="/../src.assets/tiles/tileset.png")]
		public static var _gfx_tileset_:Class;

		protected var _x:Number;
		protected var _y:Number;

		protected var _w:Number;
		protected var _h:Number;

		protected var _gfx:BitmapData;

		public function TTile(x:Number, y:Number, gfxX:uint, gfxY:uint) {
			_gfx = RetrocamelBitmapManager.getBDExt(_gfx_tileset_, gfxX, gfxY, 16, 16);

			_x = x;
			_y = y;

			_w = _gfx.width;
			_h = _gfx.height;

			setLevel();
		}

		public function hitRight(o:TGameObject):Boolean {
			return false;
		}

		public function hitLeft(o:TGameObject):Boolean {
			return false;
		}

		public function hitTop(o:TGameObject):Boolean {
			return false;
		}

		public function hitBottom(o:TGameObject):Boolean {
			return false;
		}

		protected function setLevel():void {
			Level.level.set(_x, _y, this);
		}

		protected function unsetLevel():void {
			Level.level.set(_x, _y, null);
		}

		final public function drawMe(scrollX:int = 0, scrollY:int = 0):void {
			Game.lBG.draw(_gfx, _x + scrollX, _y + scrollY);
		}

		public function get scrollX():int {
			return -RetrocamelScrollAssist.x;
		}

		public function get scrollY():int {
			return -RetrocamelScrollAssist.y;
		}
	}
}