//
//  NextCourses.swift
//  NextCodersApp
//
//  Created by Gavin Wolfe on 5/10/24.
//

import SwiftUI

struct NextCourses: View {
    @StateObject private var networkCall = NetworkManager()
    @Environment(\.dismiss) private var dismiss
    var columns = [GridItem(.flexible()) ]
    var body: some View {
        GeometryReader { geo in
            NavigationStack {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(networkCall.nextCodersClasses) { item in
                            CourseDetailView(courseObject: item, geoWidth: geo.size.width, geoHeight: geo.size.height)
                        }.padding(15)
                    }
                }
                .navigationTitle("Next Coders Courses")
                .onAppear {
                    networkCall.getCompanyClasses()
                }
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        XMarkButton().onTapGesture {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Contact Us") {
                            print("pressed")
                        }.buttonStyle(.bordered)
                        
                    }
                })
            }
        }
    }
}

struct CourseDetailView: View {
    var courseObject: NextCodersCourse
    var geoWidth: CGFloat
    var geoHeight: CGFloat
    var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 30.0)
                    .foregroundColor(Color(UIColor.opaqueSeparator))
                    .frame(width: geoWidth - 30)
                VStack() {
                    Spacer()
                        .frame(height: 30)
                    HStack {
                        Spacer()
                        VStack(alignment: .center) {
                            Spacer()
                            HStack {
                                Spacer()
                                ZStack {
                                    RoundedRectangle(cornerRadius: 30.0)
                                        .foregroundColor(Color(randomColor()))
                                        .frame(width: geoWidth / 3)
                                    AsyncImage(url: URL(string: courseObject.imageUrl)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(1, contentMode: .fit)
                                            .cornerRadius(30.0)
                                            .frame(width: geoWidth / 3)
                                        
                                    } placeholder: {
                                        Color.black
                                    }
                                }
                                Spacer()
                                    .frame(width: 5)
                            }
                            Spacer()
                        }.frame(width: geoWidth/2 - 60)
                        HStack {
                            Spacer()
                                .frame(width: 5)
                            VStack(alignment: .leading) {
                                Text(courseObject.title)
                                    .font(Font(UIFont(name: "HelveticaNeue-Bold", size: 32) ?? .systemFont(ofSize: 32)))
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                    .frame(height: 15)
                                Text("\(courseObject.studentCount) Students have completed this course")
                                    .italic()
                            }
                            Spacer()
                        }.frame(width: geoWidth/2 + 60)
                        Spacer()
                    }.frame(height: (geoWidth / 2.5) / 2)
                    HStack {
                        Spacer()
                            .frame(width: (geoWidth / 2 - 60) - (geoWidth/3))
                        VStack(alignment: .center) {
                            Spacer()
                            Text(courseObject.descriptionString)
                                .lineLimit(5)
                                .font(Font(UIFont(name: "HelveticaNeue", size: 20) ?? .systemFont(ofSize: 20)))
                                .multilineTextAlignment(.center)
                                .frame(width: geoWidth - ((geoWidth / 2 - 60) - (geoWidth/3)) -  ((geoWidth / 2 - 60) - (geoWidth/3)))
                            Spacer()
                        }
                        Spacer()
                    }
                    Spacer()
                        .frame(height: 30)
                }.frame(height: geoWidth / 2)
            }
    }
    func randomColor () -> UIColor {
         let radOne = Int.random(in: 1..<8)
        // there are 7
        if radOne == 1 {
            return UIColor(red: 0.8392, green: 0.5294, blue: 0, alpha: 1.0)
        }
        if radOne == 2 {
            return UIColor(red: 0, green: 0.6353, blue: 0.7176, alpha: 1.0)
        }
        if radOne == 3 {
            return UIColor(red: 0.7294, green: 0, blue: 0.0118, alpha: 1.0)
        }
        if radOne == 4 {
            return UIColor(red: 0.3059, green: 0, blue: 0.7098, alpha: 1.0)
        }
        if radOne == 5 {
            return UIColor(red: 0, green: 0.2039, blue: 0.6784, alpha: 1.0)
        }
        if radOne == 6 {
            return UIColor(red: 0.6863, green: 0.3216, blue: 0, alpha: 1.0)
        }
        if radOne == 7 {
            return UIColor(red: 0, green: 0.6784, blue: 0.5647, alpha: 1.0)
        }
        return UIColor.blue
    }
}


