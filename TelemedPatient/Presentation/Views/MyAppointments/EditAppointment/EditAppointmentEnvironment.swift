//
//  EditAppointmentEnvironment.swift
//  TelemedPatient
//
//  Created by Galieva on 10.02.2021.
//

import ComposableArchitecture

struct EditAppointmentEnvironment {
    public  var workSlotsClient: WorkSlotsClient
    public var mainQueue: AnySchedulerOf<DispatchQueue>
    public var progressHUD: IProgressHUD
}
