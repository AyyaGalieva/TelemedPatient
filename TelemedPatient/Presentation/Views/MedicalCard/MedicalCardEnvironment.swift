//
//  MedicalCardEnvironment.swift
//  TelemedPatient
//
//  Created by d.yurchenko on 16.12.2020.
//

import Foundation
import ComposableArchitecture

struct MedicalCardEnvironment {
    
    var medicalCardClient: MedicalCardClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var progressHUD: IProgressHUD
    
    static let live = MedicalCardEnvironment(
        medicalCardClient: .live,
        mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
        progressHUD: ProgressHUDPresenter()
    )
}
