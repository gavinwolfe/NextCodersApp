//
//  ParentHub.swift
//  NextCodersApp
//
//  Created by Gavin Wolfe on 5/4/24.
//

import SwiftUI
import Firebase

struct ParentHub: View {
    @StateObject private var networkCall = NetworkManager()
    var body: some View {
        ParentView(courses: networkCall.parentClasses, projects: networkCall.myProjects, otherProjects: networkCall.projects, myName: networkCall.userName)
            .onAppear {
                if let myUid = Auth.auth().currentUser?.uid {
                    networkCall.getParentClasses(uid: myUid)
                    networkCall.getParentsProjects(uid: myUid)
                }
            }
    }
}
struct ParentView: View {
    var courses = [ParentClass]()
    var projects = [Project]()
    var otherProjects = [Project]()
    var myName = ""
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ScrollView(showsIndicators: false) {
                    iPhoneHeader(geoWidth: geo.size.width, geoHeight: geo.size.height)
                    VStack(alignment: .leading, spacing: 10) {
                        Spacer()
                            .frame(height: 5)
                        YourClasses(courses: courses)
                        Spacer()
                            .frame(height: 10)
                       YourProjects(projects: projects)
                        Spacer()
                            .frame(height: 50)
                       OtherClasses()
                    }
                }
            }
        }
    }
}
struct YourClasses: View {
    var courses: [ParentClass]
    @StateObject private var selCourse = TransitionManagerParent()
    var body: some View {
        Text("Your Classes")
            .foregroundColor(Color(UIColor.lightGray))
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
        ScrollView(.horizontal) {
            HStack {
                ForEach(courses) { item in
                    ParentCourseItem(courseTitle: item.classTitle + ": " + item.studentName).onTapGesture {
                        selCourse.selectedCourse = item
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $selCourse.isShowingParentCourseView) {
            ParentCourseView(parentClass: selCourse.selectedCourse ?? ParentClass(classTitle: "Loading...", classId: "", studentName: "Next Coder Student", classNumber: 3, totalClasses: 16, classTimes: [1:1000], mostRecentClass: 234433, cid: ""))
        }
    }
}
struct YourProjects: View {
    var projects: [Project]
    @StateObject private var selProject = ProjectTransitionManager()
    var body: some View {
        Text("Projects: ")
            .foregroundColor(Color(UIColor.lightGray))
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
        ScrollView(.horizontal) {
            HStack {
                ForEach(projects) { item in
                    ProjectItem(project: item).onTapGesture {
                        selProject.selectedProj = item
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $selProject.isShowingProjectView) { ProjectView(project: selProject.selectedProj ?? Project(projectTitle: "Next Coders Project", descript: "This is our project, loading...", imageS: "python1", rank: 12, link: "https://replit.com"))
        }
    }
}
struct OtherClasses: View {
    @State private var selNextClasses = false
    var body: some View {
        ZStack(alignment: .center) {
            HStack {
                Spacer()
                Button {
                    selNextClasses = !selNextClasses
                } label: {
                    Text("See our other classes!")
                        .font(Font(UIFont(name: "Helvetica-Neue", size: 18) ?? .systemFont(ofSize: 18)))
                        .bold()
                        .multilineTextAlignment(.center)
                        .frame(width: 400, height: 60, alignment: .center)
                        .foregroundStyle(.white)
                        .background(Color(UIColor.systemBlue))
                        .cornerRadius(20)
                }
                Spacer()
            }
        }.fullScreenCover(isPresented: $selNextClasses) {
            NextCourses()
        }
    }
}

struct iPhoneHeader: View {
    var geoWidth: CGFloat
    var geoHeight: CGFloat
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 2.0)
                .foregroundColor(Color(UIColor.opaqueSeparator))
                .frame(height: geoWidth / 1.5)
            HStack(alignment: .top) {
                Spacer()
                VStack(alignment: .center) {
                    Text("Next \nCoders")
                        .font(Font(UIFont(name: "HelveticaNeue-Bold", size: 30) ?? .systemFont(ofSize: 32)))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .foregroundStyle(.linearGradient(colors: [Color(UIColor.systemBlue), .cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: geoWidth / 2, height: geoWidth / 3)
                    
                }.frame(width:  geoWidth / 2)
                
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .foregroundStyle(.linearGradient(colors: [.cyan, Color(UIColor.systemGreen)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: geoWidth / 3, height: geoWidth / 2)
                    .offset(y: 40)
                Spacer()
            }
        }
    }
}

struct ParentCourseItem: View {
    var courseTitle: String
    var body: some View {
        ZStack(alignment: .center) {
            Color.gray
                .frame(width: 400, height: 300)
                .cornerRadius(20.0)
            RoundedRectangle(cornerRadius: 20.0)
                .foregroundColor(Color(UIColor.systemBackground))
                .frame(width: 390, height: 290)
            VStack {
                Spacer()
                    .frame(height: 15)
                Image("pyt")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 370, height: 220)
                    .cornerRadius(20.0)
                    
                Spacer()
            }
            VStack {
                Spacer()
                Text(courseTitle)
                    .font(.headline)
                    .offset(y: -25)
            }
        }
    }
}
