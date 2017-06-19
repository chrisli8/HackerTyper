//
//  HackingViewController.swift
//  HackerTest
//
//  Created by Chris Li on 6/13/17.
//  Copyright © 2017 Chris Li. All rights reserved.
//

import UIKit
import Darwin // for random numbers

class HackingViewController: UIViewController {
    @IBOutlet weak var codeTextView: UITextView!
    @IBOutlet weak var keyboardStack: UIStackView!
    @IBOutlet weak var topRowStack: UIStackView!
    @IBOutlet weak var cursor: UIView!
    
    @IBOutlet var collectionOfButtons: Array<UIButton>?
    
    var data = AppData.shared
    var lineSpaceRemainder = CGFloat(0)
    var lineOverflowCount = 0
    var lineOverflowWidthAdjust = CGFloat(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set view background
        self.view.backgroundColor = UIColor(red:0.15, green:0.16, blue:0.13, alpha:1.0)
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(keyboardTaped))
        self.keyboardStack.addGestureRecognizer(tap)
        
        // Set top row button styles
        for btn in collectionOfButtons! {
            btn.layer.borderWidth = 1
            btn.layer.cornerRadius = 10
            btn.layer.borderColor = UIColor.white.cgColor
            btn.setTitleColor(UIColor.white, for: .normal)
        }
        
        UIView.animate(withDuration: 1, delay: 0, options: .repeat, animations: {() -> Void in
            self.cursor.alpha = 0 }, completion: {(animated: Bool) -> Void in
                self.cursor.alpha = 1
        })
        
        // Position cursor at content end
        updateCursorLocation()
        
    }
    
    override func viewDidLayoutSubviews() {
        moveToCodeBottom(animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        codeTextView.text = data.codeString
        
        // moveToCodeBottom(animated: false) will always get to bottom but jaring
    }
    
    
    // Resets statusBarStyle when view disappear
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Methods
    func getWidth() -> CGSize {
        if data.codeIndex > 0 {
            let next = data.codeLine //get previous string
            // Menlo Regular 12.0
            return (next as NSString).size(attributes: [NSFontAttributeName: UIFont(name: "Menlo", size: 12.0)!])
        } else {
            return ("" as NSString).size(attributes: [NSFontAttributeName: UIFont(name: "Menlo", size: 12.0)!])
        }
    }
    
    // Move cursor to end of editText content
    // TODO: Sometimes, after overflow line done, next line is still adjusted
    func updateCursorLocation() {
        
        let rawWidth = getWidth()
        let txtViewWidth = codeTextView.bounds.size.width
        let usedWidth = getWidth().width.truncatingRemainder(dividingBy: txtViewWidth)
        if lineOverflowCount < Int(rawWidth.width / txtViewWidth) {
            print("lineOverflowCount " + String(Int(txtViewWidth / rawWidth.width)))
            lineOverflowWidthAdjust = lineSpaceRemainder // Works for first
            lineOverflowCount = Int(rawWidth.width / txtViewWidth)
        }
        
        let textWidth = codeTextView.frame.minX + usedWidth + lineOverflowWidthAdjust
        
        let fixedWidth = codeTextView.frame.size.width
        
        var textHeight = codeTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)).height
        // if text height has reached bounds, bind cursor to bottom
        if textHeight > codeTextView.bounds.size.height {
            textHeight = codeTextView.bounds.size.height
        }
        
        // almost perfect tracking for cursor. overflow line trouble
        cursor.frame = CGRect(
            x: textWidth,
            y: textHeight - CGFloat(2), // minus 2 to fit cursor to text
            width: cursor.frame.width,
            height: cursor.frame.height
        )
        
        // Update lineSpaceRemainder
        lineSpaceRemainder = txtViewWidth - rawWidth.width
        // adjust width if overflow line
        if rawWidth.width > txtViewWidth {
            lineSpaceRemainder = getWidth().width.truncatingRemainder(dividingBy: txtViewWidth) - rawWidth.width
        } else {
            lineOverflowWidthAdjust = 0
            lineOverflowCount = 0
        }
        
        // print("Width: " + String(describing: codeTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)).width) + "___ Height: " + String(describing: codeTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)).height))
    }
    
    // Pass in if move should be animated
    func moveToCodeBottom(animated: Bool) {
        
        // Check to see if content size is greater than textview size
        
        //Math to see what the content size is
        let fixedWidth = codeTextView.frame.size.width
        let height = codeTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)).height
        
        //print(String(describing: height) + "___" + String(describing: self.codeTextView.bounds.size.height))
        
        if height > self.codeTextView.bounds.size.height {
            // move content up to line up with bottom of textview
            let bottom = self.codeTextView.contentSize.height - self.codeTextView.bounds.size.height
            self.codeTextView.setContentOffset(CGPoint(x: 0, y: bottom), animated: animated)
        }
    }
    
    // MARK: - Actions
    
    func keyboardTaped() {
        // Tap keys animation
        for btn in collectionOfButtons! {
            let probability = arc4random_uniform(5) // 5 random numbers start 0
            if probability > 3 {
                UIView.animate(withDuration: 0.2, animations:{
                    btn.frame = CGRect(x: btn.frame.origin.x + 1, y: btn.frame.origin.y + 1, width: btn.frame.size.width, height: btn.frame.size.height)
                    btn.layer.backgroundColor = UIColor.white.cgColor
                }, completion: { (value: Bool) in
                    btn.frame = CGRect(x: btn.frame.origin.x - 1, y: btn.frame.origin.y - 1, width: btn.frame.size.width, height: btn.frame.size.height)
                    btn.layer.backgroundColor = UIColor.clear.cgColor
                })
            }
        }
        
        var next = ""
        if data.codeIndex < data.code.count {
            
            if data.codeElements[data.codeIndex] == "" {
                next = "\n"
                data.codeLine = ""
            } else {
                next = data.codeElements[data.codeIndex] + " "
                data.codeLine += data.codeElements[data.codeIndex] + " "
            }
            codeTextView.text = codeTextView.text +
                next
            data.codeString += next
            data.codeIndex += 1
        }
        if data.hackStrength < 500 {
            data.hackStrength = data.hackStrength + 1
        }
        
//        print(data.codeLine)
//        print(data.hackStrength)
        moveToCodeBottom(animated: true)
        updateCursorLocation()
    }
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        performSegue(withIdentifier: "hackToStat", sender: nil)
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
