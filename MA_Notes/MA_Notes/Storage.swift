//
//  Storage.swift
//  MA_Notes
//
//  Created by Luis Valle-Arellanes on 4/18/23.
//

import Foundation

struct Note: Codable, Identifiable {
    let id: UUID
    let title: String
    let content: String
    var drawingData: Data?
}


func saveNotes(_ notes: [Note]){
    let notesData = try? JSONEncoder().encode(notes)
    UserDefaults.standard.set(notesData, forKey: "notes")
}

func loadNotes() -> [Note] {
    if let notesData = UserDefaults.standard.data(forKey: "notes"),
       let notes  = try? JSONDecoder().decode([Note].self, from: notesData){
        return notes
    }else{
        return[]
    }
}
