//
//  BaseViewController.swift
//  Demo-app
//
//  Created by Hector Alvarado on 23/01/21.
//

import UIKit
import Action
import RxSwift
import EventKitUI

class BaseViewController: UIViewController {

    // MARK: Properties

    let disposeBag = DisposeBag()
    var backButtonItem: UIBarButtonItem?
    var skipButtonItem: UIBarButtonItem?
    var stopButtonItem: UIBarButtonItem?
    var isLoadingTrigger: AnyObserver<Bool>!
    var viewToMoveWithKeyboardConstraint: NSLayoutConstraint?
    
    // MARK: Status bar configuration

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgroundColor()
        setupUI()
        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupStatusBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
    }

    // MARK: - Mandatory methods

    func setupUI() {
        self.modalPresentationStyle = .fullScreen
    }

    func setupBindings() {}

    // MARK: - Navigation Bar

    func showNavigationBar(animated: Bool, showLogo: Bool = false) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        setupNavigationBarAppearance()
        if showLogo {
            showLogoNavigationBar()
        }
    }

    func hideNavigationBar(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func addBackButton() {
        backButtonItem = UIBarButtonItem(image: Images.backArrow.withRenderingMode(.alwaysTemplate), style: .plain, target: nil, action: nil)
        backButtonItem?.tintColor = .white
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    func showLogoNavigationBar() {
        setupNavigationBarAppearance(withBackgroundColor: Colors.customRed, isTranslucent: false)
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        let imageView = UIImageView(frame: logoContainer.frame)
        imageView.contentMode = .scaleAspectFit
        imageView.image = Images.logoBlack
        logoContainer.addSubview(imageView)
        navigationItem.titleView = logoContainer
    }
    
    // MARK: - Tab Bar
    
    func hideTabBar() {
        self.hidesBottomBarWhenPushed = true
    }
    
    func showTabBar() {
        self.hidesBottomBarWhenPushed = false
    }
    
    // MARK: - Status bar setup
    
    func setupStatusBar(isLightMode: Bool = false) {
        navigationController?.navigationBar.barStyle = isLightMode ? .black : .default
    }

    // MARK: - Private methods

    private func setupBackgroundColor() {
        view.backgroundColor = UIColor.white
    }
    
    private func setupNavigationBarAppearance(withBackgroundColor backgroundColor: UIColor = .white, isTranslucent: Bool = true) {
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.barTintColor = backgroundColor
        self.navigationController?.navigationBar.isTranslucent = isTranslucent
    }

    // MARK: - Device Orientation
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [.portrait]
    }

}

extension BaseViewController: EKEventEditViewDelegate {

    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true)
    }
    
}
