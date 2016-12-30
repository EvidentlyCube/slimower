package game.objects {
	import game.global.Game;
	import game.global.Level;

	import net.retrocade.helpers.RetrocamelScrollAssist;
	import net.retrocade.retrocamel.interfaces.IRetrocamelSpatialHashElement;

	public class TMonster extends TGameObject implements IRetrocamelSpatialHashElement {
		protected var hp:int = 0;

		public function damage(dmg:uint, hitter:*):void {
		}

		override public function update():void {
			if (y > RetrocamelScrollAssist.instance.edgeBottom + 10)
				kill();
		}

		public function get hashLeft():Number {
			return _x;
		}

		public function get hashTop():Number {
			return _y;
		}

		public function get hashRight():Number {
			return _x + _width - 1;
		}

		public function get hashBottom():Number {
			return _y + _height - 1;
		}

		protected function kill():void {
			var count:uint = 0;

			for each(var o:* in Game.gAll.getAllOriginal()) {
				if (o is TMonster)
					count++;
			}

			if (count == 0) {
				player.completing = true;
				Level.levelCompleted();
			}
		}
	}
}