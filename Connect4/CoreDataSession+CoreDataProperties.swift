//
//  CoreDataSession+CoreDataProperties.swift
//  Connect4
//
//  Created by 宋文迪 on 16/12/2022.
//
//

import Foundation
import CoreData


extension CoreDataSession {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataSession> {
        return NSFetchRequest<CoreDataSession>(entityName: "CoreDataSession")
    }

    @NSManaged public var botColor: Int16
    @NSManaged public var botIsFirst: Bool
    @NSManaged public var columns: Int16
    @NSManaged public var discCount: Int64
    @NSManaged public var log: String?
    @NSManaged public var rows: Int16
    @NSManaged public var discs: CoreDataDisc?

}

extension CoreDataSession : Identifiable {

}
