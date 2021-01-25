//
//  SettingsViewController.swift
//  Demo-app
//
//  Created by Hector Alvarado on 23/01/21.
//

import RxCocoa
import RxSwift
import UIKit

class SettingsViewController: BaseViewController {

    // MARK: - Views

    // MARK: - Properties

    private var viewModel: SettingsViewModel

    // MARK: - Lifecycle

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel

        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func setupUI() {
        super.setupUI()
    }

    override func setupBindings() {
        super.setupBindings()
    }

}
