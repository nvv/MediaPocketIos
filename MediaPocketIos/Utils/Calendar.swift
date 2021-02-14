//
//  Calendar.swift
//  MediaPocketIos
//
//  Created by Vlad Namashko on 17.01.2021.
//

import Foundation

extension Calendar {

    private var currentDate: Date { return Date() }
    
    func isDateInThisMonth(_ date: Date) -> Bool {
      return isDate(date, equalTo: currentDate, toGranularity: .month)
    }
    
}
