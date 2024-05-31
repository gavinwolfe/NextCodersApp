//
//  homeHub.swift
//  NextCodersApp
//
//  Created by Gavin Wolfe on 4/23/24.
//

import SwiftUI
import Firebase

struct HomeHub: View {
    
    @StateObject private var networkCall = NetworkManager()
    
    var body: some View {
        
        HomeView(courses: networkCall.courseItems, projects: networkCall.projects, myProjects: networkCall.myProjects, myName: networkCall.userName)
            .onAppear {
                if let authId = Auth.auth().currentUser?.uid {
                    networkCall.getCourses(uid: authId)
                    networkCall.getProjects(uid: authId)
                    print(authId)
                }
            }
    }
}

struct HomeView: View {
    var courses = [Course]()
    var projects = [Project]()
    var myProjects = [Project]()
    var myName = ""
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                IpadHeader()
                VStack(alignment: .leading, spacing: 10) {
                    Spacer()
                        .frame(height: 5)
                    MyClassesStudent(courses: courses, myName: myName)
                    Spacer()
                        .frame(height: 10)
                    MyProjectsStudent(myProjects: myProjects)
                    Spacer()
                        .frame(height: 50)
                   OtherClasses()
                }
            }
        }
    }
}

struct ProjectItem: View {
    var project: Project
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 20.0)
                .foregroundColor(Color(UIColor.systemBackground))
                .frame(width: 290, height: 200)
            VStack {
                Spacer()
                    .frame(height: 5)
                Image(project.imageS)
                    .resizable()
                    .frame(width: 270, height: 130)
                    .cornerRadius(20.0)
                
                Spacer()
            }
            VStack {
                Spacer()
                Text(project.projectTitle)
                    .font(.headline)
                    .offset(y: -25)
            }
        }
    }
}

struct CourseItem: View {
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

struct IpadHeader: View {
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 2.0)
                .foregroundColor(Color(UIColor.opaqueSeparator))
                .frame(height: 315)
            HStack(alignment: .top) {
                Spacer()
                    .frame(width: 30)
                VStack(alignment: .center) {
                    Text("Next \nCoders")
                        .font(Font(UIFont(name: "HelveticaNeue-Bold", size: 50) ?? .systemFont(ofSize: 32)))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .foregroundStyle(.linearGradient(colors: [Color(UIColor.systemBlue), .cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 280, height: 140)
                }.frame(width: 280)
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .foregroundStyle(.linearGradient(colors: [.cyan, Color(UIColor.systemGreen)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 160, height: 290)
                    .offset(y: 10)
                VStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .foregroundStyle(.linearGradient(colors: [.blue, Color(UIColor.cyan)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 280, height: 140)
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .foregroundStyle(.linearGradient(colors: [.blue, Color(UIColor.systemBlue)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 280, height: 140)
                }.offset(y: 12)
                Spacer()
            }
        }
    }
}
struct MyClassesStudent: View {
    var courses: [Course]
    var myName: String
    @StateObject private var selCourse = TransitionManager()
    var body: some View {
        Text(myName)
            .foregroundColor(Color(UIColor.lightGray))
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
        HStack {
            ForEach(courses) { item in
                CourseItem(courseTitle: item.courseTitle).onTapGesture {
                    selCourse.selectedCourse = item
                }
            }
        }.fullScreenCover(isPresented: $selCourse.isShowingCourseView) { CoursePage(courseItem: selCourse.selectedCourse ?? Course(courseTitle: "Next Coders", time: [1100], cid: "123"))
        }
    }
}
struct MyProjectsStudent: View {
    var myProjects: [Project]
    @StateObject private var selProject = ProjectTransitionManager()
    var body: some View {
        Text("Projects: ")
            .foregroundColor(Color(UIColor.lightGray))
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
        HStack {
            ForEach(myProjects) { item in
                ProjectItem(project: item).onTapGesture {
                    selProject.selectedProj = item
                }
            }
        }.fullScreenCover(isPresented: $selProject.isShowingProjectView) { ProjectView(project: selProject.selectedProj ?? Project(projectTitle: "Next Coders Project", descript: "This is our project, loading...", imageS: "python1", rank: 12, link: "https://replit.com"))
        }
    }
}
