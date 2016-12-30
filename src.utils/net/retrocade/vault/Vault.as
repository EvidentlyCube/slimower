
package net.retrocade.vault{
    import flash.events.EventDispatcher;
    import flash.utils.Proxy;
    
    /**
     * <p>Vault is a static class which can be used to store sensitive numeric data
     * in a way to prevent memory-editing programs from changing it by using
     * multiple obfuscation techniques.</p>
     * <p>When a variable is detected to be modified, the function calls the preset
     * callback function, and if no function is set, it will throw an error.</p> 
     */
    final public class Vault{
        private static var array:Object = {};
        private static var modifiedVariableCallback:Function;
        
        /**
         * @private
         */
        public function Vault(){ new Error("Can't instantiate Vault object - please use static methods only!") }
        
        /****************************************************************************************************************/
        /**                                                                                                  FUNCTIONS  */
        /****************************************************************************************************************/
        
        public static function get(name:String, def:Number = 0):Number{
            if (array[name] == undefined){
                return (array[name] as SafeParent).get();
            } else {
                return def;
            }
        }
        
        public static function set(name:String, value:Number):Number{
            if (array[name] == undefined){
                array[name] = generateSafe();
                return array[name].change(value, true);
            } else {
                return array[name].change(value);
            }
        }
        
        public static function add(name:String, value:Number):Number{
            return set(name, get(name) + value);
        }
        
        public static function mul(name:String, value:Number):Number{
            return set(name, get(name) * value);
        }
       
        public static function remove(name:String):void{
            delete array[name]; 
        }

        public static function setCheatCallback(fun:Function):void{
            modifiedVariableCallback = fun;
        }
        
        public static function getSafeAsString(name:String):String{
            return SafeParent( array[name] ).safeToString();
        }
        
        public static function setSafeFromString(name:String, string:String):void{
            var safe:SafeParent;
            
            switch(string.charAt(0)){
                case("0"): safe = new Safe0; break;
                case("1"): safe = new Safe1; break;
                case("2"): safe = new Safe2; break;
            }
            
            safe.stringToSafe(string);
            
            array[name] = safe;
            
            safe.check();
        }
        
        public static function forceValue(name:String, value:Number):Number{
            if (!array[name]){
                array[name] = generateSafe();
                return array[name].change(value, true);
            } else {
                return array[name].change(value, true);
            }
        }
        
        /**
         * @private
         */
        internal static function fakeValue():void{
            if (modifiedVariableCallback!=null){
                modifiedVariableCallback();
            } else {
                new Error("A modified variable has been detected, but no callback was set!");
            }
        }
        /**
         * @private
         */
        private static function generateSafe():SafeParent{
            switch(Math.floor(Math.random())){
                case(0):return new Safe0();
                case(1):return new Safe1();
                case(2):return new Safe2();
            }
            return new Safe0;
        }
    }
}
