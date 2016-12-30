package game.global{
    import net.retrocade.vault.Safe;

    public class Score{
        public static var level:Safe = new Safe(1);
        public static var score:Safe = new Safe(0);
        public static var lives:Safe = new Safe(4);
        public static var timer:Safe = new Safe(0);
        
        public static var healthMultiplier:Safe = new Safe(1);
        public static var speedMultiplier :Safe = new Safe(1);
        public static var doubleChunks    :Boolean = false;
        public static var noPushback      :Boolean = false;
        public static var noChunkDamage   :Boolean = false;
        public static var scoreMultiplier :Safe = new Safe(1);
        public static var diffSelected    :uint = 0;
        public static var multiplier:Safe = new Safe(1);
        public static var playerStop      :Boolean = false;
        
        public static function resetGameStart():void{
            score.set(0);
            lives.set(4);
            level.set(1);
            timer.set(1000 * 60 * 5);
            playerStop = false;
        }
        
        public static function blockDestroyed():void{
            score.add(5 * multiplier.get() | 0);
            multiplier.set(10);
        }
        
        public static function addScore(amount:Number):void{
            score.add(amount * scoreMultiplier.get() * multiplier.get());
        }
        
        public static function playerDamaged(damage:uint):void{
            lives.add(- damage);
            if (lives.get() < 0){
                lives.set(4);
                Level.restartLevel();
            }
        }
    }
}