//
//  Utils.swift
//  MVTimeAnalyzer
//
//  Created by mac on 2021/1/19.
//


import Foundation
import CommonCrypto

extension String {
    var md5: String {
        let data = Data(self.utf8)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}

extension Array {
    func unique(closure: (Element) -> String) -> [Element] {
        var result: [Element] = []
        var dic: [String : Bool] = [:]
        for item in self {
            let k = closure(item)
            if let _ = dic[k] {
                continue
            }
            dic[k] = true
            result.append(item)
        }
        return result
    }
}

