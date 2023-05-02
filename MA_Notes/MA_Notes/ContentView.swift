import SwiftUI

struct ContentView: View {
    
    @State private var notes = loadNotes()
    @State private var showAlert = false
    @State private var noteToDeleteIndex: Int? = nil
    
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView {
            List {
                ForEach(notes) { note in
                    NavigationLink(destination: NoteEditorView(note: note, onSave: { updatedNote, drawingData, _ in
                        if !updatedNote.title.isEmpty && !updatedNote.content.isEmpty {
                            if let index = notes.firstIndex(where: { $0.id == note.id }) {
                                notes[index] = updatedNote
                            } else {
                                notes.append(updatedNote)
                            }
                            saveNotes(notes)
                        }
                    }, onDelete: {
                        if let index = notes.firstIndex(where: { $0.id == note.id }) {
                            notes.remove(at: index)
                            saveNotes(notes)
                        }
                    })) {
                        VStack(alignment: .leading) {
                            Text(note.title)
                                .font(.headline)
                        }
                    }
                }
                .onDelete { indexSet in
                    noteToDeleteIndex = indexSet.first
                    showAlert = true
                }
            }
            .navigationBarTitle("Notes")
            .navigationBarItems(trailing:
                NavigationLink(destination: NoteEditorView(onSave: { updatedNote, drawingData, _ in
                    if !updatedNote.title.isEmpty && !updatedNote.content.isEmpty {
                        notes.append(updatedNote)
                        saveNotes(notes)
                    }
                })) {
                    Image(systemName: "plus")
                        .imageScale(.large)
                        .accessibilityLabel("New note")
                }
            )
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Delete Note"),
                      message: Text("Are you sure you want to delete this note?"),
                      primaryButton: .destructive(Text("Delete")) {
                        if let index = noteToDeleteIndex {
                            notes.remove(at: index)
                            saveNotes(notes)
                        }
                        noteToDeleteIndex = nil
                      },
                      secondaryButton: .cancel {
                        noteToDeleteIndex = nil
                      })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
