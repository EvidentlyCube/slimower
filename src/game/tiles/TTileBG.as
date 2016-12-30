package game.tiles {
	import game.global.Level;

	public class TTileBG extends TTile {
		[Embed(source="/../src.assets/tiles/tileset.png")]
		public static var _gfx_tileset_:Class;

		public function TTileBG(x:Number, y:Number, gfxX:uint, gfxY:uint) {
			super(x, y, gfxX, gfxY);
		}

		override protected function setLevel():void {
			Level.levelBG.set(_x, _y, this);
		}

		override protected function unsetLevel():void {
			Level.levelBG.set(_x, _y, null);
		}

	}
}