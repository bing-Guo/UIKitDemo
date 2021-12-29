import Foundation
import UIKit

class FakeDataSource {
    static let shared = FakeDataSource()
    
    private init() { }
    
    static let colors: [UIColor] = [
        UIColor(hex: 0x4F726C),
        UIColor(hex: 0xF4A7B9),
        UIColor(hex: 0xD0104C),
        UIColor(hex: 0xF19483),
        UIColor(hex: 0xB9887D),
        UIColor(hex: 0x563F2E),
        UIColor(hex: 0xADA142),
        UIColor(hex: 0x6E75A4),
    ]
    
    let dataSource = Array(1...100).map { DemoItem(title: "\($0)", color: FakeDataSource.colors[$0 % FakeDataSource.colors.count]) }
}
