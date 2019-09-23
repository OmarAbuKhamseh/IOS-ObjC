//
//  BarcodeTypeHFV.swift
//  CodeScan
//
//  Created by Stephen Muscarella on 5/27/18.
//  Copyright © 2018 Elite Development LLC. All rights reserved.
//

import UIKit

class BarcodeTypeHFV: UITableViewHeaderFooterView {

    @IBOutlet weak var barcodeHeaderView: UIView!
    
    class func nib() -> BarcodeTypeHFV {
        return UINib(nibName: "BarcodeTypeHFV", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! BarcodeTypeHFV
    }

}
