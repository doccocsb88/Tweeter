//
//  CoreDataService.swift
//  Tweeter
//
//  Created by Apple on 3/17/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import CoreData
import UIKit
class CoredataService{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private static var sharedCoreData: CoredataService = {
        let sharedCoreData = CoredataService()
        
        // Configuration
        // ...
        
        return sharedCoreData
    }()
    init() {
    }
    class func shared() -> CoredataService {
        return sharedCoreData
    }
    
    func getListMessage() -> [Message]{
        //        do {
        //            let messages = try context.fetch(Message.fetchRequest()) as [Message]
        //            return messages
        //        } catch {
        //            print("Couldn't Fetch Data")
        //            return []
        //        }
        let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        let currentDate = Date() as NSDate
        fetchRequest.predicate = NSPredicate(format: "dateTime <= %@", currentDate)
        let messageSortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        fetchRequest.sortDescriptors = [messageSortDescriptor]
        do {
            let fetchedMessages = try context.fetch(fetchRequest) as! [Message]
            return fetchedMessages
        } catch {
            fatalError("Failed to fetch message: \(error)")
        }
        return []
        
    }
    
    func addNewMessage(content:String, order: Int) -> Message{
        let newEntry = Message(context: context)
        newEntry.content = content
        newEntry.dateTime = Date()
        newEntry.order = Int64(order)
        return newEntry
    }
    func save(){
        do{
            try context.save()
        }catch{
            fatalError("Failed to save message: \(error)")

        }

    }
}
