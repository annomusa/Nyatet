//
//  NoteDetailViewController.swift
//  Nyatet
//
//  Created by Muhammad Aunorafiq Musa on 2/7/17.
//  Copyright © 2017 Muhammad Aunorafiq Musa. All rights reserved.
//

import UIKit

class NoteDetailViewController: UIViewController {
    
    var noteId: Int?
    
    var noteInfo: NoteInfo?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let id = noteId {
            DBManager.shared.loadNotes(withId: id, completionHandler: { (note) in
                DispatchQueue.main.async {
                    if note != nil {
                        self.noteInfo = note
                        self.setValuesToViews()
                    }
                }
            });
        }
    }
    
    @IBAction func didTapSave(_ sender: Any) {
        let title = titleTextField.text == "" ? "Untitled" : titleTextField.text
        let content = contentTextView.text
        
        if let id = noteId {
            DBManager.shared.updateNote(id: id, title: title!, content: content!)
        } else {
            DBManager.shared.insertNewNote(title: title!, content: content!)
        }
    }
    
    func setValuesToViews() {
        titleTextField.text = noteInfo?.title
        contentTextView.text = noteInfo?.content
    }
}
