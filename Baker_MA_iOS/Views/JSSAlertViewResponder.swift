//
//  JSSAlertViewResponder.swift
//  Baker_MA_iOS
//
//  Created by Panda Systems on 7/24/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

import Foundation
import UIKit


@objc class JSSAlertViewResponder:NSObject {
    
    let alertview: JSSAlertView
    
    init(alertview: JSSAlertView) {
        self.alertview = alertview
    }
    
    func addAction(action: ()->Void) {
        self.alertview.addAction(action)
    }
    
    func addCancelAction(action: ()->Void) {
        self.alertview.addCancelAction(action)
    }
    
    func setTitleFont(fontStr: String) {
        self.alertview.setFont(fontStr, type: .Title)
    }
    
    func setTextFont(fontStr: String) {
        self.alertview.setFont(fontStr, type: .Text)
    }
    
    func setButtonFont(fontStr: String) {
        self.alertview.setFont(fontStr, type: .Button)
    }
    
    func setTextTheme(theme: TextColorTheme) {
        self.alertview.setTextTheme(theme)
    }
    
    @objc func close() {
        self.alertview.closeView(false)
    }
}