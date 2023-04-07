//
//  ImagesView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 1.11.21.
//

import SwiftUI

struct ImagesView: View {
    @EnvironmentObject var viewModel: ImagesViewModel
    @GestureState var draggingOffset: CGSize = .zero
    
    
    
    var body: some View {
        ZStack {
            if viewModel.isPresented {
                Color(uiColor: UIColor(named: "backgroundColor")!)
                    .opacity(viewModel.backgroundOpacity)
                    .ignoresSafeArea(.all, edges: .top)
                    .transition(.opacity)
//                    .navigationBarHidden(true)
            }
            
            if viewModel.isPresented {
                ScrollView(.init()) {
                    TabView(selection: $viewModel.selection) {
                        ForEach(viewModel.images, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .tag(image as UIImage?)
                                .offset(y: viewModel.verticalOffset.height)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                }
                .transition(.move(edge: viewModel.verticalOffset.height < 0 ? .top : .bottom))
            }
            
        }
        .overlay {
            if viewModel.isPresented {
                shareButton
                    .transition(.move(edge: .bottom))
            }
        }
        
        .gesture(DragGesture().updating($draggingOffset, body: { value, outputValue, _ in
            outputValue = value.translation
            viewModel.onDragChange(value: draggingOffset)
        }).onEnded({ value in viewModel.onDragEnded(value: value)}))
        
    }
    
    var shareButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
//                    guard let urlShare = URL(string: "https://developer.apple.com/xcode/swiftui/") else { return }
//                    let activityVC = UIActivityViewController(activityItems: [viewModel.selection!], applicationActivities: nil)
//                           UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
                } label: {
                    Circle()
                        .frame(width: 48, height: 48)
                        .shadow(color: .accentColor, radius: 8)
                        .overlay(Image(systemName: "square.and.arrow.up")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24)
                                    .font(Font.system(.title).bold())
                                    .foregroundColor(.white)
                        )
                }
                .padding()
            }
        }
    }
}
