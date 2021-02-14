//
//  OffsetPreferenceKey.swift
//  MediaPocketIos
//
//  Created by Vlad Namashko on 12.01.2021.
//

import Foundation
import SwiftUI

struct OffsetPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = .zero
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
