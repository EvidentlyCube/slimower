

package net.retrocade.vault{

    /**
     * A local vault object which can be referenced directly and holds only one variable
     * @author Skell
     */
    public class Safe{

        /**
         * Function called when variables are detected to be tampered with if there is no local function declared.
         */
        public static var globalCheatFunction:Function;

        
        
        /**
         * A private variable holding the safe
         * @private
         */
        private var safe:SafeParent;
        
        /**
         * The initial value that has been set. In case of variables being tampered the safe is reset to this.
         */ 
        private var defaultValue:Number;
        
        /**
         * Function called if variables are detected to be tampered with.
         */
        public var localCheatFunction:Function;

        /**
         * Creates a new MiniVault.
         * @param defValue Default value of the safe
         * @param safeString If set it creates a safe from the specified string.
         * @param cheatFunction Function to call when variables are detected to be tampered with
         */
        public function Safe(defValue:Number = 0, safeString:String = null, cheatFunction:Function = null){
            defaultValue       = defValue;
            localCheatFunction = cheatFunction;
            
            if (safeString){
                setFromString(safeString);
                return;
                
            } else {
                resetSafe();
            }

            safe.set(defValue);
        }

        /**
         * Increases the stored variable by number and return its new value
         * @param number A value by which the stored variable is to be increased
         * @return New stored value
         */
        public function add(number:Number):Number{
            if (!check()){
                return safe.get();
            }
                
            return safe.set(safe.get() + number);
        }


        /**
         * Multiplies the stored variable by number and return its new value
         * @param number A value by which the stored variable is to be Multiplied
         * @return New stored value
         */
        public function mul(number:Number):Number{
            if (!check()){
                return safe.get();
            }
            
            return safe.set(safe.get() * number);
        }

        /**
         * Sets the stored variable to number
         * @param number Value to which set the variable
         * @return New stored value
         */
        public function set(number:Number):Number{
            if (!check()){
                return safe.get();
            }
            
            return safe.set(number);
        }


        /**
         * Retrieves current value
         * @return Current Value
         */
        public function get():Number{
            return safe.get();
        }

        /**
         * Forces a value (skips cheat test)
         * @param number Value to force
         * @return New value
         */
        public function force(number:Number):Number{
            return safe.set(number);
        }
         
        /**
         * Checks if the variables haven't been tampered, resets them to default 
         * @return 
         * 
         */
        public function check():Boolean{
            if (!safe.check()){

                if (localCheatFunction != null){
                    localCheatFunction();
                
                }else if(globalCheatFunction != null){
                    globalCheatFunction();

                } else {
                    resetSafe();
                }
                
                return false;
            }
            
            return true;
        }

        /**
         * Sets the value of a vault from a string
         * @param string A safestring
         * @return True on success, false on failure
         */
        public function setFromString(string:String):Boolean{
            switch(string.charAt(0)){
                case("0"):
                    safe = new Safe0;
                    break;
                case("1"):
                    safe = new Safe1;
                    break;
                case("2"):
                    safe = new Safe2;
                    break;
            }

            if (!safe.stringToSafe(string)){
                resetSafe();
                return false;
            }
            
            return check();
        }

        /**
         * Returns the safe as a String
         * @return Safe as a string
         */
        public function getSafeAsString():String{
            return safe.safeToString();
        }

        /**
         * Generates a safe
         * @private
         */
        private function resetSafe():void{
            switch(Math.floor(Math.random() * 3)){
                case(0): safe = new Safe0(); break;
                case(1): safe = new Safe1(); break;
                case(2): safe = new Safe2(); break;
            }
            
            safe.set(defaultValue);
        }
    }
}