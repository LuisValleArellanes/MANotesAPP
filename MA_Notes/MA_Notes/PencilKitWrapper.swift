//
//  PencilKitWrapper.swift
//  MA_Notes
//
//  Created by Luis Valle-Arellanes on 4/23/23.
//

import SwiftUI
import PencilKit

struct PencilKitWrapper: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 15)
        
        // Set the drawing policy to pencilOnly
        canvasView.drawingPolicy = .pencilOnly

        if let window = UIApplication.shared.windows.first {
            if let toolPicker = PKToolPicker.shared(for: window) {
                toolPicker.setVisible(true, forFirstResponder: canvasView)
                toolPicker.addObserver(canvasView)
                canvasView.becomeFirstResponder()
            }
        }
        
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
    }

    class Coordinator: NSObject, PKToolPickerObserver {
        var parent: PencilKitWrapper

        init(_ parent: PencilKitWrapper) {
            self.parent = parent
        }
    }
}
