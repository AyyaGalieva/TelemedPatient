//
//  MedrecordShortView.swift
//  TelemedPatient
//
//  Created by d.yurchenko on 17.12.2020.
//

import SwiftUI

struct MedrecordShortView: View {
    
    let note: ShortMedrecord
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(note.medrecordDate)
                .font(.system(size: 20, weight: .bold, design: .default))
            Text("\(note.doctorSpecialty), \(note.doctorName)")
            
            Text("\(R.string.localizable.medicalCardDiagnosis()): \(note.diagnosis)")
        }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(R.color.cornflowerBlue()))
        .foregroundColor(Color.white)
    }
}
