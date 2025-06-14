//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Николай Замараев on 09.06.2025.
//

import Foundation
import UIKit

final class AlertPresenter {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func show(in viewController: UIViewController? = nil, model: AlertModel) {
        let targetViewController = viewController ?? self.viewController
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default) { _ in
                model.completion()
            }
        
        alert.addAction(action)
        
        targetViewController?.present(alert, animated: true)
    }
}

