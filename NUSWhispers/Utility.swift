//
//  Utility.swift
//  NUSWhispers
//
//  Created by jin on 12/5/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import Foundation

func convertUTCToLocalDateString(date: NSDate) -> String {
    let timeOffset: NSTimeInterval = Double(NSTimeZone.localTimeZone().secondsFromGMT)
    let localDate = date.dateByAddingTimeInterval(timeOffset)
    return convertDateToString(localDate)
}

func convertDateToString(date: NSDate) -> String {
    let relativeDateFormatter = NSDateFormatter()
    relativeDateFormatter.doesRelativeDateFormatting = true
    relativeDateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
    relativeDateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
    return relativeDateFormatter.stringFromDate(date)
}