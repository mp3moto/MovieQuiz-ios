//
//  ResultAlertPresenter.swift
//  MovieQuiz
//
//  Created by  admin on 17.08.2022.
//

import Foundation
import UIKit
class ResultAlertPresenter {
    private let title: String
    private let message: String
    private let controller: UIViewController
    private let someClosure: Void
    func show() {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Сыграть еще раз!", style: .default, handler: { _ in
            self.someClosure
        })

        alert.addAction(action)
        DispatchQueue.main.async {
            self.controller.present(alert, animated: true, completion: nil)
        }
    }

    init(title: String, message: String, controller: UIViewController, someClosure: Void?) {
        self.title = title
        self.message = message
        self.controller = controller
        self.someClosure = someClosure!
    }
}
