//
//  ProjectView.swift
//  NextCodersApp
//
//  Created by Gavin Wolfe on 5/3/24.
//

import SwiftUI

struct ProjectView: View {
    @Environment(\.dismiss) private var dismiss
    var project: Project
    var body: some View {
        NavigationStack {
            VStack {
                ZStack(alignment: .bottom) {
                    WebView(url: project.link)
//                    VStack(alignment: .trailing) {
//                        HelpView()
//                    }.frame(height: 120)
                }
                HStack {
                    Text(project.descript)
                        .font(Font(UIFont(name: "Helvetica", size: 20) ?? .systemFont(ofSize: 20)))
                        .multilineTextAlignment(.center)
                    Spacer()
                }.frame(height: 150)
                    .padding(10)
            }.toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton().onTapGesture {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("What class is this?") {
                        
                    }.buttonStyle(.bordered)
                       
                }
            }).navigationTitle(project.projectTitle)
        }
    }
}
struct HelpView: View {
    var text: String
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                ZStack {
                    Color(UIColor.opaqueSeparator)
                        .cornerRadius(12)
                        .frame(width: 230)
                    Text(text)
                        .font(.system(size: 14))
                        .padding(10)
                        .frame(width: 210)
                        .multilineTextAlignment(.center)
                }.padding(10)
            }
        }
    }
}
