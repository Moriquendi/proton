//
//  UIColor+Image.swift
//  Proton
//
//  Created by Rajdeep Kwatra on 4/1/20.
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

extension PlatformColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> PlatformImage {
        #if os(iOS)
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
        #else
        let img = PlatformImage(size: size)
        img.lockFocus()
        
        self.set()
        let rect = NSRect(origin: .zero, size: size)
        rect.fill(using: .sourceAtop)
        img.unlockFocus()
        return img
        #endif
    }
}
