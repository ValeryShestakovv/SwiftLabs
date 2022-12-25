//
//  String + Localize .swift
//  MarvelApp
//
//  Created by Jarvis on 25.12.2022.
//

import Foundation

extension String {
    func localize() -> String {
        NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
