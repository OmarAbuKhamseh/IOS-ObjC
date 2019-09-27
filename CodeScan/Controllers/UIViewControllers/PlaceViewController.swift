//
//  PlaceViewController.swift


import UIKit

class PlaceViewController: UIViewController
{

    @IBOutlet weak var lbl_place: UILabel!
    @IBOutlet weak var imgPlace: UIImageView!
    let prefs:UserDefaults = UserDefaults.standard

    override func viewDidLoad()
    {
        super.viewDidLoad()
        let isFrom:String! = prefs.value(forKey: "isFromUSA") as? String
        if isFrom == "1"
        {
            print("chnage image")
            imgPlace.image = UIImage(named: "usa_place");
            lbl_place.text = "PLACE YOUR DRIVING LICENCE LIKE THIS"
            
        }
        else
        {
            imgPlace.image = UIImage(named: "place_qr");
            lbl_place.text = "PLACE YOUR BARCODE LIKE THIS"


        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    

}
