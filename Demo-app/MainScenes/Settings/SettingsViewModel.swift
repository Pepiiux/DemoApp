//
//  SettingsViewModel.swift
//  Demo-app
//
//  Created by Hector Alvarado on 23/01/21.
//

import RxSwift
import XCoordinator

protocol SettingsViewModelInput {
}

protocol SettingsViewModelOutput {

}

protocol SettingsViewModel {
    var input: SettingsViewModelInput { get }
    var output: SettingsViewModelOutput { get }
}

extension SettingsViewModel where Self: SettingsViewModelInput & SettingsViewModelOutput {
    var input: SettingsViewModelInput { return self }
    var output: SettingsViewModelOutput { return self }
}
