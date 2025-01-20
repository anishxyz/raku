//
//  ProjectStatsView.swift
//  raku
//
//  Created by Anish Agrawal on 1/20/25.
//

import SwiftUI

struct ProgressSection: Identifiable {
    let id = UUID()
    var percentage: CGFloat  // Changed from width to percentage
    var color: Color
}

struct ProjectProgressBar: View {
    var sections: [ProgressSection]
    var height: CGFloat = 16
    
    var body: some View {
        GeometryReader { geometry in  // Add GeometryReader to get available width
            HStack(spacing: 0) {
                ForEach(sections) { section in
                    Rectangle()
                        .fill(section.color)
                        .frame(width: geometry.size.width * section.percentage, height: height)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: height / 2))
        }
        .frame(height: height)  // Set fixed height while allowing flexible width
    }
}

struct ProjectStatsView: View {
    var project: Project
    @State private var timeRange: TimeRange = .week
    
    enum TimeRange: Identifiable {
        var id: String {
            switch self {
            case .week: return "week"
            case .month: return "month"
            case .year: return "year"
            }
        }
        case week, month, year
        
        var title: String {
            switch self {
            case .week: return "This Week"
            case .month: return "This Month"
            case .year: return "This Year"
            }
        }
        
        func dateRange() -> (Date, Date) {
            let calendar = Calendar.current
            let now = Date()
            
            switch self {
            case .week:
                let sunday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
                return (sunday, calendar.date(byAdding: .day, value: 7, to: sunday)!)
            case .month:
                let components = calendar.dateComponents([.year, .month], from: now)
                let startOfMonth = calendar.date(from: components)!
                return (startOfMonth, calendar.date(byAdding: .month, value: 1, to: startOfMonth)!)
            case .year:
                let components = calendar.dateComponents([.year], from: now)
                let startOfYear = calendar.date(from: components)!
                return (startOfYear, calendar.date(byAdding: .year, value: 1, to: startOfYear)!)
            }
        }
    }
    
    func calculateProgress(for range: TimeRange) -> (missed: Int, completed: Int, future: Int) {
        let (startDate, endDate) = range.dateRange()
        let calendar = Calendar.current
        let now = Date()
        
        // Create commit cache
        let commitCache: [RakuDate: Commit] = project.commits
            .filter { $0.date >= RakuDate(date: startDate) && $0.date <= RakuDate(date: endDate) }
            .reduce(into: [:]) { result, commit in
                result[commit.date] = commit
            }
        
        var missed = 0
        var completed = 0
        var future = 0
        
        var currentDate = startDate
        while currentDate < endDate {
            let rakuDate = RakuDate(date: currentDate)
            
            if currentDate > now {
                future += 1
            } else if let commit = commitCache[rakuDate] {
                if commit.intensity > 0 {
                    completed += 1
                } else {
                    missed += 1
                }
            } else {
                missed += 1
            }
            
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return (missed, completed, future)
    }
    
    func progressSections(for range: TimeRange) -> [ProgressSection] {
        let (missed, completed, future) = calculateProgress(for: range)
        let total = CGFloat(missed + completed + future)
        
        return [
            ProgressSection(percentage: CGFloat(missed) / total, color: RakuColors.ferrariRed),
            ProgressSection(percentage: CGFloat(completed) / total, color: RakuColors.githubGreen),
            ProgressSection(percentage: CGFloat(future) / total, color: RakuColors.tertiaryBackground)
        ]
    }
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach([TimeRange.week, .month, .year]) { range in
                VStack(alignment: .leading, spacing: 8) {
                    Text(range.title)
                        .font(.headline)
                    
                    ProjectProgressBar(sections: progressSections(for: range))
                    
                    let progress = calculateProgress(for: range)
                    HStack {
                        Text("\(progress.missed) missed")
                            .foregroundColor(.red)
                        Text("\(progress.completed) completed")
                            .foregroundColor(.green)
                        Text("\(progress.future) upcoming")
                            .foregroundColor(.gray)
                    }
                    .font(.caption)
                }
            }
        }
        .padding(.vertical)
    }
}
