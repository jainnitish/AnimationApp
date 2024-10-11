//
//  ContentView.swift
//  RiveAnimation
//
//  Created by Nitish Jain on 29/09/24.
//

import SwiftUI
import RiveRuntime

struct ContentView: View {
    @AppStorage("selectedTab") var selectedTab: Tab = .chat
    @State var isOpen = false
    @State var showLogin = false
    
    let button = RiveViewModel(fileName: "menu_button", stateMachineName: "State Machine", autoPlay: false)
    
    var body: some View {
        ZStack {
            Color("Background 2")
                .ignoresSafeArea()
            
            SideMenu()
                .opacity(isOpen ? 1 : 0)
                .offset(x: isOpen ? 0 : -300)
                .rotation3DEffect(
                    .degrees(isOpen ? 0 : 30), axis: (x: 0, y: 1, z: 0)
                )
            
            Group {
                switch selectedTab {
                case .chat:
                    HomeView()
                case .search:
                    Text("Search")
                case .timer:
                    Text("Timer")
                case .bell:
                    Text("Bell")
                case .user:
                    Text("User")
                }
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 80)
            }
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: 120)
            }
            .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .rotation3DEffect(
                .degrees(isOpen ? 30 : 0), axis: (x: 0, y: -1, z: 0)
            )
            .offset(x: isOpen ? 265 : 0)
            .scaleEffect(isOpen ? 0.9 : 1)
            .scaleEffect(showLogin ? 0.95 : 1)
            .ignoresSafeArea()
            
            Image(systemName: "person")
                .frame(width: 36, height: 36)
                .background(.white)
                .mask(Circle())
                .shadow(color: Color("Shadow").opacity(0.2), radius: 5, x: 0, y: 5)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding()
                .offset(y: 4)
                .offset(x: isOpen ? 100 : 0)
                .onTapGesture {
                    withAnimation(.spring()) {
                        showLogin = true
                    }
                }
            
            button.view()
                .frame(width: 45, height: 45)
                .mask(Circle())
                .shadow(color: Color("Shadow").opacity(0.2), radius: 5, x: 0, y: 5)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding()
                .offset(x: isOpen ? 216 : 0)
                .onTapGesture {
                    try? button.setInput("isOpen", value: isOpen)
                    withAnimation(.spring(response: 0.7, dampingFraction: 0.8)) {
                        isOpen.toggle()
                    }
                }
                .onChange(of: isOpen) { newValue in
                    UIApplication.shared.setStatusBarStyle( newValue ? .lightContent : .darkContent, animated: true)
                }
            
            TabBar()
                .offset(y: isOpen || showLogin ? 300 : 0)
            
            if showLogin {
                OnboardingView(showLogin: $showLogin)
                    .background(.white)
                    .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .shadow(color: .black.opacity(0.5), radius: 40, x: 0, y: 40)
                    .ignoresSafeArea(.all, edges: .top)
                    .transition(.move(edge: .top))
                    .offset(y: showLogin ? 10 : 0)
                    .zIndex(1)
            }
        }
    }
}

#Preview {
    ContentView()
}
