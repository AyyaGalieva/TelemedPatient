//
//  ProfileState.swift
//  TelemedPatient
//
//  Created by Galieva on 16.12.2020.
//

import Foundation
import ComposableArchitecture

struct ProfileState: Equatable {
    var surname = ""
    var name = ""
    var patronymic = ""
    var specialty = ""
    var city = ""
    var phone = ""
    var dateOfBirth = ""
    var allergy = ""
    var email = ""
    var uuid = ""
    var photo: Photo?
    var id: Int
    var lastDoctorNickname: String?
    
    var sendFeedbackState: FeedBackState?
    
    static func formatDateString(dateStr: String?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD"
        let date = formatter.date(from: dateStr ?? "")
        formatter.dateFormat = "DD.MM.YYYY"
        var birthday = ""
        if let date = date {
            birthday = formatter.string(from: date)
        }
        return birthday
    }
}

extension ProfileState {
    var view: ProfileView.ViewState {
        ProfileView.ViewState(surname: surname,
                name: name,
                patronymic: patronymic,
                specialty: specialty,
                city: city,
                phone: phone,
                dateOfBirth: dateOfBirth,
                allergy: allergy,
                email: email,
                uuid: uuid,
                photo: photo)
    }
    
    init(with profile: PatientProfile) {
        let fullNameArr = profile.name?.components(separatedBy: " ")
        
        self.init(surname: fullNameArr?.count ?? 0 > 0 ? fullNameArr?[0] as! String : "", name: fullNameArr?.count ?? 0 > 1 ? fullNameArr?[1] as! String : "", patronymic: fullNameArr?.count ?? 0 > 2 ? fullNameArr?[2] as! String : "", specialty: profile.specialty ?? "", city: profile.city ?? "", phone: profile.phone ?? "", dateOfBirth: ProfileState.formatDateString(dateStr: profile.birthday), allergy: profile.allergy ?? "", email: profile.email, uuid: profile.ownerId ?? "", photo: profile.photo, id: profile.id, lastDoctorNickname: profile.lastDoctorNickname, sendFeedbackState: FeedBackState(id: profile.id, ownerId: profile.ownerId ?? ""))
    }
    
    
}
