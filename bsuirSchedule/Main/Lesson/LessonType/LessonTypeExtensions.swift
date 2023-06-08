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
		[(id: String, 					name: String, 						abbreviation: String, 	color: Color)] =
		[("ЛК", 						"Лекция", 							"ЛК", 					Constants.Colors.lecture),
		 ("УЛк", 						"Удалённая лекция", 				"УЛК", 					Constants.Colors.lecture),
		 ("ПЗ", 						"Практическое занятие", 			"ПЗ", 					Constants.Colors.practice),
		 ("УПз", 						"Удалённое практическое занятие", 	"УПз", 					Constants.Colors.practice),
		 ("ЛР", 						"Лабораторная работа", 				"ЛР", 					Constants.Colors.laboratory),
		 ("УЛР", 						"Удалённая лабораторная работа", 	"УЛР", 					Constants.Colors.laboratory),
		 ("Консультация", 				"Консультация", 					"Конс", 				Constants.Colors.consultation),
		 ("Зачет", 						"Зачёт", 							"Зачёт", 				Constants.Colors.exam),
		 ("Дифференцированный зачет",	"Дифференцированный зачёт", 		"Дифф. зч", 			Constants.Colors.exam),
		 ("Кандидатский зачет", 		"Кандидатский зачёт", 				"Канд. зч", 			Constants.Colors.exam),
		 ("Экзамен", 					"Экзамен", 							"Экз", 					Constants.Colors.exam),
		 ("Кандидатский экзамен", 		"Кандидатский экзамен", 			"Канд. экз",		 	Constants.Colors.exam)]
		
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
