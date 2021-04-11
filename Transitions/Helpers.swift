//
//  Helpers.swift
//  Transitions
//
//  Created by Rajiv Jhoomuck on 11/04/2021.
//

import UIKit

extension UIView {
  func embed(_ view: UIView, atIndex index: Int?, insets: UIEdgeInsets) {
    view.translatesAutoresizingMaskIntoConstraints = false

    if let index = index { insertSubview(view, at: index) }
    else { addSubview(view) }

    NSLayoutConstraint.activate([
      view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
      view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: insets.right),
      view.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
      view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: insets.bottom)
    ])
  }
}
