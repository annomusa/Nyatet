//
//  NotesListTableViewController.swift
//  Nyatet
//
//  Created by Muhammad Aunorafiq Musa on 2/7/17.
//  Copyright © 2017 Muhammad Aunorafiq Musa. All rights reserved.
//

import UIKit

class NotesListTableViewController: UITableViewController {
    
    var notes: [Note] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath)

        cell.textLabel!.text = notes[indexPath.row].title

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "showNote"{
            let noteDetailViewController = segue.destination as! NoteDetailViewController
            var selectedIndexPath = tableView.indexPathForSelectedRow
            noteDetailViewController.note = notes[selectedIndexPath!.row]
        }
        else if segue.identifier! == "addNote" {
            let note = Note()
            notes.append(note)
            let noteDetailViewController = segue.destination as! NoteDetailViewController
            noteDetailViewController.note = note
        }
    }

}
