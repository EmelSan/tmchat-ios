//
//  FeedMediaCell.swift
//  tmchat
//
//  Created by Shirin on 3/11/23.
//

import UIKit
import EasyPeasy
import AVFoundation

class FeedMediaCell: UICollectionViewCell {
    
    static let id = "FeedMediaCell"

    var img = UIImageView(contentMode: .scaleAspectFill,
                          cornerRadius: 0)

    var playerView = UIView()
    var player: AVPlayer?
    var asset: AVAsset?

    var loading: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView()
        loading.color = .white
        return loading
    }()

    var timeObserver: Any?
    var currentTime: Double? {
        didSet {
            if !(currentTime == nil || currentTime == 0) {
                loading.stopAnimating()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(img)
        img.easy.layout(Edges())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        img.image = nil
        
        guard let o = timeObserver else { return }
        player?.removeTimeObserver(o)
        player = nil
        
    }
    
    func setupData(data: File?){
        guard let url = URL(string: data?.fileUrl ?? "") else { return }
        if data?.type == MsgType.image.rawValue {
            playerView.removeFromSuperview()
            img.kf.setImage(with: url)
//        } else {
//            contentView.addSubview(playerView)
//            playerView.easy.layout(Edges())
//
//            contentView.addSubview(loading)
//            loading.easy.layout(Center())
//            loading.startAnimating()
//            
//            let asset = AVURLAsset(url: url)
//            addVideoPlayer(with: asset, playerView: playerView)
        }
    }

    func play() {
        guard let player = player else { return }

        if !player.isPlaying {
            player.play()
        } else {
            player.pause()
        }
    }
    
    private func addVideoPlayer(with asset: AVAsset, playerView: UIView) {
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)

        NotificationCenter.default.addObserver(self, selector: #selector(self.itemDidFinishPlaying(_:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)

        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        layer.backgroundColor = UIColor.black.cgColor
        layer.frame = CGRect(origin: .zero, size: DeviceDimensions.postCellDimensions)
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerView.layer.sublayers?.forEach({$0.removeFromSuperlayer()})
        playerView.layer.addSublayer(layer)
        observers()
        player?.play()
    }
    
    func observers(){
        timeObserver = player?.addPeriodicTimeObserver(forInterval: .init(seconds: 0.01, preferredTimescale: 1_000), queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.currentTime = time.seconds
        }
    }
    
    @objc func itemDidFinishPlaying(_ notification: Notification) {
        player?.seek(to: .zero)
        if (player?.isPlaying != true) {
            player?.play()
        }
    }
}

