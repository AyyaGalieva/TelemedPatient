//
//  UIControl.swift
//  TelemedPatient
//
//  Created by d.yurchenko on 27.11.2020.
//

import SwiftUI

extension UIControl {
    
    func addAction(for controlEvents: UIControl.Event, action: @escaping () -> ()) {
        let sleeve = ClosureSleeve(attachTo: self, closure: action)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
    }
}

var AssociatedObjectHandle: UInt8 = 0

class ClosureSleeve {
    
    let closure: () -> ()
    
    init(attachTo: AnyObject, closure: @escaping () -> ()) {
        self.closure = closure
        objc_setAssociatedObject(attachTo, &AssociatedObjectHandle, self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    @objc func invoke() {
        closure()
    }
}
