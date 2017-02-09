//
//  NoteDetailViewController.swift
//  Nyatet
//
//  Created by Muhammad Aunorafiq Musa on 2/7/17.
//  Copyright © 2017 Muhammad Aunorafiq Musa. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary

class NoteDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var noteId: Int?
    
    var noteInfo: NoteInfo?
    
    var photoUrl: URL?
    
    //MARK: Properties
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var photoImageView: UIImageView!
    
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
    
    func setValuesToViews() {
        print(noteInfo!)
        titleTextField.text = noteInfo?.title
        contentTextView.text = noteInfo?.content
        
        if let localPath = noteInfo?.imagePath {
            print("Local path " + localPath)
            
            if let nsUrl = URL(string: localPath),
                let result = PHAsset.fetchAssets(withALAssetURLs: [nsUrl], options: nil).firstObject {
                
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                
                option.isSynchronous = true
                manager.requestImage(for: result, targetSize: CGSize(width: 240, height: 240), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                    self.photoImageView.image = result!
                })
            }
        }
    }

    //MARK: Action
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        titleTextField.resignFirstResponder()
        contentTextView.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()

        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func didTapSave(_ sender: Any) {
        let title = titleTextField.text == "" ? "Untitled" : titleTextField.text
        let content = contentTextView.text
        
        if let id = noteId {
            DBManager.shared.updateNote(id: id, title: title!, content: content!, imagePath: photoUrl?.absoluteString ?? "")
        } else {
            DBManager.shared.insertNewNote(title: title!, content: content!, imagePath: photoUrl?.absoluteString ?? "")
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        photoUrl = info[UIImagePickerControllerReferenceURL] as? URL

        photoImageView.contentMode = UIViewContentMode.scaleToFill
        
        photoImageView.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
