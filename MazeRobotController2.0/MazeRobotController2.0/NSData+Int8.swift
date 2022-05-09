import Foundation

extension Data {
    //translate Int8 to NSData struct
    static func dataWithValue(value: Int8) -> Data {
        var variableValue = value
        return Data(buffer: UnsafeBufferPointer(start: &variableValue, count: 1))
    }
    
    //translate NSData struct to Int32
    func int32Value() -> Int32 {
        return Swift.min(200, Int32(bitPattern: UInt32(self[0])))
    }
}
