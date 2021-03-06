//
//  FWData.swift
//
//  Created by  on 25/01/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class FWMobileSettingData: NSObject, NSCoding {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kFWDataGlobalMobileSetttingsKey: String = "globalMobileSetttings"


    // MARK: Properties
	public var globalMobileSetttings: FWGlobalMobileSetttings?


    // MARK: SwiftyJSON Initalizers
    /**
    Initates the class based on the object
    - parameter object: The object of either Dictionary or Array kind that was passed.
    - returns: An initalized instance of the class.
    */
    convenience public init(object: AnyObject) {
        self.init(json: JSON(object))
    }

    /**
    Initates the class based on the JSON that was passed.
    - parameter json: JSON object from SwiftyJSON.
    - returns: An initalized instance of the class.
    */
    public init(json: JSON) {
		globalMobileSetttings = FWGlobalMobileSetttings(json: json[kFWDataGlobalMobileSetttingsKey])

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if globalMobileSetttings != nil {
			dictionary.updateValue(globalMobileSetttings!.dictionaryRepresentation() as AnyObject as AnyObject, forKey: kFWDataGlobalMobileSetttingsKey)
		}

        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
		self.globalMobileSetttings = aDecoder.decodeObject(forKey: kFWDataGlobalMobileSetttingsKey) as? FWGlobalMobileSetttings

    }

    public func encode(with aCoder: NSCoder) {
		aCoder.encode(globalMobileSetttings, forKey: kFWDataGlobalMobileSetttingsKey)

    }

}
