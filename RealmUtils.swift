//
//  RealmUtils.swift
//  Ajay Bhanushali
//
//  Copyright 2020 Ajay Bhanushali
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation
import RealmSwift

class RealmUtils {
    
    static let sharedInstance = RealmUtils()
    let realm = try! Realm()
    private init(){}
    
    // MARK:- Singleton Methods
    
    /// Discussion: When we want to store list of objects(models) in Realm DB.
    ///
    /// - Parameter list: List's type(model) must have Object as an extension
    /// - Returns: returns true if the list is stored successfully
    func write<T>(list: [T]) -> Bool {
        var isWritten = false
        try! realm.write {
            for item in list {
                realm.create(T.self as! Object.Type, value: item, update: false)
            }
            isWritten = true
        }
        return isWritten
    }
    
    /// Discussion: When we want to store list of objects(models) in Realm DB.
    ///
    /// - Parameter list: List's type(model) must have Object as an extension
    /// - Returns: returns true if the list is stored successfully
    func writeUpdate<T>(list: [T]) -> Bool {
        var isWritten = false
        try! realm.write {
            for item in list {
                realm.create(T.self as! Object.Type, value: item, update: true)
            }
            isWritten = true
        }
        return isWritten
    }
    
    /// Discussion: When we want to store list of objects(models) in Realm DB.
    ///
    /// - Parameter item: Item type(model) must have Object as an extension
    /// - Returns: returns true if the list is stored successfully
    func write<T>(item: T) -> Bool {
        var isWritten = false
        try! realm.write {
            realm.create(T.self as! Object.Type, value: item, update: false)
            isWritten = true
        }
        return isWritten
    }
    
    /// Discussion: When we want to fetch a specific item(of object type) from realm DB.
    ///
    /// - Parameters:
    ///   - predicate: NSPredicate with required item parameters
    ///   - ofType: Specify the type of item
    /// - Returns: item in specifed type if found else nil
    func filterItem<T>(predicate:NSPredicate, ofType: T.Type) -> T? {
        do {
            let realm = try Realm()
            if let result = realm.objects(T.self as! Object.Type).filter(predicate).first {
                return result as? T
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func filterItemBy<T>(id:String, ofType: T.Type) -> T? {
        do {
            let realm = try Realm()
            if let result = realm.object(ofType: T.self as! Object.Type, forPrimaryKey: id) {
                return result as? T
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func filterItemBy<T>(id:Int, ofType: T.Type) -> T? {
        do {
            let realm = try Realm()
            if let result = realm.object(ofType: T.self as! Object.Type, forPrimaryKey: id) {
                return result as? T
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func read<T>(ofType: T.Type) -> T? {
        print(realm.objects(T.self as! Object.Type).count)
        let x = realm.objects(T.self as! Object.Type).first
        return x as? T
    }
    
    func readArray<T>(ofType: T.Type) -> [T]? {
        do {
            let realm = try Realm()
            let result = Array(realm.objects(T.self as! Object.Type))
            if result.count != 0 {
                return result as? [T]
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    /// Discussion: When we want to fetch a specific array from realm DB.
    ///
    /// - Parameters:
    ///   - predicate: NSPredicate with required array parameters
    ///   - ofType: Specify the type of item
    /// - Returns: array in specifed type if found else nil array
    func filterArray<T>(predicate:NSPredicate, ofType: T.Type) -> [T]? {
        let result = Array(realm.objects(T.self as! Object.Type).filter(predicate))
        if result.count != 0 {
            return result as? [T]
        } else {
            return nil
        }
    }
    
    func writeUpdate<T>(item:T) -> Bool {
        var isWritten = false
        try! realm.write {
            realm.create(T.self as! Object.Type, value: item, update: true)
            isWritten = true
        }
        return isWritten
    }
    
    /// Discussion: To delete an item in Realm DB
    ///
    /// - Parameter type: Specify the type of item
    /// - Returns: true if found and deleted else false
    func delete<T>(type: T.Type) -> Bool {
        let list = realm.objects(T.self as! Object.Type)
        try! realm.write {
            realm.delete(list)
        }
        return true
    }
    
    /// Discussion: Delete items in RealmDB by primary key
    ///
    /// - Parameters:
    ///   - key: key, for which item will be delete
    ///   - type: Specify the type of item
    func delete<T>(item:T) {
        try! realm.write {
            realm.delete(item as! Object)
            realm.refresh()
        }
    }
    
    /// Discussion: Delete items in RealmDB by primary key
    ///
    /// - Parameters:
    ///   - key: key, for which item will be delete
    ///   - type: Specify the type of item
    func delete<T>(forKey key:String?, type: T.Type){
        let result = realm.object(ofType: type as! Object.Type, forPrimaryKey: key!)
        try! realm.write {
            if result != nil {
                realm.delete(result!)
            }
        }
    }
    
    /// Discussion: Deletes all the items in RealmDB for sure.
    func deleteAll() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
            realm.refresh()
        }
    }
}
