import Foundation

// Implement mobile phone storage protocol
// Requirements:
// - Mobiles must be unique (IMEI is an unique number)
// - Mobiles must be stored in memory

protocol MobileStorage {
    func getAll() -> Set<Mobile>
    func findByImei(_ imei: String) -> Mobile?
    func save(_ mobile: Mobile) throws -> Mobile
    func delete(_ product: Mobile) throws
    func exists(_ product: Mobile) -> Bool
}

struct Mobile: Hashable {
    let imei: String
    let model: String
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.imei == rhs.imei
    }
}

class MobileStorageImplementation {
    private var mobiles: Set<Mobile>
    
    init(
        mobiles: Set<Mobile> = []
    ) {
        self.mobiles = mobiles
    }
}

extension MobileStorageImplementation: MobileStorage {
    
    func getAll() -> Set<Mobile> {
        mobiles
    }
    
    func findByImei(_ imei: String) -> Mobile? {
        mobiles.first(where: { $0.imei == imei })
    }
    
    func save(_ mobile: Mobile) throws -> Mobile {
        let insertionResult = mobiles.insert(mobile)
        
        if insertionResult.inserted {
            return insertionResult.memberAfterInsert
        } else {
            throw MobileStorageError.alreadyExists(insertionResult.memberAfterInsert)
        }
    }
    
    func delete(_ product: Mobile) throws {
        let removedMobile = mobiles.remove(product)
        
        if removedMobile == nil {
            throw MobileStorageError.notFound
        }
    }
    
    func exists(_ product: Mobile) -> Bool {
        mobiles.contains(product)
    }
}

extension MobileStorageImplementation {
    
    enum MobileStorageError: Error {
        case alreadyExists(_ oldMobile: Mobile)
        case notFound
    }
}
