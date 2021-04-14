//
//  Date+Extension.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 14/04/2021.
//

import Foundation

extension Date {
    var localizedStringOfDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM, dd, yyyy"
        return dateFormatter.string(from: self)
    }
}
