//
//  BaseView.swift
//  notBird
//

import UIKit

class BaseView : UIView {
  init() {
    super.init(frame: .zero)
    configureView()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  open func configureView() {}
}
