//
//  BackgroundStyle.swift
//  Proton
//
//  Created by Rajdeep Kwatra on 11/5/20.
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
#if os(iOS)
import UIKit
#else
import AppKit
#endif

/// Shadow style for `backgroundStyle` attribute
public class ShadowStyle {

    /// Color of the shadow
    public let color: PlatformColor

    /// Shadow offset
    public let offset: CGSize

    /// Shadow blur
    public let blur: CGFloat

    public init(color: PlatformColor, offset: CGSize, blur: CGFloat) {
        self.color = color
        self.offset = offset
        self.blur = blur
    }
}

/// Border style for `backgroundStyle` attribute
public class BorderStyle {

    /// Color of border
    public let color: PlatformColor

    /// Width of the border
    public let lineWidth: CGFloat

    public init(lineWidth: CGFloat, color: PlatformColor) {
        self.lineWidth = lineWidth
        self.color = color
    }
}

/// Style for background color attribute. Adding `backgroundStyle` attribute will add border, background and shadow
/// as per the styles specified.
/// - Important:
/// This attribute is separate from `backgroundColor` attribute. Applying `backgroundColor` takes precedence over backgroundStyle`
/// i.e. the background color shows over color of `backgroundStyle` and will not show rounded corners.
/// - Note:
/// Ideally `backgroundStyle` may be used instead of `backgroundColor` as it can mimic standard background color as well as
/// border, shadow and rounded corners.
public class BackgroundStyle {

    /// Background color
    public let color: PlatformColor

    /// Corner radius of the background
    public let cornerRadius: CGFloat

    /// Optional border style for the background
    public let border: BorderStyle?

    /// Optional shadow style for the background
    public let shadow: ShadowStyle?

    public init(color: PlatformColor, cornerRadius: CGFloat = 0, border: BorderStyle? = nil, shadow: ShadowStyle? = nil) {
        self.color = color
        self.cornerRadius = cornerRadius
        self.border = border
        self.shadow = shadow
    }
}
