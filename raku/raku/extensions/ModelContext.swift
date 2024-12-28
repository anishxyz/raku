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
        WidgetCenter.shared.reloadAllTimelines()
        try? self.save()
    }
}
