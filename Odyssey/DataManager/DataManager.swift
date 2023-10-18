//
//  DataManager.swift
//  Odyssey
//
//  Created by Rajwinder Singh on 10/18/23.
//

import Foundation

//Singleton Class
class DataManager: NSObject {
    static let sharedInstance: DataManager = {
        let instance = DataManager()
        return instance
    }()
    
    private override init() {
        super.init()
    }
    
    
}

let ins = DataManager.sharedInstance
