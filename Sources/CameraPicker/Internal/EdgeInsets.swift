//
//  EdgeInsets.swift
//  CameraPicker
//
//  Created by Quentin Fasquel on 12/02/2025.
//

import SwiftUI

extension EdgeInsets {
    var uiEdgeInsets: UIEdgeInsets {
        .init(top: top, left: leading, bottom: bottom, right: trailing)
    }
}
