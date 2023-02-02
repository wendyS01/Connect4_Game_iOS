//
//  CoreDataDisc+CoreDataProperties.swift
//  Connect4
//
//  Created by 宋文迪 on 16/12/2022.
//
//

import Foundation
import CoreData


extension CoreDataDisc {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataDisc> {
        return NSFetchRequest<CoreDataDisc>(entityName: "CoreDataDisc")
    }

    @NSManaged public var column: Int16
    @NSManaged public var index: Int16
    @NSManaged public var isWinning: Bool
    @NSManaged public var row: Int16
    @NSManaged public var session: CoreDataSession?

}

extension CoreDataDisc : Identifiable {

}
