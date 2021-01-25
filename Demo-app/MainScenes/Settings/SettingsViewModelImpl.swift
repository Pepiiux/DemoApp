//
//  SettingsViewModelImpl.swift
//  Demo-app
//
//  Created by Hector Alvarado on 23/01/21.
//

import RxSwift
import XCoordinator

class SettingsViewModelImpl: SettingsViewModel, SettingsViewModelInput, SettingsViewModelOutput {

    // MARK: - Inputs

    // MARK: - Actions

    // MARK: - Private

    private let router: StrongRouter<SettingsRoute>

    // MARK: - Init

    init(router: StrongRouter<SettingsRoute>) {
        self.router = router
    }

}
