//
//  CommitLogic.swift
//  raku
//
//  Created by Anish Agrawal on 12/24/24.
//

import SwiftData
import Foundation
import WidgetKit

struct CommitLogic {
    
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func toggleTodayCommit(project: Project) {
        let today = Date().startOfDay
        let todayRakuDate = RakuDate(date: today)
        var todayCommit = project.commits.first(where: { $0.date == todayRakuDate })
        
        // Create an empty commit for today if none exists
        if todayCommit == nil {
            todayCommit = Commit(date: today, intensity: 0, project: project)
            self.modelContext.insert(todayCommit!)
        }
        
        if let commit = todayCommit {
            commit.intensity = commit.intensity == 0 ? 1 : 0
        }
        
        try? self.modelContext.save()
    }
    
    func loadTodayCommit(project: Project) -> Commit {
        let today = Date().startOfDay
        let todayRakuDate = RakuDate(date: today)
        var todayCommit = project.commits.first(where: { $0.date == todayRakuDate })
        
        // Create an empty commit for today if none exists
        if todayCommit == nil {
            todayCommit = Commit(date: today, intensity: 0, project: project)
            self.modelContext.insert(todayCommit!)
            try? self.modelContext.save()
            return todayCommit!
        }
        
        return todayCommit!
    }
    
    func toggleCommit(commit: Commit?) -> Int {
        if let commit = commit {
            commit.intensity = commit.intensity == 0 ? 1 : 0
            try? self.modelContext.save()
            
            return commit.intensity
        }
        return 0
    }
}

