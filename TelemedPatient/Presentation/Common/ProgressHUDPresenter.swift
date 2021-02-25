//
// Created by Андрей Кривобок on 18.02.2021.
//

import Foundation
import ProgressHUD
import ComposableArchitecture

protocol IProgressHUD {
    var show: () -> Effect<Never, Never> { get }
    var dismiss: () -> Effect<Never, Never> { get }
}

struct ProgressHUDPresenter: IProgressHUD {

    init() {
        ProgressHUD.animationType = .circleSpinFade
    }

    var show: () -> Effect<Never, Never> = {
        .fireAndForget {
            ProgressHUD.show(interaction: false)
        }
    }

    var dismiss: () -> Effect<Never, Never> = {
        .fireAndForget {
            ProgressHUD.dismiss()
        }
    }
}
