//
//  Image+Extension.swift
//  MVVMBaseProject
//
//  Created by hb on 22/04/25.
//

import SwiftUI
import Kingfisher

extension Image {
    
    
    @MainActor static func setImage(
        url: URL? = nil,
        placeholder: Image? = nil,
        processor: ImageProcessor? = nil,
        cacheMemoryOnly: Bool = false,
        fadeDuration: Double? = nil,
        lowResolutionURL: URL? = nil,
        roundCorners: (radius: CGFloat, corners: RectCorner)? = nil,
        serializeAs: ImageFormat? = nil,
        onProgress: ((Int64, Int64) -> Void)? = nil,
        onSuccess: ((RetrieveImageResult) -> Void)? = nil,
        onFailure: ((KingfisherError) -> Void)? = nil
    ) -> KFImage {
        
        guard let url else {
            return KFImage(nil)
                .placeholder {
                    placeholder?
                        .resizable()
                }
        }

        var image = KFImage.url(url)

        if let placeholder {
            image = image.placeholder { placeholder }
        }

        if let processor {
            image = image.setProcessor(processor)
        }

        if cacheMemoryOnly {
            image = image.cacheMemoryOnly()
        }

        if let fadeDuration {
            image = image.fade(duration: fadeDuration)
        }

        if let lowResolutionURL {
            image = image.lowDataModeSource(.network(lowResolutionURL))
        }

        if let onProgress {
            image = image.onProgress(onProgress)
        }

        if let onSuccess {
            image = image.onSuccess(onSuccess)
        }

        if let onFailure {
            image = image.onFailure(onFailure)
        }

        if let serializeAs {
            image = image.serialize(as: serializeAs)
        }

        var view = image.resizable()

        if let roundCorners {
            view = view.roundCorner(radius: .point(roundCorners.radius), roundingCorners: roundCorners.corners)
        }

        return view
    }
}


/// Example how to use this class setImage function
/*
 Image.setImage(
    url: URL(string: "https://picsum.photos/300"),
    placeholder: Image(systemName: "photo"),
    processor: DownsamplingImageProcessor(size: CGSize(width: 300, height: 300)),
    cacheMemoryOnly: true,
    fadeDuration: 0.25,
    lowResolutionURL: URL(string: "https://picsum.photos/100"),
    roundCorners: (radius: 20, corners: [.topLeft, .bottomRight]),
    serializeFormat: .PNG,
    onSuccess: { result in print("Loaded from: \(result.cacheType)") },
    onFailure: { error in print("Load failed: \(error)") }
)
.frame(width: 150, height: 150)
.cornerRadius(12)
.padding()
*/
