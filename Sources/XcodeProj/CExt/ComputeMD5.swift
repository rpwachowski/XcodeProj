import CommonCrypto
import Foundation

func computeMD5(data: UnsafePointer<CChar>, length: Int32) -> String {
    func toHex(_ value: UInt8) -> String {
        String(value, radix: 16, uppercase: true)
    }

    let count = Int(CC_MD5_DIGEST_LENGTH)
    var md = [UInt8](repeating: 0, count: count)
    CC_MD5(data, CC_LONG(length), &md)
    var hex = ""
    for i in 0..<count {
        let value = md[i]
        hex.append(toHex(value / 16))
        hex.append(toHex(value % 16))
    }
    return hex
}

