import SwiftUI
import PencilKit
import Combine

// Add the Binding extension
extension Binding {
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}

struct NoteEditorView: View {
    @State private var canvasView  =  PKCanvasView()
    @State private var title: String
    @State private var content: String
    @Environment(\.presentationMode) var presentationMode
    @State private var autoSaveTimer: Timer?
    @State private var hasBeenEdited: Bool = false
    @State private var drawingData: Data?

    @State private var prevTitle: String = ""
    @State private var prevContent: String = ""

    @State private var id: UUID // Add this property

    var onSave: (Note, Data?, Bool) -> Void
    var onDelete: (() -> Void)?

    init(note: Note? = nil, onSave: @escaping (Note, Data?, Bool) -> Void, onDelete: (() -> Void)? = nil) {
        _title = State(initialValue: note?.title ?? "")
        _content = State(initialValue: note?.content ?? "")
        _drawingData = State(initialValue: note?.drawingData)
        self.onSave = onSave
        self.onDelete = onDelete
        if let note = note {
            _id = State(initialValue: note.id)
        } else {
            _id = State(initialValue: UUID())
        }
    }

    var body: some View {
        VStack {
            TextField("Note Title", text: $title.onChange {
                hasBeenEdited = true
            })
                .font(.title)
                .padding()

            PencilKitWrapper(canvasView: $canvasView)
                .padding()

            TextEditor(text: $content.onChange {
                hasBeenEdited = true
            })
                .padding()

            Spacer()
        }
        .navigationBarTitle(Text(title.isEmpty ? "New Note" : title), displayMode: .inline)
        .navigationBarItems(leading:
            Group {
                if onDelete != nil {
                    Button(action: {
                        onDelete?()
                    }) {
                        Text("Delete")
                    }
                }
            },
        trailing:
            Button(action: {
            let updatedNote = Note(id: self.id, title: title, content: content, drawingData: canvasView.drawing.dataRepresentation())
                onSave(updatedNote, canvasView.drawing.dataRepresentation(), true)
            }) {
                Text("Save")
            }


        )

        .onAppear {
            if let drawingData = drawingData, let drawing = try? PKDrawing(data: drawingData) {
                canvasView.drawing = drawing
            }
            autoSaveTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                if hasBeenEdited && (title != prevTitle || content != prevContent) {
                    let updatedNote = Note(id: id, title: title, content: content, drawingData: canvasView.drawing.dataRepresentation())
                    onSave(updatedNote, canvasView.drawing.dataRepresentation(), false)
                    prevTitle = title
                    prevContent = content
                }
            }
        }

        .onDisappear {
            autoSaveTimer?.invalidate()
        }
    }
}
