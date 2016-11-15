//
//  FileChangeViewController.swift
//  CodeReader
//
//  Created by vulgur on 2016/11/15.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit

class FileChangeViewController: UIViewController {

    
    @IBOutlet var textView: UITextView!
    
    var patchString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let patchString = self.patchString {
            self.textView.text = patchString
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
