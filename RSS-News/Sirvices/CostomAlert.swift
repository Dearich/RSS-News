//
//  CostomAlert.swift
//  Billing
//
//  Created by Азизбек on 01.07.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

extension UIAlertController {
    enum TypeOfAlert {
        case lostInternet
    }

    convenience init(alertType: TypeOfAlert,action: UIAlertAction? = nil, controller: UIViewController) {
        switch alertType {
        case .lostInternet:
            self.init(title: "Отсутвует подключение!",
                      message: "Проверьте соединение с интернетом и попробуйте еще раз.",
                      preferredStyle: .actionSheet)
            if let action = action {
                self.addAction(action)
            }
        }
        controller.present(self, animated: true, completion: nil)
    }
}
