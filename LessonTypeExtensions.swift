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
		context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
		context.automaticallyMergesChangesFromParent = true
		
		let rawData:
		[(id: String, 				name: String, 						abbreviation: String, 	color: Color)] =
		[("ЛК", 					"Лекция", 							"ЛК", 					Color(red: -4.06846e-06, green: 0.631373, blue: 0.847059)),
		 ("УЛк", 					"Удалённая лекция", 				"УЛК", 					Color(red: -4.06846e-06, green: 0.631373, blue: 0.847059)),
		 ("ПЗ", 					"Практическое занятие", 			"ПЗ", 					Color(red: 1, green: 0.415686, blue: 9.62615e-08)),
		 ("УПз", 					"Удалённое практическое занятие", 	"УПз", 					Color(red: 1, green: 0.415686, blue: 9.62615e-08)),
		 ("ЛР", 					"Лабораторная работа", 				"ЛР", 					Color(red: 0.745098, green: 0.219608, blue: 0.952942)),
		 ("УЛР", 					"Удалённая лабораторная работа", 	"УЛР", 					Color(red: 0.745098, green: 0.219608, blue: 0.952942)),
		 ("Консультация", 			"Консультация", 					"Конс", 				Color(red: 0.156956, green: 0.374282, blue: 0.959858)),
		 ("Зачет", 					"Зачёт", 							"Зачет", 				Color(red: 0.280348, green: 0.14247, blue: 0.671006)),
		 ("Кандидатский зачет", 	"Кандидатский зачёт", 				"Канд. зч", 			Color(red: 0.280348, green: 0.14247, blue: 0.671006)),
		 ("Экзамен", 				"Экзамен", 							"Экз", 					Color(red: 0.280348, green: 0.14247, blue: 0.671006)),
		 ("Кандидатский экзамен", 	"Кандидатский экзамен", 			"Канд. экз",		 	Color(red: 0.280348, green: 0.14247, blue: 0.671006))]
		
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
