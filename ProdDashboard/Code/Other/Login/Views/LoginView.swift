//
//  LoginView.swift
//  ProdDashboard
//
//  Created by Christo Polydorou on 1/20/24.
//

import Foundation
import SwiftUI


struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    
    var body: some View {
        ZStack {
            Color.black
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [.red, .blue], startPoint:
                        .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1000, height: 400)
                .rotationEffect(.degrees(90))
            VStack(spacing: 20) {
                Text("Taskify")
                    .foregroundColor(Color(red: 255/255, green: 248/255, blue: 220/255))
                    .offset(y: -200)
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                VStack(spacing: 20) {
                    TextField("", text: $email)
                        .foregroundColor(.white)
                        .textFieldStyle(.plain)
                        .font(.system(size: 20, weight: .bold))
                        .placeholder(when: email.isEmpty) {
                            Text(NSLocalizedString("Email", comment: ""))
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold))
                        }
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    
                    
                    
                    Rectangle()
                        .frame(width: 250, height: 3)
                        .foregroundColor(.white)
                        .offset(y: -10)
                }
                .offset(y: -100)
                VStack(spacing: 20) {
                    SecureField("", text: $password)
                        .foregroundColor(.white)
                        .textFieldStyle(.plain)
                        .font(.system(size: 20, weight: .bold))
                        .placeholder(when: password.isEmpty) {
                            Text("Password")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold))
                        }
                    Rectangle()
                        .frame(width: 250, height: 3)
                        .foregroundColor(.white)
                        .offset(y: -10)
                }
                .offset(y: -100)
                Button {
                    // login up
                } label: {
                    Text("Login")
                        .bold()
                        .foregroundColor(Color(red: 100/255, green: 100/255, blue: 100/255))
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                        .background(
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .fill(Color(red: 255/255, green: 248/255, blue: 220/255))
                                .frame(width: 110, height: 40)
                        )
                        .offset(y: -90)
                }
                Button {
                    // login
                } label: {
                    Text("Don't have an account? Sign up")
                        .bold()
                        .foregroundColor(Color(red: 255/255, green: 248/255, blue: 220/255))
                        .offset(y: -80)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                }
            }
            .frame(width: 250)
        }
        .ignoresSafeArea()
    }
}

struct Contentview_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}
