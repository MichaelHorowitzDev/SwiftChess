//
//  Chess_SwiftUIApp.swift
//  Chess SwiftUI
//
//  Created by Michael Horowitz on 5/6/21.
//

import SwiftUI
import SwiftChess
@main
struct Chess_SwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            ChessBoard(lightColor: Color(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)), darkColor: Color(#colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)), game: Game())
        }
    }
}
