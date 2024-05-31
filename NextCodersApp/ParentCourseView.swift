//
//  ParentCourseView.swift
//  NextCodersApp
//
//  Created by Gavin Wolfe on 5/7/24.
//

import SwiftUI

struct ParentCourseView: View {
    @Environment(\.dismiss) private var dismiss
    var parentClass: ParentClass
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ScrollView {
                    VStack(alignment: .leading) {
                        Spacer()
                            .frame(height: 50)
                        ParentHeaderiPhone(parentClass: parentClass)
                        HStack {
                            Spacer()
                                .frame(width: 15)
                            Text("\(parentClass.studentName)'s class feedback")
                                .font(Font(UIFont(name: "HelveticaNeue-Medium", size: 20) ?? .systemFont(ofSize: 20)))
                        }
                        Spacer()
                            .frame(height: 15)
                        
                        HStack {
                            Spacer()
                                .frame(width: 10)
                            FeedbackView(feedback: feedbackItem(date: "1pm Yesterday", content: "Timmy did very well with the concepts in our class today. We started with if statements and moved to list objects. Overall he seemed to understand the concepts well."))
                                .frame(width: abs(geo.size.width / 2 - 15), height: abs(geo.size.width / 2 - 15))
                            Spacer()
                            ProgressView(progress: 0.6, width: geo.size.width / 4.5, height: geo.size.width / 4.5, lineWidth: 14, font: Font(UIFont(name: "HelveticaNeue-Medium", size: 18) ?? .systemFont(ofSize: 18)))
                                .frame(width: abs(geo.size.width / 2 - 15), height: abs(geo.size.width / 2 - 15))
                            Spacer()
                                .frame(width: 10)
                        }
                        Text("\(parentClass.studentName)'s course work: ")
                            .font(Font(UIFont(name: "HelveticaNeue-Medium", size: 20) ?? .systemFont(ofSize: 20)))
                            .padding(15)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                CodeView(studentCode: StudentCode(order: 1, imageUrl: "python2"))
                                    .frame(width: abs(geo.size.width / 3), height: abs(geo.size.width / 3))
                                    .padding(10)
                                CodeView(studentCode: StudentCode(order: 1, imageUrl: "python2"))
                                    .frame(width: abs(geo.size.width / 3), height: abs(geo.size.width / 3))
                                    .padding(10)
                                CodeView(studentCode: StudentCode(order: 1, imageUrl: "python2"))
                                    .frame(width: abs(geo.size.width / 3), height: abs(geo.size.width / 3))
                                    .padding(10)
                            }
                        }
                        Spacer()
                    }
                    
                }.ignoresSafeArea()
            }
            
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton().onTapGesture {
                        dismiss()
                    }.foregroundColor(.white)
                }
            })
        }
    }
}

struct CodeView: View {
    var studentCode: StudentCode
    var body: some View {
        ZStack {
            Color.blue
                .opacity(0.1)
                .cornerRadius(20)
            VStack {
                Image("python2")
                    .resizable()
                    .cornerRadius(20)
                Text("From Tuesday's Class")
                    .font(Font(UIFont(name: "HelveticaNeue", size: 14) ?? .systemFont(ofSize: 14)))
                    .foregroundColor(Color(UIColor.lightGray))
            }.padding(10)
        }
    }
}



struct ProgressView: View {
    var progress: Float
    var width: CGFloat
    var height: CGFloat
    var lineWidth: CGFloat
    var font: Font
    var body: some View {
            ZStack {
                Color.blue
                    .opacity(0.1)
                    .edgesIgnoringSafeArea(.all)
                    .cornerRadius(20)
                
                VStack {
                    Spacer()
                        .frame(height: 10)
                    Text("Progress")
                        .font(Font(UIFont(name: "HelveticaNeue-Bold", size: 18) ?? .systemFont(ofSize: 18)))
                    Spacer()
                        .frame(height: 20)
                    ProgressBar(progress: self.progress, lineWidth: lineWidth, font: font)
                        .frame(width: width, height: height)
                    Spacer()
                    Button(action: {
                        print("tapped")
                    }) {
                        HStack {
                            Image(systemName: "book.circle.fill")
                            Text("21 Concepts Completed")
                                .font(Font(UIFont(name: "HelveticaNeue", size: 13) ?? .systemFont(ofSize: 13)))
                        }
                        .padding(5.0)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 15.0)
//                                .stroke(lineWidth: 2.0)
//                        )
                    }
                    
                    Spacer()
                        .frame(height: 10)
                }
            }
        }
}
struct ProgressBar: View {
    var progress: Float
    var lineWidth: CGFloat
    var font: Font
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: lineWidth)
                .opacity(0.3)
                .foregroundColor(Color.blue)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color(UIColor.systemGreen))
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)

            Text(String(format: "%.0f %%", min(self.progress, 1.0)*100.0))
                .font(font)
                .bold()
        }
    }
}
struct feedbackItem {
    var date: String
    var content: String
    
}
struct FeedbackView: View {
    var feedback: feedbackItem
    var body: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: 20.0)
                    .foregroundColor(Color(UIColor.opaqueSeparator))
                VStack(alignment: .leading) {
                    Spacer()
                        .frame(height: 10)
                    Text("Thursday Class Feedback")
                        .font(Font(UIFont(name: "HelveticaNeue-Medium", size: 18) ?? .systemFont(ofSize: 20)))
                    Spacer()
                        .frame(height: 10)
                    Text(feedback.date)
                        .font(Font(UIFont(name: "HelveticaNeue-Italic", size: 14) ?? .systemFont(ofSize: 18)))
                    Spacer()
                        .frame(height: 8)
                    VStack(alignment: .center) {
                        Text(feedback.content)
                            .font(Font(UIFont(name: "HelveticaNeue", size: 12) ?? .systemFont(ofSize: 16)))
                    }
                    Spacer()
                }.padding(10)
            }
        }
    }
}

struct ParentHeaderiPad: View {
    var parentClass: ParentClass
    var body: some View {
        ZStack() {
            DrawingPaths(bottom: 300)
            VStack {
                HStack(alignment: .center) {
                    VStack {
                        Image("pyt")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:200, height:200)
                        Spacer()
                    }.frame(height: 250)
                    VStack {
                        Spacer()
                        Text(parentClass.classTitle)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                       Spacer()
                        
                    }.frame(height: 250)
                    Spacer()
                }
                .padding()
                .frame(height: 250)
                Spacer()
            }
            HStack(alignment: .bottom) {
                Spacer()
                VStack {
                    Text("Current Class: 5/15 \nTime: Mon 2pm Wed 3pm")
                        .font(Font(UIFont(name: "HelveticaNeue-Medium", size: 20) ?? .systemFont(ofSize: 30)))
                        .foregroundColor(Color(UIColor.lightGray))
                        .multilineTextAlignment(.center)
                        .offset(y: 75)
                }
                Spacer()
                    .frame(width: 40)
                
            }.frame(height: 300)
        }
    }
}
struct ParentHeaderiPhone: View {
    var parentClass: ParentClass
    var body: some View {
        ZStack() {
            DrawingPaths(bottom: 200)
            HStack(alignment: .center) {
                    VStack {
                        Image("pyt")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:150, height:150)
                    }.offset(y: -50)
                    VStack {
                        
                        Text(parentClass.classTitle)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                       
                    }.offset(y: -50)
                Spacer()
            }.frame(height: 200)
            .padding()
            Spacer()
            HStack(alignment: .bottom) {
                Spacer()
                VStack() {
                    Text("Current Class: 5/15 \nTime: Mon 2pm Wed 3pm")
                        .font(Font(UIFont(name: "HelveticaNeue-Medium", size: 14) ?? .systemFont(ofSize: 14)))
                        .foregroundColor(Color(UIColor.lightGray))
                        .multilineTextAlignment(.trailing)
                        .offset(y: 50)
                }
                Spacer()
                    .frame(width: 10)
                
            }.frame(height: 200)
        }
    }
}

struct DrawingPaths: View {
    var bottom: CGFloat
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                //Top left
                path.move(to: CGPoint(x: 0, y: 0))
                //Left vertical bound
                path.addLine(to: CGPoint(x: 0, y: bottom))
                //Curve
                path.addCurve(to: CGPoint(x: geometry.size.width, y: bottom - 100), control1: CGPoint(x: geometry.size.width / 2, y: bottom+50), control2: CGPoint(x: geometry.size.width / 2 + 75, y: 80))
                //Right vertical bound
                path.addLine(to: CGPoint(x: geometry.size.width, y: 0))
            }
            .fill(.blue)
            .edgesIgnoringSafeArea(.top)
        }
    }
}
