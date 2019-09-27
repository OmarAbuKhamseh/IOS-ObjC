//
//  BarcodeTypeHFV.swift

import UIKit

class BarcodeTypeHFV: UITableViewHeaderFooterView {

    @IBOutlet weak var barcodeHeaderView: UIView!
    
    class func nib() -> BarcodeTypeHFV {
        return UINib(nibName: "BarcodeTypeHFV", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! BarcodeTypeHFV
    }

}
