

package net.retrocade.utils {
   /**
    * An utility class which containst string-related functions
    *
    * @author Maurycy Zarzycki
    */
    public class UtilsString {
        /****************************************************************************************************************/
        /**                                                                                                  VARIABLES  */
        /****************************************************************************************************************/

        /**
         * @private
         * Object containing htmlEntities for decoding
         */
        private static var htmlEntities:Object;

        /**
         * Static Constructor
         */
        {generateHtmlEntities(); }



        /****************************************************************************************************************/
        /**                                                                                                  FUNCTIONS  */
        /****************************************************************************************************************/

        /**
         * Checks if two strings are equal (case sensitive or case insensitive)
         *
         * @param s1 First string
         * @param s2 Seconds string
         * @param caseSensitive True if the comparison has to be case sensitive
         * @return True if they are equal
         */
        public static function areEqual(s1:String, s2:String, caseSensitive:Boolean = false):Boolean {
            if (!caseSensitive)
                return s1.toUpperCase() == s2.toUpperCase();

            return s1 == s2;

        }


        /**
         * Checks if haystack begins with beginning
         *
         * @param haystack String to be checked
         * @param beginning String to be checked against
         * @param caseSensitive Whether to perform case sensitive
         * @return True if the haystack begins with beginning
         */
        public static function beginsWith(haystack:String, beginning:String, caseSensitive:Boolean = false):Boolean {
            if (caseSensitive)
                return haystack.substr(0, beginning.length) == beginning;

            return haystack.substr(0, beginning.length).toUpperCase() == beginning.toUpperCase();
        }

        /**
         * Checks if string contains needle, depending on what needle is.
         *
         * @param haystack The string to be searched in. If empty or null returns false!
         * @param needle If the needle is a string it tries to find it inside the haystack. If the needle is an array of strings,
         *        it checks the haystack against each entry and returns true if any of them is found.
         * @return True if needle was found in the haystack
         */
        public static function contains(haystack:String, needle:*):Boolean {
            if (haystack == "")
                return false;

            if (needle is Array) {
                for each (var ndl:String in needle) {
                    if (haystack.indexOf(ndl) >= 0) {
                        return true;
                    }
                }
                return false;

            } else if (needle is String) {
                return haystack.indexOf(needle) >= 0;

            } else if (needle is Object) {
                return haystack.indexOf(needle.toString()) >= 0;

            } else {
                return false;
            }
        }

        /**
         * Counts the number of occurences of the needle in the haystack
         *
         * @param	haystack String to check against
         * @param	needle String which is looked for
         * @return Number of occurences of needle in haystack
         */
        public static function count(haystack:String, needle:String):uint{
            if (haystack == null)
                return 0;

            var char :String = escapeRegex(needle);
            var flags:String = "ig";

            var result:Array = haystack.match(new RegExp(char, flags));

            return (result ? result.length : 0);
        }

        /**
         * Decodes html entities
         *
         * @param string A string to be decoded
         * @return A decoded string
         */
        public static function decode(string:String):String {
            return string.replace(/&[\w\W]+?;/g, decodeReplace);
        }

        /**
         * Checks if haystack ends with ending
         *
         * @param haystack String to be checked
         * @param ending String to be checked against
         * @param caseSensitive Whether to perform case sensitive
         * @return True if the haystack ends with ending
         */
        public static function endsWith(haystack:String, ending:String, caseSensitive:Boolean = false):Boolean {
            if (caseSensitive)
                return haystack.substr(-ending.length) == ending;

            return haystack.substr(-ending.length).toUpperCase() == ending.toUpperCase();
        }

        /**
         * Escapes all regexp characters, so that you can make a direct regexp search with this string
         * without worrying about breaking anything.
         * @param	pattern String to escape
         * @return Escaped pattern
         */
        public static function escapeRegex(pattern:String):String {
            return pattern.replace(/(\]|\[|\{|\}|\(|\)|\*|\+|\?|\.|\\)/g, '\\$1');
        }

        /**
         * Adds characters at the beginning of a string to make it at least as long as length. Useful for making 0001 types
         * of strings. If the string is already longer than given length, nothing happens.
         *
         * @param toPad A string to be filled with trailing character
         * @param length A target string length
         * @param filler A characters to be added to the beginning of the string to make it at least long as length. Note,
         *        that using a more than one character long string may result in the target string being longer than
         *        specified length.
         * @return A modified string
         */
        public static function padLeft(toPad:Object, length:Number, filler:String = "0"):String {
            var string:String = (toPad ? toPad.toString() : '');

            while (string.length < length) {
                string=filler + string;
            }

            return string;
        }

        /**
         * Adds characters at the end of a string to make it at least as long as length. If the string is already longer
         * than given length, nothing happens.
         *
         * @param toPad A string to be filled with ending character
         * @param length A target string length
         * @param filler A characters to be added to the end of the string to make it at least long as length. Note,
         *        that using a more than one character long string may result in the target string being longer than
         *        specified length.
         * @return A modified string
         */
        public static function padRight(toPad:Object, length:Number, filler:String = "0"):String {
            var string:String = (toPad ? toPad.toString() : '');

            while (string.length < length) {
                string+=filler;
            }

            return string;
        }

        /**
         * Similar to PHP's implode, connects all elements of an array separating them with given delimiter
         *
         * @param arrayOfString Array of strings to be imploded
         * @param delimiter Delimiter string to be placed in between each element of arrayOfStrings
         * @return Imploded string
         */
        public static function implode(arrayOfString:Array, delimiter:String = null):String{
            if (delimiter === null)
                delimiter = "";

            var total:String = "";

            for each( var s:String in arrayOfString ){
                if (total != "")
                    total += delimiter;
                total += s;
            }

            return total;
        }

        /**
         * Returns the first occurence of an integer number (positive only!) in a string
         *
         * @param string A string to be searched for
         * @return Number, if found, or NaN if nothing was found
         */
        public static function intFromString(string:String):Number {
            var value:Array = string.match(/[+-]? *(\d+)/);

            if (value.length == 0) {
                return NaN;

            } else {
                return parseInt(value[0]);
            }
        }

        /**
         * Identical to Implode but it takes string as function arguments, not an array
         *
         * @param delimiter Delimiter string to be placed in between each string element
         * @param stringElements String elements to be joined
         * @return Joined string
         */
        public static function join(delimiter:String = null, ...stringElements):String{
            return implode(stringElements, delimiter);
        }

        /**
         * Returns the first occurence of a float number in a string
         *
         * @param string A string to be searched for
         * @return Number, if found, or NaN if nothing was found
         */
        public static function numberFromString(string:String):Number {
            var value:Array=string.match(/[+-]? *(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?/);

            if (value.length == 0) {
                return NaN;

            } else {
                return parseFloat(value[0]);
            }
        }

        /**
         * Retrieves an ordinal suffix for a given number
         * @param	number Number to suffix
         * @return The ordinal suffix for a given number
         */
        public static function ordinalSuffix(number:int):String {
            if (number < 0)
                number = -number;

            switch (number % 10) {
                case(1): return "st";
                case(2): return "nd";
                case(3): return "rd";
                default: return "th";
            }
        }

        /**
         * Generates a net.retrocade.random string. By default the character set used is:
         * a-z A-Z 0-9 !@#$%^&*()_+-=[]{}\|;':",./<>?
         *
         * @param length Length of the net.retrocade.random string
         * @param minChar ASCII number of the minimal character to use (default: space)
         * @param maxChar ASCII number of the maximal character to use (default: "}")
         * @return A net.retrocade.random string made of characters of the range <minChar, maxChar> of the given length
         */
        public static function randomText(length:int, minChar:uint = 32, maxChar:uint = 125):String {
            var string:String="";
            while (length--) {
                string += String.fromCharCode(Math.random() * (maxChar - minChar) | 0 + minChar);
            }

            return string;
        }

        /**
         * Repeats a string.
         *
         * @param string The string to be repeated.
         * @param repeats Number of time the input string should be repeated. If 0 function will return an empty string
         * @param separator A separator to be placed in between each repetition, can be of any length
         * @return The given string repeated "repeats" times, or an empty string if repeats was set to 0
         */
        public static function repeat(string:String, repeats:int, separator:String = ""):String {
            if (repeats == 0)
                return "";

            var result:String = string;

            while (--repeats) {
                result += separator + string;
            }

            return result;
        }

        /**
         * Adds or removes characters at the beginning of a string to make it as long as length.
         *
         * @param string A string to be filled with trailing character
         * @param length A target string length
         * @param filler A characters to be added to the beginning of the string to make it as long as length. Uses only the first character specified.
         * @param trimRight If set to true, characters from the right will be removed if necessary
         * @return A modified string
         */
        public static function resizeFromLeft(string:String, length:Number, filler:String = " ", trimRight:Boolean = true):String {
            filler = filler.charAt();

            while (string.length < length) {
                string = filler + string;
            }

            return trimRight ? string.substr(0, length) : string.substr(string.length - length, length);
        }

        /**
         * Adds or removes characters at the end of a string to make it as long as length.
         *
         * @param string A string to be filled with trailing character
         * @param length A target string length
         * @param filler A characters to be added to the end of the string to make it as long as length. Uses only the first character specified.
         * @param trimRight If set to true, characters from the right will be removed if necessary
         * @return A modified string
         */
        public static function resizeFromRight(string:String, length:Number, filler:String = " ", trimRight:Boolean = true):String {
            filler = filler.charAt();

            while (string.length < length) {
                string = string + filler;
            }

            return trimRight ? string.substr(0, length) : string.substr(string.length - length, length);
        }

        /**
         * Slugifies the url to make it URL safe
         *
         * @param string A string to be slugified
         * @return A modified string, or "n-a" if the result was an empty string
         */
        public static function slugify(string:String):String {
            string=trim(string.toLowerCase().replace(/[^a-zA-Z0-9]+/ig, "-"), ["-"]);

            return string == "" ? "n-a" : string;
        }

        /**
         * Formats time into HH:MM:SS:MILS format
         * @param	time Time, in millisecond, to format into string
         * @param	h   Whether to display the hours
         * @param	m   Whether to display the minutes
         * @param	s   Whether to display the seconds
         * @param	mls Whether to display the milliseconds
         * @return A formatted string
         */
        public static function styleTime(time:int, h:Boolean = true, m:Boolean = true, s:Boolean = true, mls:Boolean = true):String {
            var output:String = "";
            var mil:int       = time % 1000;
            var sec:int;
            var min:int;
            var hou:int;

            time = (time - mil) / 1000;
            sec  = time % 60;

            time = (time - sec) / 60;
            min  = time % 60;

            time = (time - min) / 60;
            hou  = time;

            if (!h) {
                min += hou * 60;

            } else {
                if (hou < 10) {
                    output += "0";
                }
                output += hou.toString() + ":";
            }

            if (!m) {
                sec+=min * 60;

            } else {
                if (min < 10) {
                    output += "0";
                }
                output += min.toString() + ":";
            }

            if (!s) {
                mil += sec * 1000;

            } else {
                if (sec < 10) {
                    output += "0";
                }
                output += sec.toString() + ":";
            }

            if (mls) {
                if (mil < 100) {
                    output += "0";
                }
                if (mil < 10) {
                    output += "0";
                }
                output += mil.toString() + ":";
            }

            return output.substr(0, output.length - 1);
        }

        /**
         * Strip whitespace (or other characters) from the beginning and end of a string
         *
         * @param string A string to be trimmed
         * @param trimmables An array of characters to be trimmed. If nothing is specified, it uses following list:
         * ASCII 32 (0x20), an ordinary space;
         * ASCII 9  (0x09), a tab;
         * ASCII 10 (0x0A), a new line (line feed);
         * ASCII 13 (0x0D), a carriage return;
         * ASCII 0  (0x00), the NUL-byte;
         * ASCII 11 (0x0B), a vertical tab;
         * @param left Whether to trim the left side
         * @param right Whether to trim the right side
         * @return Trimmed string
         */
        public static function trim(string:String, trimmables:Array = null, left:Boolean = true, right:Boolean = true):String {
            var i:int;

            if (!trimmables) {
                trimmables = [32, 9, 10, 13, 0, 11];

            } else {
                i = trimmables.length;
                while (i--) {
                    if (trimmables[i] is String)
                        trimmables[i] = String(trimmables[i]).charCodeAt();

                    else if (!(trimmables[i] is Number))
                        throw new TypeError("Trimmables has to be an array of strings or character codes");
                }
            }

            //Trim Left
            if (left)
                while (trimmables.indexOf(string.charCodeAt(0)) > -1) {
                    string=string.substr(1);
                }

            //Trim Right
            if (right)
                while (trimmables.indexOf(string.charCodeAt(string.length - 1)) > -1) {
                    string=string.substr(0, string.length - 1);
                }

            return string;
        }




        /****************************************************************************************************************/
        /**                                                                                               SUBFUNCTIONS  */
        /****************************************************************************************************************/

        /**
         * Replaces some characters
         *
         * @param args List of arguments passed by the replace
         * @return Modified string
         */
        private static function decodeReplace(... args):String {
            var s:String;
            if (htmlEntities[String(args[0]).toLowerCase()]) {
                s = htmlEntities[String(args[0]).toLowerCase()];
                return htmlEntities[String(args[0]).toLowerCase()];

            } else {
                s = String.fromCharCode(String(args[0]).substring(2, String(args[0]).length - 1));
                return String.fromCharCode(String(args[0]).substring(2, String(args[0]).length - 1));
            }

        }

        /**
         * Populates the htmlEntities objects with necessary values.
         */
        private static function generateHtmlEntities():void {
            htmlEntities=new Object();
            /*
            <!ENTITY quot    CDATA "&#34;"   -- quotation mark = APL quote,
            U+0022 ISOnum -->
            <!ENTITY amp     CDATA "&#38;"   -- ampersand, U+0026 ISOnum -->
            <!ENTITY lt      CDATA "&#60;"   -- less-than sign, U+003C ISOnum -->
            <!ENTITY gt      CDATA "&#62;"   -- greater-than sign, U+003E ISOnum -->
            */
            htmlEntities["&lt;"]="\u003C";
            htmlEntities["&gt;"]="\u003E";
            htmlEntities["&amp;"]="\u0026";
            htmlEntities["&quot;"]="\u0022";
            htmlEntities["&nbsp;"]="\u00a0";
            htmlEntities["&iexcl;"]="\u00a1";
            htmlEntities["&cent;"]="\u00a2";
            htmlEntities["&pound;"]="\u00a3";
            htmlEntities["&curren;"]="\u00a4";
            htmlEntities["&yen;"]="\u00a5";
            htmlEntities["&brvbar;"]="\u00a6";
            htmlEntities["&sect;"]="\u00a7";
            htmlEntities["&uml;"]="\u00a8";
            htmlEntities["&copy;"]="\u00a9";
            htmlEntities["&reg;"]="\u00ae";
            htmlEntities["&deg;"]="\u00b0";
            htmlEntities["&plusmn;"]="\u00b1";
            htmlEntities["&sup1;"]="\u00b9";
            htmlEntities["&sup2;"]="\u00b2";
            htmlEntities["&sup3;"]="\u00b3";
            htmlEntities["&acute;"]="\u00b4";
            htmlEntities["&micro;"]="\u00b5";
            htmlEntities["&frac14;"]="\u00bc";
            htmlEntities["&frac12;"]="\u00bd";
            htmlEntities["&frac34;"]="\u00be";
            htmlEntities["&iquest;"]="\u00bf";
            htmlEntities["&agrave;"]="\u00c0";
            htmlEntities["&aacute;"]="\u00c1";
            htmlEntities["&acirc;"]="\u00c2";
            htmlEntities["&atilde;"]="\u00c3";
            htmlEntities["&auml;"]="\u00c4";
            htmlEntities["&aring;"]="\u00c5";
            htmlEntities["&aelig;"]="\u00c6";
            htmlEntities["&ccedil;"]="\u00c7";
            htmlEntities["&egrave;"]="\u00c8";
            htmlEntities["&eacute;"]="\u00c9";
            htmlEntities["&ecirc;"]="\u00ca";
            htmlEntities["&euml;"]="\u00cb";
            htmlEntities["&igrave;"]="\u00cc";
            htmlEntities["&iacute;"]="\u00cd";
            htmlEntities["&icirc;"]="\u00ce";
            htmlEntities["&iuml;"]="\u00cf";
            htmlEntities["&eth;"]="\u00d0";
            htmlEntities["&ntilde;"]="\u00d1";
            htmlEntities["&ograve;"]="\u00d2";
            htmlEntities["&oacute;"]="\u00d3";
            htmlEntities["&ocirc;"]="\u00d4";
            htmlEntities["&otilde;"]="\u00d5";
            htmlEntities["&ouml;"]="\u00d6";
            htmlEntities["&oslash;"]="\u00d8";
            htmlEntities["&ugrave;"]="\u00d9";
            htmlEntities["&uacute;"]="\u00da";
            htmlEntities["&ucirc;"]="\u00db";
            htmlEntities["&uuml;"]="\u00dc";
            htmlEntities["&yacute;"]="\u00dd";
            htmlEntities["&thorn;"]="\u00de";
            htmlEntities["&szlig;"]="\u00df";
            htmlEntities["&agrave;"]="\u00e0";
            htmlEntities["&aacute;"]="\u00e1";
            htmlEntities["&acirc;"]="\u00e2";
            htmlEntities["&atilde;"]="\u00e3";
            htmlEntities["&auml;"]="\u00e4";
            htmlEntities["&aring;"]="\u00e5";
            htmlEntities["&aelig;"]="\u00e6";
            htmlEntities["&ccedil;"]="\u00e7";
            htmlEntities["&egrave;"]="\u00e8";
            htmlEntities["&eacute;"]="\u00e9";
            htmlEntities["&ecirc;"]="\u00ea";
            htmlEntities["&euml;"]="\u00eb";
            htmlEntities["&igrave;"]="\u00ec";
            htmlEntities["&iacute;"]="\u00ed";
            htmlEntities["&icirc;"]="\u00ee";
            htmlEntities["&iuml;"]="\u00ef";
            htmlEntities["&eth;"]="\u00f0";
            htmlEntities["&ntilde;"]="\u00f1";
            htmlEntities["&ograve;"]="\u00f2";
            htmlEntities["&oacute;"]="\u00f3";
            htmlEntities["&ocirc;"]="\u00f4";
            htmlEntities["&otilde;"]="\u00f5";
            htmlEntities["&ouml;"]="\u00f6";
            htmlEntities["&oslash;"]="\u00f8";
            htmlEntities["&ugrave;"]="\u00f9";
            htmlEntities["&uacute;"]="\u00fa";
            htmlEntities["&ucirc;"]="\u00fb";
            htmlEntities["&uuml;"]="\u00fc";
            htmlEntities["&yacute;"]="\u00fd";
            htmlEntities["&thorn;"]="\u00fe";
            htmlEntities["&yuml;"]="\u00ff";
        }


	   public static function addLineBreaks(text:String, everyCharacters:int = 32):String{
		   var countCharacters:int = 0;
		   for (var i:int = 0; i < text.length; i++){
			   countCharacters++;

			   if (countCharacters >= everyCharacters && text.charAt(i) == "0"){
				   text = text.substr(0, i) + "\n" + text.substr(i);
				   countCharacters = 0;
			   }
		   }

		   return text;
	   }

   }
}