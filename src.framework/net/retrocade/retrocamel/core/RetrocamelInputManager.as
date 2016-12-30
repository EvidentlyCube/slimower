

package net.retrocade.retrocamel.core{
    import flash.display.Stage;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;

    import net.retrocade.signal.Signal;

    use namespace retrocamel_int;

    public class RetrocamelInputManager{

        public static var lockKeyboard:Boolean = false;

        /**
         * A Boolean indicating if the alt key is down.
         */
        private static var _isAltDown             :Boolean = false;

        /**
         * Returns true if the alt key is down
         */
        public static function isAltDown():Boolean{
            return _isAltDown && !lockKeyboard;
        }

        /**
         * A Boolean indicating if the ctrl key is down.
         */
        private static var _isCtrlDown             :Boolean = false;

        /**
         * Returns true if the ctrl key is down
         */
        public static function isCtrlDown():Boolean{
            return _isCtrlDown && !lockKeyboard;
        }

        /**
         * A Boolean indicating if the shift key is down.
         */
        private static var _isShiftDown             :Boolean = false;

        /**
         * Returns true if the Shift key is down
         */
        public static function isShiftDown():Boolean{
            return _isShiftDown && !lockKeyboard;
        }

        /**
         * Keycode of the last key pressed
         */
        private static var _lastKeyDown             :int = -1;

        /**
         * Returns Keycode of the last key pressed
         */
        public static function get lastKeyDown():int{
            return _lastKeyDown;
        }

        /**
         * Array containing hold down keys
         */
        private static var _keyDowns    :Array = new Array(256);

        /**
         * Array containing hit keys
         */
        private static var _keyHits     :Array = new Array(256);

        /**
         * A Boolean indicating if the mouse button is down.
         */
        private static var _isMouseDown             :Boolean = false;

        /**
         * Returns true if the mouse button is down.
         */
        public static function isMouseDown():Boolean{
            return _isMouseDown;
        }

        /**
         * A Boolean indicating if the mouse button is hit in this step.
         */
        private static var _isMouseHit             :Boolean = false;

        /**
         * Returns true if the mouse button was hit in this step.
         */
        public static function isMouseHit():Boolean{
            return _isMouseHit;
        }




        /**
         * X position of the mouse in stage coordinates
         */
        private static var _mouseX             :int = 0;

        /**
         * Returns X position of the mouse in stage coordinates
         */
        public static function get mouseX():int{
            return (_mouseX - RetrocamelDisplayManager.offsetX) / RetrocamelDisplayManager.scaleX;
        }




        /**
         * Y position of the mouse in stage coordinates
         */
        private static var _mouseY             :int = 0;

        /**
         * Returns Y position of the mouse in stage coordinates
         */
        public static function get mouseY():int{
            return (_mouseY - RetrocamelDisplayManager.offsetY) / RetrocamelDisplayManager.scaleX;
        }





        private static var _stage:Stage;

        private static var _keyDownSignal:Signal = new Signal(1);


        public static function get keyDownSignal():Signal{
            return _keyDownSignal;
                }

        /**
         * Resets all key, control key and mouse button states to not hit / held
         */
        public static function flushAll():void{
            flushControlKeys();
            flushKeys();
            flushMouse();
        }

        /**
         * Resets all control key states to not held
         */
        public static function flushControlKeys():void{
            _isAltDown   = false;
            _isCtrlDown  = false;
            _isShiftDown = false;
        }

        /**
         * Resets all key states to not hit / held
         */
        public static function flushKeys():void{
            for (var i:int = 0; i < 256; i++)
                _keyDowns[i] = _keyHits[i] = false;
        }

        /**
         * Resets mouse button state to not held
         */
        public static function flushMouse():void{
            _isMouseDown = false;
            _isMouseHit  = false;
        }



        // ==========================================================================================================================================
        // ==                                                                                                                            CHECKERS
        // ==========================================================================================================================================

        /**
         * Checks if the specified key is held down
         * @param keyCode KeyCode of the key to check if is held down
         * @return True if the given key is down
         */
        public static function isKeyDown(keyCode:int):Boolean{
            return _keyDowns[keyCode % 256] && !lockKeyboard;
        }

        /**
         * Checks if the specified key is hit
         * @param keyCode KeyCode of the key to check if is hit
         * @return True if the given key is hit
         */
        public static function isKeyHit(keyCode:int):Boolean{
            return _keyHits[keyCode % 256] && !lockKeyboard;
        }

        /**
         * Checks if any key is currently down (a bit slow!)
         * @return True if any key is down
         */
        public static function isAnyKeyDown(fromRange:uint = 0, toRange:uint = 256 ):Boolean {
            for (fromRange; fromRange < toRange; fromRange++){
                if (_keyDowns[fromRange])
                    return true;
            }

            return false;
        }

        /**
         * Checks if any key was hit (a bit slow!)
         * @return True if any key was hit
         */
        public static function isAnyKeyHit():Boolean{
            for(var i:uint = 0; i < 256; i++){
                if (_keyHits[i] == true)
                    return true;
            }

            return false;
        }


        // ==========================================================================================================================================
        // ==                                                                                                                              EVENTS
        // ==========================================================================================================================================

        // ::::::::::::::::::::::::::::::::::::::::::::::::
        // :: Adding Keyboard Listeners
        // ::::::::::::::::::::::::::::::::::::::::::::::::

        /**
         * Adds KeyboardEvent.KEY_DOWN event to the stage.
         * @param f Function to be added to listening
         * @param weakReference Whether to use te weak reference
         * @param priority Priority of the function
         */
        public static function addStageKeyDown(f:Function, weakReference:Boolean = true, priority:int = 0):void{
            _stage.addEventListener(KeyboardEvent.KEY_DOWN, f, false, priority, weakReference);
        }

        /**
         * Adds KeyboardEvent.KEY_UP event to the stage.
         * @param f Function to be added to listening
         * @param weakReference Whether to use te weak reference
         * @param priority Priority of the function
         */
        public static function addStageKeyUp(f:Function, weakReference:Boolean = true, priority:int = 0):void{
            _stage.addEventListener(KeyboardEvent.KEY_UP, f, false, priority, weakReference);
        }




        // ::::::::::::::::::::::::::::::::::::::::::::::::
        // :: Adding Mouse Listeners
        // ::::::::::::::::::::::::::::::::::::::::::::::::

        /**
         * Adds MouseEvent.CLICK event to the stage.
         * @param f Function to be added to listening
         * @param weakReference Whether to use te weak reference
         * @param priority Priority of the function
         */
        public static function addStageMouseClick(f:Function, weakReference:Boolean = true, priority:int = 0):void{
            _stage.addEventListener(MouseEvent.CLICK, f, false, priority, weakReference);
        }

        /**
         * Adds MouseEvent.DOUBLE_CLICK event to the stage.
         * @param f Function to be added to listening
         * @param weakReference Whether to use te weak reference
         * @param priority Priority of the function
         */
        public static function addStageMouseDoubleClick(f:Function, weakReference:Boolean = true, priority:int = 0):void{
            _stage.doubleClickEnabled = true;
            _stage.addEventListener(MouseEvent.DOUBLE_CLICK, f, false, priority, weakReference);
        }

        /**
         * Adds MouseEvent.MOUSE_DOWN event to the stage.
         * @param f Function to be added to listening
         * @param weakReference Whether to use te weak reference
         * @param priority Priority of the function
         */
        public static function addStageMouseDown(f:Function, weakReference:Boolean = true, priority:int = 0):void{
            _stage.addEventListener(MouseEvent.MOUSE_DOWN, f, false, priority, weakReference);
        }

        /**
         * Adds MouseEvent.MOUSE_MOVE event to the stage.
         * @param f Function to be added to listening
         * @param weakReference Whether to use te weak reference
         * @param priority Priority of the function
         */
        public static function addStageMouseMove(f:Function, weakReference:Boolean = true, priority:int = 0):void{
            _stage.addEventListener(MouseEvent.MOUSE_MOVE, f, false, priority, weakReference);
        }

        /**
         * Adds MouseEvent.MOUSE_OUT event to the stage.
         * @param f Function to be added to listening
         * @param weakReference Whether to use te weak reference
         * @param priority Priority of the function
         */
        public static function addStageMouseOut(f:Function, weakReference:Boolean = true, priority:int = 0):void{
            _stage.addEventListener(MouseEvent.MOUSE_OUT, f, false, priority, weakReference);
        }

        /**
         * Adds MouseEvent.MOUSE_OVER event to the stage.
         * @param f Function to be added to listening
         * @param weakReference Whether to use te weak reference
         * @param priority Priority of the function
         */
        public static function addStageMouseOver(f:Function, weakReference:Boolean = true, priority:int = 0):void{
            _stage.addEventListener(MouseEvent.MOUSE_OVER, f, false, priority, weakReference);
        }

        /**
         * Adds MouseEvent.MOUSE_UP event to the stage.
         * @param f Function to be added to listening
         * @param weakReference Whether to use te weak reference
         * @param priority Priority of the function
         */
        public static function addStageMouseUp(f:Function, weakReference:Boolean = true, priority:int = 0):void{
            _stage.addEventListener(MouseEvent.MOUSE_UP, f, false, priority, weakReference);
        }

        /**
         * Adds MouseEvent.MOUSE_WHEEL event to the stage.
         * @param f Function to be added to listening
         * @param weakReference Whether to use te weak reference
         * @param priority Priority of the function
         */
        public static function addStageMouseWheel(f:Function, weakReference:Boolean = true, priority:int = 0):void{
            _stage.addEventListener(MouseEvent.MOUSE_WHEEL, f, false, priority, weakReference);
        }




        // ::::::::::::::::::::::::::::::::::::::::::::::::
        // :: Removing Keyboard Listeners
        // ::::::::::::::::::::::::::::::::::::::::::::::::

        /**
         * Remove KeyboardEvent.KEY_DOWN event from the stage
         * @param f Function to be removed from listening
         */
        public static function removeStageKeyDown(f:Function):void{
            _stage.removeEventListener(KeyboardEvent.KEY_DOWN, f);
        }

        /**
         * Remove KeyboardEvent.KEY_UP event from the stage
         * @param f Function to be removed from listening
         */
        public static function removeStageKeyUp(f:Function):void{
            _stage.removeEventListener(KeyboardEvent.KEY_UP, f);
        }




        // ::::::::::::::::::::::::::::::::::::::::::::::::
        // :: Removing Mouse Listeners
        // ::::::::::::::::::::::::::::::::::::::::::::::::

        /**
         * Remove MouseEvent.CLICK event from the stage
         * @param f Function to be removed from listening
         */
        public static function removeStageMouseClick(f:Function):void{
            _stage.removeEventListener(MouseEvent.CLICK, f);
        }

        /**
         * Remove MouseEvent.DOUBLE_CLICK event from the stage
         * @param f Function to be removed from listening
         */
        public static function removeStageMouseDoubleClick(f:Function):void{
            _stage.removeEventListener(MouseEvent.DOUBLE_CLICK, f);

            if (!_stage.hasEventListener(MouseEvent.DOUBLE_CLICK))
                _stage.doubleClickEnabled = false;
        }

        /**
         * Remove MouseEvent.MOUSE_DOWN event from the stage
         * @param f Function to be removed from listening
         */
        public static function removeStageMouseDown(f:Function):void{
            _stage.removeEventListener(MouseEvent.MOUSE_DOWN, f);
        }

        /**
         * Remove MouseEvent.MOUSE_MOVE event from the stage
         * @param f Function to be removed from listening
         */
        public static function removeStageMouseMove(f:Function):void{
            _stage.removeEventListener(MouseEvent.MOUSE_MOVE, f);
        }

        /**
         * Remove MouseEvent.MOUSE_OUT event from the stage
         * @param f Function to be removed from listening
         */
        public static function removeStageMouseOut(f:Function):void{
            _stage.removeEventListener(MouseEvent.MOUSE_OUT, f);
        }

        /**
         * Remove MouseEvent.MOUSE_OVER event from the stage
         * @param f Function to be removed from listening
         */
        public static function removeStageMouseOver(f:Function):void{
            _stage.removeEventListener(MouseEvent.MOUSE_OVER, f);
        }

        /**
         * Remove MouseEvent.MOUSE_UP event from the stage
         * @param f Function to be removed from listening
         */
        public static function removeStageMouseUp(f:Function):void{
            _stage.removeEventListener(MouseEvent.MOUSE_UP, f);
        }

        /**
         * Remove MouseEvent.MOUSE_WHEEL event from the stage
         * @param f Function to be removed from listening
         */
        public static function removeStageMouseWheel(f:Function):void{
            _stage.removeEventListener(MouseEvent.MOUSE_WHEEL, f);
        }

        // ################################################################################################################################################################################ //
        // ##
        // ##                                                                                                                                               P R I V A T E   M E T H O D S
        // ##
        // ################################################################################################################################################################################ //

        // ==========================================================================================================================================
        // ==                                                                                                                              ACTION
        // ==========================================================================================================================================

        internal static function initialize(stage:Stage):void{
            if (_stage){
                throw new Error("You can't initialize the framework more than once!");
            }
            if (!stage){
                throw new Error("You have to pass a valid Stage object!");
            }

            //Init Variables

            _stage = stage;

            for (var i:int = 0; i < 256; i++){
                _keyDowns[i] = false;
                _keyHits [i] = false;
            }

            //Init listeners

            _stage.addEventListener(MouseEvent.MOUSE_MOVE,  onMouseMove);
            _stage.addEventListener(MouseEvent.MOUSE_DOWN,  onMouseDown);
            _stage.addEventListener(MouseEvent.MOUSE_UP,    onMouseUp);
            _stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            _stage.addEventListener(KeyboardEvent.KEY_UP,   onKeyUp);
        }

        /**
         * Internal framework update function. Flushes isMousHit and keyHits
         */
        retrocamel_int static function onEnterFrameUpdate():void{
            _isMouseHit = false;

            for (var i:int = 0; i < 256; i++){
                _keyHits [i] = false;
            }
        }

        // ==========================================================================================================================================
        // ==                                                                                                                     EVENT LISTENERS
        // ==========================================================================================================================================

        // ::::::::::::::::::::::::::::::::::::::::::::::::
        // :: Keyboard related
        // ::::::::::::::::::::::::::::::::::::::::::::::::

        private static function onKeyDown(e:KeyboardEvent):void{
            _isAltDown   = e.altKey;
            _isCtrlDown  = e.ctrlKey;
            _isShiftDown = e.shiftKey;
            _lastKeyDown = e.keyCode;

            _keyHits [e.keyCode % 256] = _keyDowns[e.keyCode % 256] = true;

            _keyDownSignal.call(e.keyCode);

        }

        private static function onKeyUp(e:KeyboardEvent):void{
            _isAltDown   = e.altKey;
            _isCtrlDown  = e.ctrlKey;
            _isShiftDown = e.shiftKey;

            _keyDowns[e.keyCode % 256] = false;
        }




        // ::::::::::::::::::::::::::::::::::::::::::::::::
        // :: Mouse related
        // ::::::::::::::::::::::::::::::::::::::::::::::::

        private static function onMouseMove(e:MouseEvent):void{
            _isAltDown   = e.altKey;
            _isCtrlDown  = e.ctrlKey;
            _isShiftDown = e.shiftKey;
            _isMouseDown = e.buttonDown;
            _mouseX      = e.stageX;
            _mouseY      = e.stageY;
        }

        private static function onMouseDown(e:MouseEvent):void{
            _isAltDown   = e.altKey;
            _isCtrlDown  = e.ctrlKey;
            _isShiftDown = e.shiftKey;
            _isMouseDown = e.buttonDown;
            _mouseX      = e.stageX;
            _mouseY      = e.stageY;

            _isMouseHit  = true;
        }

        private static function onMouseUp(e:MouseEvent):void{
            _isAltDown   = e.altKey;
            _isCtrlDown  = e.ctrlKey;
            _isShiftDown = e.shiftKey;
            _isMouseDown = e.buttonDown;
            _mouseX      = e.stageX;
            _mouseY      = e.stageY;
        }
    }
}