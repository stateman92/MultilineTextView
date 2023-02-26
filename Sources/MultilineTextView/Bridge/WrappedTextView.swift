//
//  WrappedTextView.swift
//  
//
//  Created by Kristof Kalai on 2022. 11. 25..
//

import SwiftUI

struct WrappedTextView {
    @Binding var text: String
    @Binding var calculatedHeight: CGFloat?
    @Binding var calculatedWidth: CGFloat?
    @Binding var textViewProperties: TextViewProperties?
    let maxWidth: CGFloat
}

extension WrappedTextView: UIViewRepresentable {
    func makeUIView(context: Context) -> UITextView {
        let view = NonSelectableTextView()
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        view.isUserInteractionEnabled = true
        view.isEditable = false
        // view.isSelectable = false // do not add this, that would break the links
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.automaticallyAdjustsScrollIndicatorInsets = false
        view.textContainer.lineFragmentPadding = .zero
        view.textContainerInset = .zero
        view.textContainer.lineBreakMode = .byWordWrapping
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        view.setup(with: textViewProperties)
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.setup(with: textViewProperties)

        let newSize = uiView.sizeThatFits(CGSize(width: maxWidth, height: .greatestFiniteMagnitude))
        if calculatedHeight != newSize.height {
            DispatchQueue.main.async {
                calculatedHeight = newSize.height
                calculatedWidth = newSize.width
            }
        }
    }
}
