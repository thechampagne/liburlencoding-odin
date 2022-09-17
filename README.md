# liburlencoding-odin

[![](https://img.shields.io/github/v/tag/thechampagne/liburlencoding-odin?label=version)](https://github.com/thechampagne/liburlencoding-odin/releases/latest) [![](https://img.shields.io/github/license/thechampagne/liburlencoding-odin)](https://github.com/thechampagne/liburlencoding-odin/blob/main/LICENSE)

Odin binding for **liburlencoding**.

### API

```odin
encode :: proc(data: string) -> (string, Error)

encode_binary :: proc(data: string) -> (string, Error)

decode :: proc(data: string) -> (string, Error)

decode_binary :: proc(data: string) -> (string, Error)

free :: proc(data: string)
```

### References
 - [liburlencoding](https://github.com/thechampagne/liburlencoding)

### License

This repo is released under the [MIT](https://github.com/thechampagne/liburlencoding-odin/blob/main/LICENSE).
