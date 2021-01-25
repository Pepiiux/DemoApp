//
//  UIViewController+Rx.swift
//  Demo-app
//
//  Created by Hector Alvarado on 24/01/21.
//

import RxSwift
import RxCocoa
import NVActivityIndicatorView

typealias AddActivityAttributes = (title: String, message: String)

extension Reactive where Base: BaseViewController {

    var isLoading: Binder<Bool> {
        return Binder<Bool>(self.base) { viewController, show in
            if show {
                viewController.showLoadingView()
            } else {
                viewController.hideLoadingView()
            }
        }
    }

    var simpleMessage: Binder<(String,String)> {
        return Binder<(String, String)>(self.base) { viewController, messageDescription in
            viewController.showMessage(title: messageDescription.0, message: messageDescription.1)
        }
    }

    func showMessageWith(requestCode: Int, title: String, message: String) -> Observable<Int> {
        return Observable.create { [weak base] observer in
            base?.showMessage(title: title, message: message) {
                observer.onNext(requestCode)
            }
            return Disposables.create()
        }
    }

    func showMessageWith(title: String, message: String, okButtonTitle: String, cancelButtonTitle: String) -> Observable<Bool> {
        return Observable.create { [weak base] observer in
            base?.showMessage(title: title, message: message, okButtonTitle: okButtonTitle, cancelButtonTitle: cancelButtonTitle) { accept in
                observer.onNext(accept)
            }
            return Disposables.create()
        }
    }
    
    func showMessageWithTextField(title: String, message: String, placeholder: String, okButtonTitle: String, cancelButtonTitle: String, isSecureEntry: Bool) -> Observable<String?> {
        return Observable.create { [weak base] observer in
            base?.showAlertWithTextField(title: title, message: message, acceptActionTitle: okButtonTitle, cancelActionTitle: cancelButtonTitle, textFieldPlaceHolder: placeholder, isSecureEntry: isSecureEntry, { text in
                observer.onNext(text)
            })
            
            return Disposables.create()
        }
    }
    
    func showMessageWith(message: String, okButtonTitle: String) -> Observable<Bool> {
        return Observable.create { [weak base] observer in
            base?.showMessage(message: message, okButtonTitle: okButtonTitle) { accept in
                observer.onNext(accept)
            }
            return Disposables.create()
        }
    }

    var simpleErrorMessage: Binder<String> {
        return Binder<String>(self.base) { viewController, message in
            viewController.showErrorMessage(message: message)
        }
    }

    var simpleToastMessage: Binder<String> {
        return Binder<String>(self.base) { viewController, message in
            viewController.showToastMessage(title: nil, message: message)
        }
    }

    var simpleStatusLineMessage: Binder<String> {
        return Binder<String>(self.base) { viewController, message in
            viewController.showStatusLineMessage(message: message)
        }
    }

    var hideStatusLineMessage: Binder<Void> {
        return Binder<Void>(self.base) { viewController, _  in
            viewController.hideStatusLineMessage()
        }
    }

}
