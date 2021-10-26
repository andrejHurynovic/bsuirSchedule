//
//  DesignManager.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 21.10.21.
//

import SwiftUI

class DesignManager: ObservableObject {
    
    @AppStorage("mainColor") var mainColor = Color.accentColor
    
    @AppStorage("lectureColor") var lectureColor: Color = Color(red: -4.06846e-06, green: 0.631373, blue: 0.847059)
    @AppStorage("practiceColor") var practiceColor = Color(red: 1, green: 0.415686, blue: 9.62615e-08)
    @AppStorage("laboratoryColor") var laboratoryColor = Color(red: 0.745098, green: 0.219608, blue: 0.952942)
    @AppStorage("consultationColor") var consultationColor = Color(red: 0.156956, green: 0.374282, blue: 0.959858)
    @AppStorage("examColor") var examColor = Color(red: 0.280348, green: 0.14247, blue: 0.671006)
    
    
    static var shared: DesignManager { .init() }
    
    func restoreDefaults() {
        mainColor = Color.accentColor
        
        lectureColor = Color(red: -4.06846e-06, green: 0.631373, blue: 0.847059)
        practiceColor = Color(red: 1, green: 0.415686, blue: 9.62615e-08)
        laboratoryColor = Color(red: 0.745098, green: 0.219608, blue: 0.952942)
        consultationColor = Color(red: 0.156956, green: 0.374282, blue: 0.959858)
        examColor = Color(red: 0.280348, green: 0.14247, blue: 0.671006)
    }
    
    func color(_ type: LessonType) -> Color {
        switch type {
        case .none:
            return .gray
        case .lecture:
            return lectureColor
        case .remoteLecture:
            return lectureColor
        case .practice:
            return practiceColor
        case .remotePractice:
            return practiceColor
        case .laboratory:
            return laboratoryColor
        case .consultation:
            return consultationColor
        case .exam:
            return examColor
        case .candidateText:
            return examColor
        }
    }
    
}



extension Color: RawRepresentable {
    
    public init?(rawValue: String) {
        
        guard let data = Data(base64Encoded: rawValue) else{
            self = .black
            return
        }
        
        do{
            let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor ?? .black
            self = Color(color)
        }catch{
            self = .black
        }
        
    }
    
    public var rawValue: String {
        
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: UIColor(self), requiringSecureCoding: false) as Data
            return data.base64EncodedString()
            
        }catch{
            
            return ""
            
        }
        
    }
    
}
