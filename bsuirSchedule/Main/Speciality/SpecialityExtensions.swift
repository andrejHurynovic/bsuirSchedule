//
//  SpecialityExtensions.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 11.04.23.
//

extension Speciality {
    func formattedID() -> String {
        return "\(self.abbreviation) - \(String(describing: self.faculty?.abbreviation)) - \(String(describing: self.educationType?.id)) - \(self.objectID.description)"
    }
    
    ///Name + education type + faculty abbreviation
    func formattedDescription(useSpecialityName: Bool = false) -> String {
        var base = useSpecialityName ? self.name : self.abbreviation
        let components: [String] = [self.faculty?.abbreviation,
                                    self.educationType?.name.lowercased()]
            .compactMap { $0 }
        if components.isEmpty == false {
            base.append(" (\(String(components.joined(separator: ", "))))")
        }
        
        return base
    }
    
}
