//
//  FileAPI.swift
//  TelemedPatient
//
//  Created by d.yurchenko on 13.01.2021.
//

import Moya
import UIKit

enum FileAPI: Equatable {
    
    case loadImage(_ image: NamedUIImage)
}

extension FileAPI: TargetType {
    
    public var path: String {
        switch self {
        case .loadImage: return "file"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .loadImage: return .post
        }
    }

    public var task: Task {
        switch self {
        case let .loadImage(image):
            let imageData = image.image.jpegData(compressionQuality: 1.0)
            var fileName: String = image.name ?? "NoFileName"
            fileName.append(".jpeg")
            let imageDataProvider = Moya.MultipartFormData(provider: MultipartFormData.FormDataProvider.data(imageData!),
                                                           name: "file",
                                                           fileName: fileName,
                                                           mimeType: "image/jpeg")
            return .uploadMultipart([imageDataProvider])
        }
    }
}

extension FileAPI: AccessTokenAuthorizable {

    public var authorizationType: AuthorizationType? {
        return .bearer
    }
}

extension FileAPI: FallibleService { }
