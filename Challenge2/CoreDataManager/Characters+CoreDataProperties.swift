//
//  Characters+CoreDataProperties.swift
//  Challenge2
//
//  Created by Anwesh M on 08/02/22.
//
//

import Foundation
import CoreData


extension Characters {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Characters> {
        return NSFetchRequest<Characters>(entityName: "Characters")
    }

    @NSManaged public var name: String?
    @NSManaged public var occupation: String?
    @NSManaged public var birthday: String?
    @NSManaged public var status: String?
    @NSManaged public var nickname: String?
    @NSManaged public var image: Data?
    @NSManaged public var charId: Int64
    @NSManaged public var imageURL: String?
}

extension Characters : Identifiable {

}
