//
//  GlobalService.swift
//  MVVMBaseProject
//
//  Created by hb on 23/04/25.
//

import Foundation
import Combine
import UIKit

class GlService {
    
    @Published var loingDetail: [MoodLogin.ViewModel] = []
    var anyCancelable: Set<AnyCancellable> = Set<AnyCancellable>()

    init() {
//        getUserDetail()
    }
    
    func getUserDetail() {
        loginUser()
            .map{ $0 }
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    print("======= Successfully found login data ========")
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
                self?.anyCancelable.removeAll()
            } receiveValue: { loginResult in
                if let arrayData = loginResult?.arrayData {
                    self.loingDetail = arrayData
                    print(self.loingDetail)
                } else if let dictData = loginResult?.dictData {
                    self.loingDetail.append(dictData)
                }
            }
            .store(in: &anyCancelable)

    }
    
    func loginUser() -> AnyPublisher<WSResponse<MoodLogin.ViewModel>?, Error> {
        let request = MoodLogin.Request(
            email: "testing",
            password: "Hidden@123",
            registration_id: "",
            is_send_otp: "Yes",
            otp_number: "",
            device_type:"iOS",
            app_version: "1.0",
            device_name: UIDevice.current.name,
            device_token: "",
            device_os: UIDevice.current.systemVersion,
            device_id: "",
            registration_type: "other"
        )
        return NetworkService.shared.dataRequest(with: AuthAPIRouter.login(request: request))
            .map({ $0 })
            .eraseToAnyPublisher()
    }
}
