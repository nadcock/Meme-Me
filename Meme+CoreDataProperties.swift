//
//  Meme+CoreDataProperties.swift
//  MemeMe
//
//  Created by Nick Adcock on 2/24/17.
//  Copyright © 2017 Nick. All rights reserved.
//

import Foundation
import CoreData


extension Meme {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meme> {
        return NSFetchRequest<Meme>(entityName: "Meme");
    }

    @NSManaged public var topString: String?
    @NSManaged public var bottomString: String?
    @NSManaged public var memeImage: Data
    @NSManaged public var originalImage: Data
    @NSManaged public var dateCreated: Date
    @NSManaged public var lastModified: Date
}
