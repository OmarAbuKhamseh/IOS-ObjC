//
//  MainV.swift

import UIKit

class MainV: UIView {

    var codeInfoV: CodeInfoV?
    
    func showCodeInfoV(text: String) {
        
        let screenSize: CGRect = UIScreen.main.bounds

        codeInfoV = CodeInfoV.nib()
        codeInfoV!.frame = CGRect(x: 0, y: 0, width: screenSize.size.width - 40, height: screenSize.size.height/2)
        codeInfoV!.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        codeInfoV!.codeLbl.text = text
        addSubview(codeInfoV!)
    }
    
    func removeAlert() {
        
        if codeInfoV != nil {
            codeInfoV!.removeFromSuperview()
            codeInfoV = nil
        }
    }
    
}
