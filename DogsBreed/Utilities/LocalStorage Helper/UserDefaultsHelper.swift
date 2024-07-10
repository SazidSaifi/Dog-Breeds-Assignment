//
//  UserDefaultsHelper.swift
//  DogsBreed
//
//  Created by Sazid Saifi on 10/07/24.
//

import Foundation

class LocalStorege {
   static func addData(_ newData: String) {
        var data = retrieveData() ?? [String]()
        
        if !data.contains(newData) {
            data.append(newData)
            saveData(data)
        } else {
            removeData(newData)
        }
    }
    
    static func retrieveData() -> [String]? {
        if let savedString = UserDefaults.standard.string(forKey: "breedData") {
            let dataArray = savedString.split(separator: ",").map { String($0) }
            return dataArray
        }
        return nil
    }
    
    static func saveData(_ data: [String]) {
        let joinedString = data.joined(separator: ",")
        UserDefaults.standard.set(joinedString, forKey: "breedData")
        print("Saved")
    }
    
    
    static func checkavedData(breedData: String) ->Bool {
        var data = retrieveData() ?? [String]()
        if data.contains(breedData) {
            return true
        } else {
            return false
        }
    }
    
    
    static func removeData(_ itemToRemove: String) {
        var data = retrieveData() ?? [String]()
        
        if let index = data.firstIndex(of: itemToRemove) {
            data.remove(at: index)
            saveData(data)
        }
        print("Remove")
    }
}
