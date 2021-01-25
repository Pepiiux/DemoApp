//
//  UIViewController+Additions.swift
//  Demo-app
//
//  Created by Hector Alvarado on 24/01/21.
//

import UIKit
import NVActivityIndicatorView
import PopupDialog
import RxSwift
import SwiftMessages

extension UIViewController: NVActivityIndicatorViewable {

    // MARK: - Loader

    func showLoadingView() {
        self.startAnimating(CGSize(width: 107, height: 107), type: .ballBeat)
    }

    func hideLoadingView() {
        self.stopAnimating()
    }
    
    // MARK: - Default alert
    
    func showDefaultAlert(withTitle title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Alert with Textfield
    
    func showAlertWithTextField(title: String, message: String, style: UIAlertController.Style? = nil, acceptActionTitle: String, cancelActionTitle: String, textFieldPlaceHolder: String, isSecureEntry: Bool, _ completion: @escaping (_ text: String?) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style ?? .alert)
                
        let cancel = UIAlertAction(title: cancelActionTitle, style: .cancel, handler: { _ in
            NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
        })
        
        alert.addAction(cancel)
        
        let accept = UIAlertAction(title: acceptActionTitle, style: .default, handler: { _ in
            if let textField = alert.textFields?.first {
                completion(textField.text)
            }
            
            NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
        })
        
        accept.isEnabled = false
        alert.addAction(accept)
        
        alert.addTextField(configurationHandler: { (_ textField: UITextField) -> Void in
            textField.isSecureTextEntry = isSecureEntry
            textField.attributedPlaceholder = NSAttributedString(string: textFieldPlaceHolder, attributes: [.font: UIFont.systemFont(ofSize: 10.0)])
            textField.textAlignment = .center
            
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using: { _ in
                let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                let textIsNotEmpty = textCount > 0
                
                accept.isEnabled = textIsNotEmpty
            })
        })
        
        alert.preferredAction = accept
        
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Alerts

    func showErrorMessage(message: String) {
        let title = "Error"
        showMessage(title: title, message: message)
    }

    func showMessage(title: String, message: String, completion: (() -> Void)? = nil) {
        let popup = PopupDialog(title: title, message: message)
        let buttonOk = DefaultButton(title: "OK", action: completion)
        popup.addButton(buttonOk)
        self.present(popup, animated: true)
    }

    func showMessage(title: String, message: String, okButtonTitle: String, cancelButtonTitle: String, completion: ((Bool) -> Void)? = nil) {
        let popup = PopupDialog(title: title, message: message, buttonAlignment: .horizontal)
        let buttonOk = DefaultButton(title: okButtonTitle) {
            completion?(true)
        }
        let buttonCancel = CancelButton(title: cancelButtonTitle) {
            completion?(false)
        }
        popup.addButton(buttonOk)
        popup.addButton(buttonCancel)
        self.present(popup, animated: true)
    }
    
    func showMessage(message: String, okButtonTitle: String, completion: ((Bool) -> Void)? = nil) {
        let popup = PopupDialog(title: nil, message: message, buttonAlignment: .horizontal)
        let buttonOk = DefaultButton(title: okButtonTitle) {
            completion?(true)
        }

        popup.addButton(buttonOk)
        self.present(popup, animated: true)
    }

    func showToastMessage(title: String?, message: String?) {
        guard let message = message else {
            return
        }
        let messageView = MessageView.viewFromNib(layout: .messageView)

        messageView.configureTheme(.warning)
        messageView.configureDropShadow()
        messageView.configureContent(title: title, body: message, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: nil, buttonTapHandler: nil)
        messageView.button?.isHidden = true

        // Show the message.
        SwiftMessages.show(view: messageView)
    }

    func showStatusLineMessage(message: String?) {
        guard let message = message else {
            return
        }
        let messageView = MessageView.viewFromNib(layout: .statusLine)

        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .top
        config.shouldAutorotate = false
        config.duration = .seconds(seconds: 5)
        messageView.backgroundView.backgroundColor = Colors.customGreen
        messageView.configureDropShadow()
        messageView.configureContent(title: nil, body: message, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: nil, buttonTapHandler: nil)
        messageView.button?.isHidden = true

        // Show the message.
        SwiftMessages.show(config: config, view: messageView)
    }

    func hideStatusLineMessage() {
        SwiftMessages.hide()
    }

    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */

    var topbarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            return UIApplication.shared.statusBarFrame.size.height +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        }
    }

}
