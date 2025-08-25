//
//  ContentView.swift
//  LocalizationTest
//
//  Created by Sunil AS on 09/08/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            Button("Convert XLSX to Strings") {
                if let path = Bundle.main.path(forResource: "translations", ofType: "xlsx") {
                    let outputDir = FileManager.default.temporaryDirectory.path
                    do {
                        try convertXLSXToStrings(
                            filePath: path,
                            outputDir: outputDir
                        )
                        print("✅ Strings generated at \(outputDir)")
                    } catch {
                        print("❌ Error: \(error)")
                    }
                } else {
                    print("❌ translations.xlsx not found in bundle")
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
