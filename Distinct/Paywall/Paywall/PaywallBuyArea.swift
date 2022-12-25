//
// Created by Аполлов Юрий Андреевич on 25.12.2022.
// Copyright (c) 2022 Аполлов Юрий Андреевич. All rights reserved.
//

import UIKit

@IBDesignable class PaywallBuyAreaWrapper : CDDANibWrapperView<PaywallBuyArea> { }

public class PaywallBuyArea: UIView {
    @IBOutlet public var priceLabel: UILabel!
    @IBOutlet public var buyButton: UIButton!
}
