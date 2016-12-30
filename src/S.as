package {
	public function S():S_Impl {
		return S_Impl.instance;
	}
}

import net.retrocade.retrocamel.interfaces.IRetrocamelSettings;

class S_Impl implements IRetrocamelSettings {
	public static var instance:S_Impl = new S_Impl;

	public function get languages():Array {
		return ['en', 'pl'];
	}

	public function get gameWidth():uint {
		return 512;
	}

	public function get gameHeight():uint {
		return 448;
	}

	public function get swfWidth():uint {
		return 512;
	}

	public function get swfHeight():uint {
		return 448;
	}


	public var SIZE_LEVEL_WIDTH:int = 256;
	public var SIZE_LEVEL_HEIGHT:int = 224;

	public var LANGUAGES:Array = ['en', 'pl'];
	public var LANGUAGES_NAMES:Array = ['English', 'Polish'];

	public var SPATIAL_HASH_CELL:Number = 32;
	public var SPATIAL_HASH_MAX_BUCKETS:Number = 1001;

	public var TILE_GRID_TILE_WIDTH:Number = 16;
	public var TILE_GRID_TILE_HEIGHT:Number = 16;
	public var TILE_GRID_WIDTH:Number = 160;
	public var TILE_GRID_HEIGHT:Number = 140;
}