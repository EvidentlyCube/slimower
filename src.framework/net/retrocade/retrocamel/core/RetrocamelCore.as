

package net.retrocade.retrocamel.core {

    import flash.display.MovieClip;

    import net.retrocade.retrocamel.components.RetrocamelUpdatableGroup;
    import net.retrocade.retrocamel.components.RetrocamelStateBase;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.utils.getTimer;

    import net.retrocade.retrocamel.interfaces.IRetrocamelMake;

    import net.retrocade.retrocamel.interfaces.IRetrocamelSettings;
    import net.retrocade.retrocamel.locale.RetrocamelLocale;

    use namespace retrocamel_int;

    /**
     * ...
     * @author Maurycy Zarzycki
     */
    public class RetrocamelCore {
        /**
         * Time spent since last step
         */
        private static var _deltaTime:Number = 0;

        /**
         * Time which passed since last step
         */
        public static function get deltaTime():Number {
            return _deltaTime;
        }

        /**
         * Global updates group which is always updated before anything else
         */
        private static var _groupBefore:RetrocamelUpdatableGroup = new RetrocamelUpdatableGroup();

        /**
         * Retrieves global updates group which is always updated before everything else
         */
        public static function get groupBefore():RetrocamelUpdatableGroup {
            return _groupBefore;
        }

        /**
         * Global updates group which is always updated after anything else
         */
        private static var _groupAfter:RetrocamelUpdatableGroup = new RetrocamelUpdatableGroup();

        /**
         * Retrieves global updates group which is always updated after everything else
         */
        public static function get groupAfter():RetrocamelUpdatableGroup {
            return _groupAfter;
        }


        /**
         * Time of last enter frame
         */
        private static var _lastTime:Number = 0;

        /**
         * The settings object
         */
        retrocamel_int static var settings:IRetrocamelSettings;

        /**
         * The make object
         */
        retrocamel_int static var make:IRetrocamelMake;

        /**
         * Currently displayed state
         */
        private static var _currentState:RetrocamelStateBase;

        /**
         * Retrieves current state
         */
        public static function get currentState():RetrocamelStateBase {
            return _currentState;
        }


        /**
         * Boolean indicating if the game is currently paused
         */
        private static var _paused:Boolean = false;

        /**
         * Accesses the flag indicating if game is paused or not
         */
        public static function get paused():Boolean {
            return _paused;
        }

        /**
         * @private
         */
        public static function set paused(value:Boolean):void {
            _paused = value;
        }

        /**
         * A function to call if an error is found (only during enter frame execution).
         * The error will be passed as the first argument.
         * If not set, the error handling will work as default in flash.
         */
        public static var errorCallback:Function;

        /**
         * Initialzes the whole game
         */
        public static function initFlash(stage:Stage, main:MovieClip, settingsInstance:IRetrocamelSettings, makeInstance:IRetrocamelMake):void {
            settings = settingsInstance;
            make = makeInstance;

            stage.frameRate = 60;

            RetrocamelLocale.initialize();
            RetrocamelInputManager.initialize(stage);
            RetrocamelDisplayManager.initializeFlash(main, stage);

            stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }


        /**
         * Changes the current state
         * @param state State to be set
         */
        public static function setState(state:RetrocamelStateBase):void {
            if (_currentState) {
                _currentState.destroy();
            }

            _currentState = state;
            _currentState.create();
        }

        private static function onEnterFrame(e:Event = null):void {
            if (errorCallback != null) {
                try {
                    onEnterFrameSub();
                } catch (error:Error) {
                    errorCallback(error);
                }
            } else {
                onEnterFrameSub();
            }
        }

        private static function onEnterFrameSub():void {
            if (RetrocamelDisplayManager.flashStage.focus && !RetrocamelDisplayManager.flashStage.focus.stage) {
                RetrocamelDisplayManager.flashStage.focus = null;
            }

            _deltaTime = getTimer() - _lastTime;
            _lastTime = getTimer();

            RetrocamelWindowsManager.update();

            _groupBefore.update();
            if (_currentState && !_paused && !RetrocamelWindowsManager.pauseGame) {
                _currentState.update();
            }
            _groupAfter.update();

            RetrocamelInputManager.onEnterFrameUpdate();
        }

        retrocamel_int static function onStageResized():void {
            if (_currentState) {
                _currentState.resize();
            }
        }
    }
}