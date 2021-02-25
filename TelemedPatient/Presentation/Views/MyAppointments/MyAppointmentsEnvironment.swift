//
//  MyAppointmentsEnvironment.swift
//  TelemedPatient
//
//  Created by Galieva on 07.02.2021.
//

import Foundation
import ComposableArchitecture

struct MyAppointmentsEnvironment {
    var workSlotsClient: WorkSlotsClient
    public var mainQueue: AnySchedulerOf<DispatchQueue>
    public var progressHUD: IProgressHUD
}
