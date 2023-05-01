//
//  LessonTypeExtensions.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 1.05.23.
//

import CoreData
import SwiftUI

extension LessonType {
	static func initDefaultLessonTypes() async {
		let context = PersistenceController.shared.container.newBackgroundContext()
		context.mergePolicy = NSMergePolicy(merge: .overwriteMergePolicyType)
		context.automaticallyMergesChangesFromParent = true
		
		let rawData:
		[(id: String, 				name: String, 						abbreviation: String, 	color: Color)] =
		[("ЛК", 					"Лекция", 							"ЛК", 					Color.green),
		 ("УЛк", 					"Удалённая лекция", 				"УЛК", 					Color.green),
		 ("ПЗ", 					"Практическое занятие", 			"ПЗ", 					Color.red),
		 ("УПз", 					"Удалённое практическое занятие", 	"УПз", 					Color.red),
		 ("ЛР", 					"Лабораторная работа", 				"ЛР", 					Color.blue),
		 ("УЛР", 					"Удалённая лабораторная работа", 	"УЛР", 					Color.blue),
		 ("Консультация", 			"Консультация", 					"Конс", 				Color.secondary),
		 ("Зачет", 					"Зачёт", 							"Зачёт", 				Color.primary),
		 ("Кандидатский зачет", 	"Кандидатский зачёт", 				"Канд. зч", 			Color.primary),
		 ("Экзамен", 				"Экзамен", 							"Экз", 					Color.primary),
		 ("Кандидатский экзамен", 	"Кандидатский экзамен", 			"Канд. экз",		 	Color.primary)]
		
		let _ = rawData.map { (id, name, abbreviation, color) in
			LessonType(id: id,
					   name: name,
					   abbreviation: abbreviation,
					   color: color,
					   context: context)
		}
		
		try! context.save()
	}
	
}

extension LessonType {
	func formattedName(abbreviated: Bool) -> String {
		if abbreviated {
			return abbreviation ?? id
		} else {
			return name ?? id
		}
	}
}
