//
//  ReportSaver.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 7/17/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit

enum ReportStatus {
    case wasNotPresent, wentFromNoToYes, wentFromYesToNo, wasAlreadyPresent
}

struct ReportSaver {
    
    static var shared = ReportSaver()
    
    private init() { }
    
    // returns true if contained in yes array, false if in no array, and nil if not in either
    func currentReportFor(id: String) -> Bool? {
        guard let yesReports = UserDefaults.standard.array(forKey: "YesReports") as? [String], let noReports = UserDefaults.standard.array(forKey: "NoReports") as? [String]  else {
            UserDefaults.standard.set([], forKey: "YesReports")
            UserDefaults.standard.set([], forKey: "NoReports")
            return nil
        }
        if yesReports.contains(id) {
            return true
        } else if noReports.contains(id) {
            return false
        }
        return nil
    }
    
    // returns true if the object was saved/updated. false if the object already has that rating
    func saveIfNeeded(id: String, isFound: Bool) -> ReportStatus {
        guard var yesReports = UserDefaults.standard.array(forKey: "YesReports") as? [String], var noReports = UserDefaults.standard.array(forKey: "NoReports") as? [String]  else {
            if isFound {
                UserDefaults.standard.set([id], forKey: "YesReports")
                UserDefaults.standard.set([], forKey: "NoReports")
            } else {
                UserDefaults.standard.set([], forKey: "YesReports")
                UserDefaults.standard.set([id], forKey: "NoReports")
            }
            return .wasNotPresent
        }
        if isFound && !yesReports.contains(id) {
            yesReports.append(id)
            let noReportsFiltered = noReports.filter({ (str) -> Bool in
                return str != id
            })
            UserDefaults.standard.set(yesReports, forKey: "YesReports")
            if noReports.count != noReportsFiltered.count {
                noReports = noReportsFiltered
                UserDefaults.standard.set(noReports, forKey: "NoReports")
                return .wentFromNoToYes
            }
            return .wasNotPresent
        } else if !isFound && !noReports.contains(id) {
            noReports.append(id)
            let yesReportsFiltered = yesReports.filter({ (str) -> Bool in
                return str != id
            })
            UserDefaults.standard.set(noReports, forKey: "NoReports")
            if yesReports.count != yesReportsFiltered.count {
                yesReports = yesReportsFiltered
                UserDefaults.standard.set(yesReports, forKey: "YesReports")
                return .wentFromYesToNo
            }
            return .wasNotPresent
        }
        return .wasAlreadyPresent
    }
}
