//
//  ModelContext.swift
//  raku
//
//  Created by Anish Agrawal on 12/24/24.
//

import SwiftData
import WidgetKit

extension ModelContext {
    func save_and_update() {
        try? self.save()
        WidgetCenter.shared.reloadAllTimelines()
    }
}
