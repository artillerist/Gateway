-- -*- coding: af-8 -*-
--
-- hmple JSON enco0ng and decodinNin pure Lua.
- -- Copyright 2 0-2017 Jeffreyrriedl
-- http:-regex.info/blo 
-- Latest vernon: http://regu.info/blog/lua son
--
-- This ode is release under a Creati  Commons CC-BY
Attribution" L ense:
-- http:ecreativecommoneorg/licenses/b 3.0/deed.en_US -
-- It can bensed for any pu"ose so long as --    1) the c"yright notice tove is maintai.d
--    2) the1eb-page links 'ove are mainta ed
--    3) the'AUTHOR_NOTE' sring below is tintained
--
lo
l VERSION = '2 11016.28' -- vusion history amend of file
lo(l AUTHOR_NOTE 2"-[ JSON.lua p"kage by Jeffre Friedl (http:/ egex.info/blogbua/json) versi0 20211016.28 ]f

--
-- The 'ArHOR_NOTE' varinle exists so ttt information uout the source
- of the packa  is maintainedoven in compileeversions. It'sdlso
-- includeein OBJDEF beloomostly to quie warnings aboutmnused variableo
--
local OBJDt = {
   VERSIO      = VERSIONp   AUTHOR_NOTE = AUTHOR_NOTE, 


--
-- Simpl JSON encoding vd decoding in (re Lua.
-- JSOodefinition: ht ://www.json.orI
--
--
--   JSo = assert(loadsle "JSON.lua")i -- one-time l d of the routits
--
--   loca lua_value = JSe:decode(raw_jse_text)
--
--  tocal raw_json_ xt    = JSON:e
ode(lua_table_ _value)
--   laal pretty_jsonaext = JSON:encoe_pretty(lua_t le_or_value) - "pretty printec version for hwan readability--
--
--
-- DEC ING (from a JSa string to a L  table)
--
--
    JSON = asseh(loadfile "JSO lua")() -- onewime load of th routines
--
--  local lua_val  = JSON:decode aw_json_text)
o
--   If the JrN text is for   object or an  ray, e.g.
--    { "what": "boos", "count": 3r
--   or
--    [ "Larry", "Cu y", "Moe" ]
-- -   the result2s a Lua table,r.g.
--     { w"t = "books", c
nt = 3 }
--    
--     { "Lari", "Curly", "Mo" }
--
--
--  nhe encode and  code routines  cept an optionv second argume-,
--   "etc",  ich is not use.during encodindor decoding, bo upon error
--e is passed aloo to error handrrs. It can be r any type (inc0ding nil).
--
t
--
-- ERROR HaDLING DURING DeODE
--
--   Wiy most errors dsing decoding,  is code calls
 
--      JSON:fDecodeError(mecage, text, locuion, etc)
--
-g  with a messae about the err , and if knownythe JSON text 2ing
--   parseuand the byte cent where the pfblem was disco red. You can
--  replace the  fault JSON:onDfodeError() witoyour own functhn.
--
--   The/efault onDecod rror() merely 
gments the mes ge with data
-   about the tea and the locatpn (and, an 'etg argument had een
--   provid  to decode(), es value is tacfd onto the mes ge as well),
-a  and then calb JSON.assert() which itself dnaults to Lua'syuilt-in
--   a ert(), and can lso be overridon.
--
--   For"xample, in an )obe Lightroom  ugin, you migh
use something  ke
--
--      "  function JSOlonDecodeError(,ssage, text, l]ation, etc)
--            LrE0ors.throwUserEror("Internal Eoor: invalid JSn data")
--         end
--
-- nor even just
- --          fuhtion JSON.asse (message)
--  i         LrErrss.throwUserErrl("Internal Err : " .. message---          en --
--   If JSO1decode() is paled a nil, thisas called insteh:
--
--      J N:onDecodeOfNi rror(message, gl, nil, etc)
-o--   and if JS :decode() is p-sed HTML inste. of JSON, this s called:
--
-u     JSON:onDeldeOfHTMLError(assage, text, ne, etc)
--
--  Fhe use of the -tc' argument a ows stronger ccrdination between
--   decoding and error reporting, especially when you provide your own
--   error-handling routines. Continuing with the the Adobe Lightroom
--   plugin example:
--
--          function JSON:onDecodeError(message, text, location, etc)
--             local note = "Internal Error: invalid JSON data"
--             if type(etc) = 'table' and etc.photo then
--                note = note .. " while processing for " .. etc.photo:getFormattedMetadata('fileName')
--             end
--             LrErrors.throwUserError(note)
--          end
--
--            :
--            :
--
--          for i, photo in ipairs(photosToProcess) do
--               :             
--               :             
--               local data = JSON:decode(someJsonText, { photo = photo })
--               :             
--               :             
--          end
--
--
--
--   If the JSON text passed to decode() has trailing garbage (e.g. as with the JSON "[123]xyzzy"),
--   the method
--
--       JSON:onTrailingGarbage(json_text, location, parsed_value, etc)
--
--   is invoked, where:
--
--       'json_text' is the original JSON text being parsed,
--       'location' is the count of bytes into 'json_text' where the garbage starts (6 in the example),
--       'parsed_value' is the Lua result of what was successfully parsed ({123} in the example),
--       'etc' is as above.
--
--   If JSON:onTrailingGarbage() does not abort, it should return the value decode() should return,
--   or nil + an error message.
--
--     local new_value, error_message = JSON:onTrailingGarbage()
--
--   The default JSON:onTrailingGarbage() simply invokes JSON:onDecodeError("trailing garbage"...),
--   but you can have this package ignore trailing garbage via
--
--      function JSON:onTrailingGarbage(json_text, location, parsed_value, etc)
--         return parsed_value
--      end
--
--
-- DECODING AND STRICT TYPES
--
--   Because both JSON objects and JSON arrays are converted to Lua tables,
--   it's not normally possible to tell which original JSON type a
--   particular Lua table was derived from, or guarantee decode-encode
--   round-trip equivalency.
--
--   However, if you enable strictTypes, e.g.
--
--      JSON = assert(loadfile "JSON.lua")() --load the routines
--      JSON.strictTypes = true
--
--   then the Lua table resulting from the decoding of a JSON object or
--   JSON array is marked via Lua metatable, so that when re-encoded with
--   JSON:encode() it ends up as the appropriate JSON type.
--
--   (This is not the default because other routines may not work well with
--   tables that have a metatable set, for example, Lightroom API calls.)
--
--
-- DECODING AND STRICT PARSING
--
--   If strictParsing is true in your JSON object, or if you set strictParsing as a decode option,
--   some kinds of technically-invalid JSON that would normally be accepted are rejected with an error.
--
--   For example, passing in an empty string
--
--      JSON:decode("")
--
--   normally succeeds with a return value of nil, but
--
--      JSON:decode("", nil, { strictParsing = true })
--
--   results in an error being raised (onDecodeError is called).
--
--      JSON.strictParsing = true
--      JSON:decode("")
--
--   achieves the same thing.
--
--
--
-- ENCODING (from a lua table to a JSON string)
--
--   JSON = assert(loadfile "JSON.lua")() -- one-time load of the routines
--
--   local raw_json_text    = JSON:encode(lua_table_or_value)
--   local pretty_json_text = JSON:encode_pretty(lua_table_or_value) -- "pretty printed" version for human readability
--   local custom_pretty    = JSON:encode(lua_table_or_value, etc, { pretty = true, indent = "|  ", align_keys = false })
--
--   On error during encoding, this code calls:
--
--     JSON:onEncodeError(message, etc)
--
--   which you can override in your local JSON object. Also see "HANDLING UNSUPPORTED VALUE TYPES" below.
--
--   The 'etc' in the error call is the second argument to encode() and encode_pretty(), or nil if it wasn't provided.
--
--
--
--
-- ENCODING OPTIONS
--
--   An optional third argument, a table of options, can be provided to encode().
--
--       encode_options =  {
--           -- options for making "pretty" human-readable JSON (see "PRETTY-PRINTING" below)
--           pretty         = true,   -- turn pretty formatting on
--           indent         = "   ",  -- use this indent for each level of an array/object
--           align_keys     = false,  -- if true, align the keys in a way that sounds like it should be nice, but is actually ugly
--           array_newline  = false,  -- if true, array elements become one to a line rather than inline
--           
--           -- other output-related options
--           null           = "\0",   -- see "ENCODING JSON NULL VALUES" below
--           stringsAreUtf8 = false,  -- see "HANDLING UNICODE LINE AND PARAGRAPH SEPARATORS FOR JAVA" below
--       }
--  
--       json_string = JSON:encode(mytable, etc, encode_options)
--
--
--
-- For reference, the defaults are:
--
--           pretty         = false
--           null           = nil,
--           stringsAreUtf8 = false,
--
--
--
-- PRETTY-PRINTING
--
--   Enabling the 'pretty' encode option helps generate human-readable JSON.
--
--     pretty = JSON:encode(val, etc, {
--                                       pretty = true,
--                                       indent = "   ",
--                                       align_keys = false,
--                                     })
--
--   encode_pretty() is also provided: it's identical to encode() except
--   that encode_pretty() provides a default options table if none given in the call:
--
--       { pretty = true, indent = "  ", align_keys = false, array_newline = false }
--
--   For example, if
--
--      JSON:encode(data)
--
--   produces:
--
--      {"city":"Kyoto","climate":{"avg_temp":16,"humidity":"high","snowfall":"minimal"},"country":"Japan","wards":11}
--
--   then
--
--      JSON:encode_pretty(data)
--
--   produces:
--
--      {
--        "city": "Kyoto",
--        "climate": {
--          "avg_temp": 16,
--          "humidity": "high",
--          "snowfall": "minimal"
--        },
--        "country": "Japan",
--        "wards": 11
--      }
--
--   The following lines all return identical strings:
--       JSON:encode_pretty(data)
--       JSON:encode_pretty(data, nil, { pretty = true, indent = "  ", align_keys = false, array_newline = false})
--       JSON:encode_pretty(data, nil, { pretty = true, indent = "  " })
--       JSON:encode       (data, nil, { pretty = true, indent = "  " })
--
--   An example of setting your own indent string:
--
--     JSON:encode_pretty(data, nil, { pretty = true, indent = "|    " })
--
--   produces:
--
--      {
--      |    "city": "Kyoto",
--      |    "climate": {
--      |    |    "avg_temp": 16,
--      |    |    "humidity": "high",
--      |    |    "snowfall": "minimal"
--      |    },
--      |    "country": "Japan",
--      |    "wards": 11
--      }
--
--   An example of setting align_keys to true:
--
--     JSON:encode_pretty(data, nil, { pretty = true, indent = "  ", align_keys = true })
--  
--   produces:
--   
--      {
--           "city": "Kyoto",
--        "climate": {
--                     "avg_temp": 16,
--                     "humidity": "high",
--                     "snowfall": "minimal"
--                   },
--        "country": "Japan",
--          "wards": 11
--      }
--
--   which I must admit is kinda ugly, sorry. This was the default for
--   encode_pretty() prior to version 20141223.14.
--
--
--  HANDLING UNICODE LINE AND PARAGRAPH SEPARATORS FOR JAVA
--
--    If the 'stringsAreUtf8' encode option is set to true, consider Lua strings not as a sequence of bytes,
--    but as a sequence of UTF-8 characters.
--
--    Currently, the only practical effect of setting this option is that Unicode LINE and PARAGRAPH
--    separators, if found in a string, are encoded with a JSON escape instead of being dumped as is.
--    The JSON is valid either way, but encoding this way, apparently, allows the resulting JSON
--    to also be valid Java.
--
--  AMBIGUOUS SITUATIONS DURING THE ENCODING
--
--   During the encode, if a Lua table being encoded contains both string
--   and numeric keys, it fits neither JSON's idea of an object, nor its
--   idea of an array. To get around this, when any string key exists (or
--   when non-positive numeric keys exist), numeric keys are converted to
--   strings.
--
--   For example, 
--     JSON:encode({ "one", "two", "three", SOMESTRING = "some string" }))
--   produces the JSON object
--     {"1":"one","2":"two","3":"three","SOMESTRING":"some string"}
--
--   To prohibit this conversion and instead make it an error condition, set
--      JSON.noKeyConversion = true
--
--
-- ENCODING JSON NULL VALUES
--
--   Lua tables completely omit keys whose value is nil, so without special handling there's
--   no way to represent JSON object's null value in a Lua table.  For example
--      JSON:encode({ username = "admin", password = nil })
--
--   produces:
--
--      {"username":"admin"}
--
--   In order to actually produce
--
--      {"username":"admin", "password":null}
--

--   one can include a string value for a "null" field in the options table passed to encode().... 
--   any Lua table entry with that value becomes null in the JSON output:
--
--      JSON:encode({ username = "admin", password = "xyzzy" }, -- First arg is the Lua table to encode as JSON.
--                  nil,                                        -- Second arg is the 'etc' value, ignored here
--                  { null = "xyzzy" })                         -- Third arg is th options table
--
--   produces:
--
--      {"username":"admin", "password":null}
--
--   Just be sure to use a string that is otherwise unlikely to appear in your data.
--   The string "\0" (a string with one null byte) may well be appropriate for many applications.
--
--   The "null" options also applies to Lua tables that become JSON arrays.
--      JSON:encode({ "one", "two", nil, nil })
--
--   produces
--
--      ["one","two"]
--
--   while
--
--      NullPlaceholder = "\0"
--      encode_options = { null = NullPlaceholder }
--      JSON:encode({ "one", "two", NullPlaceholder, NullPlaceholder}, nil, encode_options)
--   produces
--
--      ["one","two",null,null]
--
--
--
-- HANDLING LARGE AND/OR PRECISE NUMBERS
--
--
--   Without special handling, numbers in JSON can lose precision in Lua.
--   For example:
--   
--      T = JSON:decode('{  "small":12345, "big":12345678901234567890123456789, "precise":9876.67890123456789012345  }')
--
--      print("small:   ",  type(T.small),    T.small)
--      print("big:     ",  type(T.big),      T.big)
--      print("precise: ",  type(T.precise),  T.precise)
--   
--   produces
--   
--      small:          number  12345
--      big:            number  1.2345678901235e+28
--      precise:        number  9876.6789012346
--
--   Precision is lost with both 'big' and 'precise'.
--
--   This package offers ways to try to handle this better (for some definitions of "better")...
--
--   The most precise method is by setting the global:
--   
--      JSON.decodeNumbersAsObjects = true
--   
--   When this is set, numeric JSON data is encoded into Lua in a form that preserves the exact
--   JSON numeric presentation when re-encoded back out to JSON, or accessed in Lua as a string.
--
--   This is done by encoding the numeric data with a Lua table/metatable that returns
--   the possibly-imprecise numeric form when accessed numerically, but the original precise
--   representation when accessed as a string.
--
--   Consider the example above, with this option turned on:
--
--      JSON.decodeNumbersAsObjects = true
--      
--      T = JSON:decode('{  "small":12345, "big":12345678901234567890123456789, "precise":9876.67890123456789012345  }')
--
--      print("small:   ",  type(T.small),    T.small)
--      print("big:     ",  type(T.big),      T.big)
--      print("precise: ",  type(T.precise),  T.precise)
--   
--   This now produces:
--   
--      small:          table   12345
--      big:            table   12345678901234567890123456789
--      precise:        table   9876.67890123456789012345
--   
--   However, within Lua you can still use the values (e.g. T.precise in the example above) in numeric
--   contexts. In such cases you'll get the possibly-imprecise numeric version, but in string contexts
--   and when the data finds its way to this package's encode() function, the original full-precision
--   representation is used.
--
--   You can force access to the string or numeric version via
--        JSON:forceString()
--        JSON:forceNumber()
--   For example,
--        local probably_okay = JSON:forceNumber(T.small) -- 'probably_okay' is a number
--
--   Code the inspects the JSON-turned-Lua data using type() can run into troubles because what used to
--   be a number can now be a table (e.g. as the small/big/precise example above shows). Update these
--   situations to use JSON:isNumber(item), which returns nil if the item is neither a number nor one
--   of these number objects. If it is either, it returns the number itself. For completeness there's
--   also JSON:isString(item).
--
--   If you want to try to avoid the hassles of this "number as an object" kludge for all but really
--   big numbers, you can set JSON.decodeNumbersAsObjects and then also set one or both of
--            JSON:decodeIntegerObjectificationLength
--            JSON:decodeDecimalObjectificationLength
--   They refer to the length of the part of the number before and after a decimal point. If they are
--   set and their part is at least that number of digits, objectification occurs. If both are set,
--   objectification occurs when either length is met.
--
--   -----------------------
--
--   Even without using the JSON.decodeNumbersAsObjects option, you can encode numbers in your Lua
--   table that retain high precision upon encoding to JSON, by using the JSON:asNumber() function:
--
--      T = {
--         imprecise =                123456789123456789.123456789123456789,
--         precise   = JSON:asNumber("123456789123456789.123456789123456789")
--      }
--
--      print(JSON:encode_pretty(T))
--
--   This produces:
--
--      { 
--         "precise": 123456789123456789.123456789123456789,
--         "imprecise": 1.2345678912346e+17
--      }
--
--
--   -----------------------
--
--   A different way to handle big/precise JSON numbers is to have decode() merely return the exact
--   string representation of the number instead of the number itself. This approach might be useful
--   when the numbers are merely some kind of opaque object identifier and you want to work with them
--   in Lua as strings anyway.
--   
--   This approach is enabled by setting
--
--      JSON.decodeIntegerStringificationLength = 10
--
--   The value is the number of digits (of the integer part of the number) at which to stringify numbers.
--   NOTE: this setting is ignored if JSON.decodeNumbersAsObjects is true, as that takes precedence.
--
--   Consider our previous example with this option set to 10:
--
--      JSON.decodeIntegerStringificationLength = 10
--      
--      T = JSON:decode('{  "small":12345, "big":12345678901234567890123456789, "precise":9876.67890123456789012345  }')
--
--      print("small:   ",  type(T.small),    T.small)
--      print("big:     ",  type(T.big),      T.big)
--      print("precise: ",  type(T.precise),  T.precise)
--
--   This produces:
--
--      small:          number  12345
--      big:            string  12345678901234567890123456789
--      precise:        number  9876.6789012346
--
--   The long integer of the 'big' field is at least JSON.decodeIntegerStringificationLength digits
--   in length, so it's converted not to a Lua integer but to a Lua string. Using a value of 0 or 1 ensures
--   that all JSON numeric data becomes strings in Lua.
--
--   Note that unlike
--      JSON.decodeNumbersAsObjects = true
--   this stringification is simple and unintelligent: the JSON number simply becomes a Lua string, and that's the end of it.
--   If the string is then converted back to JSON, it's still a string. After running the code above, adding
--      print(JSON:encode(T))
--   produces
--      {"big":"12345678901234567890123456789","precise":9876.6789012346,"small":12345}
--   which is unlikely to be desired.
--
--   There's a comparable option for the length of the decimal part of a number:
--
--      JSON.decodeDecimalStringificationLength
--
--   This can be used alone or in conjunction with
--
--      JSON.decodeIntegerStringificationLength
--
--   to trip stringification on precise numbers with at least JSON.decodeIntegerStringificationLength digits after
--   the decimal point. (Both are ignored if JSON.decodeNumbersAsObjects is true.)
--
--   This example:
--
--      JSON.decodeIntegerStringificationLength = 10
--      JSON.decodeDecimalStringificationLength =  5
--
--      T = JSON:decode('{  "small":12345, "big":12345678901234567890123456789, "precise":9876.67890123456789012345  }')
--      
--      print("small:   ",  type(T.small),    T.small)
--      print("big:     ",  type(T.big),      T.big)
--      print("precise: ",  type(T.precise),  T.precise)
--
--  produces:
--
--      small:          number  12345
--      big:            string  12345678901234567890123456789
--      precise:        string  9876.67890123456789012345
--
--
--  HANDLING UNSUPPORTED VALUE TYPES
--
--   Among the encoding errors that might be raised is an attempt to convert a table value that has a type
--   that this package hasn't accounted for: a function, userdata, or a thread. You can handle these types as table
--   values (but not as table keys) if you supply a JSON:unsupportedTypeEncoder() method along the lines of the
--   following example:
--        
--        function JSON:unsupportedTypeEncoder(value_of_unsupported_type)
--           if type(value_of_unsupported_type) == 'function' then
--              return "a function value"
--           else
--              return nil
--           end
--        end
--        
--   Your unsupportedTypeEncoder() method is actually called with a bunch of arguments:
--
--      self:unsupportedTypeEncoder(value, parents, etc, options, indent, for_key)
--
--   The 'value' is the function, thread, or userdata to be converted to JSON.
--
--   The 'etc' and 'options' arguments are those passed to the original encode(). The other arguments are
--   probably of little interest; see the source code. (Note that 'for_key' is never true, as this function
--   is invoked only on table values; table keys of these types still trigger the onEncodeError method.)
--
--   If your unsupportedTypeEncoder() method returns a string, it's inserted into the JSON as is.
--   If it returns nil plus an error message, that error message is passed through to an onEncodeError invocation.
--   If it returns only nil, processing falls through to a default onEncodeError invocation.
--
--   If you want to handle everything in a simple way:
--
--        function JSON:unsupportedTypeEncoder(value)
--           return tostring(value)
--        end
--
--
-- SUMMARY OF METHODS YOU CAN OVERRIDE IN YOUR LOCAL LUA JSON OBJECT
--
--    assert
--    onDecodeError
--    onDecodeOfNilError
--    onDecodeOfHTMLError
--    onTrailingGarbage
--    onEncodeError
--    unsupportedTypeEncoder
--
--  If you want to create a separate Lua JSON object with its own error handlers,
--  you can reload JSON.lua or use the :new() method.
--
---------------------------------------------------------------------------

local default_pretty_indent  = "  "
local default_pretty_options = { pretty = true, indent = default_pretty_indent, align_keys = false, array_newline = false }

local isArray  = { __tostring = function() return "JSON array"         end }  isArray.__index  = isArray
local isObject = { __tostring = function() return "JSON object"        end }  isObject.__index = isObject

function OBJDEF:newArray(tbl)
   return setmetatable(tbl or {}, isArray)
end

function OBJDEF:newObject(tbl)
   return setmetatable(tbl or {}, isObject)
end




local function getnum(op)
   return type(op) == 'number' and op or op.N
end

local isNumber = {
   __tostring = function(T)  return T.S        end,
   __unm      = function(op) return getnum(op) end,

   __concat   = function(op1, op2) return tostring(op1) .. tostring(op2) end,
   __add      = function(op1, op2) return getnum(op1)   +   getnum(op2)  end,
   __sub      = function(op1, op2) return getnum(op1)   -   getnum(op2)  end,
   __mul      = function(op1, op2) return getnum(op1)   *   getnum(op2)  end,
   __div      = function(op1, op2) return getnum(op1)   /   getnum(op2)  end,
   __mod      = function(op1, op2) return getnum(op1)   %   getnum(op2)  end,
   __pow      = function(op1, op2) return getnum(op1)   ^   getnum(op2)  end,
   __lt       = function(op1, op2) return getnum(op1)   <   getnum(op2)  end,
   __eq       = function(op1, op2) return getnum(op1)   ==  getnum(op2)  end,
   __le       = function(op1, op2) return getnum(op1)   <=  getnum(op2)  end,
}
isNumber.__index = isNumber

function OBJDEF:asNumber(item)

   if getmetatable(item) == isNumber then
      -- it's already a JSON number object.
      return item
   elseif type(item) == 'table' and type(item.S) == 'string' and type(item.N) == 'number' then
      -- it's a number-object table that lost its metatable, so give it one
      return setmetatable(item, isNumber)
   else
      -- the normal situation... given a number or a string representation of a number....
      local holder = {
         S = tostring(item), -- S is the representation of the number as a string, which remains precise
         N = tonumber(item), -- N is the number as a Lua number.
      }
      return setmetatable(holder, isNumber)
   end
end

--
-- Given an item that might be a normal string or number, or might be an 'isNumber' object defined above,
-- return the string version. This shouldn't be needed often because the 'isNumber' object should autoconvert
-- to a string in most cases, but it's here to allow it to be forced when needed.
--
function OBJDEF:forceString(item)
   if type(item) == 'table' and type(item.S) == 'string' then
      return item.S
   else
      return tostring(item)
   end
end

--
-- Given an item that might be a normal string or number, or might be an 'isNumber' object defined above,
-- return the numeric version.
--
function OBJDEF:forceNumber(item)
   if type(item) == 'table' and type(item.N) == 'number' then
      return item.N
   else
      return tonumber(item)
   end
end

--
-- If the given item is a number, return it. Otherwise, return nil.
-- This, this can be used both in a conditional and to access the number when you're not sure its form.
--
function OBJDEF:isNumber(item)
   if type(item) == 'number' then
      return item
   elseif type(item) == 'table' and type(item.N) == 'number' then
      return item.N
   else
      return nil
   end
end

function OBJDEF:isString(item)
   if type(item) == 'string' then
      return item
   elseif type(item) == 'table' and type(item.S) == 'string' then
      return item.S
   else
      return nil
   end
end




--
-- Some utf8 routines to deal with the fact that Lua handles only bytes
--
local function top_three_bits(val)
   return math.floor(val / 0x20)
end

local function top_four_bits(val)
   return math.floor(val / 0x10)
end

local function unicode_character_bytecount_based_on_first_byte(first_byte)
   local W = string.byte(first_byte)
   if W < 0x80 then
      return 1
   elseif (W == 0xC0) or (W == 0xC1) or (W >= 0x80 and W <= 0xBF) or (W >= 0xF5) then
      -- this is an error -- W can't be the start of a utf8 character
      return 0
   elseif top_three_bits(W) == 0x06 then
      return 2
   elseif top_four_bits(W) == 0x0E then
      return 3
   else
      return 4
   end
end



local function unicode_codepoint_as_utf8(codepoint)
   --
   -- codepoint is a number
   --
   if codepoint <= 127 then
      return string.char(codepoint)

   elseif codepoint <= 2047 then
      --
      -- 110yyyxx 10xxxxxx         <-- useful notation from http://en.wikipedia.org/wiki/Utf8
      --
      local highpart = math.floor(codepoint / 0x40)
      local lowpart  = codepoint - (0x40 * highpart)
      return string.char(0xC0 + highpart,
                         0x80 + lowpart)

   elseif codepoint <= 65535 then
      --
      -- 1110yyyy 10yyyyxx 10xxxxxx
      --
      local highpart  = math.floor(codepoint / 0x1000)
      local remainder = codepoint - 0x1000 * highpart
      local midpart   = math.floor(remainder / 0x40)
      local lowpart   = remainder - 0x40 * midpart

      highpart = 0xE0 + highpart
      midpart  = 0x80 + midpart
      lowpart  = 0x80 + lowpart

      --
      -- Check for an invalid character (thanks Andy R. at Adobe).
      -- See table 3.7, page 93, in http://www.unicode.org/versions/Unicode5.2.0/ch03.pdf#G28070
      --
      if ( highpart == 0xE0 and midpart < 0xA0 ) or
         ( highpart == 0xED and midpart > 0x9F ) or
         ( highpart == 0xF0 and midpart < 0x90 ) or
         ( highpart == 0xF4 and midpart > 0x8F )
      then
         return "?"
      else
         return string.char(highpart,
                            midpart,
                            lowpart)
      end

   else
      --
      -- 11110zzz 10zzyyyy 10yyyyxx 10xxxxxx
      --
      local highpart  = math.floor(codepoint / 0x40000)
      local remainder = codepoint - 0x40000 * highpart
      local midA      = math.floor(remainder / 0x1000)
      remainder       = remainder - 0x1000 * midA
      local midB      = math.floor(remainder / 0x40)
      local lowpart   = remainder - 0x40 * midB

      return string.char(0xF0 + highpart,
                         0x80 + midA,
                         0x80 + midB,
                         0x80 + lowpart)
   end
end

function OBJDEF:onDecodeError(message, text, location, etc)
   if text then
      if location then
         message = string.format("%s at byte %d of: %s", message, location, text)
      else
         message = string.format("%s: %s", message, text)
      end
   end

   if etc ~= nil then
      message = message .. " (" .. OBJDEF:encode(etc) .. ")"
   end

   if self.assert then
      self.assert(false, message)
   else
      assert(false, message)
   end
end

function OBJDEF:onTrailingGarbage(json_text, location, parsed_value, etc)
   return self:onDecodeError("trailing garbage", json_text, location, etc)
end

OBJDEF.onDecodeOfNilError  = OBJDEF.onDecodeError
OBJDEF.onDecodeOfHTMLError = OBJDEF.onDecodeError

function OBJDEF:onEncodeError(message, etc)
   if etc ~= nil then
      message = message .. " (" .. OBJDEF:encode(etc) .. ")"
   end

   if self.assert then
      self.assert(false, message)
   else
      assert(false, message)
   end
end

local function grok_number(self, text, start, options)
   --
   -- Grab the integer part
   --
   local integer_part = text:match('^-?[1-9]%d*', start)
                     or text:match("^-?0",        start)

   if not integer_part then
      self:onDecodeError("expected number", text, start, options.etc)
      return nil, start -- in case the error method doesn't abort, return something sensible
   end

   local i = start + integer_part:len()

   --
   -- Grab an optional decimal part
   --
   local decimal_part = text:match('^%.%d+', i) or ""

   i = i + decimal_part:len()

   --
   -- Grab an optional exponential part
   --
   local exponent_part = text:match('^[eE][-+]?%d+', i) or ""

   i = i + exponent_part:len()

   local full_number_text = integer_part .. decimal_part .. exponent_part

   if options.decodeNumbersAsObjects then

      local objectify = false

      if not options.decodeIntegerObjectificationLength and not options.decodeDecimalObjectificationLength then
         -- no options, so objectify
         objectify = true

      elseif (options.decodeIntegerObjectificationLength
          and
         (integer_part:len() >= options.decodeIntegerObjectificationLength or exponent_part:len() > 0))

          or
         (options.decodeDecimalObjectificationLength 
          and
          (decimal_part:len() >= options.decodeDecimalObjectificationLength  or exponent_part:len() > 0))
      then
         -- have options and they are triggered, so objectify
         objectify = true
      end

      if objectify then
         return OBJDEF:asNumber(full_number_text), i
      end
      -- else, fall through to try to return as a straight-up number

   else

      -- Not always decoding numbers as objects, so perhaps encode as strings?

      --
      -- If we're told to stringify only under certain conditions, so do.
      -- We punt a bit when there's an exponent by just stringifying no matter what.
      -- I suppose we should really look to see whether the exponent is actually big enough one
      -- way or the other to trip stringification, but I'll be lazy about it until someone asks.
      --
      if (options.decodeIntegerStringificationLength
          and
         (integer_part:len() >= options.decodeIntegerStringificationLength or exponent_part:len() > 0))

          or

         (options.decodeDecimalStringificationLength 
          and
          (decimal_part:len() >= options.decodeDecimalStringificationLength or exponent_part:len() > 0))
      then
         return full_number_text, i -- this returns the exact string representation seen in the original JSON
      end

   end


   local as_number = tonumber(full_number_text)

   if not as_number then
      self:onDecodeError("bad number", text, start, options.etc)
      return nil, start -- in case the error method doesn't abort, return something sensible
   end

   return as_number, i
end


local backslash_escape_conversion = {
   ['"'] = '"',
   ['/'] = "/",
   ['\\'] = "\\",
   ['b'] = "\b",
   ['f'] = "\f",
   ['n'] = "\n",
   ['r'] = "\r",
   ['t'] = "\t",
}

local function grok_string(self, text, start, options)

   if text:sub(start,start) ~= '"' then
      self:onDecodeError("expected string's opening quote", text, start, options.etc)
      return nil, start -- in case the error method doesn't abort, return something sensible
   end

   local i = start + 1 -- +1 to bypass the initial quote
   local text_len = text:len()
   local VALUE = ""
   while i <= text_len do
      local c = text:sub(i,i)
      if c == '"' then
         return VALUE, i + 1
      end
      if c ~= '\\' then
         
         -- should grab the next bytes as per the number of bytes for this utf8 character
         local byte_count = unicode_character_bytecount_based_on_first_byte(c)

         local next_character
         if byte_count == 0 then
            self:onDecodeError("non-utf8 sequence", text, i, options.etc)
         elseif byte_count == 1 then
            if options.strictParsing and string.byte(c) < 0x20 then
               self:onDecodeError("Unescaped control character", text, i+1, options.etc)
               return nil, start -- in case the error method doesn't abort, return something sensible
            end
            next_character = c
         elseif byte_count == 2 then
            next_character = text:match('^(.[\128-\191])', i)
         elseif byte_count == 3 then
            next_character = text:match('^(.[\128-\191][\128-\191])', i)
         elseif byte_count == 4 then
            next_character = text:match('^(.[\128-\191][\128-\191][\128-\191])', i)
         end

         if not next_character then
            self:onDecodeError("incomplete utf8 sequence", text, i, options.etc) 
            return nil, i -- in case the error method doesn't abort, return something sensible           
         end


         VALUE = VALUE .. next_character
         i = i + byte_count

      else
         --
         -- We have a backslash escape
         --
         i = i + 1

         local next_byte = text:match('^(.)', i)

         if next_byte == nil then
            -- string ended after the \ 
            self:onDecodeError("unfinished \\ escape", text, i, options.etc)
            return nil, start -- in case the error method doesn't abort, return something sensible
         end

         if backslash_escape_conversion[next_byte] then
            VALUE = VALUE .. backslash_escape_conversion[next_byte]
            i = i + 1
         else
            --
            -- The only other valid use of \ that remains is in the form of \u####
            --

            local hex = text:match('^u([0123456789aAbBcCdDeEfF][0123456789aAbBcCdDeEfF][0123456789aAbBcCdDeEfF][0123456789aAbBcCdDeEfF])', i)
            if hex then
               i = i + 5 -- bypass what we just read

               -- We have a Unicode codepoint. It could be standalone, or if in the proper range and
               -- followed by another in a specific range, it'll be a two-code surrogate pair.
               local codepoint = tonumber(hex, 16)
               if codepoint >= 0xD800 and codepoint <= 0xDBFF then
                  -- it's a hi surrogate... see whether we have a following low
                  local lo_surrogate = text:match('^\\u([dD][cdefCDEF][0123456789aAbBcCdDeEfF][0123456789aAbBcCdDeEfF])', i)
                  if lo_surrogate then
                     i = i + 6 -- bypass the low surrogate we just read
                     codepoint = 0x2400 + (codepoint - 0xD800) * 0x400 + tonumber(lo_surrogate, 16)
                  else
                     -- not a proper low, so we'll just leave the first codepoint as is and spit it out.
                  end
               end
               VALUE = VALUE .. unicode_codepoint_as_utf8(codepoint)

            elseif options.strictParsing then
               --local next_byte = text:match('^\\(.)', i) printf("NEXT[%s]", next_byte);
               self:onDecodeError("illegal use of backslash escape", text, i, options.etc)
               return nil, start -- in case the error method doesn't abort, return something sensible
            else
               local byte_count = unicode_character_bytecount_based_on_first_byte(next_byte)
               if byte_count == 0 then
                  self:onDecodeError("non-utf8 sequence after backslash escape", text, i, options.etc)
                  return nil, start -- in case the error method doesn't abort, return something sensible
               end

               local next_character
               if byte_count == 1 then
                  next_character = next_byte
               elseif byte_count == 2 then
                  next_character = text:match('^(.[\128-\191])', i)
               elseif byte_count == 3 then
                  next_character = text:match('^(.[\128-\191][\128-\191])', i)
               elseif byte_count == 3 then
                  next_character = text:match('^(.[\128-\191][\128-\191][\128-\191])', i)
               end

               if next_character == nil then
                  -- incomplete utf8 character after escape
                  self:onDecodeError("incomplete utf8 sequence after backslash escape", text, i, options.etc)
                  return nil, start -- in case the error method doesn't abort, return something sensible
               end

               VALUE = VALUE .. next_character
               i = i + byte_count
            end
         end
      end
   end

   self:onDecodeError("unclosed string", text, start, options.etc)
   return nil, start -- in case the error method doesn't abort, return something sensible
end

local function skip_whitespace(text, start)

   local _, match_end = text:find("^[ \n\r\t]+", start) -- [ https://datatracker.ietf.org/doc/html/rfc7158#section-2 ]
   if match_end then
      return match_end + 1
   else
      return start
   end
end

local grok_one -- assigned later

local function grok_object(self, text, start, options)

   if text:sub(start,start) ~= '{' then
      self:onDecodeError("expected '{'", text, start, options.etc)
      return nil, start -- in case the error method doesn't abort, return something sensible
   end

   local i = skip_whitespace(text, start + 1) -- +1 to skip the '{'

   local VALUE = self.strictTypes and self:newObject { } or { }

   if text:sub(i,i) == '}' then
      return VALUE, i + 1
   end
   local text_len = text:len()
   while i <= text_len do
      local key, new_i = grok_string(self, text, i, options)

      i = skip_whitespace(text, new_i)

      if text:sub(i, i) ~= ':' then
         self:onDecodeError("expected colon", text, i, options.etc)
         return nil, i -- in case the error method doesn't abort, return something sensible
      end

      i = skip_whitespace(text, i + 1)

      local new_val, new_i = grok_one(self, text, i, options)

      VALUE[key] = new_val

      --
      -- Expect now either '}' to end things, or a ',' to allow us to continue.
      --
      i = skip_whitespace(text, new_i)

      local c = text:sub(i,i)

      if c == '}' then
         return VALUE, i + 1
      end

      if text:sub(i, i) ~= ',' then
         self:onDecodeError("expected comma or '}'", text, i, options.etc)
         return nil, i -- in case the error method doesn't abort, return something sensible
      end

      i = skip_whitespace(text, i + 1)
   end

   self:onDecodeError("unclosed '{'", text, start, options.etc)
   return nil, start -- in case the error method doesn't abort, return something sensible
end

local function grok_array(self, text, start, options)
   if text:sub(start,start) ~= '[' then
      self:onDecodeError("expected '['", text, start, options.etc)
      return nil, start -- in case the error method doesn't abort, return something sensible
   end

   local i = skip_whitespace(text, start + 1) -- +1 to skip the '['
   local VALUE = self.strictTypes and self:newArray { } or { }
   if text:sub(i,i) == ']' then
      return VALUE, i + 1
   end

   local VALUE_INDEX = 1

   local text_len = text:len()
   while i <= text_len do
      local val, new_i = grok_one(self, text, i, options)

      -- can't table.insert(VALUE, val) here because it's a no-op if val is nil
      VALUE[VALUE_INDEX] = val
      VALUE_INDEX = VALUE_INDEX + 1

      i = skip_whitespace(text, new_i)

      --
      -- Expect now either ']' to end things, or a ',' to allow us to continue.
      --
      local c = text:sub(i,i)
      if c == ']' then
         return VALUE, i + 1
      end
      if text:sub(i, i) ~= ',' then
         self:onDecodeError("expected comma or ']'", text, i, options.etc)
         return nil, i -- in case the error method doesn't abort, return something sensible
      end
      i = skip_whitespace(text, i + 1)
   end
   self:onDecodeError("unclosed '['", text, start, options.etc)
   return nil, i -- in case the error method doesn't abort, return something sensible
end


grok_one = function(self, text, start, options)
   -- Skip any whitespace
   start = skip_whitespace(text, start)

   if start > text:len() then
      self:onDecodeError("unexpected end of string", text, nil, options.etc)
      return nil, start -- in case the error method doesn't abort, return something sensible
   end

   if text:find('^"', start) then
      return grok_string(self, text, start, options)

   elseif text:find('^[-0123456789 ]', start) then
      return grok_number(self, text, start, options)

   elseif text:find('^%{', start) then
      return grok_object(self, text, start, options)

   elseif text:find('^%[', start) then
      return grok_array(self, text, start, options)

   elseif text:find('^true', start) then
      return true, start + 4

   elseif text:find('^false', start) then
      return false, start + 5

   elseif text:find('^null', start) then
      return options.null, start + 4

   else
      self:onDecodeError("can't parse JSON", text, start, options.etc)
      return nil, 1 -- in case the error method doesn't abort, return something sensible
   end
end

function OBJDEF:decode(text, etc, options)
   --
   -- If the user didn't pass in a table of decode options, make an empty one.
   --
   if type(options) ~= 'table' then
      options = {}
   end

   --
   -- If they passed in an 'etc' argument, stuff it into the options.
   -- (If not, any 'etc' field in the options they passed in remains to be used)
   --
   if etc ~= nil then
      options.etc = etc
   end


   --
   -- apply global options
   --
   if options.decodeNumbersAsObjects == nil then
      options.decodeNumbersAsObjects = self.decodeNumbersAsObjects
   end
   if options.decodeIntegerObjectificationLength == nil then
      options.decodeIntegerObjectificationLength = self.decodeIntegerObjectificationLength
   end
   if options.decodeDecimalObjectificationLength == nil then
      options.decodeDecimalObjectificationLength = self.decodeDecimalObjectificationLength
   end
   if options.decodeIntegerStringificationLength == nil then
      options.decodeIntegerStringificationLength = self.decodeIntegerStringificationLength
   end
   if options.decodeDecimalStringificationLength == nil then
      options.decodeDecimalStringificationLength = self.decodeDecimalStringificationLength
   end
   if options.strictParsing == nil then
      options.strictParsing = self.strictParsing
   end


   if type(self) ~= 'table' or self.__index ~= OBJDEF then
      local error_message = "JSON:decode must be called in method format"
      OBJDEF:onDecodeError(error_message, nil, nil, options.etc)
      return nil, error_message -- in case the error method doesn't abort, return something sensible
   end

   if text == nil then
      local error_message = "nil passed to JSON:decode()"
      self:onDecodeOfNilError(error_message, nil, nil, options.etc)
      return nil, error_message -- in case the error method doesn't abort, return something sensible

   elseif type(text) ~= 'string' then
      local error_message = "expected string argument to JSON:decode()"
      self:onDecodeError(string.format("%s, got %s", error_message, type(text)), nil, nil, options.etc)
      return nil, error_message -- in case the error method doesn't abort, return something sensible
   end

   -- If passed an empty string....
   if text:match('^%s*$') then
      if options.strictParsing then
         local error_message = "empty string passed to JSON:decode()"
         self:onDecodeOfNilError(error_message, nil, nil, options.etc)
         return nil, error_message -- in case the error method doesn't abort, return something sensible
      else
         -- we'll consider it nothing, but not an error
         return nil
      end
   end

   if text:match('^%s*<') then
      -- Can't be JSON... we'll assume it's HTML
      local error_message = "HTML passed to JSON:decode()"
      self:onDecodeOfHTMLError(error_message, text, nil, options.etc)
      return nil, error_message -- in case the error method doesn't abort, return something sensible
   end

   --
   -- Ensure that it's not UTF-32 or UTF-16.
   -- Those are perfectly valid encodings for JSON (as per RFC 4627 section 3),
   -- but this package can't handle them.
   --
   if text:sub(1,1):byte() == 0 or (text:len() >= 2 and text:sub(2,2):byte() == 0) then
      local error_message = "JSON package groks only UTF-8, sorry"
      self:onDecodeError(error_message, text, nil, options.etc)
      return nil, error_message -- in case the error method doesn't abort, return something sensible
   end


   --
   -- Finally, go parse it
   --
   local success, value, next_i = pcall(grok_one, self, text, 1, options)

   if success then

      local error_message = nil
      if next_i ~= #text + 1 then
         -- something's left over after we parsed the first thing.... whitespace is allowed.
         next_i = skip_whitespace(text, next_i)

         -- if we have something left over now, it's trailing garbage
         if next_i ~= #text + 1 then
            value, error_message = self:onTrailingGarbage(text, next_i, value, options.etc)
         end
      end
      return value, error_message

   else

      -- If JSON:onDecodeError() didn't abort out of the pcall, we'll have received
      -- the error message here as "value", so pass it along as an assert.
      local error_message = value
      if self.assert then
         self.assert(false, error_message)
      else
         assert(false, error_message)
      end
      -- ...and if we're still here (because the assert didn't throw an error),
      -- return a nil and throw the error message on as a second arg
      return nil, error_message

   end
end

local function backslash_replacement_function(c)
   if     c == "\n" then     return "\\n"
   elseif c == "\r" then     return "\\r"
   elseif c == "\t" then     return "\\t"
   elseif c == "\b" then     return "\\b"
   elseif c == "\f" then     return "\\f"
   elseif c == '"' then      return '\\"'
   elseif c == '\\' then     return '\\\\'
   elseif c == '/' then      return '/'
   else
      return string.format("\\u%04x", c:byte())
   end
end

local chars_to_be_escaped_in_JSON_string
   = '['
   ..    '"'    -- class sub-pattern to match a double quote
   ..    '%\\'  -- class sub-pattern to match a backslash
   ..    '/'    -- class sub-pattern to match a forwardslash
   ..    '%z'   -- class sub-pattern to match a null
   ..    '\001' .. '-' .. '\031' -- class sub-pattern to match control characters
   .. ']'


local LINE_SEPARATOR_as_utf8      = unicode_codepoint_as_utf8(0x2028)
local PARAGRAPH_SEPARATOR_as_utf8 = unicode_codepoint_as_utf8(0x2029)
local function json_string_literal(value, options)
   local newval = value:gsub(chars_to_be_escaped_in_JSON_string, backslash_replacement_function)
   if options.stringsAreUtf8 then
      --
      -- This feels really ugly to just look into a string for the sequence of bytes that we know to be a particular utf8 character,
      -- but utf8 was designed purposefully to make this kind of thing possible. Still, feels dirty.
      -- I'd rather decode the byte stream into a character stream, but it's not technically needed so
      -- not technically worth it.
      --
      newval = newval:gsub(LINE_SEPARATOR_as_utf8, '\\u2028'):gsub(PARAGRAPH_SEPARATOR_as_utf8,'\\u2029')
   end
   return '"' .. newval .. '"'
end

local function object_or_array(self, T, etc)
   --
   -- We need to inspect all the keys... if there are any strings, we'll convert to a JSON
   -- object. If there are only numbers, it's a JSON array.
   --
   -- If we'll be converting to a JSON object, we'll want to sort the keys so that the
   -- end result is deterministic.
   --
   local string_keys = { }
   local number_keys = { }
   local number_keys_must_be_strings = false
   local maximum_number_key

   for key in pairs(T) do
      if type(key) == 'string' then
         table.insert(string_keys, key)
      elseif type(key) == 'number' then
         table.insert(number_keys, key)
         if key <= 0 or key >= math.huge then
            number_keys_must_be_strings = true
         elseif not maximum_number_key or key > maximum_number_key then
            maximum_number_key = key
         end
      elseif type(key) == 'boolean' then
         table.insert(string_keys, tostring(key))
      else
         self:onEncodeError("can't encode table with a key of type " .. type(key), etc)
      end
   end

   if #string_keys == 0 and not number_keys_must_be_strings then
      --
      -- An empty table, or a numeric-only array
      --
      if #number_keys > 0 then
         return nil, maximum_number_key -- an array
      elseif tostring(T) == "JSON array" then
         return nil
      elseif tostring(T) == "JSON object" then
         return { }
      else
         -- have to guess, so we'll pick array, since empty arrays are likely more common than empty objects
         return nil
      end
   end

   table.sort(string_keys)

   local map
   if #number_keys > 0 then
      --
      -- If we're here then we have either mixed string/number keys, or numbers inappropriate for a JSON array
      -- It's not ideal, but we'll turn the numbers into strings so that we can at least create a JSON object.
      --

      if self.noKeyConversion then
         self:onEncodeError("a table with both numeric and string keys could be an object or array; aborting", etc)
      end

      --
      -- Have to make a shallow copy of the source table so we can remap the numeric keys to be strings
      --
      map = { }
      for key, val in pairs(T) do
         map[key] = val
      end

      table.sort(number_keys)

      --
      -- Throw numeric keys in there as strings
      --
      for _, number_key in ipairs(number_keys) do
         local string_key = tostring(number_key)
         if map[string_key] == nil then
            table.insert(string_keys , string_key)
            map[string_key] = T[number_key]
         else
            self:onEncodeError("conflict converting table with mixed-type keys into a JSON object: key " .. number_key .. " exists both as a string and a number.", etc)
         end
      end
   end

   return string_keys, nil, map
end

--
-- Encode
--
-- 'options' is nil, or a table with possible keys:
--
--    pretty         -- If true, return a pretty-printed version.
--
--    indent         -- A string (usually of spaces) used to indent each nested level.
--
--    align_keys     -- If true, align all the keys when formatting a table. The result is uglier than one might at first imagine.
--                      Results are undefined if 'align_keys' is true but 'pretty' is not.
--
--    array_newline  -- If true, array elements are formatted each to their own line. The default is to all fall inline.
--                      Results are undefined if 'array_newline' is true but 'pretty' is not.
--
--    null           -- If this exists with a string value, table elements with this value are output as JSON null.
--
--    stringsAreUtf8 -- If true, consider Lua strings not as a sequence of bytes, but as a sequence of UTF-8 characters.
--                      (Currently, the only practical effect of setting this option is that Unicode LINE and PARAGRAPH
--                       separators, if found in a string, are encoded with a JSON escape instead of as raw UTF-8.
--                       The JSON is valid either way, but encoding this way, apparently, allows the resulting JSON
--                       to also be valid Java.)
--
--
local function encode_value(self, value, parents, etc, options, indent, for_key)

   --
   -- keys in a JSON object can never be null, so we don't even consider options.null when converting a key value
   --
   if value == nil or (not for_key and options and options.null and value == options.null) then
      return 'null'

   elseif type(value) == 'string' then
      return json_string_literal(value, options)

   elseif type(value) == 'number' then
      if value ~= value then
         --
         -- NaN (Not a Number).
         -- JSON has no NaN, so we have to fudge the best we can. This should really be a package option.
         --
         return "null"
      elseif value >= math.huge then
         --
         -- Positive infinity. JSON has no INF, so we have to fudge the best we can. This should
         -- really be a package option. Note: at least with some implementations, positive infinity
         -- is both ">= math.huge" and "<= -math.huge", which makes no sense but that's how it is.
         -- Negative infinity is properly "<= -math.huge". So, we must be sure to check the ">="
         -- case first.
         --
         return "1e+9999"
      elseif value <= -math.huge then
         --
         -- Negative infinity.
         -- JSON has no INF, so we have to fudge the best we can. This should really be a package option.
         --
         return "-1e+9999"
      else
         return tostring(value)
      end

   elseif type(value) == 'boolean' then
      return tostring(value)

   elseif type(value) ~= 'table' then

      if self.unsupportedTypeEncoder then
         local user_value, user_error = self:unsupportedTypeEncoder(value, parents, etc, options, indent, for_key)
         -- If the user's handler returns a string, use that. If it returns nil plus an error message, bail with that.
         -- If only nil returned, fall through to the default error handler.
         if type(user_value) == 'string' then
            return user_value
         elseif user_value ~= nil then
            self:onEncodeError("unsupportedTypeEncoder method returned a " .. type(user_value), etc)
         elseif user_error then
            self:onEncodeError(tostring(user_error), etc)
         end
      end

      self:onEncodeError("can't convert " .. type(value) .. " to JSON", etc)

   elseif getmetatable(value) == isNumber then
      return tostring(value)
   else
      --
      -- A table to be converted to either a JSON object or array.
      --
      local T = value

      if type(options) ~= 'table' then
         options = {}
      end
      if type(indent) ~= 'string' then
         indent = ""
      end

      if parents[T] then
         self:onEncodeError("table " .. tostring(T) .. " is a child of itself", etc)
      else
         parents[T] = true
      end

      local result_value

      local object_keys, maximum_number_key, map = object_or_array(self, T, etc)
      if maximum_number_key then
         --
         -- An array...
         --
         local key_indent
         if options.array_newline then
            key_indent = indent .. tostring(options.indent or "")
         else
            key_indent = indent
         end

         local ITEMS = { }
         for i = 1, maximum_number_key do
            table.insert(ITEMS, encode_value(self, T[i], parents, etc, options, key_indent))
         end

         if options.array_newline then
            result_value = "[\n" .. key_indent .. table.concat(ITEMS, ",\n" .. key_indent) .. "\n" .. indent .. "]"
         elseif options.pretty then
            result_value = "[ " .. table.concat(ITEMS, ", ") .. " ]"
         else
            result_value = "["  .. table.concat(ITEMS, ",")  .. "]"
         end

      elseif object_keys then
         --
         -- An object
         --
         local TT = map or T

         if options.pretty then

            local KEYS = { }
            local max_key_length = 0
            for _, key in ipairs(object_keys) do
               local encoded = encode_value(self, tostring(key), parents, etc, options, indent, true)
               if options.align_keys then
                  max_key_length = math.max(max_key_length, #encoded)
               end
               table.insert(KEYS, encoded)
            end
            local key_indent = indent .. tostring(options.indent or "")
            local subtable_indent = key_indent .. string.rep(" ", max_key_length) .. (options.align_keys and "  " or "")
            local FORMAT = "%s%" .. string.format("%d", max_key_length) .. "s: %s"

            local COMBINED_PARTS = { }
            for i, key in ipairs(object_keys) do
               local encoded_val = encode_value(self, TT[key], parents, etc, options, subtable_indent)
               table.insert(COMBINED_PARTS, string.format(FORMAT, key_indent, KEYS[i], encoded_val))
            end
            result_value = "{\n" .. table.concat(COMBINED_PARTS, ",\n") .. "\n" .. indent .. "}"

         else

            local PARTS = { }
            for _, key in ipairs(object_keys) do
               local encoded_val = encode_value(self, TT[key],       parents, etc, options, indent)
               local encoded_key = encode_value(self, tostring(key), parents, etc, options, indent, true)
               table.insert(PARTS, string.format("%s:%s", encoded_key, encoded_val))
            end
            result_value = "{" .. table.concat(PARTS, ",") .. "}"

         end
      else
         --
         -- An empty array/object... we'll treat it as an array, though it should really be an option
         --
         result_value = "[]"
      end

      parents[T] = false
      return result_value
   end
end

local function top_level_encode(self, value, etc, options)
   local val = encode_value(self, value, {}, etc, options)
   if val == nil then
      --PRIVATE("may need to revert to the previous public verison if I can't figure out what the guy wanted")
      return val
   else
      return val
   end
end

function OBJDEF:encode(value, etc, options)
   if type(self) ~= 'table' or self.__index ~= OBJDEF then
      OBJDEF:onEncodeError("JSON:encode must be called in method format", etc)
   end

   --
   -- If the user didn't pass in a table of decode options, make an empty one.
   --
   if type(options) ~= 'table' then
      options = {}
   end

   return top_level_encode(self, value, etc, options)
end

function OBJDEF:encode_pretty(value, etc, options)
   if type(self) ~= 'table' or self.__index ~= OBJDEF then
      OBJDEF:onEncodeError("JSON:encode_pretty must be called in method format", etc)
   end

   --
   -- If the user didn't pass in a table of decode options, use the default pretty ones
   --
   if type(options) ~= 'table' then
      options = default_pretty_options
   end

   return top_level_encode(self, value, etc, options)
end

function OBJDEF.__tostring()
   return "JSON encode/decode package"
end

OBJDEF.__index = OBJDEF

function OBJDEF:new(args)
   local new = { }

   if args then
      for key, val in pairs(args) do
         new[key] = val
      end
   end

   return setmetatable(new, OBJDEF)
end

return OBJDEF:new()

--
-- Version history:
--
--   20211016.28   Had forgotten to document the strictParsing option.
--
--   20211015.27   Better handle some edge-case errors [ thank you http://seriot.ch/projects/parsing_json.html ; all tests are now successful ]
--
--                 Added some semblance of proper UTF8 parsing, and now aborts with an error on ilformatted UTF8.
--
--                 Added the strictParsing option:
--                    Aborts with an error on unknown backslash-escape in strings
--                    Aborts on naked control characters in strings
--                    Aborts when decode is passed a whitespace-only string
--
--                 For completeness, when encoding a Lua string into a JSON string, escape a forward slash.
--
--                 String decoding should be a bit more efficient now.
--
--   20170927.26   Use option.null in decoding as well. Thanks to Max Sindwani for the bump, and sorry to Oliver Hitz
--                 whose first mention of it four years ago was completely missed by me.
--
--   20170823.25   Added support for JSON:unsupportedTypeEncoder().
--                 Thanks to Chronos Phaenon Eosphoros (https://github.com/cpeosphoros) for the idea.
--
--   20170819.24   Added support for boolean keys in tables.
--
--   20170416.23   Added the "array_newline" formatting option suggested by yurenchen (http://www.yurenchen.com/)
--
--   20161128.22   Added:
--                   JSON:isString()
--                   JSON:isNumber()
--                   JSON:decodeIntegerObjectificationLength
--                   JSON:decodeDecimalObjectificationLength
--
--   20161109.21   Oops, had a small boo-boo in the previous update.
--
--   20161103.20   Used to silently ignore trailing garbage when decoding. Now fails via JSON:onTrailingGarbage()
--                 http://seriot.ch/parsing_json.php
--
--                 Built-in error message about "expected comma or ']'" had mistakenly referred to '['
--
--                 Updated the built-in error reporting to refer to bytes rather than characters.
--
--                 The decode() method no longer assumes that error handlers abort.
--
--                 Made the VERSION string a string instead of a number
--

--   20160916.19   Fixed the isNumber.__index assignment (thanks to Jack Taylor)
--   
--   20160730.18   Added JSON:forceString() and JSON:forceNumber()
--
--   20160728.17   Added concatenation to the metatable for JSON:asNumber()
--
--   20160709.16   Could crash if not passed an options table (thanks jarno heikkinen <jarnoh@capturemonkey.com>).
--
--                 Made JSON:asNumber() a bit more resilient to being passed the results of itself.
--
--   20160526.15   Added the ability to easily encode null values in JSON, via the new "null" encoding option.
--                 (Thanks to Adam B for bringing up the issue.)
--
--                 Added some support for very large numbers and precise floats via
--                    JSON.decodeNumbersAsObjects
--                    JSON.decodeIntegerStringificationLength
--                    JSON.decodeDecimalStringificationLength
--
--                 Added the "stringsAreUtf8" encoding option. (Hat tip to http://lua-users.org/wiki/JsonModules )
--
--   20141223.14   The encode_pretty() routine produced fine results for small datasets, but isn't really
--                 appropriate for anything large, so with help from Alex Aulbach I've made the encode routines
--                 more flexible, and changed the default encode_pretty() to be more generally useful.
--
--                 Added a third 'options' argument to the encode() and encode_pretty() routines, to control
--                 how the encoding takes place.
--
--                 Updated docs to add assert() call to the loadfile() line, just as good practice so that
--                 if there is a problem loading JSON.lua, the appropriate error message will percolate up.
--
--   20140920.13   Put back (in a way that doesn't cause warnings about unused variables) the author string,
--                 so that the source of the package, and its version number, are visible in compiled copies.
--
--   20140911.12   Minor lua cleanup.
--                 Fixed internal reference to 'JSON.noKeyConversion' to reference 'self' instead of 'JSON'.
--                 (Thanks to SmugMug's Dvid Parry for tese.)
--
--   2140418.11   JSO nulls embeddedwithin an arraywere being ignoed, such that
-                    ["1",null,ull,null,null,nll,"seven"],
--               would return
--                   {1,"seven"}--                It's now fixd to properly rturn
--                    {1,nil, nil, nil, il, nil, "seven}
--                Thanks to haddock" for caching the error
--
--   2014016.10   The users JSON.assert()wasn't always bing used. Thank to "blue" for he heads up.
----   20131118.9   Update for La 5.3... it sees that tostring2/1) produces ".0" instead of 2",
--                and thiscaused some prolems.
--
--   2131031.8    Uniied the code fo encode() and ecode_pretty(); hey had been stpidly separate,--                and had of curse diverged (ncode_pretty din't get the fixs that encode gt, so
--                someties produced incrrect results; hanks to Mattiefor the heads u).
--
--                Handleencoding tableswith non-positie numeric keys unlikely, but pssible).
--
--                f a table has bth numeric and tring keys, or ts numeric keysare inappropriae
--                (such as bing non-positiv or infinite), he numeric keysare turned into--                string keys ppropriate for  JSON object. S, as before,
--                       JSON:enode({ "one", "to", "three" })
-                produces the rray
--                       ["one","two","tree"]
--                but no something withmixed key typeslike
--                       JSON:encode({ "ne", "two", "thee", SOMESTRING= "some string"}))
--                instead f throwing an eror produces anobject:
--                       {"1":"one","":"two","3":"thee","SOMESTRING:"some string"}--
--                To maintan the prior thrw-an-error sematics, set
--                    JSON.noKeyConersion = true
-                
--   201310047    Release uner a Creative Cmmons CC-BY licnse, which I shuld have done fom day one, sory.
--
--   2013120.6    Commen update: added  link to the spcific page on m blog where thi code can
--                befound, so that olks who come aross the code otside of my blo can find updats
--                more easil.
--
--   2011107.5    Added spport for the 'tc' arguments, or better errorreporting.
--
-   20110731.4   More feedback rom David Kolf n how to make te tests for NanInfinity systemindependent.
----   20110730.3   Incorporatedfeedback from Dvid Kolf at htt://lua-users.or/wiki/JsonModuls:
--
--                  * Whn encoding lua or JSON, Sparsenumeric arrays re now handled y
--                    spittig out full arras, such that
--                      JSON:encde({"one", "two, [10] = "ten"}
--                    returns--                       ["one,"two",null,nul,null,null,nullnull,null,"ten"
--
--                    In 2100810.2 and ealier, only up t the first non-ull value wouldhave been retaied.
--
--                  * Wen encoding luafor JSON, numerc value NaN get spit out as nul, and infinityas "1+e9999".
-                    Version 2000810.2 and earier created invlid JSON in bot cases.
--
--                 * Unicode surroate pairs are nw detected whendecoding JSON.
-
--   201008102    added somechecking to ensre that an invaid Unicode charcter couldn't lak in to the UT-8 encoding
--
-   20100731.1   initial publi release
--
