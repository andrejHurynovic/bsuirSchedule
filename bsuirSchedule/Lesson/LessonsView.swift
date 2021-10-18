//
//  TimetableView.swift
//  TimetableView
//
//  Created by Andrej Hurynovič on 29.07.21.
//

import SwiftUI

struct LessonsView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var viewModel = LessonsViewModel()
    
    @State var isShowingReturnButton = false
    
    @State var date = Date()
    @State var isShowingDatePicker = false
    
    @State var isShowingSearchField = false
    @State var searchText = ""
    
    
    
    var body: some View {
        ZStack {
            ScrollViewReader { scrollProxy in
                ZStack {
                    if viewModel.dates.isEmpty {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .onAppear {
                                viewModel.update()
                            }
                    } else {
                        List {
                            ForEach(viewModel.dates, id: \.self) { date in
                                if let lessons = viewModel.lessons(date, searchText: searchText), lessons.isEmpty == false {
                                    Text(viewModel.dateFormatter.string(from: date) + viewModel.week(date))
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    ForEach(lessons, id: \.self) { lesson in
                                        LessonView(lesson: lesson, showEmployee: !viewModel.isEmployee, showGroups: viewModel.isEmployee || viewModel.isClassroom)
                                    }.onDisappear {
                                        if Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())! == date {
                                            withAnimation(.linear(duration: 0.2)) {
                                                isShowingReturnButton = true
                                            }
                                        }
                                    }
                                    .onAppear {
                                        if Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())! == date {
                                            withAnimation(.linear(duration: 0.2)) {
                                                isShowingReturnButton = false
                                            }
                                        }
                                    }
                                }
                            }
                            .onAppear {
                                scrollProxy.scrollTo(Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!, anchor: .top)
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listStyle(.plain)
                    }
                    
                    VStack {
                        Spacer()
                        HStack {
                            Button {
                                withAnimation(.spring()) {
                                    isShowingDatePicker.toggle()
                                }
                            } label: {
                                Image(systemName: "calendar.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                
                            }
                            if isShowingReturnButton {
                                Button {
                                    withAnimation {
                                        scrollProxy.scrollTo(Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!, anchor: .top)
                                    }
                                } label: {
                                    withAnimation(.spring()) {
                                        Image(systemName: "arrow.uturn.backward.circle.fill")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                    }
                                }
                            }
                            Spacer()
                            Button {
                                withAnimation(.spring()) {
                                    isShowingSearchField.toggle()
                                }
                            } label: {
                                Image(systemName: "magnifyingglass.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                
                            }
                        }
                        .foregroundColor(.primary)
                        
                        if isShowingDatePicker {
                            DatePicker("", selection: $date, in: viewModel.dateRange(), displayedComponents: .date)
                                .datePickerStyle(.graphical)
                                .background(.ultraThinMaterial)
                                .cornerRadius(16)
                                .foregroundColor(Color.black)
                            
                                .onChange(of: date) { newValue in
                                    withAnimation {
                                        isShowingDatePicker = false
                                        scrollProxy.scrollTo(Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: newValue)!, anchor: .top)
                                    }
                                    
                                }
                        }
                        
                        if isShowingSearchField {
                            TextField("Название предмета", text: $searchText)
                                .frame(height: 36)
                                .background(.ultraThinMaterial)
                                .cornerRadius(16)
                            
                        }
                    }
                    .padding()
                }
                .navigationTitle(viewModel.name)
                .toolbar {
                    Button {
                        viewModel.favorite.toggle()
                    } label: {
                        Image(systemName: viewModel.favorite ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                    }
                }
            }
        }
    }
}
