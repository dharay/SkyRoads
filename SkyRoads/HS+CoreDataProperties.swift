//
//  HS+CoreDataProperties.swift
//  SkyRoads
//
//  Created by dharay mistry on 03/11/16.
//  Copyright © 2016 forever knights. All rights reserved.
//

import Foundation
import CoreData


extension HS {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HS> {
        return NSFetchRequest<HS>(entityName: "HS");
    }

    @NSManaged public var hscore: Int64

}
