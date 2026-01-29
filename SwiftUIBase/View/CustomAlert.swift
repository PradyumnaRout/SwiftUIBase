//
//  CustomAlert.swift
//  CustomAlert
//
//  Created by hb on 01/08/23.
//

import Combine
import SwiftUI

enum AlertType {
    
    case success(title: String, message: String = "")
    case error(title: String, message: String = "")
    
    func title() -> String {
        switch self {
        case .success(title: let title, _):
            return title
        case .error(title: let title, _):
            return title
        }
    }
    
    func message() -> String {
        switch self {
        case .success(_, message: let message):
            return message
        case .error(_, message: let message):
            return message
        }
    }
}

struct CustomAlert: View {
    
    @State var alertType: AlertType
    // public var style: AlertStyle? = nil
    var leftActionText: String = ""
    var rightActionText: String = ""
    var image: UIImage? = nil
    
    var leftButtonAction: (() -> Void)?
    var rightButtonAction: (() -> Void)?
    //  var isSingleButton:Bool? = false
    let verticalButtonsHeight: CGFloat = 80
    
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    VStack(spacing: 0) {
                        
                        if image != nil {
                            Image(uiImage: image ?? UIImage())
                                .resizable()
                            // .clipShape(Circle())
                                .frame(width: 100, height: 100)
                                .padding(.top, 10)
                            
                        }
                        
                        
                        if !alertType.title().isEmpty {
                            
                            // alert title
                            Text(alertType.title())
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color.black)
                                .multilineTextAlignment(.center)
                                .padding(.top, 16)
                                .padding(.bottom, 8)
                                .padding(.horizontal, 30)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        if !alertType.message().isEmpty {
                            // alert message
                            Text(alertType.message())
                                .font(.system(size: 16, weight: .regular ))
                                .foregroundColor(Color.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 25)
                                .padding(.bottom, 16)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.all, 0)
                        }
                        HStack(spacing: 20) {
                            
                            // left button
                            if (!(leftActionText.isEmpty)) {
                                Button {
                                    leftButtonAction?()
                                } label: {
                                    Text(leftActionText)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                        .multilineTextAlignment(.center)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                }
                                .accessibilityIdentifier("removebtn")
                                .background(.gray)
                                .cornerRadius(10)
                            }
                            
                            // right button (default)
                            if (!(rightActionText.isEmpty)) {
                                Button {
                                    rightButtonAction?()
                                        
                                } label: {
                                    Text(rightActionText)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .padding(15)
                                    
                                        .frame(maxWidth: .infinity)
                                }
                                .accessibilityIdentifier("removebtn")
                                .background(.blue)
                                .cornerRadius(10)
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                        .padding([.horizontal], 20)
                        .padding(.bottom, 20)
                        
                        
                    }
                    .padding(.top, 10)
                    .frame(width: UIScreen.main.bounds.width - 30)
                    .background(
                        Color.white
                    )
                    .cornerRadius(10)
                }
                .zIndex(2)
                
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            .background(.gray.opacity(0.5))
            .ignoresSafeArea()
        }
    }
}

/*
 // Just explained how to present
 VStack {
 ....
 
 }
 if presentAlert{
 CustomAlert(alertType: .success(title: "Done", message: "jfbnfdikcfjdocjgikjopdxjk"), leftActionText: "vfgfgbg", rightActionText: "right", image:UIImage(named: "cafeMeets")) {
 withAnimation{
 print("left")
 }
 } rightButtonAction: {
 withAnimation{
 print("right")
 self.presentAlert.toggle()
 }
 }
 }
 
 */
