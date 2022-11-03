//
//  DesignManager.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 21.10.21.
//

import SwiftUI

//MARK: FORMS

struct Form: View  {
    var name: String
    var parameter: String
    
    init(_ name: String, _ parameter: String) {
        self.name = name
        self.parameter = parameter
    }
    
    var body: some View {
        HStack {
            Text(name)
                .foregroundColor(.primary)
            Spacer()
            Text(parameter)
                .foregroundColor(.secondary)
        }
    }
}

//MARK: Buttons

func FavoriteButton(_ favorite: Bool, circle: Bool = false, toggle: @escaping () -> Void) -> some View {
    Button {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.9)) {
            toggle()
            try! PersistenceController.shared.container.viewContext.save()
        }
    } label: {
        Label(favorite ? "Убрать из избранных" : "Добавить в избранные",
              systemImage: favorite ? (circle ? "star.circle" : "star.slash") : (circle ? "star.circle.fill" : "star.fill"))
    }
    
}

//MARK: Context menu buttons

struct PhotoActionButtons: View {
    var image: UIImage
    var body: some View {
        pasteToCopyboard(image: image)
        saveToPhotosLibrary(image: image)
    }
}

private struct pasteToCopyboard: View {
    var image: UIImage
    var body: some View {
        Button {
            UIPasteboard.general.image = image
        } label: {
            Label("Скопировать фото", systemImage: "doc.on.doc")
        }
    }
}

private struct saveToPhotosLibrary: View {
    var image: UIImage
    var body: some View {
        Button {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        } label: {
            Label("Сохранить фото", systemImage: "square.and.arrow.down")
        }
    }
}

//MARK: Shadow

extension View {
    func standardisedShadow() -> some View {
//        shadow(radius: 8, x: 4, y: 4)
        shadow(color: Color(uiColor: UIColor(named: "shadowColor")!), radius: 8, x: 0, y: 0)
    }
}

//MARK: Headers

struct standardizedHeader: View {
    var title: String
    
    var body: some View {
        Text(title)
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

struct Design_Previews: PreviewProvider {
    static var previews: some View {
        standardizedHeader(title: "ПРИВЕт, мужики!")
            .previewInterfaceOrientation(.portrait)
    }
}

