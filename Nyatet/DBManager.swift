//
//  DBManager.swift
//  Nyatet
//
//  Created by Muhammad Aunorafiq Musa on 2/8/17.
//  Copyright © 2017 Muhammad Aunorafiq Musa. All rights reserved.
//

import UIKit

class DBManager: NSObject {
    
    let field_NoteID = "noteID"
    let field_NoteTitle = "title"
    let field_NoteContent = "content"
    let table_name = "notes"

    let databaseFileName = "database.sqlite"
    
    var pathToDatabase: String!
    
    var database: FMDatabase!
    
    static let shared: DBManager = DBManager()
    
    override init() {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
    }
    
    func createDatabase() -> Bool {
        var created = false
        
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                // Open the database.
                if database.open() {
                    let createMoviesTableQuery = "create table notes (\(field_NoteID) integer primary key autoincrement not null, \(field_NoteTitle) text not null, \(field_NoteContent) text not null)"
                    
                    print(createMoviesTableQuery)
                    
                    do {
                        try database.executeUpdate(createMoviesTableQuery, values: nil)
                        created = true
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
                    
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        
        return created
    }
    
    func loadNotes() -> [NoteInfo]? {
        var notes: [NoteInfo]?
        
        if openDatabase() {
            let query = "select * from notes order by \(field_NoteID) asc"
            print(query)
            
            do {
                print(database)
                let results = try database.executeQuery(query, values: nil)
                
                while results.next() {
                    let movie = NoteInfo(noteID: Int(results.int(forColumn: field_NoteID)),
                                         title: results.string(forColumn: field_NoteTitle),
                                         content: results.string(forColumn: field_NoteContent)
                    )
                    
                    if notes == nil {
                        notes = [NoteInfo]()
                    }
                    
                    notes?.append(movie)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return notes
    }
    
    func loadNotes(withId id: Int, completionHandler: (_ noteInfo: NoteInfo?) -> Void) {
        var noteInfo: NoteInfo!
        
        if openDatabase() {
            let query = "select * from notes where \(field_NoteID)=?"
            
            do {
                let results = try database.executeQuery(query, values: [id])
                
                if results.next() {
                    noteInfo = NoteInfo(noteID: Int(results.int(forColumn: field_NoteID)),
                                          title: results.string(forColumn: field_NoteTitle),
                                          content: results.string(forColumn: field_NoteContent)
                    )
                    
                }
                else {
                    print(database.lastError())
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        completionHandler(noteInfo)
    }
    
    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        
        return false
    }
    
    func insertNewNote(title: String, content: String) {
        if openDatabase() {
            let query = "insert into notes (\(field_NoteID), \(field_NoteTitle), \(field_NoteContent)) values (null, '\(title)', '\(content)');"
            print(query)
            
            if !database.executeStatements(query) {
                print("Failed to insert data into the database.")
                print(database.lastError(), database.lastErrorMessage())
            }
        }
    }
    
    func updateNote(id: Int, title: String, content: String) {
        if openDatabase() {
            let query = "update notes set \(field_NoteTitle) = '\(title)', \(field_NoteContent) = '\(content)' where \(field_NoteID) = \(id)"
            
            if !database.executeStatements(query) {
                print("Failed to update data into the database.")
                print(database.lastError(), database.lastErrorMessage())
            }
        }
    }
}
