package game.objects {
	import game.global.Game;
	import game.global.Level;
	import game.tiles.TTile;

	import net.retrocade.helpers.RetrocamelScrollAssist;

	import net.retrocade.retrocamel.components.RetrocamelDisplayObject;
	import net.retrocade.retrocamel.components.RetrocamelUpdatableGroup;

	public class TGameObject extends RetrocamelDisplayObject {
		/**
		 * X of the left edge of the level
		 */
		public function get levelLeft():Number {
			return 0;
		}

		/**
		 * Y of the top edge of the level
		 */
		public function get levelTop():Number {
			return 0;
		}

		/**
		 * X of the right edge of the level
		 */
		public function get levelRight():Number {
			return S().SIZE_LEVEL_WIDTH;
		}

		/**
		 * Y of the bottom edge of the level
		 */
		public function get levelBottom():Number {
			return S().SIZE_LEVEL_HEIGHT;
		}


		public function get maxX():Number {
			return S().SIZE_LEVEL_WIDTH - _width;
		}

		public function get maxY():Number {
			return S().SIZE_LEVEL_HEIGHT - _height;
		}

		public function getTile(x:Number, y:Number):TTile {
			return Level.level.get(x, y);
		}

		override public function get defaultGroup():RetrocamelUpdatableGroup{
			return Game.gAll;
		}

		public function get player():TPlayer {
			return Level.player;
		}

		public function get scrollX():int {
			return -RetrocamelScrollAssist.x;
		}

		public function get scrollY():int {
			return -RetrocamelScrollAssist.y;
		}

		protected function checkCollision(dir:Number):Boolean {
			var tile1:TTile, tile2:TTile, func:String;
			switch (dir) {
				case(0):
					tile1 = getTile(right, y);
					tile2 = getTile(right, bottom);
					func = "hitLeft";
					break;
				case(90):
				case(-270):
					if ((middle / 16 | 0) * 16 - x > (right / 16 | 0) * 16 - center) {
						tile1 = getTile(x, bottom + 1);
						tile2 = getTile(right, bottom + 1);
					} else {
						tile2 = getTile(x, bottom + 1);
						tile1 = getTile(right, bottom + 1);
					}
					func = "hitTop";
					break;
				case(180):
				case(-180):
					tile1 = getTile(x, y);
					tile2 = getTile(x, bottom);
					func = "hitRight";
					break;
				case(270):
				case(-90):
					if ((center / 16 | 0) * 16 - x > (right / 16 | 0) * 16 - center) {
						tile1 = getTile(x, y);
						tile2 = getTile(right, y);
					} else {
						tile2 = getTile(x, y);
						tile1 = getTile(right, y);
					}
					func = "hitBottom";
					break;

			}

			var ret:Boolean = false;
			if (tile1 && tile1[func](this)) {
				ret = true;
			}

			if (tile2 && tile2 != tile1 && tile2[func](this)) {
				ret = true;
			}

			return ret;
		}

		override public function draw():void {
		}
	}
}