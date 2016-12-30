package game.global{
    import net.retrocade.sfxr.SfxrParams;
    import net.retrocade.sfxr.SfxrSynth;

    public class Sfx{
        public static var sfxBlockBoom     :SfxrSynth;
        public static var sfxPlayerBounce  :SfxrSynth;
        public static var sfxLevelCompleted:SfxrSynth;
        public static var sfxRollOver      :SfxrSynth;
        public static var sfxClick         :SfxrSynth;
        public static var sfxDeath         :SfxrSynth;
        public static var sfxChangeColor   :SfxrSynth;
        
        public static function initialize():void{
            var p:SfxrParams = new SfxrParams();
            
            p.setSettingsString("3,,0.3563,0.4426,0.13,0.2216,,-0.2897,,,,-0.506,0.8443,,,,,,1,,,,,0.50");
            sfxBlockBoom = new SfxrSynth();
            sfxBlockBoom.params = p.clone();
            
            p.setSettingsString("0,,0.027,,0.2638,0.4521,,-0.6317,,,,,,0.3518,,,,,1,,,0.1684,,0.50");
            sfxPlayerBounce = new SfxrSynth();
            sfxPlayerBounce.params = p.clone();
            
            p.setSettingsString("2,,0.01,,1,0.41,,0.34,0.6799,0.35,0.66,,0.63,0.1344,,0.58,,,0.42,,,,,0.52");
            sfxLevelCompleted = new SfxrSynth();
            sfxLevelCompleted.params = p.clone();
            
            p.setSettingsString("2,0.0051,0.0252,,0.21,0.29,0.0752,,,,,,0.89,0.4339,,,,,1,,,,,0.52");
            sfxRollOver = new SfxrSynth();
            sfxRollOver.params = p.clone();
            
            p.setSettingsString("2,,0.186,,0.0638,0.5582,,,,,,,,,,,,,1,,,0.1,,0.52");
            sfxClick = new SfxrSynth();
            sfxClick.params = p.clone();
            
            p.setSettingsString("1,,0.08,,0.77,0.41,,0.34,0.62,0.35,0.82,,0.8,0.1344,,0.55,,,0.42,,,,,0.52");
            p.setSettingsString("3,,0.08,,0.77,0.41,,-0.18,0.6399,0.73,0.87,-1,0.73,0.1344,,0.55,,,1,,,,,0.52");
            p.setSettingsString("3,,0.1764,0.6369,0.4858,0.1138,,0.2251,,0.56,0.47,0.3912,0.6772,,,0.75,,,1,,,,,0.52");
            sfxDeath = new SfxrSynth();
            sfxDeath.params = p.clone();
            
            p.setSettingsString("0,,0.25,0.2,0.63,0.56,,,,0.3,0.72,,0.16,,,,,,0.61,-0.1999,,,,0.5");
            sfxChangeColor = new SfxrSynth();
            sfxChangeColor.params = p;
            
            sfxRollOver.cacheSound();
            sfxClick.cacheSound();
        }
        
        public static function startGenerating(callback:Function):void {
            callback();
        }
    }
}