//
//  UITableView+Extension.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/16/23.
//

import UIKit

extension UITableView {
    
    func dequeueCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("Couldn't find UITableViewCell")
        }
        return cell
    }
    
    func register<T: UITableViewCell>(cellWithClass name: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: name))
    }
    
    func getStringFromTextField(with number: Int) -> String {
        let view = self.cellForRow(
            at: IndexPath(row: 0, section: number)
        )?.contentView.getViewsByTag(tag: number)[0]
        
        if let tf = view as? UITextField, let text = tf.text {
            tf.text = ""
            return text
        }
        return ""
    }
}
