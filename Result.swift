//
//  Result.swift
//  AlcCalc
//
//  Created by Andrew Regan on 29/5/17.
//  Copyright © 2017 Andrew Regan. All rights reserved.
//

import UIKit
import os.log

class Result: NSObject, NSCoding {
    
    //MARK: Properties
    var drinkName: String
    var drinkNumber = Int()
    var drinkAlcoholContent = Double()
    var drinkVolume = Int()
    var drinkPrice = Float()
    
    //calculated result from above variables
    var alcCalcResult = Double()
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("results")
    
    //MARK: Types
    struct PropertyKey {
        static let drinkName = "drinkName"
        static let drinkNumber = "drinkNumber"
        static let drinkAlcoholContent = "drinkAlcoholContent"
        static let drinkVolume = "drinkVolume"
        static let drinkPrice = "drinkPrice"
        static let alcCalcResult = "alcCalcResult"
    }
    
    //MARK: Initialization
    
    init?(drinkName: String, drinkNumber: Int, drinkAlcoholContent: Double, drinkVolume: Int, drinkPrice: Float, alcCalcResult: Double) {
        
        // The name must not be empty
        guard !drinkName.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.drinkName = drinkName
        self.drinkNumber = drinkNumber
        self.drinkAlcoholContent = drinkAlcoholContent
        self.drinkVolume = drinkVolume
        self.drinkPrice = drinkPrice
        self.alcCalcResult = round(Double(drinkNumber) * Double(drinkVolume) * Double(drinkAlcoholContent) / Double(drinkPrice) / 100 * 100)/100
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(drinkName, forKey: PropertyKey.drinkName)
        aCoder.encode(drinkNumber, forKey: PropertyKey.drinkNumber)
        aCoder.encode(drinkAlcoholContent, forKey: PropertyKey.drinkAlcoholContent)
        aCoder.encode(drinkVolume, forKey: PropertyKey.drinkVolume)
        aCoder.encode(drinkPrice, forKey: PropertyKey.drinkPrice)
        aCoder.encode(alcCalcResult, forKey: PropertyKey.alcCalcResult)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let drinkName = aDecoder.decodeObject(forKey: PropertyKey.drinkName) as? String else {
            os_log("Unable to decode the drinkName for a Result object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let drinkNumber = aDecoder.decodeObject(forKey: PropertyKey.drinkNumber) as? Int else {
            if #available(iOS 10.0, *) {
                os_log("Unable to decode the drink number for a Result object.", log: OSLog.default, type: .debug)
            } else {
                // Fallback on earlier versions
            }
            return nil
        }
        
        guard let drinkAlcoholContent = aDecoder.decodeObject(forKey: PropertyKey.drinkAlcoholContent) as? Double else {
            if #available(iOS 10.0, *) {
                os_log("Unable to decode the drink alcohol content for a Result object.", log: OSLog.default, type: .debug)
            } else {
                // Fallback on earlier versions
            }
            return nil
        }
        guard let drinkVolume = aDecoder.decodeObject(forKey: PropertyKey.drinkVolume) as? Int else {
            if #available(iOS 10.0, *) {
                os_log("Unable to decode the drinkVolume for a Result object.", log: OSLog.default, type: .debug)
            } else {
                // Fallback on earlier versions
            }
            return nil
        }
        guard let drinkPrice = aDecoder.decodeObject(forKey: PropertyKey.drinkPrice) as? Float else {
            if #available(iOS 10.0, *) {
                os_log("Unable to decode the drinkPRice for a Result object.", log: OSLog.default, type: .debug)
            } else {
                // Fallback on earlier versions
            }
            return nil
        }
        guard let alcCalcResult = aDecoder.decodeObject(forKey: PropertyKey.alcCalcResult) as? Double else {
            if #available(iOS 10.0, *) {
                os_log("Unable to decode the AlcCalc for a Result object.", log: OSLog.default, type: .debug)
            } else {
                // Fallback on earlier versions
            }
            return nil
        }
        
        // Must call designated initializer.
        self.init(drinkName: drinkName, drinkNumber: drinkNumber, drinkAlcoholContent: Double(drinkAlcoholContent), drinkVolume: drinkVolume, drinkPrice: drinkPrice, alcCalcResult: Double(alcCalcResult))
        
    }
}

