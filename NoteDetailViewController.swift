//
//  NoteDetailViewController.swift
//  Nyatet
//
//  Created by Muhammad Aunorafiq Musa on 2/7/17.
//  Copyright © 2017 Muhammad Aunorafiq Musa. All rights reserved.
//

import UIKit

class NoteDetailViewController: UIViewController {
    
    var note: Note!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleTextField.text = note.title
        contentTextView.text = note.content
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        note.title = titleTextField.text ?? "Note"
        note.content = contentTextView.text
    }

}
