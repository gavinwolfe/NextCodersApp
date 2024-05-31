//
//  CoursePage.swift
//  NextCodersApp
//
//  Created by Gavin Wolfe on 4/30/24.
//

import SwiftUI
import WebKit
import Firebase

struct CoursePage: View {
    @StateObject private var networkCall = NetworkManager()
    @State private var selHw = false
    @Environment(\.dismiss) private var dismiss
    var courseItem: Course
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                    .frame(height: 20)
                ZoomButton()
                CodingView(courseLink: networkCall.courseLink, userLoggedOutIdePrompt: networkCall.userLoggedOutIdePrompt)
                if networkCall.studentPastCode.count <= 0 {
                    EmptyPastCodeView()
                } else {
                    PreviousCodeViewManager(studentPastCode: networkCall.studentPastCode)
                }
                Spacer()
                    .frame(height: 15)
            }
            .ignoresSafeArea()
            .onAppear {
                networkCallLoadup()
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton().onTapGesture {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("HW + Help") {
                        selHw = !selHw
                    }.buttonStyle(.bordered)
                       
                }
            })
            .sheet(isPresented: $selHw) {
                HomeworkView(courseId: courseItem.cid)
            }
            .onDisappear {
                guard let authId = Auth.auth().currentUser?.uid else { return }
                Database.database().reference().child("classes").child(courseItem.cid).child("links").removeAllObservers()
                Database.database().reference().child("classes").child(courseItem.cid).child("codeWork").child(authId).removeAllObservers()
                Database.database().reference().child("users").child(authId).child("loginIssue").removeAllObservers()
            }
        }
    }
    
    func networkCallLoadup() {
        if let authId = Auth.auth().currentUser?.uid {
            print("network call in progress")
            networkCall.getCourseCode(uid: authId, courseId: courseItem.cid)
            networkCall.getCourseLink(courseId: courseItem.cid, uid: authId)
            networkCall.getCourseLoginPrompt(uid: authId)
        }
    }
}
struct ZoomButton: View {
    var body: some View {
        HStack {
            Button {
                print("Button was tapped")
            } label: {
                Text("Zoom")
                    .padding()
                    .font(.title)
                    .frame(width: 200, height: 60)
                    .foregroundStyle(.white)
                    .background(Color(UIColor.systemBlue))
                    .cornerRadius(6)
            }
        }
    }
}
struct EmptyPastCodeView: View {
    var body: some View {
        VStack (alignment: .center) {
            Text("Your old code will show up here.\n Happy Coding!")
                .font(Font(UIFont(name: "Helvetica-Medium", size: 20) ?? .systemFont(ofSize: 20)))
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
        }.frame(height: 200)
    }
}
struct PreviousCodeViewManager: View {
    var studentPastCode: [StudentCode]
    @StateObject private var selCode = CodeScreenTransitionManager()
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(studentPastCode) { item in
                    PreviousCode(imageUrl: item.imageUrl).onTapGesture {
                        selCode.selectedCode = item
                    }
                }
                Spacer()
            }
        }
        .frame(height: 200)
        .sheet(isPresented: $selCode.isShowingCodeView) {
            ViewCodeShot(imageUrl: selCode.selectedCode?.imageUrl ?? "python1")
        }
        
    }
}
struct CodingView: View {
    var courseLink: String
    var userLoggedOutIdePrompt: String
    var body: some View {
        ZStack {
            WebView(url: courseLink)
            if userLoggedOutIdePrompt != "" {
                VStack(alignment: .trailing) {
                    HelpView(text: userLoggedOutIdePrompt)
                }.frame(height: 120)
            }
        }
    }
}
struct PreviousCode: View {
    var imageUrl: String
    var body: some View {
        ZStack(alignment: .leading) {
            Image(imageUrl)
                .resizable()
                .cornerRadius(8)
                .frame(width: 190, height: 190)
        }
    }
}

struct ViewCodeShot: View {
    var imageUrl: String
    var body: some View {
        ZStack(alignment: .center) {
            Image(imageUrl)
                .resizable()
                .cornerRadius(20)
        }
    }
}

struct HomeworkView: View {
    var courseId: String
    @StateObject private var networkCall = NetworkManager()
    var body: some View {
        VStack {
            HomeworkBody(hw: networkCall.homeworkAssignment)
        }.onAppear {
            networkCall.getHomeworkForCourse(courseId: courseId)
        }
    }
}
struct HomeworkBody: View {
    var hw: Homework
    var body: some View {
        VStack(alignment:.leading) {
            TopView(hw: hw)
            Spacer()
                .frame(height: 15)
            Text("Messages From Instructor: ")
                .foregroundColor(Color(UIColor.systemBlue))
                .font(Font(UIFont(name: "Helvetica", size: 14) ?? .systemFont(ofSize: 14) ))
            Spacer()
                .frame(height: 5)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(hw.messages) { item in
                        MessageView(instructMessage: item)
                    }
                    Spacer()
                }
            }
            Spacer()
            HStack {
                Spacer()
                Button("Ask Instructor Question") {
                    
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                Spacer()
            }
        }.padding(10)
    }
}
struct TopView: View {
    var hw: Homework
    var body: some View {
        Spacer()
            .frame(height: 15)
        Text("Homework")
            .font(Font(UIFont(name: "Helvetica-Neue", size: 36) ?? .systemFont(ofSize: 36)))
            .bold()
        Spacer()
            .frame(height: 15)
        Text(hw.title)
            .font(Font(UIFont(name: "Helvetica-Neue-Medium", size: 24) ?? .systemFont(ofSize: 24)))
            .foregroundColor(.secondary)
        Spacer()
            .frame(height: 10)
        VStack(alignment: .center) {
            Text(hw.descript)
                .font(Font(UIFont(name: "Helvetica-Neue", size: 20) ?? .systemFont(ofSize: 20)))
                .foregroundColor(Color(UIColor.secondaryLabel))
                .bold()
        }
    }
}
struct MessageView: View {
    var instructMessage: InstructorMessage
    var body: some View {
        ZStack(alignment:.center) {
            Color(UIColor.opaqueSeparator)
                .cornerRadius(12)
            Text(instructMessage.text)
                .font(Font(UIFont(name: "Helvetica-Medium", size: 14) ?? .systemFont(ofSize: 14)))
                .multilineTextAlignment(.center)
                .padding(10)
        }.frame(width: 300, height: 200)
    }
}

struct WebView: UIViewRepresentable {
 
    var url: String

        func makeUIView(context: Context) -> WKWebView  {
            return WKWebView()
        }

        func updateUIView(_ uiView: WKWebView, context: Context) {
            uiView.load(url)
        }
}

struct XMarkButton: View {
    
    var body: some View {
        Image(systemName: "xmark") //changed to image, can change color here if needed
            .font(.headline)
    }
}

extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}
