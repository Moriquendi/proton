//
//  FontTraitToggleCommand.swift
//  Proton
//
//  Created by Rajdeep Kwatra on 8/1/20.
//  Copyright © 2020 Rajdeep Kwatra. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

/// Editor command that toggles given font trait to the selected range in the Editor.
public class FontTraitToggleCommand: EditorCommand {
    public let trait: FontDescriptor.SymbolicTraits

    public let name: CommandName

    public init(name: CommandName, trait: FontDescriptor.SymbolicTraits) {
        self.name = name
        self.trait = trait
    }

    public func execute(on editor: EditorView) {
        let selectedText = editor.selectedText
        if editor.isEmpty || editor.selectedRange == .zero || selectedText.length == 0 {
            guard let font = editor.typingAttributes[.font] as? PlatformFont else { return }
            editor.typingAttributes[.font] = font.toggled(trait: trait)
            return
        }

        guard let initFont = selectedText.attribute(.font, at: 0, effectiveRange: nil) as? PlatformFont else {
            return
        }

        editor.attributedText.enumerateAttribute(.font, in: editor.selectedRange, options: .longestEffectiveRangeNotRequired) { font, range, _ in
            if let font = font as? PlatformFont {
                let fontToApply = initFont.contains(trait: trait) ? font.removing(trait: trait) : font.adding(trait: trait)
                editor.addAttribute(.font, value: fontToApply, at: range)
            }
        }
    }
}
