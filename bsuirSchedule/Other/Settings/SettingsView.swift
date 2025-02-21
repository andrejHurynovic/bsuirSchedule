//
//  SettingsView.swift
//  SettingsView
//
//  Created by Andrej Hurynovič on 29.07.21.
//

import SwiftUI
import CoreData

struct SettingsView: View {
    
    @StateObject var viewModel = SettingsViewModel()
    
    var body: some View {
        Form {
            PrimarySchedulePickerView()
            tintColorPicker
            lessonTypes
            developer
        }
        .navigationTitle("Настройки")
    }
    
    @ViewBuilder var tintColorPicker: some View {
        Section("Основной цвет") {
            ColorPicker("Основной", selection: $viewModel.tintColor)
            RestoreButton {
                viewModel.tintColor = .blue
            }
        }
    }
    
    var lessonTypes: some View {
        NavigationLink {
            LessonTypesView()
        } label: {
            Label("Типы занятий", systemImage: "tray.circle")
                .foregroundColor(.accentColor)
        }
    }
    
    var developer: some View {
        Section("Разработчик") {
            NavigationLink {
                DeveloperView()
            } label: {
                Label("Разработчик", systemImage: "lock.open.laptopcomputer")
                    .foregroundColor(.accentColor)
            }
        }
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
