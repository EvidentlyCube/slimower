package net.retrocade.collision{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	import net.retrocade.retrocamel.core.retrocamel_int;
	import net.retrocade.utils.UtilsNumber;

	use namespace retrocamel_int;

	public class RetrocamelSimpleCollider{
		/**
		 * Collision between two circles
		 * @param x1 X position of the first circle
		 * @param y1 Y position of the first circle
		 * @param r1 Radius of the first circle
		 * @param x2 X position of the second circle
		 * @param y2 Y position of the second circle
		 * @param r2 Radius of the second circle
		 * @return True if collision occurs, otherwise false
		 */
		public static function circleCircle(x1:Number, y1:Number, r1:Number, x2:Number, y2:Number, r2:Number):Boolean{
			return (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1) < (r1 + r2) * (r1 + r2);
		}

		/**
		 * Collision between a circle and a point
		 * @param x1 X position of the circle
		 * @param y1 Y position of the circle
		 * @param r1 Radius of the circle
		 * @param x2 X position of the point
		 * @param y2 Y position of the point
		 * @return True if collision occurs, otherwise false
		 */
		public static function circlePoint(x1:Number, y1:Number, r1:Number, x2:Number, y2:Number):Boolean{
			return (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1) < r1 * r1;
		}

		/**
		 * Collision between a circle and a rectangle
		 * @param x1 X position of the circle
		 * @param y1 Y position of the circle
		 * @param r1 Radius of the circle
		 * @param x2 X position of the rectangle
		 * @param y2 Y position of the rectangle
		 * @param w2 Width of the rectangle
		 * @param h2 Height of the rectangle
		 * @return True if collision occurs, otherwise false
		 */
		public static function circleRect(x1:Number, y1:Number, r1:Number, x2:Number, y2:Number, w2:Number, h2:Number):Boolean{
			x1 -= x2;
			y1 -= y2;
			x2 = y2 = 0;

			var _countOutsides:int = 0;

			if (x1 < 0 ) _countOutsides++;
			if (x1 > w2) _countOutsides++;
			if (y1 < 0 ) _countOutsides++;
			if (y1 > h2) _countOutsides++;

			switch(_countOutsides){
				case (0):
					return true;

				case (1):
					return rectRect(x1 - r1, y1 - r1, r1 * 2, r1 * 2, x2, y2, w2, h2);

				case (2):
					return circlePoint(x1, y1, r1, UtilsNumber.limit(x1, w2, 0), UtilsNumber.limit(y1, h2, 0));

				default:
					return false;
			}
		}

		/**
		 * Line-Line (Segments) intersection algorithm as taken from - http://paulbourke.net/geometry/lineline2d/ It checks if two line segments intersect
		 * @param fromX1 X of the first line's starting point
		 * @param fromY1 Y of the first line's starting point
		 * @param toX1 X of the first line's ending point
		 * @param toY1 Y of the first line's ending point
		 * @param fromX2 X of the second line's starting point
		 * @param fromY2 Y of the second line's starting point
		 * @param toX2 X of the second line's ending point
		 * @param toY2 Y of the second line's ending point
		 * @return True if the lines intersect
		 */
		public static function lineLine(fromX1:Number, fromY1:Number, toX1:Number, toY1:Number, fromX2:Number, fromY2:Number, toX2:Number, toY2:Number):Boolean{
			var ua:Number = ((toX2 - fromX2) * (fromY1 - fromY2) - (toY2 - fromY2) * (fromX1-fromX2)) / ((toY2 - fromY2) * (toX1 - fromX1) - (toX2 - fromX2) * (toY1 - fromY1));
			var ub:Number = ((toX1 - fromX1) * (fromY1 - fromY2) - (toY1 - fromY1) * (fromX1-fromX2)) / ((toY2 - fromY2) * (toX1 - fromX1) - (toX2 - fromX2) * (toY1 - fromY1));

			if ((ua < 1 && ua > 0 && ub < 1 && ub > 0) || (ua == 0 && ub == 0)){
				return true;
			} else {
				return false;
			}
		}

		public static function LineRect(x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, wid:uint, hei:uint):Boolean{

			if ((x1 >= x3 && x1 < x3 + wid && y1 >= y3 && y1 < y3 + hei) ||
				(x2 >= x3 && x2 < x3 + wid && y2 >= y3 && y2 < y3 + hei))
			{
				return true;
			}

			var xDir:int = (x2 > x1 ? 1
				: x2 < x1 ? -1
				: 0);

			var yDir:int = (y2 > y1 ? 1
				: y2 < y1 ? -1
				: 0);

			if (xDir == 1 && lineLine(x1, y1, x2, y2, x3, y3, x3, y3 + hei))
				return true;
			else if (xDir == -1 && lineLine(x1, y1, x2, y2, x3 + wid, y3, x3 + wid, y3 + hei))
				return true;

			if (yDir == 1 && lineLine(x1, y1, x2, y2, x3, y3, x3 + wid, y3))
				return true;
			else if (yDir == -1 && lineLine(x1, y1, x2, y2, x3, y3 + hei, x3 + wid, y3 + hei))
				return true;

			return false;
		}

		/**
		 * Collision between a rectangle and a circle
		 * @param x1 X position of the rectangle
		 * @param y1 Y position of the rectangle
		 * @param w1 Width of the rectangle
		 * @param h1 Height of the rectangle
		 * @param x2 X position of the point
		 * @param y2 Y position of the point
		 * @return True if collision occurs, otherwise false
		 */
		public static function rectPoint(x1:Number, y1:Number, w1:Number, h1:Number, x2:Number, y2:Number):Boolean{
			return (x2 >= x1 && y2 >= y1 && x2 < x1 + w1 && y2 < y1 + h1);
		}

		/**
		 * Collision between two rectangles
		 * @param x1 X position of the first rectangle
		 * @param y1 Y position of the first rectangle
		 * @param w1 Width of the first rectangle
		 * @param h1 height of the first rectangle
		 * @param x2 X position of the second rectangle
		 * @param y2 Y position of the second rectangle
		 * @param w2 Width of the second rectangle
		 * @param h2 Height of the second rectangle
		 * @return True if collision occurs, otherwise false
		 */
		public static function rectRect(x1:Number, y1:Number, w1:Number, h1:Number, x2:Number, y2:Number, w2:Number, h2:Number):Boolean{
			x1 = x2 - x1;
			y1 = y2 - y1;
			return x1 < w1 && x1 > -w2 && y1 < h1 && y1 > -h2;
		}


		retrocamel_int static var _bitmapData:BitmapData;
		private static var _rect:Rectangle;

		private static var _ct:ColorTransform;

		private static var _mtx1:Matrix;
		private static var _mtx2:Matrix;

		public static function initBitmapCollision(width:uint, height:uint):void{
			_bitmapData = new BitmapData(width, height);
			_rect = new Rectangle(0, 0, width, height);

			_ct = new ColorTransform(1, 1, 1, 1, 255, -255, -255, 0);

			_mtx1 = new Matrix();
			_mtx2 = new Matrix();
		}


		public static function bitmap(_gfx1:BitmapData, _x1:Number, _y1:Number, scaleX1:Number, scaleY1:Number, rotation1:Number,
		                              _gfx2:BitmapData, _x2:Number, _y2:Number, scaleX2:Number, scaleY2:Number, rotation2:Number):Boolean{

			if (!_gfx1 || !_gfx2){
				return false;
			}

			_bitmapData.fillRect(_rect, 0);

			if (_x1 < _x2){
				_x2 -= _x1;
				_x1 = 0;
			} else {
				_x1 -= _x2;
				_x2 = 0;
			}

			if (_y1 < _y2){
				_y2 -= _y1;
				_y1 = 0;
			} else {
				_y1 -= _y2;
				_y2 = 0;
			}

			_x1 += 15;
			_x2 += 15;
			_y1 += 15;
			_y2 += 15;

			_mtx1.identity();
			_mtx2.identity();

			_mtx1.translate(- _gfx1.width / 2, - _gfx1.height / 2);
			_mtx2.translate(- _gfx2.width / 2, - _gfx2.height / 2);

			_mtx1.scale(scaleX1, scaleY1);
			_mtx2.scale(scaleX2, scaleY2);

			_mtx1.rotate(rotation1 * Math.PI / 180);
			_mtx2.rotate(rotation2 * Math.PI / 180);

			_mtx1.translate(_x1 + _gfx1.width * scaleX1 / 2, _y1 + _gfx1.height * scaleY1 / 2);
			_mtx2.translate(_x2 + _gfx2.width * scaleX2 / 2, _y2 + _gfx2.height * scaleY2 / 2);

			_bitmapData.draw(_gfx1, _mtx1, _ct, BlendMode.NORMAL);
			_bitmapData.draw(_gfx2, _mtx2, _ct, BlendMode.DIFFERENCE);

			return (_bitmapData.getColorBoundsRect(0xFFFFFFFF, 0xFF000000).width) > 0;
		}
	}
}