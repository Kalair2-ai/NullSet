//
//  Convert.swift
//  LocalizationTest
//
//  Created by Sunil AS on 09/08/25.
//

import Foundation
import CoreXLSX

func convertXLSXToStrings(filePath: String, outputDir: String) throws {
    let file = XLSXFile(filepath: filePath)!
    guard let sharedStrings = try file.parseSharedStrings() else {
        return
    }
    let paths = try file.parseWorksheetPaths()
    
    // Assuming the first sheet contains translations
    let ws = try file.parseWorksheet(at: paths[0])
    
    var translationsByLang: [String: [String]] = [:]
    var headers: [String] = []
    
    for (rowIndex, row) in ws.data?.rows.enumerated() ?? [].enumerated() {
        var cells = row.cells.map { $0.stringValue(sharedStrings) ?? "" }
        
        if rowIndex == 0 {
            headers = cells // ["key", "en", "fr", "de"]
            for lang in headers.dropFirst() {
                translationsByLang[lang] = []
            }
            continue
        }
        
        let key = cells[0]
        for (index, lang) in headers.dropFirst().enumerated() {
            let value = index + 1 >= cells.count ? "" : cells[index + 1]
            translationsByLang[lang]?.append("\"\(key)\" = \"\(value)\";\n")
        }
    }
    
    for (lang, lines) in translationsByLang {
        let dirPath = "\(outputDir)/\(lang).lproj"
        try FileManager.default.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
        let filePath = "\(dirPath)/Localizable.strings"
        try lines.joined().write(toFile: filePath, atomically: true, encoding: .utf8)
    }
    
    print("✅ Localizable.strings generated in \(outputDir)")
}
