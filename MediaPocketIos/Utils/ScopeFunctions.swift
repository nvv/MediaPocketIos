//
//  ScopeFunctions.swift
//  MediaPocketIos
//
//  Created by Vlad Namashko on 17.01.2021.
//

import Foundation

@discardableResult func apply<T>(_ it:T, f:(T)->()) -> T {
    f(it)
    return it
}
