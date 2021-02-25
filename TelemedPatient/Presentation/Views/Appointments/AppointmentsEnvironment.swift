//
// Created by Андрей Кривобок on 17.12.2020.
//

import ComposableArchitecture

struct AppointmentsEnvironment {
    var workSlotsClient: WorkSlotsClient
    var socketClient: SocketClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var progressHUD: IProgressHUD
}
