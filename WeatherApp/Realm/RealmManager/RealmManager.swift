//
//  RealmManager.swift
//  WeatherApp
//
//  Created by Евгений Фирман on 08.05.2023.
//

import Realm
import RealmSwift

class RealmManager {
    static let shared = RealmManager()

    private func getRealm() -> Realm {
        if let _ = NSClassFromString("XCTest") {
            return try! Realm(configuration: Realm.Configuration(fileURL: nil, inMemoryIdentifier: "test", encryptionKey: nil, readOnly: false, schemaVersion: 0, migrationBlock: nil, objectTypes: nil))
        } else {
            return try! Realm();
        }
    }

    func objects<T: Object>(_ type: T.Type, predicate: NSPredicate? = nil) -> Results<T>? {
        if !isRealmAccessible() { return nil }

        let realm = getRealm()
        realm.refresh()

        return predicate == nil ? realm.objects(type) : realm.objects(type).filter(predicate!)
    }

    func object<T: Object>(_ type: T.Type, key: Any) -> T? {
        if !isRealmAccessible() { return nil }

        let realm = getRealm()
        realm.refresh()

        return realm.object(ofType: type, forPrimaryKey: key)
    }

    func add<T: Object>(_ data: [T], update: Bool = true) {
        if !isRealmAccessible() { return }

        let realm = getRealm()
        realm.refresh()

        if realm.isInWriteTransaction {
            realm.add(data)
        } else {
            try? realm.write {
                realm.add(data)
            }
        }
    }

    func add<T: Object>(_ data: T, update: Bool = true) {
        add([data], update: update)
    }

    func runTransaction(action: () -> Void) {
        if !isRealmAccessible() { return }

        let realm = getRealm()
        realm.refresh()

        try? realm.write {
            action()
        }
    }

    func delete<T: Object>(_ data: [T]) {
        let realm = getRealm()
        realm.refresh()
        try? realm.write { realm.delete(data) }
    }

    func delete<T: Object>(_ data: T) {
        delete([data])
    }

    func clearAllData() {
        if !isRealmAccessible() { return }

        let realm = getRealm()
        realm.refresh()
        try? realm.write { realm.deleteAll() }
    }
}

extension RealmManager {
    func isRealmAccessible() -> Bool {
        do { _ = try Realm() } catch {
            print("Realm is not accessible")
            return false
        }
        return true
    }

    func configureRealm() {
        let config = RLMRealmConfiguration.default()
        config.deleteRealmIfMigrationNeeded = true
        RLMRealmConfiguration.setDefault(config)
    }
}
