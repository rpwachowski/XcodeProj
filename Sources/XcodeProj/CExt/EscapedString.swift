import Foundation

func escapedString(_ string: UnsafePointer<CChar>) -> String {
    let length = strlen(string)
    let escapedHolder = UnsafeMutablePointer<CChar>.allocate(capacity: length * 2 + 3)
    var escaped = escapedHolder.advanced(by: 1)
    var current = 0
    var needsQuoting = false
    let backslash = Int8(Character("\\").asciiValue!)
    let quote = Int8(Character("\"").asciiValue!)
    let nul = Int8(Character("\0").asciiValue!)
    for i in 0..<length {
        let c = Character(Unicode.Scalar(UInt8(string.advanced(by: i).pointee)))
        if c != "$" && c != "_" && !(Character(".") <= c && c <= Character("9")) {
            needsQuoting = true
        }
        switch c {
        case "\\":
            escaped[current] = backslash
            current += 1
            escaped[current] = backslash
            current += 1
        case "\"":
            escaped[current] = backslash
            current += 1
            escaped[current] = quote
            current += 1
        case "\t":
            escaped[current] = backslash
            current += 1
            escaped[current] = Int8(Character("t").asciiValue!)
            current += 1
        case "\n":
            escaped[current] = backslash
            current += 1
            escaped[current] = Int8(Character("n").asciiValue!)
            current += 1
        default:
            escaped[current] = Int8(c.asciiValue!)
            current += 1
        }
    }
    escaped[current] = nul
    if strstr(escaped, "//") != nil || strstr(escaped, "___") != nil {
        needsQuoting = true
    }
    if needsQuoting && !(escaped[0] == quote && escaped[current - 1] == quote) {
        escaped[current] = quote
        current += 1
        escaped = escaped.predecessor()
        escaped[0] = quote
        current += 1
    }
    escaped[current] = nul
    let result = String(cString: escaped)
    escapedHolder.deallocate()
    return result
}
