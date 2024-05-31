//
//  TransitionManager.swift
//  NextCodersApp
//
//  Created by Gavin Wolfe on 5/1/24.
//

import Foundation

class TransitionManager: ObservableObject {
    var selectedCourse: Course? {
        didSet {
            isShowingCourseView = true
        }
    }
    @Published var isShowingCourseView = false
    
}
class TransitionManagerParent: ObservableObject {
    var selectedCourse: ParentClass? {
        didSet {
            isShowingParentCourseView = true
        }
    }
    @Published var isShowingParentCourseView = false
}

class CodeScreenTransitionManager: ObservableObject {
    @Published var isShowingCodeView = false
    var selectedCode: StudentCode? {
        didSet {
            isShowingCodeView = true
        }
    }
}

class HomeworkTransitionManager: ObservableObject {
    @Published var isShowingHwView = false
    var selectedCode: Homework? {
        didSet {
            isShowingHwView = true
        }
    }
}

class ProjectTransitionManager: ObservableObject {
    @Published var isShowingProjectView = false
    var selectedProj: Project? {
        didSet {
            isShowingProjectView = true
        }
    }
}

