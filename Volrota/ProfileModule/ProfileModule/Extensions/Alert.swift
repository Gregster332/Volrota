//
//  Alert.swift
//  MyMeds
//  LMBase
//
//  Created by Niyazov on 20.11.2022.
//

import UIKit

public struct Alert {
    public let title: String?
    public let message: String?
    public let style: UIAlertController.Style
    public let actions: [Action]
    
    public init(title: String?, message: String?, style: UIAlertController.Style, actions: [Action]) {
        self.title = title
        self.message = message
        self.style = style
        self.actions = actions
    }

    public struct Action {
        public let title: String
        public let style: UIAlertAction.Style
        public let action: (() -> Void)?
        
        public init(title: String, style: UIAlertAction.Style, action: (() -> Void)?) {
            self.title = title
            self.style = style
            self.action = action
        }
    }
}
