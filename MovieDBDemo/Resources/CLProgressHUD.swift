//****************************   Hardeep  Singh  ****************************
//****************************   hardeep.singh@click-labs.com
//****************************   +919872322049

//
//  CLProgressHUD.swift
//  CLApp
//
//  Created by Hardeep Singh. on 07/12/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import UIKit
import MBProgressHUD

class CLProgressHUD: MBProgressHUD {
  
  private static var sharedView: CLProgressHUD!
  
  @discardableResult
  func mode(mode: MBProgressHUDMode) -> CLProgressHUD {
    self.mode = mode
    return self
  }
  
  @discardableResult
  func animationType(animationType: MBProgressHUDAnimation) -> CLProgressHUD {
    self.animationType = animationType
    return self
  }
  
  @discardableResult
  func backgroundViewStyle(style: MBProgressHUDBackgroundStyle) -> CLProgressHUD {
    self.backgroundView.style = style
    return self
  }
  
  @discardableResult
  class func present(animated: Bool) -> CLProgressHUD {
    if sharedView != nil {
      sharedView.hide(animated: false)
    }
    if let view = appDelegate.window {
      sharedView = CLProgressHUD.showAdded(to: view, animated: true)
    }
    return sharedView
  }
  
  class func dismiss(animated: Bool) {
    if sharedView != nil {
      sharedView.hide(animated: true)
    }
  }
  
}
