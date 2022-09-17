/*
 * Copyright (c) 2022 XXIV
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
package urlencoding

import "core:c"
import "core:fmt"

when ODIN_OS == .Linux {
    when #config(shared, true) {
        foreign import lib "liburlencoding.so" 
    } else {
        foreign import lib "liburlencoding.a"
    }
} else when ODIN_OS == .Windows  {
    when #config(shared, true) {
        foreign import lib "liburlencoding.dll" 
    } else {
        foreign import lib "liburlencoding.lib"
    }
} else when ODIN_OS == .Darwin {
    when #config(shared, true) {
        foreign import lib "liburlencoding.dylib" 
    } else {
        foreign import lib "liburlencoding.a"
    }
} else {
	foreign import lib "system:urlencoding"
}

foreign lib {
    url_encoding_encode :: proc(data: cstring) -> [^]u8 ---
    
    url_encoding_encode_binary :: proc(data: cstring, length: c.size_t) -> [^]u8 ---

    url_encoding_decode :: proc(data: cstring) -> [^]u8 ---

    url_encoding_decode_binary :: proc(data: cstring, length: c.size_t) -> [^]u8 ---
    
    url_encoding_free :: proc(ptr: [^]u8) ---
}

Error :: enum {
    None,
    Null
}


/// Percent-encodes every byte except alphanumerics and -, _, ., ~. Assumes UTF-8 encoding.
/// 
/// Example:
/// * *
/// package main
///
/// import "core:fmt"
/// import "urlencoding"
/// 
/// main :: proc() {
///   input, err := try urlencoding.encode("This string will be URL encoded.");
///   defer urlencoding.free(s)
///   fmt.println(input)
/// }
/// * *
/// 
/// @param data
/// @return string, Error
encode :: proc(data: string) -> (string, Error) {
    res := url_encoding_encode(cstring(raw_data(data)))
    if res == nil {
        return "",Error.Null
    }
    return string(cstring(&res[0])), Error.None
}

/// Percent-encodes every byte except alphanumerics and -, _, ., ~.
/// 
/// Example:
/// * *
/// package main
///
/// import "core:fmt"
/// import "urlencoding"
/// 
/// main :: proc() {
///   input, err := try urlencoding.encode_binary("This string will be URL encoded.");
///   defer urlencoding.free(s)
///   fmt.println(input)
/// }
/// * *
/// 
/// @param data
/// @return string, Error
encode_binary :: proc(data: string) -> (string, Error) {
    res := url_encoding_encode_binary(cstring(raw_data(data)), len(data))
    if res == nil {
        return "",Error.Null
    }
    return string(cstring(&res[0])), Error.None
}

/// Decode percent-encoded string assuming UTF-8 encoding.
/// 
/// Example:
/// * *
/// package main
///
/// import "core:fmt"
/// import "urlencoding"
/// 
/// main :: proc() {
///   input, err := try urlencoding.decode("%F0%9F%91%BE%20Exterminate%21");
///   defer urlencoding.free(s)
///   fmt.println(input)
/// }
/// * *
/// 
/// @param data
/// @return string, Error
decode :: proc(data: string) -> (string, Error) {
    res := url_encoding_decode(cstring(raw_data(data)))
    if res == nil {
        return "",Error.Null
    }
    return string(cstring(&res[0])), Error.None
}

/// Decode percent-encoded string assuming UTF-8 encoding.
/// 
/// Example:
/// * *
/// package main
///
/// import "core:fmt"
/// import "urlencoding"
/// 
/// main :: proc() {
///   input, err := try urlencoding.decode_binary("%F1%F2%F3%C0%C1%C2");
///   defer urlencoding.free(s)
///   fmt.println(input)
/// }
/// * *
/// 
/// @param data
/// @return string, Error
decode_binary :: proc(data: string) -> (string, Error) {
    res := url_encoding_decode_binary(cstring(raw_data(data)), len(data))
    if res == nil {
        return "",Error.Null
    }
    return string(cstring(&res[0])), Error.None
}

/// function to free the memory after using urlencoding functions
///
/// @param data string returned from urlencoding functions
free :: proc(data: string) {
    url_encoding_free(([^]u8)(raw_data(data)))
}