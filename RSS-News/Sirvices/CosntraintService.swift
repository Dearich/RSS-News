//
//  CosntraintService.swift
//  EventBall
//
//  Created by Азизбек on 04.05.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

extension UIView {

        func addConstraintsWithFormat(format: String, views: UIView...) {
            var viewDictinary = [String: UIView]()
            for (index, view) in views.enumerated() {
                let key = "v\(index)"
                viewDictinary[key] = view
                view.translatesAutoresizingMaskIntoConstraints = false
            }
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewDictinary))

        }
}
