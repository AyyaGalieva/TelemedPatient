//
//  MedrecordState.swift
//  TelemedPatient
//
//  Created by d.yurchenko on 21.12.2020.
//

import Foundation
import SwiftUI

struct MedrecordState: Identifiable {
    
    var id: Int {
        medrecord.id ?? -1
    }
    
    var presentationMode: Binding<PresentationMode>?
    var costString: String = ""
    var medrecord: Medrecord
    var namelessFilesCount: Int = 0
    var wasNamelessFile: Bool = false
    
    var filesNameString: String {
        var filesNameString = ""
        medrecord.files.forEach { file in
            if filesNameString.isEmpty {
                filesNameString.append(file.name)
            } else {
                filesNameString.append(", \(file.name)")
            }
        }
        return filesNameString
    }
    
    init (with medrecord: Medrecord) {
        self.medrecord = medrecord
        costString = String(medrecord.cost ?? 0)
    }
}

extension MedrecordState: Equatable {
    
    static func == (lhs: MedrecordState, rhs: MedrecordState) -> Bool {
        lhs.medrecord == rhs.medrecord
    }
}

extension MedrecordState {

    var view: MedrecordView.ViewState {
        
        MedrecordView.ViewState(
            medrecord: medrecord,
            costString: costString,
            filesNameString: filesNameString
        )
    }
}
