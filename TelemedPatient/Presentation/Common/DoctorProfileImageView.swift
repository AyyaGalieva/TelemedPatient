//
//  DoctorProfileImageView.swift
//  TelemedPatient
//
//  Created by Андрей Кривобок on 27.12.2020.
//

import SwiftUI
import URLImage

struct DoctorProfileImageView: View {

    let doctorProfile: DoctorProfile?

    var body: some View {
        if let photoURL = doctorProfile?.photo?.url {
            // TODO: tune URLImage
            URLImage(url: photoURL) { (image: Image) in
                image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .fixedSize(horizontal: true, vertical: false)
            }
        } else {
            Image("doctor")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .fixedSize(horizontal: true, vertical: false)
        }
    }
}
