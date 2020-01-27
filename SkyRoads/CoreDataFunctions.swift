//
//  CoreDataFunctions.swift
//  SkyRoads
//
//  Created by dharay mistry on 03/11/16.
//  Copyright © 2016 forever knights. All rights reserved.
//

import Foundation
import CoreData
import UIKit


func getContext () -> NSManagedObjectContext {
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	return appDelegate.persistentContainer.viewContext
}

func getScores () {
	
	let fetchRequest: NSFetchRequest<HS> = HS.fetchRequest()
	
	do {
		
		Const.CDscores = try getContext().fetch(fetchRequest)

		Const.CDcount=Const.CDscores.count
		print ("num of results = \(Const.CDscores.count)")
	
		for s in Const.CDscores as [NSManagedObject]{
	
			Const.highScores.append( s.value(forKey: "hscore") as! Int)
		
		}
	} catch {
		print("Error with request: \(error)")
	}
}
func storeScore (score:Int, date: Date) {
	let context = getContext()
	
	let entity =  NSEntityDescription.entity(forEntityName: "HS", in: context)
	
	let hs = NSManagedObject(entity: entity!, insertInto: context)
	hs.setValue(score, forKey: "hscore")
    hs.setValue(date, forKey: "date")

	do {
		try context.save()
		
		print("saved!")
	} catch let error as NSError  {
		print("Could not save \(error), \(error.userInfo)")
	} catch {
		
	}
}
