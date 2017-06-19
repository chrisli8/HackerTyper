//
//  StatViewController.swift
//  HackerTest
//
//  Created by Chris Li on 6/13/17.
//  Copyright © 2017 Chris Li. All rights reserved.
//

import UIKit

class StatViewController: UIViewController {
    @IBOutlet weak var hackStrength1: UIProgressView!
    @IBOutlet weak var hackStrength2: UIProgressView!
    @IBOutlet weak var hackStrength3: UIProgressView!
    @IBOutlet weak var hackStrength4: UIProgressView!
    @IBOutlet weak var hackStrength5: UIProgressView!
    
    var hackStrengthArry: [UIProgressView] = []
    
    var data = AppData.shared


    override func viewDidLoad() {
        super.viewDidLoad()

        // set view background
        self.view.backgroundColor = UIColor(red:0.15, green:0.16, blue:0.13, alpha:1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hackStrengthArry.append(hackStrength1)
        hackStrengthArry.append(hackStrength2)
        hackStrengthArry.append(hackStrength3)
        hackStrengthArry.append(hackStrength4)
        hackStrengthArry.append(hackStrength5)
        
        for bar in hackStrengthArry {
            bar.setProgress(0.0, animated: false)
        }
        
        updateHackStrength()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Methods
    
    func updateHackStrength() {
        let max = data.hackStrength / 100
        let overflow = data.hackStrength % 100
        for index in 0..<max {
            hackStrengthArry[index].setProgress(1.0, animated: false)
        }
        if max < 5 {
            hackStrengthArry[max].setProgress(Float(Double(overflow) / 100.0), animated: false)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        performSegue(withIdentifier: "statToHack", sender: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
