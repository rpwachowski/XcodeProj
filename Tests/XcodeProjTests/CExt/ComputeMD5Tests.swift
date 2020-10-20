import Foundation
import XcodeProjCExt
import XCTest
@testable import XcodeProj

class ComputeMD5Tests: XCTestCase {

    func testResultMatchesXcodeProjCExt() {
        guard let data = "Test MD5 Hashing".data(using: .utf8, allowLossyConversion: true) else {
            fatalError("Unable to get UTF-8 string from data")
        }
        let localMD5 = data.withUnsafeBytes { bufferPointer -> String in
            let castedBuffer = bufferPointer.bindMemory(to: Int8.self)
            let hex = computeMD5(data: castedBuffer.baseAddress!, length: Int32(data.count))
            return String(cString: hex, encoding: .ascii)!
        }
        let remoteMD5 = data.withUnsafeBytes { bufferPointer -> String in
            let castedBuffer = bufferPointer.bindMemory(to: Int8.self)
            let hex = XCPComputeMD5(castedBuffer.baseAddress, Int32(data.count))!
            return String(cString: hex, encoding: .ascii)!
        }
        XCTAssertTrue(localMD5 == remoteMD5)
    }

    func testaResultMatchesXcodeProjCExt() {
        let string = "\"adsdas\n\n 238942387 \\\\\\\\\\ \t\t\t\t\""
        let localEscaping = string.withCString(escapedString)
        let remoteEscaping = string.withCString { buffer -> String in
            let esc = XCPEscapedString(buffer)!
            let newString = String(cString: esc)
            free(UnsafeMutableRawPointer(mutating: esc))
            return newString
        }
        XCTAssertTrue(localEscaping == remoteEscaping)
    }

}
