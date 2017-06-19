//
//  AppData.swift
//  HackerTest
//
//  Created by Chris Li on 6/13/17.
//  Copyright © 2017 Chris Li. All rights reserved.
//

import UIKit

class AppData: NSObject {
    static let shared = AppData()
    
    // the code boken up by lenth
    var code: [String] = []
    
    // current element in codeElements
    var codeIndex = 0
    
    // number for how much code is written
    var hackStrength = 0
    
    // the build up string to be recalled for UITextView
    var codeString = ""
    
    // the built up sting for on line
    var codeLine = ""
    
    // Holds code elements split by " "
    var codeElements: [String] = []
    
    override init() {
        super.init()
        loadCodeFile()
    }
    
    // MARK: - Methods
    
    func loadCodeFile() {
        if let filepath = Bundle.main.path(forResource: "Code", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath)
                code = contents.components(separatedBy: "\n")
                for line in code {
                    print(line.components(separatedBy: " "))
                    codeElements.append(contentsOf: line.components(separatedBy: " "))
                    // codeElements.append("\n") // to double space
                }
            } catch {
                // can't load
            }
        } else {
            // File not found
        }
    }
    
}
