//
//  DesignManager.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 21.10.21.
//

import SwiftUI

//MARK: - Shadow

extension View {
    func standardisedShadow() -> some View {
//        shadow(radius: 8, x: 4, y: 4)
        shadow(color: Color(uiColor: UIColor(named: "shadowColor")!), radius: 8, x: 0, y: 0)
    }
}

//MARK: - Headers

struct standardizedHeader: View {
    var title: String
    
    var body: some View {
        Text(title)
//            .font(.system(.title2, design: .rounded, weight: .heavy))
            .font(.title2)
            .fontWeight(.heavy)
            .foregroundColor(.primary)
            .padding(.top)
    }
}

struct NewHeader: View {
    var title: String
    var divider = true
    
    var body: some View {
        Text(title)
            .font(.title2)
            .fontWeight(.bold)
            .padding(.top)
        if divider {
            Divider()
                .padding(.bottom)
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
            let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) ?? .black
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

struct Design_Previews: PreviewProvider {
    static var previews: some View {
        standardizedHeader(title: "ПРИВЕт, мужики!")
            .previewInterfaceOrientation(.portrait)
    }
}

