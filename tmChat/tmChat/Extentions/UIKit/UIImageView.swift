//
//  UIImageView.swift
//  Guncha
//
//  Created by Shirin on 2/9/23.
//

import UIKit.UIImageView
import EasyPeasy

extension UIImageView {
    
    convenience init(contentMode: UIView.ContentMode,
                     cornerRadius: CGFloat,
                     image: UIImage? = nil,
                     backgroundColor: UIColor = .lee) {
        
        self.init(frame: .zero)
        self.contentMode = contentMode
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.image = image
        self.clipsToBounds = true
        self.isUserInteractionEnabled = true
    }
}

extension UIImage {
    func addTextToImage(_ text: String, color: UIColor) -> UIImage? {
        let tempView = UIStackView(axis: .vertical,
                                   alignment: .center,
                                   spacing: 4,
                                   edgeInsets: UIEdgeInsets(horizontalEdges: 14,
                                                            verticalEdges: 10),
                                   distribution: .equalSpacing)
        
        tempView.frame = CGRect(x: 0, y: 0, width: 90, height: 60)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = color
        
        let label = UILabel(font: .minitext_12,
                            color: color,
                            alignment: .center,
                            numOfLines: 1,
                            text: text)
        
        tempView.addArrangedSubview(imageView)
        tempView.addArrangedSubview(label)

        let renderer = UIGraphicsImageRenderer(bounds: CGRect(x: 15, y: 0, width: 60, height: 60))
        let image = renderer.image { rendererContext in
            tempView.layer.render(in: rendererContext.cgContext)
        }
        
        
        return image
    }
}
