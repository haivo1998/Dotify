//
//  Constants.swift
//  Dotify
//
//  Created by An Nguyen Thanh on 7/11/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import Foundation

class Constants {
    // MARK: List of Constants
    static let DEFAULT_DARK_COLOR = "#262626"
    static let DEFAULT_COLOR = "#E55F2C"
    static let CLOUDS_COLOR = "#F2F2F2"
    static let AVENIR_NEXT_FONT = "Avenir Next"
    static let ORANGE_COLOR = "#E35F35"
}

//Date converter
func convertDateToStr(_ date: Date, dateFormat: String = "MM/dd/yyyy HH:mm:ss") -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormat
    return formatter.string(from: date)
}

func convertStrToDate(_ str: String, dateFormat: String = "MM/dd/yyyy HH:mm:ss") -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormat
    return formatter.date(from: str)
}
