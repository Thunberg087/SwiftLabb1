//
//  ViewControllerCityInfo.swift
//  SwiftLabb1
//
//  Created by Jonathan Thunberg on 2020-02-20.
//  Copyright © 2020 Jonathan Thunberg. All rights reserved.
//

import UIKit

class ViewControllerCityInfo: UIViewController {

    var city : String?
    var weatherStatus : String?
    var temp : Int?
    
    var animator: UIDynamicAnimator!
    var gravityBehavior: UIGravityBehavior!
    
    @IBOutlet weak var CityNameTitle: UILabel!
    @IBOutlet weak var clothesLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherStatusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let title = CityNameTitle
        
        
    
        tempLabel.text = "\(temp!) °C"
        weatherStatusLabel.text = weatherStatus
        
        guard let temp = temp else { print("Det här va inte bra"); return}
        
    
            switch temp {
                case -20...0:
                    clothesLabel.text = "Gå fan inte ut."
                case 4...13:
                    clothesLabel.text = "Vanligt svenskt väder du vet vad du ska ha."
                case 14...20:
                    clothesLabel.text = "Börjar bli lite nice nu, behöver inte vinter kläder."
                case 21...30:
                    clothesLabel.text = "Nu är det riktigt gött, behöver inte ens jacka."
                default:
                    clothesLabel.text = "nu vet jag inte"
            }
        
        
        switch weatherStatus {
            case "Rain":
                clothesLabel.text = "\(clothesLabel.text!) Ta med ett paraply"
            case "Clouds":
                clothesLabel.text = "\(clothesLabel.text!) Molnigt behövs inget speciellt"
            case "Haze":
                clothesLabel.text = "\(clothesLabel.text!) Glöm inte glasögonen"
            case "Clear":
                    if (temp > 17) {
                        clothesLabel.text = "\(clothesLabel.text!) Solkräm kan behövas"
                    }
            default:
                clothesLabel.text = "\(clothesLabel.text!) vet ej"
        }
            
            
            
            
        animator = UIDynamicAnimator(referenceView: view)
        gravityBehavior = UIGravityBehavior(items: [title!])
        animator.addBehavior(gravityBehavior)
        
        
        title!.text = self.city
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func saveAsFavorite(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        var tempArray = defaults.stringArray(forKey: "favoriteCities") ?? [String]()
        
        tempArray.append(self.city!)
        
        defaults.set(tempArray, forKey: "favoriteCities")
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
