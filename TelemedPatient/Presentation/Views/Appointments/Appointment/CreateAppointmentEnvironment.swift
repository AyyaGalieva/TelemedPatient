//
// Created by Андрей Кривобок on 15.01.2021.
//

import ComposableArchitecture

struct CreateAppointmentEnvironment {
    public  var workSlotsClient: WorkSlotsClient
    public var mainQueue: AnySchedulerOf<DispatchQueue>
    public var progressHUD: IProgressHUD
}
