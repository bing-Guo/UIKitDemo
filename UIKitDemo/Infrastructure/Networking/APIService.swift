import Foundation

enum APIError: Error {
    
}

class APIService {
    static let shared = APIService()
    
    private init() { }
    
    func fetchDemoItem(perPageCount: Int, page: Int, responseQueue: DispatchQueue = .main, completionHandler: @escaping ((Result<[DemoItem], APIError>) -> Void)) {
        // Simulate network delay
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [unowned self] in
            let data = self.generateDemoItem(perCount: perPageCount, page: page)
            
            responseQueue.async {
                return completionHandler(.success(data))
            }
        }
    }
    
    /**
     Generate items using fake data
     */
    private func generateDemoItem(perCount: Int, page: Int) -> [DemoItem] {
        let start = perCount * page
        var end = start + perCount
        end = (end > FakeDataSource.shared.dataSource.count) ? FakeDataSource.shared.dataSource.count : end
        
        guard start < FakeDataSource.shared.dataSource.count else {
            return []
        }
        
        return Array(FakeDataSource.shared.dataSource[start...end])
    }
}
