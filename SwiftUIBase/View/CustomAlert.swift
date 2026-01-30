//
//  CustomAlert.swift
//  CustomAlert
//
//  Created by hb on 01/08/23.
//

import Combine
import SwiftUI

struct CustomAlert: View {
    
    var title: String = ""
    var message: String = ""
    var leftActionText: String = ""
    var rightActionText: String = ""
    var image: UIImage? = nil
    
    var leftButtonAction: (() -> Void)?
    var rightButtonAction: (() -> Void)?
    let verticalButtonsHeight: CGFloat = 80
    
    @State private var show = false
    
    
    var body: some View {
        VStack {
            ZStack {
                VStack(spacing: 0) {
                    
                    if image != nil {
                        Image(uiImage: image ?? UIImage())
                            .resizable()
                        // .clipShape(Circle())
                            .frame(width: 100, height: 100)
                            .padding(.top, 10)
                    } else {
                        Image(systemName: "bell.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.red)
                    }
                    
                    
                    if !title.isEmpty {
                        // Alert title
                        Text(title)
                            .alertStyle(
                                font: .system(size: 20, weight: .bold),
                                foregroundColor: Color.black,
                                textAlignment: .center,
                                paddingTop: 16,
                                paddingBottom: 8,
                                paddingHorizontal: 30
                            )
                    }
                    if !message.isEmpty {
                        // alert message
                        Text(message)
                            .alertStyle(
                                font: .system(size: 16, weight: .regular ),
                                foregroundColor: Color.gray,
                                textAlignment: .center,
                                paddingTop: 0,
                                paddingBottom: 16,
                                paddingHorizontal: 25
                            )
                    }
                    HStack(spacing: 20) {
                        
                        // left button
                        if (!(leftActionText.isEmpty)) {
                            Button {
                                withAnimation(.spring()) {
                                    show = false
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                    leftButtonAction?()
                                }
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
                                withAnimation(.spring()) {
                                    show = false
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                    rightButtonAction?()
                                }
                                
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
                .padding(.vertical, 20)
                .background(
                    Color.white
                )
                .cornerRadius(20)
                .padding(.horizontal, 15)
                .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 0)
                .scaleEffect(show ? 1 : 0.7)
                .opacity(show ? 1 : 0)
            }
            .zIndex(2)
        }
        .onAppear {
            withAnimation(.spring()) {
                show = true
            }
        }
        .ignoresSafeArea()
    }
}



#Preview {
    CustomAlert(title: "Alert", message: "Are you sure you want to verify the new email for this account?", leftActionText: "No", rightActionText: "Verify", image:UIImage(named: "cafeMeets")) {
        withAnimation{
            print("left")
        }
    } rightButtonAction: {
        withAnimation{
            print("right")
        }
    }
}
