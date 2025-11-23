//
//  Bundle+Extension.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/27/25.
//

import Foundation

extension Bundle {
    var appVersion: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    var buildNumber: String {
        infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    var appVersionWithBuild: String {
        "\(appVersion) (\(buildNumber))"
    }
}
