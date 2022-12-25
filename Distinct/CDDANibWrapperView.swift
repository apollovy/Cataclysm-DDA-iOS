//
// Created by Аполлов Юрий Андреевич on 26.12.2022.
// Copyright (c) 2022 Аполлов Юрий Андреевич. All rights reserved.
//
import Foundation
import UIKit

class CDDANibWrapperView<T: UIView> : NibWrapperView<T> {
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if (super.forwardingTarget(for: aSelector) == nil) {
            return contentView
        }
        return nil
    }
}
