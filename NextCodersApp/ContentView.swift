//
//  ContentView.swift
//  NextCodersApp
//
//  Created by Gavin Wolfe on 4/19/24.
//

import SwiftUI
import CoreData
import Firebase

struct ContentView: View {
    @State private var accessCode = ""
    @State private var isUserLoggedIn = false
    var body: some View {
        if isUserLoggedIn {
            let defaults = UserDefaults.standard
            if let _ = defaults.string(forKey: "instructorMode") {
                InstructorHub()
            } else if let _ = defaults.string(forKey: "parentMode") {
                ParentHub()
            } else {
                HomeHub()
            }
        } else {
            loginContent
        }
    }
    
    var loginContent: some View {
        ZStack {
            SlashView()
            VStack(spacing: 20) {
                Spacer()
                    .frame(height: 400)
                Text("Next Coders")
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .offset(x: -50, y: -220)
                Spacer()
                    .frame(height: 200)
                TextField("Login Code", text: $accessCode, prompt:
                            Text("Enter Login Code Here...")
                    .foregroundColor(.gray))
                .foregroundColor(.black)
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.black)
                Button {
                    loginAction()
                } label: {
                    LoginButtonText()
                }.offset(y: 10)
                Spacer()
                Button {
                    //handle help
                } label: {
                    Text("Click here for help logging in...")
                }.offset(y: -20)
            }
            .onAppear {
                //handle any on appear settings
            }
        }.ignoresSafeArea()
    }
    func loginRequest(instructorCode: String) {
        let arrayOfStrings = instructorCode.components(separatedBy: "/")
        guard arrayOfStrings.count == 2 else { return }
        let ref = Database.database().reference()
        ref.child("addCodes").child(arrayOfStrings[0]).observeSingleEvent(of: .value, with: { snapshot in
            if let secretCode = snapshot.value as? String, secretCode == arrayOfStrings[1] {
                Auth.auth().signInAnonymously() { (authResult, error) in
                    if let authUID = authResult?.user.uid {
                        ref.child("instructors").child(instructorCode).updateChildValues(["iUID": authUID])
                        ref.child("instructorUids").updateChildValues([authUID: instructorCode])
                        let defaults = UserDefaults.standard
                        defaults.set("instructor", forKey: "instructorMode")
                        ref.child("users").child(authUID).updateChildValues(["instructorCode": instructorCode])
                        self.isUserLoggedIn.toggle()
                    }
                }
            }
            
        })
    }
    func loginRequest(parentId: String) {
        let ref = Database.database().reference()
        ref.child("parents").child(parentId).observeSingleEvent(of: .value, with: { snapshot in
            let data = snapshot.value as? [String: AnyObject]
            if let studentClasses = data?["studentAddCodes"] as? [String: String], let parentName = data?["name"] as? String {
                Auth.auth().signInAnonymously() { (authResult, error) in
                    if let authUID = authResult?.user.uid {
                        ref.child("parents").child(parentId).updateChildValues(["parentId": authUID])
                        ref.child("users").child(authUID).updateChildValues(["name": parentName])
                        ref.child("users").child(authUID).updateChildValues(["parentId": parentId])
                        ref.child("users").child(authUID).updateChildValues(["studentAddCodes": studentClasses])
                        let defaults = UserDefaults.standard
                        defaults.set(parentName, forKey: "parentMode")
                        self.isUserLoggedIn.toggle()
                    }
                }
            }
        })
    }
    func loginRequest(classCode: String) {
        let ref = Database.database().reference()
        ref.child("addCodes").child(classCode).observeSingleEvent(of: .value, with: { snap in
            if let classesOfStudent = snap.value as? [String: String] {
                Auth.auth().signInAnonymously() { (authResult, error) in
                    if let nameOfStudent = classesOfStudent.values.first, nameOfStudent != "", let uid = authResult?.user.uid {
                        ref.child("users").child(uid).updateChildValues(["name": nameOfStudent])
                        var studentRefData = [String: String]()
                        for (classid, _) in classesOfStudent {
                            studentRefData[classid] = classCode
                            ref.child("classes").child(classid).child("students").updateChildValues([uid: nameOfStudent])
                        }
                        ref.child("users").child(uid).child("classCodes").updateChildValues(studentRefData)
                        self.isUserLoggedIn.toggle()
                    }
                }
            }
        })
    }
    func loginAction() {
        guard accessCode != "" else {
            return
        }
        if accessCode.lowercased().contains("instructor") {
            loginRequest(instructorCode: accessCode.lowercased())
        } else if accessCode.lowercased().contains("parent") {
            loginRequest(parentId: accessCode.lowercased())
        } else {
            loginRequest(classCode: accessCode.lowercased())
        }
    }
}

struct SlashView: View {
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .foregroundStyle(.linearGradient(colors: [.green, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width: 1000, height: 460)
            .rotationEffect(.degrees(160))
            .offset(y: -450)
    }
}

struct LoginButtonText: View {
    
    var body: some View {
        Text("Go!")
            .bold()
            .frame(width: 200, height: 40)
            .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.linearGradient(colors: [.blue, .cyan], startPoint: .top, endPoint: .bottomTrailing)))
            .foregroundColor(.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .onAppear {
               print("loaded")
            }
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
