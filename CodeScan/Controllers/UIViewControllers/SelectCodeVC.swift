//
//  SelectCodeVC.swift


import UIKit
import AVFoundation

protocol SelectedTypesDelegate {
    func setSelectedTypes(types: [AVMetadataObject.ObjectType])
}

class SelectCodeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let Types: [AVMetadataObject.ObjectType] = [.ean8, .ean13, .pdf417, .aztec, .code128, .code39, .code39Mod43, .code93, .dataMatrix, .face, .interleaved2of5, .itf14, .qr, .upce]
    var selectedTypes: [AVMetadataObject.ObjectType] = [AVMetadataObject.ObjectType]()
    var selectedTypesDelegate: SelectedTypesDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(BarcodeTypeTVC.nib(), forCellReuseIdentifier: BARCODE_TYPE_TVC)
        
        addBarButton(imageNormal: BACK_WHITE, imageHighlighted: nil, action: #selector(backBtnPressed), side: .west)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let barcodeTypeHFV = BarcodeTypeHFV.nib()
        return barcodeTypeHFV
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Types.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let type = Types[indexPath.row]
        // Load the top-level objects from the custom cell XIB.
        let cell = tableView.dequeueReusableCell(withIdentifier: BARCODE_TYPE_TVC, for: indexPath) as! BarcodeTypeTVC
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        if selectedTypes.contains(type) {
            cell.setSelected(code: type)
        } else {
            cell.setUnselected(code: type)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let type = (tableView.cellForRow(at: indexPath) as! BarcodeTypeTVC).code.rawValue
        
        if let index = selectedTypes.index(where: { $0.rawValue == type }), selectedTypes.contains(AVMetadataObject.ObjectType(rawValue: type)) {
            selectedTypes.remove(at: index)
        } else {
            selectedTypes.append(AVMetadataObject.ObjectType(rawValue: type))
        }
        tableView.reloadData()
    }
    
    @objc func backBtnPressed() {
        
        selectedTypesDelegate.setSelectedTypes(types: selectedTypes)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backAction(_ sender: Any)
    {
        selectedTypesDelegate.setSelectedTypes(types: selectedTypes)
        navigationController?.popViewController(animated: true)
    }
    
}
