//
//  Image+Extensions.swift
//  TelemedPatient
//
//  Created by d.yurchenko on 09.12.2020.
//

import SwiftUI

extension Image {
 
    init(_ uiImage: UIImage?) {
        guard let uiImage = uiImage else { fatalError("Smth has gone worng") }
        self = Image(uiImage: uiImage)
    }
}
