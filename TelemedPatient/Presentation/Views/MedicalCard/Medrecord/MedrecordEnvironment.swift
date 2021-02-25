//
//  MedrecordEnvironment.swift
//  TelemedPatient
//
//  Created by d.yurchenko on 21.12.2020.
//

import Foundation
import ComposableArchitecture

struct MedrecordEnvironment {
    
    var medicalCardClient: MedicalCardClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var progressHUD: IProgressHUD
    
    static let live = MedrecordEnvironment(
        medicalCardClient: .live,
        mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
        progressHUD: ProgressHUDPresenter()
    )
}
