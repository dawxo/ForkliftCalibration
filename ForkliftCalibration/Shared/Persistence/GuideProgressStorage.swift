////  GuideProgressStorage.swift
//

import Foundation

enum GuideProgressStorage {
    static func load<Progress: Decodable>(key: String) -> Progress? {
        decode(UserDefaults.standard.data(forKey: key))
    }

    static func decode<Progress: Decodable>(_ data: Data?) -> Progress? {
        guard let data else {
            return nil
        }
        return try? JSONDecoder().decode(Progress.self, from: data)
    }

    static func save<Progress: Encodable>(_ progress: Progress, key: String) {
        do {
            UserDefaults.standard.set(try JSONEncoder().encode(progress), forKey: key)
        } catch {
            assertionFailure("Couldn't save guide progress: \(error)")
        }
    }

    static func clear(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
