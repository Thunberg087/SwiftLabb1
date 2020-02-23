//
//  FavoritesViewController.swift
//  SwiftLabb1
//
//  Created by Jonathan Thunberg on 2020-02-21.
//  Copyright © 2020 Jonathan Thunberg. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var favoritesLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       
        
        
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        
        favoritesLabel.text = ""
        
        let defaults = UserDefaults.standard
        let favArray = defaults.stringArray(forKey: "favoriteCities") ?? [String]()
        
        for city in favArray {
            favoritesLabel.text! += "\(city) +"
        }
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
