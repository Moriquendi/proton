//
//  ListCommand.swift
//  Proton
//
//  Created by Rajdeep Kwatra on 28/5/20.
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
import UIKit

public enum Indentation {
    case indent
    case outdent
}

public struct LineFormatting {
    public let indentation: CGFloat
    public let spacingBefore: CGFloat

    public init(indentation: CGFloat, spacingBefore: CGFloat) {
        self.indentation = indentation
        self.spacingBefore = spacingBefore
    }
}

public class ListCommand: EditorCommand {
    public init() { }

    public var name: CommandName {
        return CommandName("listCommand")
    }

    public var attributeValue: Any?

    public func execute(on editor: EditorView) {
        var selectedRange = editor.selectedRange
        // Adjust to span entire line range if the selection starts in the middle of the line
        if let currentLine = editor.contentLinesInRange(NSRange(location: selectedRange.location, length: 0)).first {
            let location = currentLine.range.location
            var length = max(currentLine.range.length, selectedRange.length + (selectedRange.location - currentLine.range.location))
            let range = NSRange(location: location, length: length)
            if editor.contentLength > range.endLocation,
                editor.attributedText.attributedSubstring(from: NSRange(location: range.endLocation, length: 1)).string == "\n" {
                length += 1
            }
            selectedRange = NSRange(location: location, length: length)
        }

        guard selectedRange.length > 0 else {
            ListIndentCommand(indentMode: .indent, editedRange: selectedRange, attributeValue: attributeValue)
                    .execute(on: editor)
            return
        }

        guard let attrValue = attributeValue else {
            let paragraphStyle = editor.paragraphStyle
            editor.addAttributes([
                .paragraphStyle: paragraphStyle
            ], at: selectedRange)
            editor.removeAttribute(.listItem, at: selectedRange)
            return
        }

        // Fix the list attribute on the trailing `\n` in previous line, if previous line has a listItem attribute applied
        if let previousLine = editor.previousContentLine(from: selectedRange.location),
            let listValue = editor.attributedText.attribute(.listItem, at: previousLine.range.endLocation - 1, effectiveRange: nil),
            editor.attributedText.attribute(.listItem, at: previousLine.range.endLocation, effectiveRange: nil) == nil {
            editor.addAttribute(.listItem, value: listValue, at: NSRange(location: previousLine.range.endLocation, length: 1))
        }

        editor.attributedText.enumerateAttribute(.paragraphStyle, in: selectedRange, options: []) { (value, range, _) in
            let paraStyle = value as? NSParagraphStyle
            let mutableStyle = ListTextProcessor.updatedParagraphStyle(paraStyle: paraStyle, listLineFormatting: editor.listLineFormatting, indentMode: .indent)
            editor.addAttribute(.paragraphStyle, value: mutableStyle ?? editor.paragraphStyle, at: range)
        }
        editor.addAttribute(.listItem, value: attrValue, at: selectedRange)
        attributeValue = nil
    }

    public func execute(on editor: EditorView, attributeValue: Any?) {
        self.attributeValue = attributeValue
        execute(on: editor)
    }
}
