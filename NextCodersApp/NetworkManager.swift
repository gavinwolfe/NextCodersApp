//
//  NetworkingManager.swift
//  NextCodersApp
//
//  Created by Gavin Wolfe on 4/26/24.
//

import Foundation
import Firebase

class NetworkManager: ObservableObject {
    @Published var courseItems: [Course] = []
    @Published var studentPastCode: [StudentCode] = []
    @Published var courseLink: String = "https://replit.com/login"
    @Published var userName: String = ""
    @Published var homeworkAssignment: Homework = Homework(title: "Next Coders", descript: "Next Coders Homework", messages: [])
    @Published var userLoggedOutIdePrompt: String = ""
    @Published var projects: [Project] = []
    @Published var myProjects: [Project] = []
    @Published var nextCodersClasses: [NextCodersCourse] = []
    @Published var parentClasses: [ParentClass] = []
    func getCourses(uid: String)  {
        var returnCourses = [Course]()
        let ref = Database.database().reference()
        ref.child("users").child(uid).child("classCodes").observeSingleEvent(of: .value, with: { snapshot in
            if let data = snapshot.value as? [String: String] {
                let dispatchGroup = DispatchGroup()
                for (courseId, _) in data {
                    dispatchGroup.enter()
                    ref.child("classes").child(courseId).observeSingleEvent(of: .value, with: { snap in
                        let courseData = snap.value as? [String: AnyObject]
                        if let title = courseData?["courseTitle"] as? String, let cid = courseData?["cid"] as? String {
                            let newCourse = Course(courseTitle: title, time: [0], cid: cid)
                            returnCourses.append(newCourse)
                        }
                        dispatchGroup.leave()
                    })
                }
                dispatchGroup.notify(queue: DispatchQueue.main) {
                    self.courseItems = returnCourses
                    ref.child("users").child(uid).child("name").observeSingleEvent(of: .value, with: { snap_kid in
                        if let myName = snap_kid.value as? String {
                            self.userName = myName
                        }
                    })
                }
            }
        })
        
    }
    
    func getCourseLink(courseId: String, uid: String) {
        let ref = Database.database().reference()
        ref.child("classes").child(courseId).child("links").child(uid).observe(.value, with: { snapshot in
            if let data = snapshot.value as? String {
                self.courseLink = data
                print(data)
            } else {
                ref.child("classes").child(courseId).child("generalLink").observeSingleEvent(of: .value, with: { snap in
                    if let data2 = snap.value as? String {
                        self.courseLink = data2
                        print("data2")
                        print(data2)
                    }
                })
            }
        })
    }
    
    
    func getCourseCode(uid: String, courseId: String) {
        let ref = Database.database().reference()
        var returnCodes = [StudentCode]()
        ref.child("classes").child(courseId).child("codeWork").child(uid).observe(.value, with: { snapshot_code in
            if let data = snapshot_code.value as? [String: Int] {
                for (c,v) in data {
                    let newCode = StudentCode(order: v, imageUrl: c)
                    returnCodes.append(newCode)
                }
            }
            self.studentPastCode = returnCodes
            returnCodes.removeAll()
        })
    }
    
    func getCourseLoginPrompt(uid: String) {
        let ref = Database.database().reference()
        ref.child("users").child(uid).child("loginIssue").observe(.value, with: { snap_login in
            if let loginPrompt = snap_login.value as? String {
                self.userLoggedOutIdePrompt = loginPrompt
            } else {
                self.userLoggedOutIdePrompt = ""
            }
        })
    }
    
    func getHomeworkForCourse(courseId: String) {
        let ref = Database.database().reference()
        ref.child("classes").child(courseId).child("homework").observeSingleEvent(of: .value, with: { snapshot_hw in
            let hwData = snapshot_hw.value as? [String: AnyObject]
            if let descript = hwData?["directions"] as? String, let title = hwData?["title"] as? String {
                var messages = [InstructorMessage]()
                if let mesgs = hwData?["messages"] as? [String: AnyObject] {
                    for (_,each) in mesgs {
                        if let mesg = each["message"] as? String, let time = each["time"] as? Int {
                            messages.append(InstructorMessage(time: time, text: mesg))
                        }
                    }
                }
                let hw = Homework(title: title, descript: descript, messages: messages)
                self.homeworkAssignment = hw
            }
        })
    }
    
    func getProjects(uid: String) {
        let ref = Database.database().reference()
        ref.child("projects").observeSingleEvent(of: .value, with: { snapshot in
            var projectsAdd = [Project]()
            var myProjectsAdd = [Project]()
            if let data = snapshot.value as? [String: AnyObject] {
                for (_, each) in data {
                    if let titleProj = each["title"] as? String, let url = each["link"] as? String, let image = each["image"] as? String, let time = each["time"] as? Int, let proj_uid = each["uid"] as? String, let descript = each["descript"] as? String {
                        if proj_uid != uid {
                            projectsAdd.append(Project(projectTitle: titleProj, descript: descript, imageS: image, rank: time, link: url))
                        } else {
                            myProjectsAdd.append(Project(projectTitle: titleProj, descript: descript, imageS: image, rank: time, link: url))
                        }
                    }
                }
            }
            self.projects = projectsAdd
            self.myProjects = myProjectsAdd
        })
    }
    
    func getParentsProjects(uid: String) {
        let ref = Database.database().reference()
        ref.child("users").child(uid).child("parentId").observeSingleEvent(of: .value, with: { snapshot_parentId in
            if let myParentID = snapshot_parentId.value as? String {
                ref.child("projects").observeSingleEvent(of: .value, with: { snapshot in
                    var projectsAdd = [Project]()
                    var myProjectsAdd = [Project]()
                    if let data = snapshot.value as? [String: AnyObject] {
                        for (_, each) in data {
                            if let titleProj = each["title"] as? String, let url = each["link"] as? String, let image = each["image"] as? String, let time = each["time"] as? Int, let proj_pid = each["parentId"] as? String, let descript = each["descript"] as? String {
                                if proj_pid != myParentID {
                                    projectsAdd.append(Project(projectTitle: titleProj, descript: descript, imageS: image, rank: time, link: url))
                                } else {
                                    myProjectsAdd.append(Project(projectTitle: titleProj, descript: descript, imageS: image, rank: time, link: url))
                                }
                            }
                        }
                    }
                    self.projects = projectsAdd
                    self.myProjects = myProjectsAdd
                })
            }
        })
    }
    
    func getParentClasses(uid: String) {
        let ref = Database.database().reference()
        var tempParentCourses = [ParentClass]()
        ref.child("users").child(uid).child("studentAddCodes").observeSingleEvent(of: .value, with: { snapshot_parent in
            if let data = snapshot_parent.value as? [String: String] {
                let dispatchGroup1 = DispatchGroup()
                for (addCodeid, studentName) in data {
                    dispatchGroup1.enter()
                    ref.child("addCodes").child(addCodeid).observeSingleEvent(of: .value, with: { addCodeSnap in
                        let dispatchGroup2 = DispatchGroup()
                        if let data2 = addCodeSnap.value as? [String: String] {
                            for (courseId, _) in data2 {
                                dispatchGroup2.enter()
                                ref.child("classes").child(courseId).observeSingleEvent(of: .value, with: { snap3 in
                                    let data3 = snap3.value as? [String: AnyObject]
                                    if let courseTitle = data3?["courseTitle"] as? String, let progress = data3?["currentClass"] as? Int, let totalClasses = data3?["totalClasses"] as? Int, let mostRecentClass = data3?["mostRecentClass"] as? Int, let class_id = data3?["cid"] as? String {
                                        let newCourse = ParentClass(classTitle: courseTitle, classId: courseId, studentName: studentName, classNumber: progress, totalClasses: totalClasses, classTimes: [1:10], mostRecentClass: mostRecentClass, cid: class_id)
                                        tempParentCourses.append(newCourse)
                                    }
                                    dispatchGroup2.leave()
                                })
                            }
                        }
                        dispatchGroup2.notify(queue: DispatchQueue.main) {
                            dispatchGroup1.leave()
                        }
                    })
                }
                dispatchGroup1.notify(queue: DispatchQueue.main) {
                    self.parentClasses = tempParentCourses
                    ref.child("users").child(uid).child("name").observeSingleEvent(of: .value, with: { snap_par in
                        if let myName = snap_par.value as? String {
                            self.userName = myName
                        }
                    })
                }
            }
        })
    }
    
    func getCompanyClasses() {
        let ref = Database.database().reference()
        var returnClasses = [NextCodersCourse]()
        ref.child("nextCodersCourses").observeSingleEvent(of: .value, with: { snapshot_comp in
            if let data = snapshot_comp.value as? [String: AnyObject] {
                for (_, each) in data {
                    if let imgUrl = each["imageUrl"] as? String, let info = each["info"] as? String, let title = each["name"] as? String, let studentCount = each["completedStudents"] as? Int {
                        let newNextCourse = NextCodersCourse(title: title, imageUrl: imgUrl, descriptionString: info, studentCount: studentCount)
                        returnClasses.append(newNextCourse)
                    }
                }
            }
            self.nextCodersClasses = returnClasses
        })
    }
    
}

struct Course: Identifiable {
    var courseTitle: String
    var time: [Int]
    var cid: String
    var id: String { courseTitle }
}
struct Project: Identifiable {
    var projectTitle: String
    var descript: String
    var imageS: String
    var rank: Int
    var link: String
    var id: String { projectTitle }
}
struct StudentCode: Identifiable {
    var order: Int
    var imageUrl: String
    var id: String { imageUrl }
}
struct InstructorMessage: Identifiable {
    var time: Int
    var text: String
    var id: String { text }
}
struct Homework {
    var title: String
    var descript: String
    var messages: [InstructorMessage]
}
struct ParentClass: Identifiable {
    var classTitle: String
    var classId: String
    var studentName: String
    var classNumber: Int
    var totalClasses: Int
    var classTimes: [Int: Int]
    var mostRecentClass: Int
    var cid: String
    var id: String { classId }
}
struct NextCodersCourse: Identifiable {
    var title: String
    var imageUrl: String
    var descriptionString: String
    var studentCount: Int
    var id: String { title }
}
enum APError: Error {
    case invalidResponse
}

