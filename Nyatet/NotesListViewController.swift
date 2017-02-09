//
//  NotesListTableViewController.swift
//  Nyatet
//
//  Created by Muhammad Aunorafiq Musa on 2/7/17.
//  Copyright © 2017 Muhammad Aunorafiq Musa. All rights reserved.
//

import UIKit
import Photos

struct NoteInfo {
    var noteID: Int!
    var title: String!
    var content: String!
    var imagePath: String?
}

class NotesListTableViewController: UITableViewController {
    
    var notes: [NoteInfo]? = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        notes = DBManager.shared.loadNotes()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let selectedItemId = notes?[indexPath.row].noteID
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            if DBManager.shared.deleteNote(id: selectedItemId!) {
                notes?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomCell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath) as! CustomCell
        
        let note: NoteInfo = (notes?[indexPath.row])!
        
        cell.noteLabel.text = note.title
        
        if let localPath = note.imagePath {
            
            if let nsUrl = URL(string: localPath),
                let result = PHAsset.fetchAssets(withALAssetURLs: [nsUrl], options: nil).firstObject {
                
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                
                option.isSynchronous = true
                manager.requestImage(for: result, targetSize: CGSize(width: 240, height: 240), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                    cell.noteImage.image = result!
                })
            }
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "showNote" {
            let noteDetailViewController = segue.destination as! NoteDetailViewController
            noteDetailViewController.noteId = notes?[(tableView.indexPathForSelectedRow?.row)!].noteID
        }
    }
}
